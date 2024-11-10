import 'package:flutter/material.dart';
import 'package:task_management/ui/controllers/auth_controller.dart';
import 'package:task_management/ui/screens/profile_screen.dart';

import '../screens/sign_in_screen.dart';
import '../utils/app_colors.dart';

class TMAppBar extends StatelessWidget implements PreferredSize {
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
        Navigator.push(context, MaterialPageRoute(builder: (context)=> const ProfileScreen()));
      },
      child: AppBar(
        backgroundColor: AppColors.themeColor,
        title: Row(
          children: [
            const CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.onThemeColor,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AuthController.userData?.fullName ?? '',
                    style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    AuthController.userData?.email ?? '',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.onThemeColor,
                    ),
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
    await AuthController.clearUserData();
    Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder: (context) => const SignInScreen()),(predicate) => false);
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  // TODO: implement child
  Widget get child => throw UnimplementedError();

}
