import 'package:flutter/material.dart';
import 'package:sns/style.dart';

class CommentRichText extends StatefulWidget {
  final String name;
  final String text;

  const CommentRichText({Key? key, required this.name, required this.text})
      : super(key: key);

  @override
  State<CommentRichText> createState() => _CommentRichTextState();
}

class _CommentRichTextState extends State<CommentRichText> {
  int _maxLines = 2;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _maxLines = 100;
        });
      },
      child: RichText(
        maxLines: _maxLines,
        overflow: TextOverflow.ellipsis,
        text: TextSpan(style: DefaultTextStyle
            .of(context)
            .style, children: [
          TextSpan(
            text: widget.name,
            style: commentNameTextStyle,
          ),
          const TextSpan(text: ' '),
          TextSpan(
            text: widget.text,
            style: commentContentTextStyle,
          ),
        ]),
      ),
    );
  }
}
