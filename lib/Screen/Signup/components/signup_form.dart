import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:tanya_app_v1/Model/user_login_model.dart';
//import 'package:tanya_app_v1/Screen/Notify/notify_screen_old.dart';
import 'package:tanya_app_v1/Screen/Login/login_screen.dart';
import 'package:tanya_app_v1/components/already_have_an_account_acheck.dart';
import 'package:tanya_app_v1/constants.dart';
import 'package:tanya_app_v1/home_app_screen.dart';
import 'package:tanya_app_v1/utils/constans.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({
    Key? key,
  }) : super(key: key);

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  void toLogInScreen() async {
    var userLoginBox = Hive.box<UserLogin>(HiveDatabaseName.USER_LOGIN);
    var userLogin = userLoginBox.get(0);
    if (userTextController.text.isNotEmpty &&
        passTextController.text.isNotEmpty) {
      if (userLogin == null) {
        // first Sign Up
        userLoginBox.add(UserLogin(
            username: userTextController.text,
            password: passTextController.text,
            lastTimeLogin: DateTime.now().toString(),
            logOut: false,
            beginningUse: true));

        // from Sign Up -> Home
        Get.to(
          () => ShowCaseWidget(
            builder: Builder(
              builder: (context) => const HomeAppScreen(
                showHelp: true, // beginning use
              ),
            ),
          ),
        );
      } else {
        // re-Sign Up
        userLogin.username = userTextController.text;
        userLogin.password = passTextController.text;
        userLogin.lastTimeLogin = DateTime.now().toString();
        userLogin.logOut = false;
        userLogin.beginningUse = true;
        await userLogin.save();

        // from Sign Up -> Home
        Get.to(
          () => ShowCaseWidget(
            builder: Builder(
              builder: (context) => HomeAppScreen(
                showHelp: userLogin.beginningUse,
              ),
            ),
          ),
        );
      }
    } else {
      // show popup
      Get.defaultDialog(
          title: "การสมัครสมาชิก",
          middleText: "ต้องระบุข้อมูลผู้ใช้และรหัสผ่าน\nเพื่อสมัครสมาชิก");
    }
  }

  TextEditingController userTextController = TextEditingController();

  TextEditingController passTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          TextFormField(
            controller: userTextController,
            textInputAction: TextInputAction.next,
            cursorColor: kPrimaryColor,
            decoration: const InputDecoration(
              hintText: "ข้อมูลผู้ใช้",
              prefixIcon: Padding(
                padding: EdgeInsets.all(defaultPadding),
                child: Icon(Icons.person),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultPadding),
            child: TextFormField(
              controller: passTextController,
              textInputAction: TextInputAction.done,
              cursorColor: kPrimaryColor,
              decoration: const InputDecoration(
                hintText: "รหัสผ่าน",
                prefixIcon: Padding(
                  padding: EdgeInsets.all(defaultPadding),
                  child: Icon(Icons.lock),
                ),
              ),
            ),
          ),
          const SizedBox(height: defaultPadding / 2),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 60,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12))),
              onPressed: toLogInScreen,
              child: const Text(
                'สมัครสมาชิก',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
          ),
          const SizedBox(height: defaultPadding),
          AlreadyHaveAnAccountCheck(
            login: false,
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const LoginScreen();
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
