import 'package:flutter/material.dart';
import 'package:sns/data_models/user.dart';
import 'package:sns/utils/constant.dart';
import 'package:sns/view/profile/components/profile_detail_part.dart';
import 'package:sns/view/profile/components/profile_posts_grid_part.dart';
import 'package:sns/view/profile/components/profile_setting_part.dart';
import 'package:sns/view_models/profile_view_model.dart';
import 'package:sns/view_models/who_cares_me_view_model.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatelessWidget {
  final ProfileMode profileMode;
  final User? selectedUser;
  final bool isOpenFromProfileScreen;
  final String? popProfileUserId;

  const ProfilePage(
      {Key? key,
      required this.profileMode,
      this.selectedUser,
      required this.isOpenFromProfileScreen,
      this.popProfileUserId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final profileViewModel = context.read<ProfileViewModel>();
    profileViewModel.setProfileUser(
        profileMode, selectedUser, popProfileUserId);

    Future(() => profileViewModel.getPost());

    return Scaffold(
      body: Consumer<ProfileViewModel>(
        builder: (context, viewModel, child) {
          final profileUser = viewModel.profileUser;
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                leadingWidth: (!isOpenFromProfileScreen) ? 0.0 : 56.0,
                leading: (!isOpenFromProfileScreen)
                    ? Container()
                    : IconButton(
                        onPressed: () {
                          viewModel.popProfileUser();
                          _popWithRebuildWhoCaredMeScreen(
                              context, viewModel.popProfileUserId);
                        },
                        icon: const Icon(Icons.arrow_back),
                      ),
                title: Text(profileUser.inAppUserName),
                pinned: true,
                floating: true,
                actions: [
                  ProfileSettingPart(mode: profileMode),
                ],
                expandedHeight: 280.0,
                flexibleSpace: FlexibleSpaceBar(
                  background: ProfileDetailPart(
                    mode: profileMode,
                  ),
                ),
              ),
              ProfilePostsGridPart(
                posts: viewModel.posts,
              ),
            ],
          );
        },
      ),
    );
  }

  void _popWithRebuildWhoCaredMeScreen(
      BuildContext context, String popProfileUserId) {
    final whoCaresMeViewModel = context.read<WhoCaresMeViewModel>();
    whoCaresMeViewModel.rebuildAfterPop(popProfileUserId);
    Navigator.pop(context);
  }
}
