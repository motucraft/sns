import 'package:flutter/material.dart';
import 'package:sns/style.dart';
import 'package:sns/view/common/components/circle_photo.dart';

class UserCard extends StatelessWidget {
  final VoidCallback? onTap;
  final String photoUrl;
  final String title;
  final String subTitle;
  final Widget? trailing;

  const UserCard(
      {Key? key,
      this.onTap,
      required this.photoUrl,
      required this.title,
      required this.subTitle,
      this.trailing})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.blueGrey,
      onTap: onTap,
      child: ListTile(
        leading: CirclePhoto(
          photoUrl: photoUrl,
          isImageFromFile: false,
        ),
        title: Text(
          title,
          style: userCardTitleTextStyle,
        ),
        subtitle: Text(
          subTitle,
          style: userCardSubTitleTextStyle,
        ),
        trailing: trailing,
      ),
    );
  }
}
