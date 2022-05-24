import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sns/generated/l10n.dart';
import 'package:sns/style.dart';
import 'package:sns/view/common/components/button_with_icon.dart';
import 'package:sns/view/home_screen.dart';
import 'package:sns/view_models/login_view_model.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Consumer<LoginViewModel>(
          builder: (BuildContext context, model, Widget? child) {
            return model.isLoading
                ? const CircularProgressIndicator()
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        S.of(context).appTitle,
                        style: loginTitleTextStyle,
                      ),
                      const SizedBox(height: 8.0),
                      ButtonWithIcon(
                        iconData: FontAwesomeIcons.rightToBracket,
                        label: S.of(context).signIn,
                        onPressed: () => _login(context),
                      ),
                    ],
                  );
          },
        ),
      ),
    );
  }

  _login(BuildContext context) async {
    final loginViewModel = context.read<LoginViewModel>();
    await loginViewModel.signIn();

    if (!loginViewModel.isSuccessful) {
      Fluttertoast.showToast(msg: S.of(context).signInFailed);
      return;
    }
    _openHomeScreen(context);
  }

  void _openHomeScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const HomeScreen(),
      ),
    );
  }
}
