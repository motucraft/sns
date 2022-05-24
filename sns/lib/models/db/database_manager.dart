import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:sns/data_models/comments.dart';
import 'package:sns/data_models/like.dart';
import 'package:sns/data_models/post.dart';
import 'package:sns/data_models/user.dart';
import 'package:sns/models/repositories/user_repository.dart';

class DatabaseManager {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<bool> searchUserInDb(auth.User firebaseUser) async {
    var query = await _db
        .collection('users')
        .where('userId', isEqualTo: firebaseUser.uid)
        .get();
    if (query.docs.isNotEmpty) {
      return true;
    }
    return false;
  }

  Future<void> insertUser(User user) async {
    await _db.collection('users').doc(user.userId).set(user.toMap());
  }

  Future<User> getUserInfoFromDbById(String userId) async {
    var query =
        await _db.collection('users').where('userId', isEqualTo: userId).get();
    return User.fromMap(query.docs[0].data());
  }

  Future<String> uploadImageToStorage(File imageFile, String storageId) async {
    final storageRef = FirebaseStorage.instance.ref().child(storageId);
    return await (await storageRef.putFile(imageFile)).ref.getDownloadURL();
  }

  Future<void> insertPost(Post post) async {
    await _db.collection('posts').doc(post.postId).set(post.toMap());
  }

  Future<List<Post>> getPostsMineAndFollowings(String userId) async {
    // データの有無を判定
    final query = await _db.collection('posts').get();
    if (query.docs.isEmpty) return [];

    var userIds = await getFollowingUserIds(userId);
    userIds.add(userId);

    final quotient = userIds.length ~/ 10;
    final remainder = userIds.length % 10;
    final numberOfChunks = (remainder == 0) ? quotient : quotient + 1;

    var userIdChunks = <List<String>>[];

    if (quotient == 10) {
      userIdChunks.add(userIds);
    } else if (quotient == 1) {
      userIdChunks.add(userIds.sublist(0, 9));
      userIdChunks.add(userIds.sublist(10, 10 + remainder));
    } else {
      for (int i = 0; i < numberOfChunks - 1; i++) {
        userIdChunks.add(userIds.sublist(i * 10, i * 10 + 10));
      }
      userIdChunks.add(userIds.sublist(
          (numberOfChunks - 1) * 10, (numberOfChunks - 1) * 10 + remainder));
    }

    var results = <Post>[];
    await Future.forEach(userIdChunks, (List<String> userIds) async {
      final tempPosts = await getPostsOfChunkedUsers(userIds);
      for (var post in tempPosts) {
        results.add(post);
      }
    });

    return results;
  }

  Future<List<Post>> getPostsOfChunkedUsers(List<String> userIds) async {
    var results = <Post>[];

    var querySnapshot = await _db
        .collection('posts')
        .where('userId', whereIn: userIds)
        .orderBy('postDateTime', descending: true)
        .get();
    for (var element in querySnapshot.docs) {
      results.add(Post.fromMap(element.data()));
    }

    return results;
  }

  Future<List<String>> getFollowingUserIds(String userId) async {
    // データの有無を判定
    final query = await _db
        .collection('users')
        .doc(userId)
        .collection('followings')
        .get();
    if (query.docs.isEmpty) return [];

    var userIds = <String>[];
    query.docs.forEach((id) {
      userIds.add(id.data()['userId']);
    });

    return userIds;
  }

  Future<void> updatePost(Post updatePost) async {
    final reference = _db.collection('posts').doc(updatePost.postId);
    await reference.update(updatePost.toMap());
  }

  Future<void> postComment(Comment comment) async {
    // 追加：投稿が存在することを確認
    var documentSnapshot =
        await _db.collection('posts').doc(comment.postId).get();
    if (!documentSnapshot.exists) return;

    await _db
        .collection('comments')
        .doc(comment.commentId)
        .set(comment.toMap());
  }

  Future<List<Comment>> getComments(String postId) async {
    final query = await _db.collection('comments').get();
    if (query.docs.isEmpty) return [];

    var results = <Comment>[];
    var querySnapshot = await _db
        .collection('comments')
        .where('postId', isEqualTo: postId)
        .orderBy('commentDateTime')
        .get();

    for (var element in querySnapshot.docs) {
      results.add(Comment.fromMap(element.data()));
    }

    return results;
  }

  Future<void> deleteComment(String deleteCommentId) async {
    final reference = _db.collection('comments').doc(deleteCommentId);
    await reference.delete();
  }

  Future<void> likeIt(Like like) async {
    await _db.collection('likes').doc(like.likeId).set(like.toMap());
  }

  Future<List<Like>> getLikes(String postId) async {
    final query = await _db.collection('likes').get();
    if (query.docs.isEmpty) return [];

    var results = <Like>[];
    var querySnapshot = await _db
        .collection('likes')
        .where('postId', isEqualTo: postId)
        .orderBy('likeDateTime')
        .get();

    for (var element in querySnapshot.docs) {
      results.add(Like.fromMap(element.data()));
    }

    return results;
  }

