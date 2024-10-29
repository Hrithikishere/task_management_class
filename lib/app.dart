import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task_management/ui/screens/splash_screen.dart';
import 'package:task_management/ui/utils/app_colors.dart';

class TaskManagerApp extends StatefulWidget {
  const TaskManagerApp({super.key});

  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  State<TaskManagerApp> createState() => _TaskManagerAppState();
}

class _TaskManagerAppState extends State<TaskManagerApp> {

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      navigatorKey: TaskManagerApp.navigatorKey,
      theme: _appThemeData(),
      home: const SplashScreen(),
    );
  }

  ThemeData _appThemeData(){
    return ThemeData(
      colorSchemeSeed: AppColors.themeColor,
      textTheme: GoogleFonts.poppinsTextTheme(),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(5.0),
        ),
        filled: true,
        fillColor: Colors.grey[100],
        hintStyle: TextStyle(color: Colors.grey[800], fontSize: 12),
        activeIndicatorBorder: BorderSide(color: Colors.green[600]!, width: 2),
        contentPadding: const EdgeInsets.all(15),
        floatingLabelAlignment: FloatingLabelAlignment.center,
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        floatingLabelStyle: TextStyle(color: Colors.green[600], fontSize: 12),
        labelStyle: TextStyle(color: Colors.green[600], fontSize: 12),
        focusColor: AppColors.themeColor,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor:
          const WidgetStatePropertyAll<Color>(AppColors.themeColor),
          iconColor: const WidgetStatePropertyAll<Color>(AppColors.onThemeColor),
          fixedSize: WidgetStatePropertyAll<Size>(Size(MediaQuery.of(context).size.width, 50)),
          shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
        ),
      ),
    );
  }
}
