import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tanya_app_v1/Screen/Login/login_screen.dart';
import 'package:tanya_app_v1/Screen/Signup/signup_screen.dart';
import 'package:tanya_app_v1/constants.dart';

class LoginAndSignupBtn extends StatelessWidget {
  const LoginAndSignupBtn({
    Key? key,
  }) : super(key: key);

  void toLoginScreen() {
    Get.to(() => LoginScreen());
  }

  void toSignUpScreen() {
    Get.to(() => SignUpScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: hSizeButton,
          child: ElevatedButton(
            onPressed: toLoginScreen,
            child: Text(
              "Login".toUpperCase(),
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          height: hSizeButton,
          child: ElevatedButton(
            onPressed: toSignUpScreen,
            style: ElevatedButton.styleFrom(
                backgroundColor: defaultColor, elevation: 0),
            child: Text(
              "Sign Up".toUpperCase(),
              style: const TextStyle(
                color: Colors.black,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
