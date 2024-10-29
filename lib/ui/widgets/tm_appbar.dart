import 'package:flutter/material.dart';
import 'package:task_management/ui/controllers/auth_controller.dart';

import '../screens/sign_in_screen.dart';
import '../utils/app_colors.dart';

class TMAppBar extends StatelessWidget implements PreferredSize {
  const TMAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.themeColor,
      title: Row(
        children: [
          const CircleAvatar(
            radius: 16,
            backgroundColor: AppColors.onThemeColor,
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Rabbil Hasan",
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  "rabbil@gmail.com",
                  style: TextStyle(
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
