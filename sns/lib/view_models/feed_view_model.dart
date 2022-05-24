import 'package:flutter/material.dart';
import 'package:sns/data_models/comments.dart';
import 'package:sns/data_models/like.dart';
import 'package:sns/data_models/post.dart';
import 'package:sns/data_models/user.dart';
import 'package:sns/models/repositories/post_repository.dart';
import 'package:sns/models/repositories/user_repository.dart';
import 'package:sns/utils/constant.dart';

class FeedViewModel extends ChangeNotifier {
  final UserRepository userRepository;
  final PostRepository postRepository;
  String caption = '';

  FeedViewModel({required this.userRepository, required this.postRepository});

  bool isProcessing = false;
  List<Post> posts = [];

  late User feedUser;

  User get currentUser => UserRepository.currentUser!;

  void setFeedUser(FeedMode feedMode, User? user) {
    if (feedMode == FeedMode.fromFeed) {
      feedUser = currentUser;
    } else {
      feedUser = user!;
    }
  }

  Future<void> getPosts(FeedMode feedMode) async {
    isProcessing = true;
    notifyListeners();

    posts = await postRepository.getPosts(feedMode, feedUser);

    isProcessing = false;
    notifyListeners();
  }

  Future<User> getPostUserInfo(String userId) async {
    return await userRepository.getUserById(userId);
  }

  Future<void> updatePost(Post post, FeedMode feedMode) async {
    isProcessing = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 10));
    await postRepository.updatePost(post.copyWith(caption: caption));
    await getPosts(feedMode);

    isProcessing = false;
    notifyListeners();
  }

  Future<List<Comment>> getComments(String postId) async {
    return await postRepository.getComments(postId);
  }

  Future<void> likeIt(Post post) async {
    isProcessing = true;
    notifyListeners();
    await postRepository.likeIt(post, currentUser);
    isProcessing = false;
    notifyListeners();
  }

  Future<LikeResult> getLikeResult(String postId) async {
    return await postRepository.getLikeResult(postId, currentUser);
  }

  Future<void> unLikeIt(Post post) async {
    isProcessing = true;
    notifyListeners();
    await postRepository.unLikeIt(post, currentUser);
    isProcessing = false;
    notifyListeners();
  }

  Future<void> deletePost(Post post, FeedMode feedMode) async {
    isProcessing = true;
    notifyListeners();

    await postRepository.deletePost(post.postId, post.imageStoragePath);
    await getPosts(feedMode);

    isProcessing = false;
    notifyListeners();
  }
}
