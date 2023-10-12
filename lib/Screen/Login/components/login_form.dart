import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:tanya_app_v1/GetXBinding/medicine_state_binding.dart';
import 'package:tanya_app_v1/Model/user_login_model.dart';
import 'package:tanya_app_v1/Screen/Signup/signup_screen.dart';
import 'package:tanya_app_v1/components/already_have_an_account_acheck.dart';
import 'package:tanya_app_v1/constants.dart';
import 'package:tanya_app_v1/home_app_screen.dart';
import 'package:tanya_app_v1/utils/constans.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({
    Key? key,
  }) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController userTextController = TextEditingController();
  final TextEditingController passwordTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          TextField(
            controller: userTextController,
            cursorColor: kPrimaryColor,
            textInputAction: TextInputAction.next,
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
            child: TextField(
              controller: passwordTextController,
              obscureText: true,
              cursorColor: kPrimaryColor,
              textInputAction: TextInputAction.done,
              decoration: const InputDecoration(
                hintText: "รหัสผ่าน",
                prefixIcon: Padding(
                  padding: EdgeInsets.all(defaultPadding),
                  child: Icon(Icons.lock),
                ),
              ),
            ),
          ),
          const SizedBox(height: defaultPadding),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 60,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12))),
              onPressed: loginAction,
              child: const Text(
                'เข้าสู่ระบบ',
                style: TextStyle(
                  fontSize: 20,
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

  void loginAction() async {
    var userLoginBox = Hive.box<UserLogin>(HiveDatabaseName.USER_LOGIN);
    var userLogin = userLoginBox.get(0);
    if (userLogin == null) {
      Get.defaultDialog(
          title: 'เข้าสู่ระบบผิดพลาด',
          middleText: 'ยังไม่มีข้อมุลผู้ใช้\nกรุณาสมัครสมาชิกก่อนเข้าระบบ',
          confirm: TextButton(
              onPressed: () {
                Get.to(const SignUpScreen());
              },
              child: const Text(
                'สมัครสมาชิก',
                style: TextStyle(fontSize: 18),
              )));
    } else {
      if (userTextController.text == userLogin.username &&
          passwordTextController.text == userLogin.password) {
        userLogin.logOut = false;
        userLogin.beginningUse = true;
        await userLogin.save();
        Get.to(
          () => ShowCaseWidget(
            builder: Builder(
              builder: (context) => HomeAppScreen(
                showHelp: userLogin.beginningUse,
              ),
            ),
          ),
          binding: AppInfoBinding(),
        );
      } else {
        Get.defaultDialog(
          title: 'เข้าสู่ระบบผิดพลาด',
          middleText: 'ข้อมูลผู้ใช้ หรือ รหัสผ่านไม่ผู้ต้อง',
          confirm: TextButton(
            onPressed: toSignUpScreen,
            child: const Text(
              'สมัครสมาชิกใหม่',
              style: TextStyle(fontSize: 18),
            ),
          ),
        );
      }
    }
  }

  void toSignUpScreen() {
    Get.to(() => const SignUpScreen());
  }
}
