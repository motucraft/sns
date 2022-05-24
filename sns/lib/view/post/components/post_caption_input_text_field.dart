import 'package:flutter/material.dart';
import 'package:sns/generated/l10n.dart';
import 'package:sns/style.dart';
import 'package:sns/utils/constant.dart';
import 'package:sns/view_models/feed_view_model.dart';
import 'package:sns/view_models/post_view_model.dart';
import 'package:provider/provider.dart';

class PostCaptionInputTextField extends StatefulWidget {
  final String? captionBeforeUpdated;
  final PostCaptionOpenMode? from;

  const PostCaptionInputTextField(
      {Key? key, this.captionBeforeUpdated, this.from})
      : super(key: key);

  @override
  State<PostCaptionInputTextField> createState() =>
      _PostCaptionInputTextFieldState();
}

class _PostCaptionInputTextFieldState extends State<PostCaptionInputTextField> {
  final _captionController = TextEditingController();

  @override
  initState() {
    super.initState();
    _captionController.addListener(_onCaptionUpdated);
    if (widget.from == PostCaptionOpenMode.fromFeed) {
      _captionController.text = widget.captionBeforeUpdated ?? '';
    }
  }

  @override
  dispose() {
    _captionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: TextInputType.multiline,
      maxLines: null,
      controller: _captionController,
      style: postCaptionTextStyle,
      autofocus: true,
      decoration: InputDecoration(
        hintText: S.of(context).inputCaption,
        border: InputBorder.none,
      ),
    );
  }

  _onCaptionUpdated() {
    if (widget.from == PostCaptionOpenMode.fromFeed) {
      final viewModel = context.read<FeedViewModel>();
      viewModel.caption = _captionController.text;
      print('caption fromFeed: ${viewModel.caption}');
    } else {
      final viewModel = context.read<PostViewModel>();
      viewModel.caption = _captionController.text;
      print('caption fromPost: ${viewModel.caption}');
    }
  }
}
