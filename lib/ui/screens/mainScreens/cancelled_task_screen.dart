import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_management/data/models/network_response.dart';
import 'package:task_management/data/models/task_list_model.dart';
import 'package:task_management/data/models/task_model.dart';
import 'package:task_management/data/services/network_caller.dart';
import 'package:task_management/data/utils/urls.dart';
import 'package:task_management/ui/controllers/cancelled_task_list_controller.dart';
import 'package:task_management/ui/widgets/centeredCircularProgressIndicator.dart';
import 'package:task_management/ui/widgets/show_snackbar_message.dart';
import 'package:task_management/ui/widgets/task_card.dart';

class CancelledTaskScreen extends StatefulWidget {

  static const String name = '/cancelledTasks';

  const CancelledTaskScreen({super.key});

  @override
  State<CancelledTaskScreen> createState() => _CancelledTaskScreenState();
}

class _CancelledTaskScreenState extends State<CancelledTaskScreen> {

  final CancelledTaskListController _cancelledTaskListController = Get.find<CancelledTaskListController>();

  @override
  void initState() {
    super.initState();
    _getCancelledTaskList();
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
            Text('Cancelled Tasks',
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
        init: _cancelledTaskListController,
        builder: (controller) {
          return Visibility(
            visible: !controller.inProgress,
            replacement: const CenteredCircularProgressIndicator(),
            child: RefreshIndicator(
              onRefresh: _getCancelledTaskList,
              child: ListView.separated(
                itemCount: _cancelledTaskListController.cancelledTaskList.length,
                itemBuilder: (context, index) {
                  if (_cancelledTaskListController.inProgress == false) {
                    if (_cancelledTaskListController.cancelledTaskList.isNotEmpty) {
                      return TaskCard(
                          id: _cancelledTaskListController.cancelledTaskList[index].id,
                          title: _cancelledTaskListController.cancelledTaskList[index].title,
                          description: _cancelledTaskListController.cancelledTaskList[index].description,
                          createdDate: _cancelledTaskListController.cancelledTaskList[index].createdDate,
                          status: _cancelledTaskListController.cancelledTaskList[index].status);
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

  Future<void> _getCancelledTaskList() async {
    final bool result = await _cancelledTaskListController.getCancelledTaskList();
    if(!result){
      showSnackBarMessage(context, _cancelledTaskListController.errorMessage!, true);
    }
  }
}
