import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tanya_app_v1/Screen/Signup/signup_screen.dart';
import 'package:tanya_app_v1/utils/constans.dart';

class IntroScreen extends StatelessWidget {
  const IntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Container(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/images/intro_picture.png"),
              const SizedBox(
                height: 8,
              ),
              const Text(
                Introduction.INTRO_INFO,
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 50,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12))),
                    onPressed: () {
                      Get.to(() => const SignUpScreen());
                    },
                    child: const Text(
                      "เริ่มต้นใช้งาน",
                      style: TextStyle(fontSize: 20),
                    )),
              )
            ],
          )),
    ));
  }
}
