import 'package:flutter/material.dart';
import 'package:task_management/ui/screens/add_new_task_screen.dart';
import 'package:task_management/ui/screens/mainScreens/cancelled_task_screen.dart';
import 'package:task_management/ui/screens/mainScreens/completed_task_screen.dart';
import 'package:task_management/ui/screens/mainScreens/home_task_screen.dart';
import 'package:task_management/ui/screens/mainScreens/progress_task_screen.dart';
import 'package:task_management/ui/screens/profile_screen.dart';
import 'package:task_management/ui/screens/sign_in_screen.dart';
import 'package:task_management/ui/utils/app_colors.dart';
import 'package:task_management/ui/widgets/tm_appbar.dart';

class MainBottomNavBarScreen extends StatefulWidget {
  const MainBottomNavBarScreen({super.key});

  @override
  State<MainBottomNavBarScreen> createState() => _MainBottomNavBarScreenState();
}

class _MainBottomNavBarScreenState extends State<MainBottomNavBarScreen> {
  int _selectedIndex = 0;
  final List<Widget> _screens = const [
    HomeTaskScreen(),
    ProgressTaskScreen(),
    CompletedTaskScreen(),
    CancelledTaskScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const TMAppBar(),
      body: _screens[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (int index) {
          _selectedIndex = index;
          setState(() {});
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: "Home"),
          NavigationDestination(icon: Icon(Icons.done), label: "Completed"),
          NavigationDestination(icon: Icon(Icons.cancel), label: "Cancelled"),
          NavigationDestination(icon: Icon(Icons.sticky_note_2), label: "Progress"),
        ],
      ),
    );
  }

}

