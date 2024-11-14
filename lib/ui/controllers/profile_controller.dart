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

  final AuthController _authController = Get.find<AuthController>();

  void setUserData(){
    userModel.email = _authController.userData?.email ?? '';
    userModel.firstName = _authController.userData?.firstName ?? '';
    userModel.lastName = _authController.userData?.lastName ?? '';
    userModel.mobile = _authController.userData?.mobile ?? '';
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
    // final NetworkResponse responseProfile = await NetworkCaller.getRequest(url: Urls.profileDetails);

    if(response.isSuccess){
      if(selectedImage==null){
        requestBody["photo"] = _authController.userData?.photo!;
      }
      UserModel userModel = UserModel.fromJson(requestBody);
      await _authController.clearUserProfileData();
      await _authController.saveUserData(userModel);
      await _authController.getUserData();
      isSuccess=true;
    }

    _inProgress = false;
    update();
    return isSuccess;
  }


}