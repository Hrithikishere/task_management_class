import 'package:flutter/material.dart';
import 'package:task_management/ui/utils/app_colors.dart';

class TaskCard extends StatelessWidget {
  TaskCard({
    required this.title,
    required this.description,
    required this.status,
    super.key,
  });

  String title;
  String description;
  String status;

  @override
  Widget build(BuildContext context) {
    return Card(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: 16.0, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(
                      fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Text(
                description,
                style: const TextStyle(
                    color: Colors.black45, fontSize: 12),
              ),
              const SizedBox(height: 4),
              const Text(
                "Date: 02/02/2020",
                style: TextStyle(
                    color: Colors.black87, fontSize: 12),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Chip(
                      label: Text(status),
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
                      onPressed: () {},
                      icon: const Icon(
                        Icons.edit_note,
                        color: AppColors.themeColor,
                      )),
                  IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.delete_outline,
                        color: Colors.red[500],
                      )),
                ],
              )
            ],
          ),
        ));
  }
}
