import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'core/user_prefs.dart';
import 'views/intro_view.dart';
import 'views/login_view.dart';
import 'views/profile_setup_view.dart';
import 'views/home_feed_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  bool loggedIn = await UserPrefs.isLoggedIn();
  bool profileDone = await UserPrefs.isProfileDone();

  Widget initialScreen = const IntroView();
  if (loggedIn && profileDone) {
    initialScreen = const HomeFeedView();
  } else if (loggedIn && !profileDone) {
    initialScreen = const ProfileSetupView();
  }

  runApp(FizzLiveApp(initialScreen: initialScreen));
}

class FizzLiveApp extends StatelessWidget {
  final Widget initialScreen;
  const FizzLiveApp({super.key, required this.initialScreen});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fizz Live Pro',
      theme: ThemeData.dark(),
      home: initialScreen,
    );
  }
}
