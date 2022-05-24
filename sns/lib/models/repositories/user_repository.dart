import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sns/data_models/user.dart';
import 'package:sns/models/db/database_manager.dart';
import 'package:sns/utils/constant.dart';
import 'package:uuid/uuid.dart';

class UserRepository {
  final DatabaseManager dbManager;

  UserRepository({required this.dbManager});

  static User? currentUser;

  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<bool> isSignIn() async {
    final firebaseUser = _auth.currentUser;
    if (firebaseUser != null) {
      // ユーザ情報取得
      currentUser = await dbManager.getUserInfoFromDbById(firebaseUser.uid);
      return true;
    }
    return false;
  }

  Future<bool> signIn() async {
    try {
      // https://firebase.google.com/docs/auth/flutter/federated-auth#google

      var signInAccount = await _googleSignIn.signIn();
      if (signInAccount == null) return false;

      var signInAuthentication = await signInAccount.authentication;

      var credential = auth.GoogleAuthProvider.credential(
        idToken: signInAuthentication.idToken,
        accessToken: signInAuthentication.accessToken,
      );

      var firebaseUser = (await _auth.signInWithCredential(credential)).user;
      if (firebaseUser == null) {
        return false;
      }

      // ユーザ検索
      var isUserExistedInDb = await dbManager.searchUserInDb(firebaseUser);
      if (!isUserExistedInDb) {
        await dbManager.insertUser(_convertToUser(firebaseUser));
      }

      // ユーザ情報取得
      currentUser = await dbManager.getUserInfoFromDbById(firebaseUser.uid);
      return true;
    } catch (error) {
      print('sign in error caught!: $error');
      return false;
    }
  }

  _convertToUser(auth.User firebaseUser) {
    return User(
      userId: firebaseUser.uid,
      displayName: firebaseUser.displayName ?? '',
      inAppUserName: firebaseUser.displayName ?? '',
      photoUrl: firebaseUser.photoURL ?? '',
      email: firebaseUser.email ?? '',
      bio: '',
    );
  }

  Future<User> getUserById(String userId) async {
    return await dbManager.getUserInfoFromDbById(userId);
  }

  Future<void> signOut() async {
    // signOut()とdisconnect()があるが、disconnect()ではissueにも上がっている問題が発生する模様。
    // そのため、ここではsignOut()を利用する。
    // https://github.com/firebase/flutterfire/issues/592
    await _googleSignIn.signOut();
    // await _googleSignIn.disconnect();
    await _auth.signOut();
    currentUser = null;
  }

  Future<int> getNumberOfFollowers(User profileUser) async {
    return (await dbManager.getFollowerUserIds(profileUser.userId)).length;
  }

  Future<int> getNumberOfFollowings(User profileUser) async {
    return (await dbManager.getFollowingUserIds(profileUser.userId)).length;
  }

  Future<void> updateProfile(User profileUser, String namedUpdated,
      String bioUpdated, String photoUrlUpdated, bool isImageFromFile) async {
    String? updatePhotoUrl;

    if (isImageFromFile) {
      final updatePhotoFile = File(photoUrlUpdated);
      final storagePath = Uuid().v1();
      updatePhotoUrl =
          await dbManager.uploadImageToStorage(updatePhotoFile, storagePath);
    }

    final userBeforeUpdate =
        await dbManager.getUserInfoFromDbById(profileUser.userId);
    final updateUser = userBeforeUpdate.copyWith(
      inAppUserName: namedUpdated,
      photoUrl: isImageFromFile ? updatePhotoUrl : userBeforeUpdate.photoUrl,
      bio: bioUpdated,
    );

    await dbManager.updateProfile(updateUser);
  }

  Future<void> getCurrentUserById(String userId) async {
    currentUser = await dbManager.getUserInfoFromDbById(userId);
  }

  Future<List<User>> searchUsers(String query) async {
    return await dbManager.searchUsers(query);
  }

  Future<void> follow(User profileUser) async {
    if (currentUser != null) {
      await dbManager.follow(profileUser, currentUser!);
    }
  }

  Future<bool> checkIsFollowing(User profileUser) async {
    return (currentUser != null)
        ? await dbManager.checkIsFollowing(profileUser, currentUser!)
        : false;
  }

  Future<void> unFollow(User profileUser) async {
    if (currentUser != null) {
      await dbManager.unFollow(profileUser, currentUser!);
    }
  }

  Future<List<User>> getCaresMeUsers(String id, WhoCaresMeMode mode) async {
    var results = <User>[];

    switch (mode) {
      case WhoCaresMeMode.like:
        final postId = id;
        results = await dbManager.getLikesUsers(postId);
        break;
      case WhoCaresMeMode.followed:
        final profileUserId = id;
        results = await dbManager.getFollowerUsers(profileUserId);
        break;
      case WhoCaresMeMode.followings:
        final profileUserId = id;
        results = await dbManager.getFollowingUsers(profileUserId);
        break;
    }

    return results;
  }
}
