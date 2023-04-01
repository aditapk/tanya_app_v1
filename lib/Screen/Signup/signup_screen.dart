import 'package:flutter/material.dart';

import 'package:tanya_app_v1/constants.dart';

import 'components/sign_up_top_image.dart';
import 'components/signup_form.dart';
//import 'components/socal_sign_up.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 40,
              ),
              const SignUpScreenTopImage(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.85,
                      child: const SignUpForm(),
                    ),
                    const SizedBox(height: defaultPadding / 2),
                    // SocalSignUp()
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
