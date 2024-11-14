import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:task_management/ui/controllers/auth_controller.dart';
import 'package:task_management/ui/screens/mainScreens/main_bottom_nav_bar_screen.dart';
import 'package:task_management/ui/screens/sign_in_screen.dart';
import 'package:task_management/ui/utils/assets_path.dart';
import 'package:task_management/ui/widgets/screen_background.dart';

class SplashScreen extends StatefulWidget {

  static const String name = '/';

  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  final AuthController _authController = Get.find<AuthController>();


  Future<void> _navigateToNextScreen() async {
    await Future.delayed(const Duration(seconds: 2));
    await _authController.getAccessToken();
    await _authController.getUserData();

    if(_authController.isLoggedIn()){
      if(mounted){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MainBottomNavBarScreen()));
      }
    }else{
      if(mounted){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const SignInScreen()));
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenBackground(
        child: Center(
          child: SvgPicture.asset(AssetsPath.logoSvg),
        ),
      ),
    );
  }
}
