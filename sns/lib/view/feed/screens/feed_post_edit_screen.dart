import 'package:flutter/material.dart';
import 'package:sns/data_models/post.dart';
import 'package:sns/data_models/user.dart';
import 'package:sns/generated/l10n.dart';
import 'package:sns/utils/constant.dart';
import 'package:sns/view/common/components/user_card.dart';
import 'package:sns/view/common/dialog/confirm_dialog.dart';
import 'package:sns/view/post/components/post_caption_part.dart';
import 'package:sns/view_models/feed_view_model.dart';
import 'package:provider/provider.dart';

class FeedPostEditScreen extends StatelessWidget {
  final Post post;
  final User postUser;
  final FeedMode feedMode;

  const FeedPostEditScreen(
      {Key? key,
      required this.post,
      required this.postUser,
      required this.feedMode})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<FeedViewModel>(
      builder: (_, model, child) {
        return Scaffold(
          appBar: AppBar(
            leading: model.isProcessing
                ? Container()
                : IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
            title: model.isProcessing
                ? Text(S.of(context).underProcessing)
                : Text(S.of(context).editInfo),
            actions: [
              model.isProcessing
                  ? Container()
                  : IconButton(
                      onPressed: () => showConfirmDialog(
                        context: context,
                        title: S.of(context).editPost,
                        content: S.of(context).editPostConfirm,
                        onConfirmed: (isConfirmed) {
                          if (isConfirmed) {
                            _updatePost(context);
                          }
                        },
                      ),
                      icon: const Icon(Icons.done),
                    ),
            ],
          ),
          body: model.isProcessing
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      UserCard(
                        photoUrl: postUser.photoUrl,
                        title: postUser.inAppUserName,
                        subTitle: post.locationString,
                        onTap: null,
                      ),
                      PostCaptionPart(
                        from: PostCaptionOpenMode.fromFeed,
                        post: post,
                      ),
                    ],
                  ),
                ),
        );
      },
    );
  }

  void _updatePost(BuildContext context) async {
    final feedViewModel = context.read<FeedViewModel>();
    await feedViewModel.updatePost(post, feedMode);
    Navigator.pop(context);
  }
}
