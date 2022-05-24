import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:sns/data_models/comments.dart';
import 'package:sns/data_models/like.dart';
import 'package:sns/data_models/location.dart';
import 'package:sns/data_models/post.dart';
import 'package:sns/data_models/user.dart';
import 'package:sns/models/db/database_manager.dart';
import 'package:sns/models/location/location_manager.dart';
import 'package:sns/utils/constant.dart';
import 'package:uuid/uuid.dart';

class PostRepository {
  final DatabaseManager dbManager;

  final LocationManager locationManager;

  PostRepository({required this.dbManager, required this.locationManager});

  Future<File?> pickImage(UploadType uploadType) async {
    final imagePicker = ImagePicker();

    if (uploadType == UploadType.gallery) {
      final pickedImage =
          await imagePicker.pickImage(source: ImageSource.gallery);
      return (pickedImage != null) ? File(pickedImage.path) : null;
    } else {
      final pickedImage =
          await imagePicker.pickImage(source: ImageSource.camera);
      return (pickedImage != null) ? File(pickedImage.path) : null;
    }
  }

  Future<Location> getCurrentLocation() async {
    return await locationManager.getCurrentLocation();
  }

  Future<Location> updateLocation(double latitude, double longitude) async {
    return await locationManager.updateLocation(latitude, longitude);
  }

  Future<void> post(User currentUser, File imageFile, String caption,
      Location location, String locationString) async {
    final storageId = const Uuid().v1();
    final imageUrl = await dbManager.uploadImageToStorage(imageFile, storageId);
    final post = Post(
      postId: const Uuid().v1(),
      userId: currentUser.userId,
      imageUrl: imageUrl,
      imageStoragePath: storageId,
      caption: caption,
      locationString: locationString,
      latitude: location.latitude,
      longitude: location.longitude,
      postDateTime: DateTime.now(),
    );
    await dbManager.insertPost(post);
  }

  Future<List<Post>> getPosts(FeedMode feedMode, User feedUser) {
    if (feedMode == FeedMode.fromFeed) {
      return dbManager.getPostsMineAndFollowings(feedUser.userId);
    } else {
      return dbManager.getPostsByUser(feedUser.userId);
    }
  }

  Future<void> updatePost(Post updatePost) async {
    return dbManager.updatePost(updatePost);
  }

  Future<void> postComment(
      Post post, User commentUser, String commentString) async {
    final comment = Comment(
      commentId: Uuid().v1(),
      postId: post.postId,
      commentUserId: commentUser.userId,
      comment: commentString,
      commentDateTime: DateTime.now(),
    );

    await dbManager.postComment(comment);
  }

  Future<List<Comment>> getComments(String postId) async {
    return dbManager.getComments(postId);
  }

  Future<void> deleteComment(String deleteCommentId) async {
    await dbManager.deleteComment(deleteCommentId);
  }

  Future<void> likeIt(Post post, User currentUser) async {
    final like = Like(
      likeId: Uuid().v1(),
      postId: post.postId,
      likeUserId: currentUser.userId,
      likeDateTime: DateTime.now(),
    );

    await dbManager.likeIt(like);
  }

  Future<LikeResult> getLikeResult(String postId, User currentUser) async {
    // いいねの取得
    final likes = await dbManager.getLikes(postId);
    // 自分がその投稿にいいねしたかどうかの判定
    var isLikedPost = false;
    for (var like in likes) {
      if (like.likeUserId == currentUser.userId) {
        isLikedPost = true;
        break;
      }
    }

    return LikeResult(likes: likes, isLikedToThisPost: isLikedPost);
  }

  Future<void> unLikeIt(Post post, User currentUser) async {
    await dbManager.unLikeIt(post, currentUser);
  }

  Future<void> deletePost(String postId, String imageStoragePath) async {
    await dbManager.deletePost(postId, imageStoragePath);
  }
}
