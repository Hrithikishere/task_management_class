import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_management/data/models/task_status_model.dart';
import 'package:task_management/ui/controllers/auth_controller.dart';
import 'package:task_management/ui/controllers/new_task_list_controller.dart';
import 'package:task_management/ui/controllers/task_count_controller.dart';
import 'package:task_management/ui/widgets/centeredCircularProgressIndicator.dart';
import 'package:task_management/ui/widgets/show_snackbar_message.dart';
import 'package:task_management/ui/widgets/task_card.dart';
import 'package:task_management/ui/widgets/task_count_card.dart';

import '../add_new_task_screen.dart';

class HomeTaskScreen extends StatefulWidget {
  const HomeTaskScreen({super.key});

  @override
  State<HomeTaskScreen> createState() => _HomeTaskScreenState();
}

class _HomeTaskScreenState extends State<HomeTaskScreen> {
  final NewTaskListController _newTaskListController = Get.find<NewTaskListController>();
  final TaskCountListController _taskCountListController = Get.find<TaskCountListController>();
  final AuthController _authController = Get.find<AuthController>();

  @override
  void initState() {
    // TODO: implement initState
    _getTaskStatusCount();
    _getNewTaskList();
    super.initState();
  }

  //TODO: Backward Refresh
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _taskCountSection(),
            const SizedBox(height: 15),
            _taskListSection()
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onTapFloatingActionButton,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _onTapFloatingActionButton() {
    // Navigator.push(context,
    //     MaterialPageRoute(builder: (context) => const AddNewTaskScreen()));
    Get.toNamed(AddNewTaskScreen.name);
  }

  Widget _taskCountSection() {
    return GetBuilder(
      init: _taskCountListController,
      builder: (controller) {
        return Visibility(
          visible: !controller.inProgress,
          replacement: const CenteredCircularProgressIndicator(),
          child: Row(
            children: _getTaskCountCard(),
          ),
        );
      }
    );
  }

  List<TaskCountCard> _getTaskCountCard() {
    List<TaskCountCard> taskCountCardList = [];
    for (TaskStatusModel task in _taskCountListController.taskStatusCountList) {
      taskCountCardList
          .add(TaskCountCard(count: '${task.sum}', title: '${task.sId}'));
    }
    return taskCountCardList;
  }

  Widget _taskListSection() {
    return Expanded(
      child: GetBuilder(
          init: _newTaskListController,
          builder: (controller) {
            return Visibility(
              visible: !controller.inProgress,
              replacement: const CenteredCircularProgressIndicator(),
              child: RefreshIndicator(
                onRefresh: () async {
                  _getNewTaskList();
                  _getTaskStatusCount();
                  await _authController.getUserData();
                },
                child: ListView.separated(
                    itemBuilder: (context, index) {
                      if (controller.inProgress == false) {
                        if (controller.newTaskList.isNotEmpty) {
                          return TaskCard(
                              id: controller.newTaskList[index].id,
                              title: controller.newTaskList[index].title,
                              description:
                                  controller.newTaskList[index].description,
                              createdDate:
                                  controller.newTaskList[index].createdDate,
                              status: controller.newTaskList[index].status);
                        }
                      } else {
                        return const CircularProgressIndicator();
                      }
                      return null;
                    },
                    separatorBuilder: (context, index) {
                      return const SizedBox(height: 8);
                    },
                    itemCount: controller.newTaskList.length),
              ),
            );
          }),
    );
  }

  Future<void> _getNewTaskList() async {
    final bool result = await _newTaskListController.getNewTaskList();

    if (result == false) {
      showSnackBarMessage(context, _newTaskListController.errorMessage!, true);
    }
  }

  Future<void> _getTaskStatusCount() async {
    _taskCountListController.taskStatusCountList.clear();
    final bool result = await _taskCountListController.getTaskStatusCount();

    if (!result) {
      showSnackBarMessage(context, _newTaskListController.errorMessage!, true);
    }
  }
}
