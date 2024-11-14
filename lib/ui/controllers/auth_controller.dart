import 'dart:convert';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_management/data/models/user_model.dart';

class AuthController extends GetxController{

  static const String _accessTokenKey = 'access-token';
  static const String _userDataKey = 'user-data';

  String? _accessToken;
  UserModel? _userData;

  String? get accessToken=>_accessToken;
  UserModel? get userData=>_userData;

  Future<void> saveUserData(UserModel userModel) async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString(_userDataKey, jsonEncode(userModel.toJson()));
    _userData = userModel;
  }

  Future<UserModel?> getUserData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? userEncodeData = sharedPreferences.getString(_userDataKey);
    if(userEncodeData==null){
      return null;
    }
    UserModel userModel = UserModel.fromJson(jsonDecode(userEncodeData));
    _userData = userModel;
    print(userData);
    update();
    return userModel;
  }

  Future<void> clearUserdata() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.clear();
    _accessToken = null;
  }

  Future<void> saveAccessToken(String token) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString(_accessTokenKey, token);
    _accessToken = token;
  }

  Future<String?> getAccessToken() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? token = await sharedPreferences.getString(_accessTokenKey);
    _accessToken = token;
    print(token);
    return token;
  }

  bool isLoggedIn(){
    return accessToken != null;
  }

  Future<void> clearUserData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.clear();
    _accessToken = null;
  }

  Future<void> clearUserProfileData() async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.remove(_userDataKey);
  }
}
