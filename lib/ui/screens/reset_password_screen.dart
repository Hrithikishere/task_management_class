import 'package:flutter/material.dart';
import 'package:task_management/ui/screens/sign_in_screen.dart';
import 'package:task_management/ui/widgets/screen_background.dart';
import '../utils/app_colors.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() =>
      _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  @override
  Widget build(BuildContext context) {
    TextTheme textThemeStyle = Theme.of(context).textTheme;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: ScreenBackground(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 35.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Set Password",
                style: textThemeStyle.titleLarge
                    ?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                "Minimum length password 8 character with letter and number combination",
                style: textThemeStyle.bodyMedium
                    ?.copyWith(fontWeight: FontWeight.w400, color: Colors.grey),
              ),
              const SizedBox(height: 30),
              _buildVerifyEmailForm(),
              const SizedBox(height: 40),
              _haveAccountSection(),
            ],
          ),
        ),
      ),
    );
  }

  Column _buildVerifyEmailForm() {
    return Column(
      children: [
        TextFormField(
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(hintText: 'Password')),
        const SizedBox(height: 10),
        TextFormField(
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(hintText: 'Confirm Password')),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: _onTapConfirmButton,
          child: const Text("Confirm", style: TextStyle(fontSize: 14, color: AppColors.onThemeColor),),
        ),
      ],
    );
  }

  Column _haveAccountSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Have an account? ",
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
            ),
            InkWell(
              onTap: _onTapSignInButton,
              child: const Text(
                "Sign In",
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                    color: AppColors.themeColor),
              ),
            )
          ],
        ),
      ],
    );
  }

  void _onTapConfirmButton() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => const SignInScreen(),
      )
    );
  }

  void _onTapSignInButton() {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const SignInScreen()),
            (_) => false);
  }
}
