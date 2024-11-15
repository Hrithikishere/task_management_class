import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_management/data/models/network_response.dart';
import 'package:task_management/data/services/network_caller.dart';
import 'package:task_management/ui/widgets/centeredCircularProgressIndicator.dart';
import 'package:task_management/ui/widgets/screen_background.dart';
import 'package:task_management/ui/widgets/show_snackbar_message.dart';

import '../../data/utils/urls.dart';
import '../utils/app_colors.dart';
import 'forgot_password_otp_screen.dart';

class ForgotPasswordEmailScreen extends StatefulWidget {

  static const String name = "/forgotPasswordEmail";

  const ForgotPasswordEmailScreen({super.key});

  @override
  State<ForgotPasswordEmailScreen> createState() =>
      _ForgotPasswordEmailScreenState();
}

class _ForgotPasswordEmailScreenState extends State<ForgotPasswordEmailScreen> {

  final TextEditingController _emailTEController = TextEditingController();
  bool _inProgress = false;

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
          controller: _emailTEController,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(hintText: 'Email'),
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (String? value) {
            if (value?.isEmpty ?? true) {
              return 'Enter valid email';
            }
            return null;
          },
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: _onTapNextButton,
          child: _inProgress ? const CenteredCircularProgressIndicator() : const Icon(Icons.arrow_forward_ios),
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
    if(_emailTEController.text.isNotEmpty){
      _verifyEmail();
    }
  }

  Future<void> _verifyEmail() async {
    _inProgress = true;
    setState(() {});

    String email = _emailTEController.text.trim();

    NetworkResponse response = await NetworkCaller.getRequest(url: Urls.verifyEmail(email));
    _inProgress = false;
    setState(() {});

    if (response.isSuccess) {
      // Get.toNamed(ForgotPasswordOtpScreen.name, arguments: email);
      Navigator.push(context,MaterialPageRoute(builder: (context) => ForgotPasswordOtpScreen(userEmail: email),));
    } else {
      showSnackBarMessage(context, response.errorMessage, true);
    }
  }

  void _onTapSignInButton() {
    Get.back();
    // Navigator.pop(context);
  }

  @override
  void dispose() {
    _emailTEController.dispose();
    super.dispose();
  }
}
