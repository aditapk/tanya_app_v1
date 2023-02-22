import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text('Header message'),
            Text('Detail message'),
            SizedBox(height: 20),
            UsernameTextField(),
            SizedBox(height: 20),
            PasswordTextField(),
            SizedBox(height: 20),
            SignInButton(),
          ],
        ),
      ),
    ));
  }
}

class UsernameTextField extends StatelessWidget {
  const UsernameTextField({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
            color: Colors.grey[200],
            border: Border.all(
              color: Colors.black26,
            ),
            borderRadius: BorderRadius.circular(10)),
        child: const Padding(
          padding: EdgeInsets.only(left: 20.0),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Username',
              border: InputBorder.none,
            ),
          ),
        ),
      ),
    );
  }
}

class PasswordTextField extends StatelessWidget {
  const PasswordTextField({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
            color: Colors.grey[200],
            border: Border.all(
              color: Colors.black26,
            ),
            borderRadius: BorderRadius.circular(12)),
        child: const Padding(
          padding: EdgeInsets.only(left: 20.0),
          child: TextField(
            obscureText: true,
            decoration: InputDecoration(
              hintText: 'Password',
              border: InputBorder.none,
            ),
          ),
        ),
      ),
    );
  }
}

class SignInButton extends StatelessWidget {
  const SignInButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.greenAccent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Center(
          child: Text(
            'Sign In',
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.black54,
            ),
          ),
        ),
      ),
    );
  }
}
