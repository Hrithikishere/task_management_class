import 'package:flutter/material.dart';
import 'package:task_management/data/models/network_response.dart';
import 'package:task_management/data/services/network_caller.dart';
import 'package:task_management/data/utils/urls.dart';
import 'package:task_management/ui/screens/sign_in_screen.dart';
import 'package:task_management/ui/widgets/screen_background.dart';
import 'package:task_management/ui/widgets/show_snackbar_message.dart';
import '../utils/app_colors.dart';

class ResetPasswordScreen extends StatefulWidget {
  ResetPasswordScreen({super.key, required this.userEmail, required this.userOTP});

  String userEmail;
  String userOTP;

  @override
  State<ResetPasswordScreen> createState() =>
      _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _newPasswordTEController = TextEditingController();
  final TextEditingController _confirmNewPasswordTEController = TextEditingController();
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

  Widget _buildVerifyEmailForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _newPasswordTEController,
            autovalidateMode: AutovalidateMode.onUserInteraction,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(hintText: 'Password'),
              validator: (String? value) {
                if (value?.isEmpty ?? true) {
                  return 'Enter strong password';
                }
                if (value!.length <= 6) {
                  return 'Password must be greater than 6 characters';
                }
                return null;
            },
          ),

          const SizedBox(height: 10),
          TextFormField(
            controller: _confirmNewPasswordTEController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(hintText: 'Confirm Password'),
            validator: (String? value) {
              if (value?.isEmpty ?? true) {
                return 'Re Enter new password';
              }
              if (value!.length <= 6) {
                return 'Password must be greater than 6 characters';
              }
              if (_newPasswordTEController.text!=value) {
                return "Password doesn't match";
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _onTapConfirmButton,
            child: const Text("Confirm", style: TextStyle(fontSize: 14, color: AppColors.onThemeColor),),
          ),
        ],
      ),
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
    if(!_formKey.currentState!.validate()) {
      return;
    }
    _resetPassword();
  }


  Future<void> _resetPassword() async{

    _inProgress = true;
    setState(() {});

    Map<String, dynamic> requestBody = {
      "email": widget.userEmail,
      "OTP": widget.userOTP,
      "password": _confirmNewPasswordTEController.text,
    };

    NetworkResponse response = await NetworkCaller.postRequest(url: Urls.recoverResetPassword, body: requestBody);
    _inProgress = false;
    setState(() {});

    if (response.isSuccess) {
      showSnackBarMessage(context, 'Password has been changed! Redirecting to sign in...');
      Future.delayed(const Duration(milliseconds: 1), () {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const SignInScreen(),
            ),
                (_) => false);
      });
    } else {
      showSnackBarMessage(context, response.errorMessage, true);
    }
  }


  void _onTapSignInButton() {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const SignInScreen()),
            (_) => false);
  }

  @override
  void dispose() {
    _newPasswordTEController.dispose();
    _confirmNewPasswordTEController.dispose();
    super.dispose();
  }
}