  Future<void> unLikeIt(Post post, User currentUser) async {
    final likeRef = await _db
        .collection('likes')
        .where('postId', isEqualTo: post.postId)
        .where('likeUserId', isEqualTo: currentUser.userId)
        .get();

    for (var element in likeRef.docs) {
      final ref = _db.collection('likes').doc(element.id);
      await ref.delete();
    }
  }

  Future<void> deletePost(String postId, String imageStoragePath) async {
    // Post
    final postRef = _db.collection('posts').doc(postId);
    await postRef.delete();

    // Comment
    final commentRef = await _db
        .collection('comments')
        .where('postId', isEqualTo: postId)
        .get();
    for (var element in commentRef.docs) {
      final ref = _db.collection('comments').doc(element.id);
      await ref.delete();
    }

    // Likes
    final likeRef =
        await _db.collection('likes').where('postId', isEqualTo: postId).get();
    for (var element in likeRef.docs) {
      final ref = _db.collection('likes').doc(element.id);
      await ref.delete();
    }

    // Storageから画像削除
    final storageRef = FirebaseStorage.instance.ref().child(imageStoragePath);
    await storageRef.delete();
  }

  Future<List<Post>> getPostsByUser(String userId) async {
    final query = await _db.collection('posts').get();
    if (query.docs.isEmpty) return [];

    var results = <Post>[];
    var querySnapshot = await _db
        .collection('posts')
        .where('userId', isEqualTo: userId)
        .orderBy('postDateTime', descending: true)
        .get();
    for (var element in querySnapshot.docs) {
      results.add(Post.fromMap(element.data()));
    }

    return results;
  }

  Future<List<String>> getFollowerUserIds(String userId) async {
    final query =
        await _db.collection('users').doc(userId).collection('followers').get();
    if (query.docs.isEmpty) return [];

    var userIds = <String>[];
    for (var id in query.docs) {
      userIds.add(id.data()['userId']);
    }

    return userIds;
  }

  Future<void> updateProfile(User updateUser) async {
    await _db
        .collection('users')
        .doc(updateUser.userId)
        .update(updateUser.toMap());
  }

  Future<List<User>> searchUsers(String queryString) async {
    final query = await _db
        .collection('users')
        .orderBy('inAppUserName')
        .startAt([queryString]).endAt([queryString + '\uf8ff']).get();
    if (query.docs.isEmpty) return [];
    print('searchUsers: ${query.docs}');

    var soughtUsers = <User>[];
    for (var element in query.docs) {
      final selectedUser = User.fromMap(element.data());
      if (selectedUser.userId != UserRepository.currentUser?.userId) {
        soughtUsers.add(selectedUser);
      }
    }

    return soughtUsers;
  }

  Future<void> follow(User profileUser, User currentUser) async {
    // currentUserにとってのfollowings
    await _db
        .collection('users')
        .doc(currentUser.userId)
        .collection('followings')
        .doc(profileUser.userId)
        .set({'userId': profileUser.userId});

    // profileUserにとってのfollowers
    await _db
        .collection('users')
        .doc(profileUser.userId)
        .collection('followers')
        .doc(currentUser.userId)
        .set({'userId': currentUser.userId});
  }

  Future<bool> checkIsFollowing(User profileUser, User currentUser) async {
    final query = await _db
        .collection('users')
        .doc(currentUser.userId)
        .collection('followings')
        .get();
    if (query.docs.isEmpty) return false;

    final checkQuery = await _db
        .collection('users')
        .doc(currentUser.userId)
        .collection('followings')
        .where('userId', isEqualTo: profileUser.userId)
        .get();
    if (checkQuery.docs.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  Future<void> unFollow(User profileUser, User currentUser) async {
    await _db
        .collection('users')
        .doc(currentUser.userId)
        .collection('followings')
        .doc(profileUser.userId)
        .delete();

    await _db
        .collection('users')
        .doc(profileUser.userId)
        .collection('followers')
        .doc(currentUser.userId)
        .delete();
  }

  Future<List<User>> getLikesUsers(String postId) async {
    final query =
        await _db.collection('likes').where('postId', isEqualTo: postId).get();
    if (query.docs.isEmpty) return [];

    var userIds = <String>[];
    for (var id in query.docs) {
      userIds.add(id.data()['likeUserId']);
    }

    var likesUsers = <User>[];
    await Future.forEach(userIds, (String userId) async {
      final user = await getUserInfoFromDbById(userId);
      likesUsers.add(user);
    });

    return likesUsers;
  }

  Future<List<User>> getFollowerUsers(String profileUserId) async {
    final followerUserIds = await getFollowerUserIds(profileUserId);

    var followerUsers = <User>[];
    await Future.forEach(followerUserIds, (String followerUserId) async {
      final user = await getUserInfoFromDbById(followerUserId);
      followerUsers.add(user);
    });
    print('getFollowerUsers: $followerUsers');

    return followerUsers;
  }

  Future<List<User>> getFollowingUsers(String profileUserId) async {
    final followingUserIds = await getFollowingUserIds(profileUserId);

    var followingUsers = <User>[];
    await Future.forEach(followingUserIds, (String followingUserId) async {
      final user = await getUserInfoFromDbById(followingUserId);
      followingUsers.add(user);
    });
    print('getFollowingUsers: $followingUsers');

    return followingUsers;
  }
}
