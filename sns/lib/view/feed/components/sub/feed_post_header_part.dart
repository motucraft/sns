import 'package:flutter/material.dart';
import 'package:sns/data_models/post.dart';
import 'package:sns/data_models/user.dart';
import 'package:sns/generated/l10n.dart';
import 'package:sns/utils/constant.dart';
import 'package:sns/view/common/components/user_card.dart';
import 'package:sns/view/common/dialog/confirm_dialog.dart';
import 'package:sns/view/feed/screens/feed_post_edit_screen.dart';
import 'package:sns/view/profile/screens/profile_screen.dart';
import 'package:sns/view_models/feed_view_model.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class FeedPostHeaderPart extends StatelessWidget {
  final User postUser;
  final Post post;
  final User currentUser;
  final FeedMode feedMode;

  const FeedPostHeaderPart(
      {Key? key,
      required this.postUser,
      required this.post,
      required this.currentUser,
      required this.feedMode})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return UserCard(
      photoUrl: postUser.photoUrl,
      title: postUser.inAppUserName,
      subTitle: post.locationString,
      onTap: () => _openProfile(context, postUser),
      trailing: PopupMenuButton(
        icon: const Icon(Icons.more_vert),
        onSelected: (PostMenu value) => _onPopupMenuSelected(context, value),
        itemBuilder: (BuildContext context) {
          if (postUser.userId == currentUser.userId) {
            return [
              PopupMenuItem(
                value: PostMenu.edit,
                child: Text(S.of(context).edit),
              ),
              PopupMenuItem(
                value: PostMenu.delete,
                child: Text(S.of(context).delete),
              ),
              PopupMenuItem(
                value: PostMenu.share,
                child: Text(S.of(context).share),
              ),
            ];
          } else {
            return [
              PopupMenuItem(
                value: PostMenu.share,
                child: Text(S.of(context).share),
              ),
            ];
          }
        },
      ),
    );
  }

  _onPopupMenuSelected(BuildContext context, PostMenu selectedMenu) {
    switch (selectedMenu) {
      case PostMenu.edit:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => FeedPostEditScreen(
              post: post,
              postUser: postUser,
              feedMode: feedMode,
            ),
          ),
        );
        break;
      case PostMenu.share:
        Share.share(post.imageUrl, subject: post.caption);
        break;
      case PostMenu.delete:
        showConfirmDialog(
          context: context,
          title: S.of(context).deletePost,
          content: S.of(context).postConfirm,
          onConfirmed: (isConfirmed) {
            if (isConfirmed) {
              _deletePost(context, post);
            }
          },
        );
        break;
    }
  }

  void _deletePost(BuildContext context, Post post) async {
    final feedViewModel = context.read<FeedViewModel>();
    await feedViewModel.deletePost(post, feedMode);
  }

  _openProfile(BuildContext context, User postUser) {
    final feedViewModel = context.read<FeedViewModel>();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfileScreen(
          profileMode: postUser.userId == feedViewModel.currentUser.userId
              ? ProfileMode.myself
              : ProfileMode.other,
          selectedUser: postUser,
          popProfileUserId: currentUser.userId,
        ),
      ),
    );
  }
}
