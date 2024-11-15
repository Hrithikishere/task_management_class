import 'package:get/get.dart';
import 'package:task_management/data/models/network_response.dart';
import 'package:task_management/data/models/task_list_model.dart';
import 'package:task_management/data/models/task_model.dart';
import 'package:task_management/data/services/network_caller.dart';
import 'package:task_management/data/utils/urls.dart';


class CancelledTaskListController extends GetxController{

  bool _inProgress = false;
  bool get inProgress=>_inProgress;

  String? _errorMessage;
  String? get errorMessage=>_errorMessage;

  List<TaskModel> _cancelledTaskList = [];
  List<TaskModel> get cancelledTaskList=>_cancelledTaskList;

  Future<bool> getCancelledTaskList() async {
    bool isSuccess = false;
    _cancelledTaskList.clear();
    _inProgress = true;
    update();

    final NetworkResponse response =
    await NetworkCaller.getRequest(url: Urls.cancelledTaskList);
    if (response.isSuccess) {
      final TaskListModel taskListModel =
      TaskListModel.fromJson(response.responseData);
      _cancelledTaskList = taskListModel.taskList;
      isSuccess = true;
    } else {
      _errorMessage = response.errorMessage;
    }
    _inProgress = false;
    update();

    return isSuccess;
  }
}