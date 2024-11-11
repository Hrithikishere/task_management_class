import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_management/data/models/network_response.dart';
import 'package:task_management/data/models/task_list_model.dart';
import 'package:task_management/data/models/task_model.dart';
import 'package:task_management/data/services/network_caller.dart';
import 'package:task_management/data/utils/urls.dart';
import 'package:task_management/ui/controllers/completed_task_list_controller.dart';
import 'package:task_management/ui/widgets/centeredCircularProgressIndicator.dart';
import 'package:task_management/ui/widgets/show_snackbar_message.dart';
import 'package:task_management/ui/widgets/task_card.dart';

class CompletedTaskScreen extends StatefulWidget {

  static const String name = '/completedTasks';

  const CompletedTaskScreen({super.key});

  @override
  State<CompletedTaskScreen> createState() => _CompletedTaskScreenState();
}

class _CompletedTaskScreenState extends State<CompletedTaskScreen> {

  final CompletedTaskListController _completedTaskListController = Get.find<CompletedTaskListController>();

  @override
  void initState() {
    super.initState();
    _getCompletedTaskList();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 10
            ),
            Text('Completed Tasks',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(
                    fontWeight: FontWeight.w600)),
            const SizedBox(
                height: 10
            ),
            _taskListSection()
          ],
        ),
      ),
    );

  }

  Widget _taskListSection() {
    return Expanded(
      child: GetBuilder(
        init: _completedTaskListController,
        builder: (controller) {
          return Visibility(
            visible: !controller.inProgress,
            replacement: const CenteredCircularProgressIndicator(),
            child: RefreshIndicator(
              onRefresh: _getCompletedTaskList,
              child: ListView.separated(
                itemCount: controller.completedTaskList.length,
                itemBuilder: (context, index) {
                  if (controller.inProgress == false) {
                    if (controller.completedTaskList.isNotEmpty) {
                      return TaskCard(
                          id: controller.completedTaskList[index].id,
                          title: controller.completedTaskList[index].title,
                          description: controller.completedTaskList[index].description,
                          createdDate: controller.completedTaskList[index].createdDate,
                          status: controller.completedTaskList[index].status);
                    }
                  } else {
                    return const CircularProgressIndicator();
                  }
                },
                separatorBuilder: (context, index) {
                  return const SizedBox(height: 8);
                },
              ),
            ),
          );
        }
      ),
    );
  }

  Future<void> _getCompletedTaskList() async {
    final bool result = await _completedTaskListController.getCompletedTaskList();
    if(!result){
      showSnackBarMessage(context, _completedTaskListController.errorMessage!, true);
    }
  }
}
