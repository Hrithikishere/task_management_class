import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task_management/data/models/network_response.dart';
import 'package:task_management/data/models/task_list_model.dart';
import 'package:task_management/data/models/task_model.dart';
import 'package:task_management/data/services/network_caller.dart';
import 'package:task_management/data/utils/urls.dart';
import 'package:task_management/ui/utils/app_colors.dart';
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
  bool _getNewTaskListInProgress = false;
  List<Task> _newTaskList = [];

  @override
  void initState() {
    // TODO: implement initState
    _getNewTaskList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            _taskCountSection(),
            const SizedBox(
              height: 15,
            ),
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
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const AddNewTaskScreen()));
  }

  Widget _taskCountSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TaskCountCard(
          count: '9',
          title: 'Total',
        ),
        TaskCountCard(
          count: '6',
          title: 'Completed',
        ),
        TaskCountCard(
          count: '2',
          title: 'Cancelled',
        ),
        TaskCountCard(
          count: '1',
          title: 'Pending',
        ),
      ],
    );
  }

  Widget _taskListSection() {
    return Expanded(
      child: Visibility(
        visible: !_getNewTaskListInProgress,
        replacement: const CenteredCircularProgressIndicator(),
        child: RefreshIndicator(
          onRefresh: _getNewTaskList,
          child: ListView.separated(
              itemBuilder: (context, index) {
                if (_getNewTaskListInProgress == false) {
                  if (_newTaskList.isNotEmpty) {
                    return TaskCard(
                        title: _newTaskList[index].title,
                        description: _newTaskList[index].description,
                        status: _newTaskList[index].status);
                  }
                } else {
                  return const CircularProgressIndicator();
                }
              },
              separatorBuilder: (context, index) {
                return const SizedBox(height: 8);
              },
              itemCount: _newTaskList.length),
        ),
      ),
    );
  }

  Future<void> _getNewTaskList() async {
    _newTaskList.clear();
    _getNewTaskListInProgress = true;
    setState(() {});

    final NetworkResponse response =
        await NetworkCaller.getRequest(url: Urls.newTaskList);
    if (response.isSuccess) {
      final TaskListModel taskListModel =
          TaskListModel.fromJson(response.responseData);
      _newTaskList = taskListModel.taskList ?? [];
    } else {
      showSnackBarMessage(context, response.errorMessage, true);
    }

    _getNewTaskListInProgress = false;
    setState(() {});
  }
}
