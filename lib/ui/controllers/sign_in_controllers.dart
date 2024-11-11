import 'package:get/get.dart';
import 'package:task_management/data/models/network_response.dart';
import 'package:task_management/data/models/user_model.dart';
import 'package:task_management/data/services/network_caller.dart';
import 'package:task_management/data/utils/urls.dart';
import 'package:task_management/ui/controllers/auth_controller.dart';

class SignInController extends GetxController{

  bool _inProgress = false;
  bool get inProgress => _inProgress;
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<bool> signIn(String email, String password) async{
    bool isSuccess = false;
    _inProgress = true;
    update();

    Map<String, dynamic> requestBody = {
      "email": email,
      "password": password,
    };

    final NetworkResponse response = await NetworkCaller.postRequest(url: Urls.login, body: requestBody);
    // _inProgress = false;
    // update();

    if(response.isSuccess){
      // LoginModel loginModel = LoginModel.fromJson(response.responseData);
      await AuthController.saveAccessToken(response.responseData['token']);
      await AuthController.saveUserData(UserModel.fromJson(response.responseData['data']));
      isSuccess = true;
    }else{
      _errorMessage = response.errorMessage;
    }
    _inProgress = false;
    update();

    return isSuccess;
  }
}