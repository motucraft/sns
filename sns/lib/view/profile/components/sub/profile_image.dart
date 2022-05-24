import 'package:flutter/material.dart';
import 'package:sns/view/common/components/circle_photo.dart';
import 'package:sns/view_models/profile_view_model.dart';
import 'package:provider/provider.dart';

class ProfileImage extends StatelessWidget {
  const ProfileImage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final profileViewModel = context.read<ProfileViewModel>();
    final profileUser = profileViewModel.profileUser;

    return CirclePhoto(
      photoUrl: profileUser.photoUrl,
      isImageFromFile: false,
      radius: 40.0,
    );
  }
}
