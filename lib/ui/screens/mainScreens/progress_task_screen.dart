import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_management/data/models/network_response.dart';
import 'package:task_management/data/models/task_list_model.dart';
import 'package:task_management/data/models/task_model.dart';
import 'package:task_management/data/services/network_caller.dart';
import 'package:task_management/data/utils/urls.dart';
import 'package:task_management/ui/controllers/progress_task_list_controller.dart';
import 'package:task_management/ui/widgets/centeredCircularProgressIndicator.dart';
import 'package:task_management/ui/widgets/show_snackbar_message.dart';
import 'package:task_management/ui/widgets/task_card.dart';

class ProgressTaskScreen extends StatefulWidget {

  static const String name ='/progressTasks';

  const ProgressTaskScreen({super.key});

  @override
  State<ProgressTaskScreen> createState() => _ProgressTaskScreenState();
}

class _ProgressTaskScreenState extends State<ProgressTaskScreen> {

  final ProgressTaskListController _progressTaskListController = Get.find<ProgressTaskListController>();

  @override
  void initState() {
    super.initState();
    _getProgressTaskList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Text('Progress Tasks',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(
                    fontWeight: FontWeight.w600)),
            const SizedBox(height: 10),

            _taskListSection(),
          ],
        ),
      ),
    );
  }

  Widget _taskListSection() {
    return Expanded(
      child: GetBuilder(
        init: _progressTaskListController,
        builder: (controller) {
          return Visibility(
            visible: !controller.inProgress,
            replacement: const CenteredCircularProgressIndicator(),
            child: RefreshIndicator(
              onRefresh: _getProgressTaskList,
              child: ListView.separated(
                itemCount: _progressTaskListController.progressTaskList.length,
                itemBuilder: (context, index) {
                  if (_progressTaskListController.inProgress == false) {
                    if (_progressTaskListController.progressTaskList.isNotEmpty) {
                      return TaskCard(
                          id: _progressTaskListController.progressTaskList[index].id,
                          title: _progressTaskListController.progressTaskList[index].title,
                          description: _progressTaskListController.progressTaskList[index].description,
                          createdDate: _progressTaskListController.progressTaskList[index].createdDate,
                          status: _progressTaskListController.progressTaskList[index].status);
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

  Future<void> _getProgressTaskList() async {

    final bool result = await _progressTaskListController.getProgressTaskList();
    if(!result){
      showSnackBarMessage(context, _progressTaskListController.errorMessage!, true);
    }
  }
}
