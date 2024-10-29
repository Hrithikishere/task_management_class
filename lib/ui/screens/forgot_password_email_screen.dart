import 'package:flutter/material.dart';
import 'package:task_management/ui/widgets/screen_background.dart';

import '../utils/app_colors.dart';
import 'forgot_password_otp_screen.dart';

class ForgotPasswordEmailScreen extends StatefulWidget {
  const ForgotPasswordEmailScreen({super.key});

  @override
  State<ForgotPasswordEmailScreen> createState() =>
      _ForgotPasswordEmailScreenState();
}

class _ForgotPasswordEmailScreenState extends State<ForgotPasswordEmailScreen> {
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
                "Your Email Address",
                style: textThemeStyle.titleLarge
                    ?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                "A 6 digit verification pin will send to your email address",
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
            decoration: const InputDecoration(hintText: 'Email')),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: _onTapNextButton,
          child: const Icon(Icons.arrow_forward_ios),
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

  void _onTapNextButton() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => const ForgotPasswordOtpScreen(),
      )
    );
    //TODO: Tap next button navigate to next screen
  }

  void _onTapSignInButton() {
    Navigator.pop(context);
  }
}
