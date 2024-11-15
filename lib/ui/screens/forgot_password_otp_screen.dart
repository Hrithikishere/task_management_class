import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:task_management/data/models/network_response.dart';
import 'package:task_management/data/services/network_caller.dart';
import 'package:task_management/data/utils/urls.dart';
import 'package:task_management/ui/screens/reset_password_screen.dart';
import 'package:task_management/ui/screens/sign_in_screen.dart';
import 'package:task_management/ui/widgets/centeredCircularProgressIndicator.dart';
import 'package:task_management/ui/widgets/screen_background.dart';
import 'package:task_management/ui/widgets/show_snackbar_message.dart';

import '../utils/app_colors.dart';

class ForgotPasswordOtpScreen extends StatefulWidget {

  static const String name = "/forgotPasswordOtp";

  ForgotPasswordOtpScreen({super.key, required this.userEmail});

  String userEmail;

  @override
  State<ForgotPasswordOtpScreen> createState() =>
      _ForgotPasswordOtpScreenState();
}

class _ForgotPasswordOtpScreenState extends State<ForgotPasswordOtpScreen> {

  final TextEditingController _otpTEController = TextEditingController();
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
                "Pin Verification",
                style: textThemeStyle.titleLarge
                    ?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(
                height: 5
              ),
              Text(
                "A 6 digit verification otp has been sent to your email address",
                style: textThemeStyle.bodyMedium
                    ?.copyWith(fontWeight: FontWeight.w400, color: Colors.grey),
              ),
              const SizedBox(height: 30),
              _buildVerifyOtpForm(),
              const SizedBox(height: 40),
              _haveAccountSection(),
            ],
          ),
        ),
      ),
    );
  }

  Column _buildVerifyOtpForm() {
    return Column(
      children: [
        PinCodeTextField(
          controller: _otpTEController,
          keyboardType: TextInputType.number,
          appContext: context,
          length: 6,
          obscureText: false,
          animationType: AnimationType.fade,
          pinTheme: PinTheme(
            shape: PinCodeFieldShape.box,
            borderRadius: BorderRadius.circular(5),
            fieldHeight: 50,
            fieldWidth: 40,
            activeColor: Colors.transparent,
            selectedColor: AppColors.themeColor,
            selectedFillColor: Colors.transparent,
            inactiveFillColor: Colors.transparent,
          ),
          textStyle: GoogleFonts.poppins(
              color: Colors.black87, fontWeight: FontWeight.w500),
          cursorColor: AppColors.themeColor,
          animationDuration: const Duration(milliseconds: 300),
          enableActiveFill: true,
          beforeTextPaste: (text) {
            print("Allowing to paste $text");
            //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
            //but you can show anything you want here, like your pop up saying wrong paste format or etc
            return true;
          },
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: _onTapNextButton,
          child: _inProgress ? const CenteredCircularProgressIndicator() :  const Text("Verify", style: TextStyle(fontSize: 14, color: AppColors.onThemeColor),),
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

    if(_otpTEController.text.isNotEmpty){
      _verifyOTP();
    }
  }

  Future<void> _verifyOTP() async {
    _inProgress = true;
    setState(() {});

    String otp = _otpTEController.text;
    // print(otp);

    NetworkResponse response = await NetworkCaller.getRequest(url: Urls.recoverVerifyOtp(widget.userEmail, otp));
    _inProgress = false;
    setState(() {});

    if (response.isSuccess) {
      Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder: (context) => ResetPasswordScreen(userEmail: widget.userEmail, userOTP: otp,),),(_) => false);
    } else {
      showSnackBarMessage(context, response.errorMessage, true);
    }
  }

  void _onTapSignInButton() {
    Get.offAllNamed(SignInScreen.name);
    // Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder: (context) => const SignInScreen()),(_) => false);
  }

  @override
  void dispose() {
    _otpTEController.dispose();
    super.dispose();
  }
}
