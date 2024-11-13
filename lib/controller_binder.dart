import 'package:get/get.dart';
import 'package:task_management/ui/controllers/add_new_task_controller.dart';
import 'package:task_management/ui/controllers/cancelled_task_list_controller.dart';
import 'package:task_management/ui/controllers/completed_task_list_controller.dart';
import 'package:task_management/ui/controllers/new_task_list_controller.dart';
import 'package:task_management/ui/controllers/profile_controller.dart';
import 'package:task_management/ui/controllers/progress_task_list_controller.dart';
import 'package:task_management/ui/controllers/sign_in_controllers.dart';
import 'package:task_management/ui/controllers/task_count_controller.dart';

class ControllerBinder extends Bindings{
  @override
  void dependencies() {
    Get.put(SignInController());
    Get.put(NewTaskListController());
    Get.put(ProgressTaskListController());
    Get.put(CompletedTaskListController());
    Get.put(CancelledTaskListController());
    Get.put(TaskCountListController());
    Get.put(AddNewTaskController());
    Get.put(ProfileController());
  }
}