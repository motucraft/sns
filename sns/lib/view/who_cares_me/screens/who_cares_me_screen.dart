import 'package:flutter/material.dart';
import 'package:sns/data_models/user.dart';
import 'package:sns/generated/l10n.dart';
import 'package:sns/utils/constant.dart';
import 'package:sns/view/common/components/user_card.dart';
import 'package:sns/view/profile/screens/profile_screen.dart';
import 'package:sns/view_models/who_cares_me_view_model.dart';
import 'package:provider/provider.dart';

class WhoCaresMeScreen extends StatelessWidget {
  final WhoCaresMeMode mode;
  final String id;

  const WhoCaresMeScreen({Key? key, required this.mode, required this.id})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final whoCaresMeViewModel = context.read<WhoCaresMeViewModel>();

    Future(() => whoCaresMeViewModel.getCaresMeUsers(id, mode));

    return Consumer<WhoCaresMeViewModel>(
      builder: (_, model, child) => Scaffold(
        appBar: AppBar(
          title: Text(_titleText(context, model.whoCaresMeMode)),
        ),
        body: model.careMeUsers.isEmpty
            ? Container()
            : ListView.builder(
                itemCount: model.careMeUsers.length,
                itemBuilder: (context, int index) {
                  final user = model.careMeUsers[index];
                  return UserCard(
                    photoUrl: user.photoUrl,
                    title: user.inAppUserName,
                    subTitle: user.bio,
                    onTap: () => _openProfileScreen(context, user),
                  );
                },
              ),
      ),
    );
  }

  String _titleText(BuildContext context, WhoCaresMeMode mode) {
    var titleText = '';
    switch (mode) {
      case WhoCaresMeMode.like:
        titleText = S.of(context).likes;
        break;
      case WhoCaresMeMode.followings:
        titleText = S.of(context).followings;
        break;
      case WhoCaresMeMode.followed:
        titleText = S.of(context).followers;
        break;
    }

    return titleText;
  }

  _openProfileScreen(BuildContext context, User user) {
    final whoCaresMeViewModel = context.read<WhoCaresMeViewModel>();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProfileScreen(
          profileMode: user.userId == whoCaresMeViewModel.currentUser.userId
              ? ProfileMode.myself
              : ProfileMode.other,
          selectedUser: user,
          popProfileUserId: id,
        ),
      ),
    );
  }
}
