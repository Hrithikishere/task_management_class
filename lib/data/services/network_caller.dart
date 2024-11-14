import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:task_management/app.dart';
import 'package:task_management/data/models/network_response.dart';
import 'package:task_management/ui/controllers/auth_controller.dart';
import 'package:task_management/ui/screens/sign_in_screen.dart';

class NetworkCaller {


  static Future<NetworkResponse> getRequest({required String url}) async {
    final AuthController authController = Get.find<AuthController>();

    try {
      Uri uri = Uri.parse(url);
      debugPrint(url);
      Map<String, String> headers = {'token': authController.accessToken.toString()};
      printRequest(url: url, headers: headers);
      final http.Response response = await http.get(uri, headers: headers);
      printResponse(url, response);
      if (response.statusCode == 200) {
        final decodeData = jsonDecode(response.body);
        return NetworkResponse(
            isSuccess: true,
            statusCode: response.statusCode,
            responseData: decodeData);
      }
      else if(response.statusCode == 401){
        _moveToLogin();
        return NetworkResponse(
            isSuccess: true,
            statusCode: response.statusCode,
            errorMessage: 'Unauthorized!'
        );
      }
      else {
        return NetworkResponse(
            isSuccess: false, statusCode: response.statusCode);
      }
    } catch (e) {
      return NetworkResponse(
          isSuccess: false, statusCode: -1, errorMessage: e.toString());
    }
  }

  static Future<NetworkResponse> postRequest({required String url, Map<String, dynamic>? body}) async {
    final AuthController authController = Get.find<AuthController>();

    try {
      Uri uri = Uri.parse(url);
      debugPrint(url);
      Map<String, String> headers = {'content-Type': 'application/json', 'token': authController.accessToken.toString()};
      printRequest(url: url, body: body, headers: headers);

      final http.Response response = await http.post(
        uri,
        headers: headers,
        body: jsonEncode(body),
      );

      // printResponse(url, response);
      if (response.statusCode == 200) {
        final decodeData = jsonDecode(response.body);
        if(decodeData['status']=='fail'){
          return NetworkResponse(
              isSuccess: false,
              statusCode: response.statusCode,
              errorMessage: decodeData['data']);
        }
        return NetworkResponse(
            isSuccess: true,
            statusCode: response.statusCode,
            responseData: decodeData);
      }
      else if(response.statusCode == 401){
        _moveToLogin();
        return NetworkResponse(
            isSuccess: true,
            statusCode: response.statusCode,
            errorMessage: 'Unauthorized!'
        );
      }
      else {
        final decodeData = jsonDecode(response.body);
        return NetworkResponse(
              isSuccess: false,
              statusCode: response.statusCode,
              errorMessage: decodeData['data']);
      }
    } catch (e) {
      return NetworkResponse(
          isSuccess: false, statusCode: -1, errorMessage: e.toString());
    }
  }

  static void printRequest(
      {required String url, Map<String, dynamic>? body, required Map<String, dynamic> headers}) {
    debugPrint('REQUEST URL: $url\nBODY: $body\nHEADERS: $headers');
    print('REQUEST URL: $url\nBODY: $body\nHEADERS: $headers');
  }

  static void printResponse(String url, http.Response response) {
    // debugPrint('URL: $url\nRESPONSE CODE: ${response.statusCode}\nBODY: ${response.body}');
    print('URL: $url\nRESPONSE CODE: ${response.statusCode}\nBODY: ${response.body}');
  }

  static Future<void> _moveToLogin() async {
    final AuthController authController = Get.find<AuthController>();
    await authController.clearUserData();
    Navigator.pushAndRemoveUntil(TaskManagerApp.navigatorKey.currentContext!, MaterialPageRoute(builder: (context)=> const SignInScreen()), (predicate)=>false);
  }
}
