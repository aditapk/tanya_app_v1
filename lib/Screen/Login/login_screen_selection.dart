import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:tanya_app_v1/Model/user_login_model.dart';
import 'package:tanya_app_v1/Screen/Login/login_screen.dart';
import 'package:tanya_app_v1/Screen/Signup/signup_screen.dart';
import 'package:tanya_app_v1/home_app_screen.dart';
import 'package:tanya_app_v1/utils/constans.dart';

class LoginScreenSelection extends StatelessWidget {
  const LoginScreenSelection({super.key});

  @override
  Widget build(BuildContext context) {
    var userLoginBox = Hive.box<UserLogin>(HiveDatabaseName.USER_LOGIN);
    var userLogin = userLoginBox.get(0);

    if (userLogin == null) {
      // first Login
      return const SignUpScreen();
    } else if (userLogin.logOut!) {
      // have logout
      return const LoginScreen();
    } else {
      if (userLogin.beginningUse == null) {
        userLogin.beginningUse = true;
        userLogin.save();
        return ShowCaseWidget(
          builder: (context) => const HomeAppScreen(
            showHelp: true,
          ),
        );
      } else {
        return ShowCaseWidget(
          builder: (context) => const HomeAppScreen(
            showHelp: false,
          ),
        );
      }
    }
  }
}
