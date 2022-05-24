import 'package:flutter/material.dart';
import 'package:sns/generated/l10n.dart';
import 'package:sns/style.dart';
import 'package:sns/utils/constant.dart';
import 'package:sns/view/who_cares_me/screens/who_cares_me_screen.dart';
import 'package:sns/view_models/profile_view_model.dart';
import 'package:provider/provider.dart';

class ProfileRecords extends StatelessWidget {
  const ProfileRecords({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final profileViewModel = context.read<ProfileViewModel>();

    return Row(
      children: [
        FutureBuilder(
          future: profileViewModel.getNumberOfPosts(),
          builder: (context, AsyncSnapshot<int> snapshot) {
            return _userRecordWidget(
              context: context,
              score: snapshot.hasData ? snapshot.data! : 0,
              title: S
                  .of(context)
                  .post,
            );
          },
        ),
        FutureBuilder(
          future: profileViewModel.getNumberOfFollowers(),
          builder: (context, AsyncSnapshot<int> snapshot) {
            return _userRecordWidget(
              context: context,
              score: snapshot.hasData ? snapshot.data! : 0,
              title: S
                  .of(context)
                  .followers,
              whoCaresMeMode: WhoCaresMeMode.followed,
            );
          },
        ),
        FutureBuilder(
          future: profileViewModel.getNumberOfFollowings(),
          builder: (context, AsyncSnapshot<int> snapshot) {
            return _userRecordWidget(
              context: context,
              score: snapshot.hasData ? snapshot.data! : 0,
              title: S
                  .of(context)
                  .followings,
              whoCaresMeMode: WhoCaresMeMode.followings,
            );
          },
        ),
      ],
    );
  }

  _userRecordWidget({required BuildContext context,
    required int score,
    required String title,
    WhoCaresMeMode? whoCaresMeMode}) {
    return Expanded(
      flex: 1,
      child: GestureDetector(
        onTap: whoCaresMeMode == null
            ? null
            : () => _checkFollowUsers(context, whoCaresMeMode),
        child: Column(
          children: [
            Text(
              score.toString(),
              style: profileRecordScoreTextStyle,
            ),
            Text(
              title,
              style: profileRecordTitleTextStyle,
            ),
          ],
        ),
      ),
    );
  }

  _checkFollowUsers(BuildContext context, WhoCaresMeMode whoCaresMeMode) {
    final profileViewModel = context.read<ProfileViewModel>();
    final profileUser = profileViewModel.profileUser;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            WhoCaresMeScreen(
              mode: whoCaresMeMode,
              id: profileUser.userId,
            ),
      ),
    );
  }
}
