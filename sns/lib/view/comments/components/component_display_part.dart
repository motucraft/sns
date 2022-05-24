import 'package:flutter/material.dart';
import 'package:sns/style.dart';
import 'package:sns/utils/functions.dart';
import 'package:sns/view/common/components/circle_photo.dart';
import 'package:sns/view/common/components/comment_rich_text.dart';

class CommentDisplayPart extends StatelessWidget {
  final String postUserPhotoUrl;
  final String name;
  final String text;
  final DateTime postDateTime;
  final GestureLongPressCallback? onLongPress;

  const CommentDisplayPart(
      {Key? key,
      required this.postUserPhotoUrl,
      required this.name,
      required this.text,
      required this.postDateTime,
      this.onLongPress})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        splashColor: Colors.grey,
        onLongPress: onLongPress,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CirclePhoto(
              photoUrl: postUserPhotoUrl,
              isImageFromFile: false,
            ),
            const SizedBox(
              width: 8.0,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CommentRichText(
                    name: name,
                    text: text,
                  ),
                  Text(
                    createTimeAgoString(postDateTime),
                    style: timeAgoTextStyle,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
