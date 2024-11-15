import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_management/ui/controllers/sign_up_controller.dart';
import 'package:task_management/ui/screens/sign_in_screen.dart';
import 'package:task_management/ui/widgets/screen_background.dart';
import 'package:task_management/ui/widgets/show_snackbar_message.dart';
import '../utils/app_colors.dart';

class SignUpScreen extends StatefulWidget {

  static const String name = '/signUp';

  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {

  final SignUpController _signUpController = Get.find<SignUpController>();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _firstNameTEController = TextEditingController();
  final TextEditingController _lastNameTEController = TextEditingController();
  final TextEditingController _phoneTEController = TextEditingController();
  final TextEditingController _passwordTEController = TextEditingController();

  bool _autoValidate = true;

  @override
  Widget build(BuildContext context) {
    TextTheme textThemeStyle = Theme.of(context).textTheme;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: ScreenBackground(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Get Started With",
                style: textThemeStyle.titleLarge
                    ?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 30),
              _buildSignUpForm(),
              const SizedBox(height: 30),
              _haveAccountSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSignUpForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _emailTEController,
            keyboardType: TextInputType.emailAddress,
            autovalidateMode: _autoValidate
                ? AutovalidateMode.onUserInteraction
                : AutovalidateMode.disabled,
            decoration: const InputDecoration(hintText: 'Email'),
            validator: (String? value) {
              if (value?.isEmpty ?? true) {
                return 'Enter valid email';
              }
              return null;
            },
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: _firstNameTEController,
            autovalidateMode: _autoValidate
                ? AutovalidateMode.onUserInteraction
                : AutovalidateMode.disabled,
            decoration: const InputDecoration(hintText: 'First Name'),
            validator: (String? value) {
              if (value?.isEmpty ?? true) {
                return 'Enter first name';
              }
              return null;
            },
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: _lastNameTEController,
            autovalidateMode: _autoValidate
                ? AutovalidateMode.onUserInteraction
                : AutovalidateMode.disabled,
            decoration: const InputDecoration(hintText: 'Last Name'),
            validator: (String? value) {
              if (value?.isEmpty ?? true) {
                return 'Enter last name';
              }
              return null;
            },
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: _phoneTEController,
            keyboardType: TextInputType.phone,
            autovalidateMode: _autoValidate
                ? AutovalidateMode.onUserInteraction
                : AutovalidateMode.disabled,
            decoration: const InputDecoration(hintText: 'Phone'),
            validator: (String? value) {
              if (value?.isEmpty ?? true) {
                return 'Enter valid phone number';
              }
              return null;
            },
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: _passwordTEController,
            autovalidateMode: _autoValidate
                ? AutovalidateMode.onUserInteraction
                : AutovalidateMode.disabled,
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
          const SizedBox(height: 20),
          GetBuilder(
            init: _signUpController,
            builder: (controller) {
              return ElevatedButton(
                onPressed: _signUpController.inProgress ? null : _onTapNextButton,
                child: _signUpController.inProgress
                    ? const CircularProgressIndicator(
                    color: Colors.white, strokeWidth: 3)
                    : const Icon(Icons.arrow_forward_ios),
              );
            }
          ),
        ],
      ),
    );
  }

  Future<void> _signUp() async {

    final bool result = await _signUpController.signUp(_emailTEController.text.trim(), _firstNameTEController.text.trim(), _lastNameTEController.text.trim(), _phoneTEController.text.trim(), _passwordTEController.text);

    if (result) {
      _clearTextFields();
      showSnackBarMessage(context, "New user created! Redirecting to Sign in...");
      Future.delayed(const Duration(seconds: 1), () => Get.toNamed(SignInScreen.name),);

    } else {
      showSnackBarMessage(context, _signUpController.errorMessage!, true);
    }
  }

  void _clearTextFields() {
    setState(() {
      _autoValidate = false;
      _formKey.currentState!.reset();
      _emailTEController.clear();
      _firstNameTEController.clear();
      _lastNameTEController.clear();
      _phoneTEController.clear();
      _passwordTEController.clear();
      Future.delayed(const Duration(milliseconds: 100), () {
        setState(() {
          _autoValidate = true;
        });
      });
    });
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
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _signUp();
  }

  void _onTapSignInButton() {
    Get.back();
    // Navigator.pop(context);
  }

  @override
  void dispose() {
    _emailTEController.dispose();
    _firstNameTEController.dispose();
    _lastNameTEController.dispose();
    _phoneTEController.dispose();
    _passwordTEController.dispose();
    super.dispose();
  }
}
