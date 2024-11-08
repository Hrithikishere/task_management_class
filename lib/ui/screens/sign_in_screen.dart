import 'package:flutter/material.dart';
import 'package:task_management/data/models/network_response.dart';
import 'package:task_management/data/services/network_caller.dart';
import 'package:task_management/data/utils/urls.dart';
import 'package:task_management/ui/controllers/auth_controller.dart';
import 'package:task_management/ui/screens/forgot_password_email_screen.dart';
import 'package:task_management/ui/screens/mainScreens/main_bottom_nav_bar_screen.dart';
import 'package:task_management/ui/screens/sign_up_screen.dart';
import 'package:task_management/ui/widgets/screen_background.dart';
import 'package:task_management/ui/widgets/show_snackbar_message.dart';

import '../utils/app_colors.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _passwordTEController = TextEditingController();

  bool _inProgress = false;

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
                "Join With Us",
                style: textThemeStyle.titleLarge
                    ?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 30),
              _buildSignInForm(),
              const SizedBox(height: 30),
              _forgotOrRegister(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSignInForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
              controller: _emailTEController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(hintText: 'Email'),
              validator: (String? value){
                if(value?.isEmpty ?? true){
                  return 'Enter valid email';
                }
                return null;
              },
          ),

          const SizedBox(height: 10),

          TextFormField(
              controller: _passwordTEController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              obscureText: true,
              decoration: const InputDecoration(hintText: 'Password'),
              validator: (String? value){
              if(value?.isEmpty ?? true){
                return 'Enter password';
              }
              if(value!.length <= 6){
                return 'Password must be greater than 6 characters';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _onTapNextButton,
            child: _inProgress ? const CircularProgressIndicator(color: Colors.white, strokeWidth: 3) : const Icon(Icons.arrow_forward_ios),
          ),
        ],
      ),
    );
  }

  Column _forgotOrRegister() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        TextButton(
          onPressed: _onTapForgotPasswordButton,
          child: const Text(
            "Forgot Password?",
            style: TextStyle(fontSize: 12),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Don't have any account? ",
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
            ),
            InkWell(
              onTap: _onTapSignUpButton,
              child: const Text(
                "Sign Up",
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
    if(_formKey.currentState!.validate()){
      _signIn();
   }
    return;
  }

  Future<void> _signIn() async{
    FocusScope.of(context).unfocus();
    _inProgress = true;
    setState(() {});

    Map<String, dynamic> requestBody = {
      "email": _emailTEController.text.trim(),
      "password": _passwordTEController.text,
    };

    final NetworkResponse response = await NetworkCaller.postRequest(url: Urls.login, body: requestBody);
    _inProgress = false;
    setState(() {});

    if(response.isSuccess){
      
      await AuthController.saveAccessToken(response.responseData['token']);
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> const MainBottomNavBarScreen()), (_)=>false);
    }else{
      showSnackBarMessage(context, response.errorMessage, true);
    }
  }

  void _onTapForgotPasswordButton() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ForgotPasswordEmailScreen(),
      ),
    );
  }

  void _onTapSignUpButton() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SignUpScreen(),
      ),
    );
  }

  void _clearTextFields(){
    _formKey.currentState!.reset();
    _emailTEController.clear();
    _passwordTEController.clear();
  }

  @override
  void dispose() {
    _emailTEController.dispose();
    _passwordTEController.dispose();
    super.dispose();
  }
}
