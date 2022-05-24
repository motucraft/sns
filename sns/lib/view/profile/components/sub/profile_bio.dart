import 'package:flutter/material.dart';
import 'package:sns/data_models/user.dart';
import 'package:sns/generated/l10n.dart';
import 'package:sns/style.dart';
import 'package:sns/utils/constant.dart';
import 'package:sns/view/profile/screens/edit_profile_screen.dart';
import 'package:sns/view_models/profile_view_model.dart';
import 'package:provider/provider.dart';

class ProfileBio extends StatelessWidget {
  final ProfileMode mode;

  const ProfileBio({Key? key, required this.mode}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final profileViewModel = context.read<ProfileViewModel>();
    final profileUser = profileViewModel.profileUser;

    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(profileUser.inAppUserName),
          Text(
            profileUser.bio,
            style: profileBioTextStyle,
          ),
          const SizedBox(
            height: 16.0,
          ),
          SizedBox(
            width: double.infinity,
            child: _button(context, profileUser),
          ),
        ],
      ),
    );
  }

  _button(BuildContext context, User profileUser) {
    final profileViewModel = context.read<ProfileViewModel>();
    final isFollowing = profileViewModel.isFollowingProfileUser;

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4.0),
        ),
      ),
      child: mode == ProfileMode.myself
          ? Text(S.of(context).editProfile)
          : isFollowing
              ? Text(S.of(context).unFollow)
              : Text(S.of(context).follow),
      onPressed: () {
        mode == ProfileMode.myself
            ? _openEditProfileScreen(context)
            : isFollowing
                ? _unFollow(context)
                : _follow(context);
      },
    );
  }

  _openEditProfileScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EditProfileScreen(),
      ),
    );
  }

  // TODO
  _unFollow(BuildContext context) {
    final profileViewModel = context.read<ProfileViewModel>();
    profileViewModel.unFollow();
  }

  _follow(BuildContext context) {
    final profileViewModel = context.read<ProfileViewModel>();
    profileViewModel.follow();
  }
}
