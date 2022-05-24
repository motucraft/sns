import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sns/data_models/like.dart';
import 'package:sns/data_models/post.dart';
import 'package:sns/data_models/user.dart';
import 'package:sns/generated/l10n.dart';
import 'package:sns/style.dart';
import 'package:sns/utils/constant.dart';
import 'package:sns/view/comments/screens/comments_screen.dart';
import 'package:sns/view/who_cares_me/screens/who_cares_me_screen.dart';
import 'package:sns/view_models/feed_view_model.dart';
import 'package:provider/provider.dart';

class FeedPostLikesPart extends StatelessWidget {
  final Post post;
  final User postUser;

  const FeedPostLikesPart(
      {Key? key, required this.post, required this.postUser})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final feedViewModel = context.read<FeedViewModel>();

    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: FutureBuilder(
        future: feedViewModel.getLikeResult(post.postId),
        builder: (context, AsyncSnapshot<LikeResult> snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            final likeResult = snapshot.data!;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    likeResult.isLikedToThisPost
                        ? IconButton(
                            onPressed: () => feedViewModel.isProcessing
                                ? null
                                : _unLikeIt(context),
                            icon: const FaIcon(FontAwesomeIcons.solidHeart),
                          )
                        : IconButton(
                            onPressed: () => feedViewModel.isProcessing
                                ? null
                                : _likeIt(context),
                            icon: const FaIcon(FontAwesomeIcons.heart),
                          ),
                    IconButton(
                      onPressed: () => _openCommentScreen(context),
                      icon: const FaIcon(FontAwesomeIcons.comment),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () => _checkLikesUsers(context),
                  child: Text(
                    likeResult.likes.length.toString() +
                        ' ' +
                        S.of(context).likes,
                    style: numberOfLikesTextStyle,
                  ),
                ),
              ],
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }

  _openCommentScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CommentsScreen(
          post: post,
          postUser: postUser,
        ),
      ),
    );
  }

  _likeIt(BuildContext context) async {
    final feedViewModel = context.read<FeedViewModel>();
    await feedViewModel.likeIt(post);
  }

  // いいねをやめる
  _unLikeIt(BuildContext context) async {
    final feedViewModel = context.read<FeedViewModel>();
    await feedViewModel.unLikeIt(post);
  }

  _checkLikesUsers(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => WhoCaresMeScreen(
          mode: WhoCaresMeMode.like,
          id: post.postId,
        ),
      ),
    );
  }
}
