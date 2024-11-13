import 'dart:convert';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:task_management/data/models/network_response.dart';
import 'package:task_management/data/models/user_model.dart';
import 'package:task_management/data/services/network_caller.dart';
import 'package:task_management/data/utils/urls.dart';
import 'package:task_management/ui/controllers/auth_controller.dart';

class ProfileController extends GetxController{

  bool _inProgress = false;
  bool get inProgress=>_inProgress;

  String? _errorMessage;
  String? get errorMessage=>_errorMessage;

  UserModel _userModel = UserModel();
  UserModel get userModel => _userModel;

  XFile? selectedImage;
  // String selectedImageName = 'Select Photo';

  void setUserData(){
    userModel.email = AuthController.userData?.email ?? '';
    userModel.firstName = AuthController.userData?.firstName ?? '';
    userModel.lastName = AuthController.userData?.lastName ?? '';
    userModel.mobile = AuthController.userData?.mobile ?? '';
  }

  void pickImage(XFile selectedImage){
    this.selectedImage = selectedImage;
    update();
  }

  String getSelectedPhotoTitle(){
    if(selectedImage!=null){
      return selectedImage!.name;
    }
    return 'Select Photo';
  }

  Future<bool> updateProfile(String email, String firstName, String lastName, String mobile, String password)async{
    bool isSuccess = false;
    _inProgress = true;
    update();

    Map<String, dynamic> requestBody = {
      "email": email.trim(),
      "firstName": firstName,
      "lastName": lastName,
      "mobile": mobile,
    };

    if(password.isNotEmpty){
      requestBody["password"] =  password;
    }

    if(selectedImage!=null){
      List<int> imageBytes = await selectedImage!.readAsBytes();
      String convertedImage = base64Encode(imageBytes);
      requestBody["photo"] =  convertedImage;
    }

    final NetworkResponse response = await NetworkCaller.postRequest(url: Urls.profileUpdate, body: requestBody);

    if(response.isSuccess){
      UserModel userModel = UserModel.fromJson(requestBody);
      await AuthController.clearUserProfileData();
      await AuthController.saveUserData(userModel);
      await AuthController.getUserData();
      isSuccess=true;
    }

    _inProgress = false;
    update();
    return isSuccess;
  }


}