import 'package:flutter/material.dart';
import 'package:sns/data_models/comments.dart';
import 'package:sns/data_models/post.dart';
import 'package:sns/data_models/user.dart';
import 'package:sns/generated/l10n.dart';
import 'package:sns/style.dart';
import 'package:sns/utils/functions.dart';
import 'package:sns/view/comments/screens/comments_screen.dart';
import 'package:sns/view/common/components/comment_rich_text.dart';
import 'package:sns/view_models/feed_view_model.dart';
import 'package:provider/provider.dart';

class FeedPostCommentsPart extends StatelessWidget {
  final Post post;
  final User postUser;

  const FeedPostCommentsPart(
      {Key? key, required this.post, required this.postUser})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final feedViewModel = context.read<FeedViewModel>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 投稿者名とキャプション
          CommentRichText(
            name: postUser.inAppUserName,
            text: post.caption,
          ),
          InkWell(
            onTap: () => _openCommentScreen(context),
            child: FutureBuilder(
              future: feedViewModel.getComments(post.postId),
              builder: (context, AsyncSnapshot<List<Comment>> snapshot) {
                if (snapshot.hasData && snapshot.data != null) {
                  final comments = snapshot.data!;
                  return Text(
                    comments.length.toString() + ' ' + S.of(context).comments,
                    style: numberOfCommentsTextStyle,
                  );
                } else {
                  return Container();
                }
              },
            ),
          ),
          Text(
            createTimeAgoString(post.postDateTime),
            style: timeAgoTextStyle,
          ),
        ],
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
}
