import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:task_management/data/models/network_response.dart';
import 'package:task_management/data/services/network_caller.dart';
import 'package:task_management/data/utils/urls.dart';

class AddNewTaskController extends GetxController{

  bool _inProgress = false;
  bool get inProgress=>_inProgress;

  AutovalidateMode _autovalidateMode = AutovalidateMode.onUserInteraction;
  AutovalidateMode get autovalidateMode => _autovalidateMode;

  String? _errorMessage;
  String? get errorMessage=>_errorMessage;

  Future<bool> addNewTask(String title, String description) async {
    bool isSuccess = false;
    _inProgress = true;
    _autovalidateMode = AutovalidateMode.disabled;
    update();

    Map<String, dynamic> requestBody = {
      'title': title,
      'description': description,
      'status': 'New',
    };

    final NetworkResponse response = await NetworkCaller.postRequest(url: Urls.addNewTask, body: requestBody);

    if(response.isSuccess){
      isSuccess = true;
    }else{
      _errorMessage = response.errorMessage;
    }
    _autovalidateMode = AutovalidateMode.onUserInteraction;
    _inProgress = false;
    update();

    return isSuccess;
  }
}