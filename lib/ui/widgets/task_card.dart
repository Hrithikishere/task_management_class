import 'package:flutter/material.dart';
import 'package:task_management/data/models/network_response.dart';
import 'package:task_management/data/services/network_caller.dart';
import 'package:task_management/data/utils/urls.dart';
import 'package:task_management/ui/utils/app_colors.dart';
import 'package:task_management/ui/widgets/show_snackbar_message.dart';

class TaskCard extends StatefulWidget {
  TaskCard({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    super.key,
  });

  String id;
  String title;
  String description;
  String status;

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {

  String _selectedStatus = '';
  bool _changeStatusInProgress = false;
  bool _deleteTaskInProgress = false;

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
              const Text("Date: 02/02/2020", style: TextStyle(color: Colors.black87, fontSize: 12)),
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
                  IconButton(
                      onPressed: _onTapEditButton,
                      icon: _changeStatusInProgress ? const CircularProgressIndicator() : const Icon(
                    Icons.edit_note,
                    color: AppColors.themeColor,
                  ),),
                  IconButton(
                      onPressed: _onTapDeleteButton,
                      icon: _deleteTaskInProgress ? const CircularProgressIndicator() : Icon(
                        Icons.delete_outline,
                        color: Colors.red[500],
                      )),
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
    _deleteTaskInProgress = true;
    setState(() {});
    final NetworkResponse response = await NetworkCaller.getRequest(
        url: Urls.deleteTask(widget.id));
    _deleteTaskInProgress = false;
    if (response.isSuccess) {
      setState(() {});
      showSnackBarMessage(context, 'Task deleted! Please refresh to see changes');
    } else {
      _deleteTaskInProgress = false;
      setState(() {});
      showSnackBarMessage(context, response.errorMessage, true);
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
    _changeStatusInProgress = true;
    setState(() {});
    final NetworkResponse response = await NetworkCaller.getRequest(
        url: Urls.changeStatus(widget.id, newStatus));
    _changeStatusInProgress = false;
    if (response.isSuccess) {
      setState(() {});
      showSnackBarMessage(context, 'Task status changed! Please refresh to see changes');
    } else {
      setState(() {});
      showSnackBarMessage(context, response.errorMessage);
    }
  }
}
