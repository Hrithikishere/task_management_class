import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:task_management/data/models/network_response.dart';
import 'package:task_management/data/services/network_caller.dart';
import 'package:task_management/ui/controllers/auth_controller.dart';
import 'package:task_management/ui/widgets/show_snackbar_message.dart';
import 'package:task_management/ui/widgets/tm_appbar.dart';

import '../../data/utils/urls.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});


  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _firstNameTEController = TextEditingController();
  final TextEditingController _lastNameTEController = TextEditingController();
  final TextEditingController _mobileTEController = TextEditingController();
  final TextEditingController _passwordTEController = TextEditingController();

  XFile? selectedImage;
  bool _inProgress = false;
  bool _autoValidate = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _setUserData();
  }

  void _setUserData(){
    _emailTEController.text = AuthController.userData?.email ?? '';
    _firstNameTEController.text = AuthController.userData?.firstName ?? '';
    _lastNameTEController.text = AuthController.userData?.lastName ?? '';
    _mobileTEController.text = AuthController.userData?.mobile ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: TMAppBar(isProfileScreenOpen: true),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 42),
              Text(
                "Update Profile",
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 24),
              _buildProfileForm(),
            ],
          ),

        ),
      ),
    );
  }

  Widget _buildProfileForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          _buildPhotoPicker(),
          const SizedBox(height: 10),
          TextFormField(
            readOnly: true,
            controller: _emailTEController,
            keyboardType: TextInputType.emailAddress,
            autovalidateMode: _autoValidate
                ? AutovalidateMode.onUserInteraction
                : AutovalidateMode.disabled,
            decoration: const InputDecoration(hintText: 'Email'),
            validator: (String? value) {
              if (value?.isEmpty ?? true) {
                return 'Enter valid email';
              }
              return null;
            },
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: _firstNameTEController,
            autovalidateMode: _autoValidate
                ? AutovalidateMode.onUserInteraction
                : AutovalidateMode.disabled,
            decoration: const InputDecoration(hintText: 'First Name'),
            validator: (String? value) {
              if (value?.isEmpty ?? true) {
                return 'Enter first name';
              }
              return null;
            },
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: _lastNameTEController,
            autovalidateMode: _autoValidate
                ? AutovalidateMode.onUserInteraction
                : AutovalidateMode.disabled,
            decoration: const InputDecoration(hintText: 'Last Name'),
            validator: (String? value) {
              if (value?.isEmpty ?? true) {
                return 'Enter last name';
              }
              return null;
            },
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: _mobileTEController,
            keyboardType: TextInputType.phone,
            autovalidateMode: _autoValidate
                ? AutovalidateMode.onUserInteraction
                : AutovalidateMode.disabled,
            decoration: const InputDecoration(hintText: 'Phone'),
            validator: (String? value) {
              if (value?.isEmpty ?? true) {
                return 'Enter valid phone number';
              }
              return null;
            },
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: _passwordTEController,
            autovalidateMode: _autoValidate
                ? AutovalidateMode.onUserInteraction
                : AutovalidateMode.disabled,
            decoration: const InputDecoration(hintText: 'Password'),
            validator: (String? value) {
              // if (value?.isEmpty ?? true) {
              //   return 'Enter strong password';
              // }
              if (value!.isNotEmpty && value.length <= 6) {
                return 'Password must be greater than 6 characters';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: onTapNextButton,
            child: _inProgress
                ? const CircularProgressIndicator(
                color: Colors.white, strokeWidth: 3)
                : const Icon(Icons.arrow_forward_ios),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoPicker(){
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Container(
              height: 50,
              width: 100,
              decoration: const BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8),
                  bottomLeft: Radius.circular(8),
                )
              ),
              alignment: Alignment.center,
              child: const Text('Photo', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),),
            ),
            const SizedBox(width: 10),
            Text(_getSelectedPhotoTitle()),
          ],
        ),
      ),
    );
  }

  void onTapNextButton(){

    if(_formKey.currentState!.validate()){
        _updateProfile();
    }
  }


  Future<void> _updateProfile()async{
    _inProgress = true;
    setState(() {});
    Map<String, dynamic> requestBody = {
      "email": _emailTEController.text.trim(),
      "firstName": _firstNameTEController.text.trim(),
      "lastName": _lastNameTEController.text.trim(),
      "mobile": _mobileTEController.text.trim(),
    };

    if(_passwordTEController.text.isNotEmpty){
      requestBody["password"] =  _passwordTEController.text;
    }

    if(selectedImage!=null){
      List<int> imageBytes = await selectedImage!.readAsBytes();
      String convertedImage = base64Encode(imageBytes);
      requestBody["photo"] =  convertedImage;
    }

    final NetworkResponse response = await NetworkCaller.postRequest(url: Urls.profileUpdate, body: requestBody);
    _inProgress = false;

    if(response.isSuccess){
      await AuthController.saveUserData(response.responseData);
      await AuthController.getUserData();
      showSnackBarMessage(context, 'Profile has been updated!');
    }else{
      showSnackBarMessage(context, response.errorMessage, true);
    }
    setState(() {});
  }

  Future<void> _pickImage() async{
    ImagePicker _imagePicker = ImagePicker();
    XFile? pickedImage = await _imagePicker.pickImage(source: ImageSource.gallery);
    if(pickedImage!=null){
      selectedImage = pickedImage;
      setState(() {});
    }
  }

  String _getSelectedPhotoTitle(){
    if(selectedImage!=null){
      return selectedImage!.name;
    }
    return 'Select Photo';
  }
}
