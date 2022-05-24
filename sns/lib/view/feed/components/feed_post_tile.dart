import 'package:flutter/material.dart';
import 'package:sns/data_models/post.dart';
import 'package:sns/data_models/user.dart';
import 'package:sns/utils/constant.dart';
import 'package:sns/view/feed/components/sub/feed_post_comments_parat.dart';
import 'package:sns/view/feed/components/sub/feed_post_header_part.dart';
import 'package:sns/view/feed/components/sub/feed_post_likes_part.dart';
import 'package:sns/view/feed/components/sub/image_from_url.dart';
import 'package:sns/view_models/feed_view_model.dart';
import 'package:provider/provider.dart';

class FeedPostTile extends StatelessWidget {
  final FeedMode feedMode;

  final Post post;

  const FeedPostTile({Key? key, required this.feedMode, required this.post})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final feedViewModel = context.read<FeedViewModel>();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: FutureBuilder(
        future: feedViewModel.getPostUserInfo(post.userId),
        builder: (context, AsyncSnapshot<User> snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            final postUser = snapshot.data!;
            final currentUser = feedViewModel.currentUser;
            print('postUser: $postUser');

            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                FeedPostHeaderPart(
                  currentUser: currentUser,
                  post: post,
                  postUser: postUser,
                  feedMode: feedMode,
                ),
                ImageFromUrl(imageUrl: post.imageUrl),
                FeedPostLikesPart(
                  post: post,
                  postUser: postUser,
                ),
                FeedPostCommentsPart(
                  postUser: postUser,
                  post: post,
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
}
