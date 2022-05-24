import 'package:flutter/material.dart';
import 'package:sns/data_models/post.dart';
import 'package:sns/generated/l10n.dart';
import 'package:sns/style.dart';
import 'package:sns/view/common/components/circle_photo.dart';
import 'package:sns/view_models/comments_view_model.dart';
import 'package:provider/provider.dart';

class CommentInputPart extends StatefulWidget {
  final Post post;

  const CommentInputPart({Key? key, required this.post}) : super(key: key);

  @override
  State<CommentInputPart> createState() => _CommentInputPartState();
}

class _CommentInputPartState extends State<CommentInputPart> {
  final _commentInputController = TextEditingController();
  bool isCommentPostEnabled = false;

  @override
  initState() {
    super.initState();
    _commentInputController.addListener(_onCommentChanged);
  }

  @override
  dispose() {
    _commentInputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cardColor = Theme.of(context).cardColor;
    final commentsViewModel = context.watch<CommentsViewModel>();
    final commenter = commentsViewModel.currentUser;

    return Card(
      color: cardColor,
      child: ListTile(
        leading: CirclePhoto(
          photoUrl: commenter.photoUrl,
          isImageFromFile: false,
        ),
        title: TextField(
          maxLines: null,
          controller: _commentInputController,
          style: commentInputTextStyle,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: S.of(context).addComment,
          ),
        ),
        trailing: TextButton(
          onPressed: isCommentPostEnabled
              ? () => _postComment(context, widget.post)
              : null,
          child: Text(
            S.of(context).post,
            style: TextStyle(
              color: isCommentPostEnabled ? Colors.blue : Colors.grey,
            ),
          ),
        ),
      ),
    );
  }

  void _onCommentChanged() {
    final commentsViewModel = context.read<CommentsViewModel>();
    commentsViewModel.comment = _commentInputController.text;
    print('Comments in ViewModel: ${commentsViewModel.comment}');

    setState(() {
      if (_commentInputController.text.isNotEmpty) {
        isCommentPostEnabled = true;
      } else {
        isCommentPostEnabled = false;
      }
    });
  }

  // TODO
  _postComment(BuildContext context, Post post) async {
    final commentsViewModel = context.read<CommentsViewModel>();
    await commentsViewModel.postComment(post);
    _commentInputController.clear();
  }
}
