import 'package:get/get.dart';
import 'package:task_management/data/models/network_response.dart';
import 'package:task_management/data/models/task_status_count_model.dart';
import 'package:task_management/data/models/task_status_model.dart';
import 'package:task_management/data/services/network_caller.dart';
import 'package:task_management/data/utils/urls.dart';


class TaskCountListController extends GetxController{

  bool _inProgress = false;
  bool get inProgress=>_inProgress;
  String? _errorMessage;
  String? get errorMessage=>_errorMessage;
  List<TaskStatusModel> _taskStatusCountList = [];
  List<TaskStatusModel> get taskStatusCountList=>_taskStatusCountList;

  Future<bool> getTaskStatusCount() async {
    bool isSuccess = false;
    _taskStatusCountList.clear();
    _inProgress = true;
    update();

    final NetworkResponse response = await NetworkCaller.getRequest(url: Urls.taskStatusCount);
    if(response.isSuccess){
      final TaskStatusCountModel taskStatusCountModel = TaskStatusCountModel.fromJson(response.responseData);
      _taskStatusCountList = taskStatusCountModel.taskStatusCountList ?? [];
      isSuccess = true;
    }else{
      _errorMessage = response.errorMessage;
    }
    _inProgress = false;
    update();

    return isSuccess;
  }
}