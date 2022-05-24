import 'package:flutter/material.dart';
import 'package:sns/data_models/post.dart';
import 'package:sns/data_models/user.dart';
import 'package:sns/generated/l10n.dart';
import 'package:sns/view/comments/components/comment_input_part.dart';
import 'package:sns/view/comments/components/component_display_part.dart';
import 'package:sns/view/common/dialog/confirm_dialog.dart';
import 'package:sns/view_models/comments_view_model.dart';
import 'package:provider/provider.dart';

class CommentsScreen extends StatelessWidget {
  final Post post;
  final User postUser;

  const CommentsScreen({Key? key, required this.post, required this.postUser})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final commentViewModel = context.read<CommentsViewModel>();

    Future(() => commentViewModel.getComments(post.postId));

    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).comments),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // キャプション
              CommentDisplayPart(
                postUserPhotoUrl: postUser.photoUrl,
                name: postUser.inAppUserName,
                text: post.caption,
                postDateTime: post.postDateTime,
              ),
              Consumer<CommentsViewModel>(
                builder: (context, model, child) {
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: model.comments.length,
                    itemBuilder: (context, index) {
                      final comment = model.comments[index];
                      final commentUserId = comment.commentUserId;

                      return FutureBuilder(
                        future: model.getCommentUserInfo(commentUserId),
                        builder: (context, AsyncSnapshot<User> snapshot) {
                          if (snapshot.hasData && snapshot.data != null) {
                            final commentUser = snapshot.data!;
                            return CommentDisplayPart(
                              postUserPhotoUrl: commentUser.photoUrl,
                              name: commentUser.inAppUserName,
                              text: comment.comment,
                              postDateTime: comment.commentDateTime,
                              onLongPress: () => showConfirmDialog(
                                context: context,
                                title: S.of(context).deleteComment,
                                content: S.of(context).deleteCommentConfirm,
                                onConfirmed: (isConfirmed) {
                                  if (isConfirmed) {
                                    _deleteComment(context, index);
                                  }
                                },
                              ),
                            );
                          } else {
                            return Container();
                          }
                        },
                      );
                    },
                  );
                },
              ),
              // コメント入力パート
              CommentInputPart(
                post: post,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _deleteComment(BuildContext context, int commentIndex) async {
    final commentViewModel = context.read<CommentsViewModel>();
    await commentViewModel.deleteComment(post, commentIndex);
  }
}
