import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_management/ui/controllers/add_new_task_controller.dart';
import 'package:task_management/ui/widgets/show_snackbar_message.dart';
import 'package:task_management/ui/widgets/tm_appbar.dart';

class AddNewTaskScreen extends StatefulWidget {

  static const String name = "/addNewTask";

  const AddNewTaskScreen({super.key});

  @override
  State<AddNewTaskScreen> createState() => _AddNewTaskScreenState();
}

class _AddNewTaskScreenState extends State<AddNewTaskScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _titleTEController = TextEditingController();
  final TextEditingController _descriptionTEController = TextEditingController();

  final AddNewTaskController _addNewTaskController = Get.find<AddNewTaskController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: TMAppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: SingleChildScrollView(
            child: _buildTaskForm(),
          ),
        ),
      ),
    );
  }

  Widget _buildTaskForm(){
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 42),
          Text(
            "Add New Task",
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 24),
          TextFormField(
            controller: _titleTEController,
            autovalidateMode: _addNewTaskController.autovalidateMode,
            decoration: const InputDecoration(hintText: "Title"),
            validator: (String? value) {
              if (value?.trim().isEmpty ?? true) {
                return 'Enter task title';
              }
              return null;
            },
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _descriptionTEController,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            decoration: const InputDecoration(hintText: "Description"),
            maxLines: 5,
            validator: (String? value) {
              if (value?.trim().isEmpty ?? true) {
                return 'Enter task description';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          GetBuilder(
            init: _addNewTaskController,
            builder: (controller) {
              return ElevatedButton(
                  onPressed: controller.inProgress ? null : _onTapSubmitButton,
                  child: controller.inProgress ? const CircularProgressIndicator(color: Colors.white, strokeWidth: 3) : const Icon(Icons.arrow_forward_ios));
            }
          ),
        ],
      ),
    );

  }

  void _onTapSubmitButton(){

    if(_formKey.currentState!.validate()){
      _addNewTask();
    }
  }

  Future<void> _addNewTask() async{

    final bool result = await _addNewTaskController.addNewTask(_titleTEController.text.trim(),_descriptionTEController.text.trim());
    if(result){
      _clearTextFields();
    }else{
      showSnackBarMessage(context, _addNewTaskController.errorMessage!, true);
    }
  }

  void _clearTextFields(){
    _titleTEController.clear();
    _descriptionTEController.clear();
  }
}
