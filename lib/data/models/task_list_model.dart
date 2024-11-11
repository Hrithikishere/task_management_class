import 'dart:convert';

import 'task_model.dart';

TaskListModel taskListModelFromJson(String str) => TaskListModel.fromJson(json.decode(str));

String taskListModelToJson(TaskListModel data) => json.encode(data.toJson());

class TaskListModel {
    TaskListModel({
        required this.taskList,
        required this.status,
    });

    List<TaskModel> taskList;
    String status;

    factory TaskListModel.fromJson(Map<dynamic, dynamic> json) => TaskListModel(
        taskList: List<TaskModel>.from(json["data"].map((x) => TaskModel.fromJson(x))),
        status: json["status"],
    );

    Map<dynamic, dynamic> toJson() => {
        "data": List<dynamic>.from(taskList.map((x) => x.toJson())),
        "status": status,
    };
}