import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:tanya_app_v1/Model/user_login_model.dart';
import 'package:tanya_app_v1/Screen/Login/login_screen.dart';
import 'package:tanya_app_v1/Screen/Signup/signup_screen.dart';
import 'package:tanya_app_v1/home_app_screen.dart';

class LoginScreenSelection extends StatelessWidget {
  const LoginScreenSelection({super.key});

  @override
  Widget build(BuildContext context) {
    var userLoginBox = Hive.box<UserLogin>('user_login');
    var userLogin = userLoginBox.get(0);
    if (userLogin == null) {
      //return const LoginScreen();
      return const SignUpScreen();
    } else {
      if (userLogin.logOut!) {
        return const LoginScreen();
      } else {
        return const HomeAppScreen();
      }
    }
  }
}
