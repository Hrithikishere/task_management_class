import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:task_management/ui/controllers/task_controller.dart';
import 'package:task_management/ui/utils/app_colors.dart';
import 'package:task_management/ui/widgets/show_snackbar_message.dart';

class TaskCard extends StatefulWidget {
  TaskCard({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.createdDate,
    super.key,
  });

  String id;
  String title;
  String description;
  String status;
  DateTime createdDate;

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {

  final TaskController _taskController = Get.find<TaskController>();

  String _selectedStatus = '';
  bool _inProgressUpdate = false;
  bool _inProgressDelete = false;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _selectedStatus = widget.status;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.title,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(
                      fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Text(
                widget.description,
                style: const TextStyle(
                    color: Colors.black45, fontSize: 12),
              ),
              const SizedBox(height: 4),
              Text('Created Time: ${DateFormat(' yyyy-MM-dd – kk:mm').format(widget.createdDate)}', style: const TextStyle(color: Colors.black87, fontSize: 12)),
              const SizedBox(height: 6),
              Row(
                children: [
                  Chip(
                      label: Text(widget.status),
                      labelStyle: const TextStyle(fontSize: 12),
                      labelPadding: const EdgeInsets.symmetric(
                          horizontal: 15),
                      backgroundColor:
                      AppColors.onThemeColorWhite,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(25),
                      )),
                  const Spacer(),
                  GetBuilder(
                    init: _taskController,
                    builder: (controller) {
                      return IconButton(
                          onPressed: controller.inProgressUpdate ? null :_onTapEditButton,
                          icon: _inProgressUpdate ? const CircularProgressIndicator() : const Icon(
                        Icons.edit_note,
                        color: AppColors.themeColor,
                      ),);
                    }
                  ),
                  GetBuilder(
                    init: _taskController,
                    builder: (controller) {
                      return IconButton(
                          onPressed: controller.inProgressDelete ? null : _onTapDeleteButton,
                          icon: _inProgressDelete ? const CircularProgressIndicator() : Icon(
                            Icons.delete_outline,
                            color: Colors.red[500],
                          ));
                    }
                  ),
                ],
              )
            ],
          ),
        ));

  }

  void _onTapEditButton() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Status'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: ['New', 'Completed', 'Cancelled', 'Progress'].map((status) {
              return ListTile(
                onTap: () {
                  _changeStatus(status);
                  Navigator.pop(context);
                },
                title: Text(status),
                selected: _selectedStatus == status,
                trailing: _selectedStatus == status ? const Icon(Icons.check) : null,
              );
            }).toList(),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _onTapDeleteButton() async {
    _inProgressDelete = true;
    setState(() {});
    final bool result = await _taskController.deleteTask(widget.id);
    setState(() {});
    _inProgressDelete = false;
    if (result) {
      showSnackBarMessage(context, 'Task deleted!');
    } else {
      showSnackBarMessage(context, _taskController.errorMessage!, true);
    }
  }

  Widget _buildTaskStatusChip() {
    return Chip(
      label: Text(
        widget.status,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      side: const BorderSide(
        color: AppColors.themeColor,
      ),
    );
  }

  Future<void> _changeStatus(String newStatus) async {
    _inProgressUpdate = false;
    setState(() {});
    final bool result = await _taskController.changeStatus(widget.id, newStatus);
    setState(() {});
    _inProgressUpdate = false;
    if (result) {
      showSnackBarMessage(context, 'Task updated!');
    } else {
      showSnackBarMessage(context, _taskController.errorMessage!, true);
    }
  }
}
