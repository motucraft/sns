import 'package:flutter/material.dart';
import 'package:sns/data_models/user.dart';
import 'package:sns/utils/constant.dart';
import 'package:sns/view/profile/pages/profile_page.dart';

class ProfileScreen extends StatelessWidget {
  final ProfileMode profileMode;
  final User selectedUser;
  final String popProfileUserId;

  const ProfileScreen(
      {Key? key,
      required this.profileMode,
      required this.selectedUser,
      required this.popProfileUserId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ProfilePage(
      profileMode: profileMode,
      selectedUser: selectedUser,
      isOpenFromProfileScreen: true,
      popProfileUserId: popProfileUserId,
    );
  }
}
