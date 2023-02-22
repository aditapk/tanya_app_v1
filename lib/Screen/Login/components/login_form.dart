import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tanya_app_v1/Screen/Notify/notify_screen_old.dart';
import 'package:tanya_app_v1/Screen/Signup/signup_screen.dart';
import 'package:tanya_app_v1/components/already_have_an_account_acheck.dart';
import 'package:tanya_app_v1/constants.dart';

import '../../../home_app_screen.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({
    Key? key,
  }) : super(key: key);

  void toHomeScreen() {
    Get.to(() => HomeAppScreen());
  }

  void toSignUpScreen() {
    Get.to(() => SignUpScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          TextFormField(
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            cursorColor: kPrimaryColor,
            onSaved: (email) {},
            decoration: const InputDecoration(
              hintText: "Your email",
              prefixIcon: Padding(
                padding: EdgeInsets.all(defaultPadding),
                child: Icon(Icons.person),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultPadding),
            child: TextFormField(
              textInputAction: TextInputAction.done,
              obscureText: true,
              cursorColor: kPrimaryColor,
              decoration: const InputDecoration(
                hintText: "Your password",
                prefixIcon: Padding(
                  padding: EdgeInsets.all(defaultPadding),
                  child: Icon(Icons.lock),
                ),
              ),
            ),
          ),
          const SizedBox(height: defaultPadding),
          SizedBox(
            width: double.infinity,
            height: hSizeButton,
            child: ElevatedButton(
              onPressed: toHomeScreen,
              child: Text(
                "Login".toUpperCase(),
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
          ),
          const SizedBox(height: defaultPadding),
          AlreadyHaveAnAccountCheck(
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const SignUpScreen();
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
