import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_management/ui/controllers/auth_controller.dart';
import 'package:task_management/ui/screens/profile_screen.dart';

import '../screens/sign_in_screen.dart';
import '../utils/app_colors.dart';

class TMAppBar extends StatelessWidget implements PreferredSize {

  final AuthController _authController = Get.find<AuthController>();

  TMAppBar({
    super.key,
    this.isProfileScreenOpen = false,
  });

  final bool isProfileScreenOpen;

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: (){
        if(isProfileScreenOpen){
          return;
        }
        Get.toNamed(ProfileScreen.name);
        // Navigator.push(context, MaterialPageRoute(builder: (context)=> const ProfileScreen()));
      },
      child: AppBar(
        backgroundColor: AppColors.themeColor,
        title: Row(
          children: [
            GetBuilder(
              init: _authController,
              builder: (controller) {
                return CircleAvatar(
                  radius: 16,
                  backgroundColor: AppColors.onThemeColor,
                    backgroundImage: MemoryImage(base64Decode(_authController.userData!.photo??'')),
                );
              }
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GetBuilder(
                      init: _authController,
                      builder: (controller) {
                      return Text(
                        _authController.userData?.fullName ?? '',
                        style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      );
                    }
                  ),
                  GetBuilder(
                    init: _authController,
                    builder: (controller) {
                      return Text(
                        _authController.userData?.email ?? '',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.onThemeColor,
                        ),
                      );
                    }
                  ),
                ],
              ),
            ),
            IconButton(
                onPressed: (){_onTapLogoutButton(context);},
                icon: const Icon(Icons.logout)),
          ],
        ),
      ),
    );

  }

  void _onTapLogoutButton(BuildContext context) async {
    await _authController.clearUserData();
    Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder: (context) => const SignInScreen()),(predicate) => false);
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  // TODO: implement child
  Widget get child => throw UnimplementedError();

}
