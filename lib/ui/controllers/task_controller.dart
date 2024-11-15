import 'package:get/get.dart';
import 'package:task_management/data/models/network_response.dart';
import 'package:task_management/data/services/network_caller.dart';
import 'package:task_management/data/utils/urls.dart';
import 'package:task_management/ui/controllers/cancelled_task_list_controller.dart';
import 'package:task_management/ui/controllers/completed_task_list_controller.dart';
import 'package:task_management/ui/controllers/new_task_list_controller.dart';
import 'package:task_management/ui/controllers/progress_task_list_controller.dart';
import 'package:task_management/ui/controllers/task_count_controller.dart';

class TaskController extends GetxController{

  bool _inProgressDelete = false;
  bool get inProgressDelete=>_inProgressDelete;

  bool _inProgressUpdate = false;
  bool get inProgressUpdate=>_inProgressUpdate;

  String? _errorMessage;
  String? get errorMessage=>_errorMessage;

  final NewTaskListController _newTaskController = Get.find<NewTaskListController>();
  final ProgressTaskListController _progressTaskListController = Get.find<ProgressTaskListController>();
  final CompletedTaskListController _completedTaskListController = Get.find<CompletedTaskListController>();
  final CancelledTaskListController _cancelledTaskListController = Get.find<CancelledTaskListController>();
  final TaskCountListController _taskCountListController = Get.find<TaskCountListController>();

  Future<bool> deleteTask(String id) async {
    bool isSuccess = false;
    _inProgressDelete = true;
    update();
    final NetworkResponse response = await NetworkCaller.getRequest(
        url: Urls.deleteTask(id));
    _inProgressDelete = false;
    if (response.isSuccess) {
      isSuccess = true;
    }else{
      _errorMessage = response.errorMessage;
    }

    _newTaskController.getNewTaskList();
    _progressTaskListController.getProgressTaskList();
    _completedTaskListController.getCompletedTaskList();
    _cancelledTaskListController.getCancelledTaskList();
    _taskCountListController.getTaskStatusCount();

    _inProgressDelete = false;
    update();
    return isSuccess;
  }

  Future<bool> changeStatus(String taskId, String newStatus) async {
    bool isSuccess = false;
    _inProgressUpdate = true;
    update();
    final NetworkResponse response = await NetworkCaller.getRequest(
        url: Urls.changeStatus(taskId, newStatus));

    if (response.isSuccess) {
      isSuccess = true;
    }else{
      _errorMessage = response.errorMessage;
    }

    _newTaskController.getNewTaskList();
    _progressTaskListController.getProgressTaskList();
    _completedTaskListController.getCompletedTaskList();
    _cancelledTaskListController.getCancelledTaskList();
    _taskCountListController.getTaskStatusCount();

    _inProgressUpdate = false;
    update();
    return isSuccess;
  }
}