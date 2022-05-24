import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:sns/di/providers.dart';
import 'package:sns/firebase_options.dart';
import 'package:sns/generated/l10n.dart';
import 'package:sns/models/repositories/theme_change_repository.dart';
import 'package:sns/view/home_screen.dart';
import 'package:sns/view/login/login_screen.dart';
import 'package:sns/view_models/login_view_model.dart';
import 'package:sns/view_models/theme_change_view_model.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as time_ago;

import 'firebase_options.dart';

void main() async {
  // main関数内で非同期処理を行うため
  WidgetsFlutterBinding.ensureInitialized();

  final themeChangeRepository = ThemeChangeRepository();
  await themeChangeRepository.getIsDarkOn();

  time_ago.setLocaleMessages('ja', time_ago.JaMessages());

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: globalProviders,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final loginViewModel = context.read<LoginViewModel>();
    final themeChangeViewModel = context.watch<ThemeChangeViewModel>();

    return MaterialApp(
      title: 'DaitaInstagram',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      theme: themeChangeViewModel.selectedTheme,
      home: FutureBuilder(
        future: loginViewModel.isSignIn(),
        builder: (context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.hasData && snapshot.data == true) {
            return const HomeScreen();
          } else {
            return const LoginScreen();
          }
        },
      ),
    );
  }
}
