import 'package:flutter/material.dart';
import 'package:sns/generated/l10n.dart';
import 'package:sns/utils/constant.dart';
import 'package:sns/view/login/login_screen.dart';
import 'package:sns/view_models/profile_view_model.dart';
import 'package:sns/view_models/theme_change_view_model.dart';
import 'package:provider/provider.dart';

class ProfileSettingPart extends StatelessWidget {
  final ProfileMode mode;

  const ProfileSettingPart({Key? key, required this.mode}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeChangeViewModel = context.watch<ThemeChangeViewModel>();
    final isDarkOn = themeChangeViewModel.isDarkOn;

    return PopupMenuButton(
      icon: const Icon(Icons.settings),
      onSelected: (ProfileSettingMenu value) =>
          _onPopupMenuSelected(context, value, isDarkOn),
      itemBuilder: (context) {
        if (mode == ProfileMode.myself) {
          return [
            PopupMenuItem(
              value: ProfileSettingMenu.themeChange,
              child: isDarkOn
                  ? Text(
                      S.of(context).changeToLightTheme,
                    )
                  : Text(
                      S.of(context).changeToDarkTheme,
                    ),
            ),
            PopupMenuItem(
              value: ProfileSettingMenu.signOut,
              child: Text(
                S.of(context).signOut,
              ),
            ),
          ];
        } else {
          return [
            PopupMenuItem(
              value: ProfileSettingMenu.themeChange,
              child: Text(
                S.of(context).changeToLightTheme,
              ),
            ),
          ];
        }
      },
    );
  }

  _onPopupMenuSelected(
      BuildContext context, ProfileSettingMenu selectedMenu, bool isDarkOn) {
    switch (selectedMenu) {
      case ProfileSettingMenu.themeChange:
        final themeChangeViewModel = context.read<ThemeChangeViewModel>();
        themeChangeViewModel.setTheme(!isDarkOn);
        break;
      case ProfileSettingMenu.signOut:
        _signOut(context);
        break;
    }
  }

  void _signOut(BuildContext context) async {
    final profileViewModel = context.read<ProfileViewModel>();
    await profileViewModel.signOut();
    await Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const LoginScreen()));
  }
}
