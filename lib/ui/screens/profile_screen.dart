import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:task_management/ui/controllers/auth_controller.dart';
import 'package:task_management/ui/controllers/profile_controller.dart';
import 'package:task_management/ui/widgets/show_snackbar_message.dart';
import 'package:task_management/ui/widgets/tm_appbar.dart';

class ProfileScreen extends StatefulWidget {

  static const String name = "/profile";

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

  final ProfileController _profileController = Get.find<ProfileController>();
  final AuthController _authController = Get.find<AuthController>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _setUserData();
  }

  void _setUserData(){
    _emailTEController.text = _authController.userData?.email ?? '';
    _firstNameTEController.text = _authController.userData?.firstName ?? '';
    _lastNameTEController.text = _authController.userData?.lastName ?? '';
    _mobileTEController.text = _authController.userData?.mobile ?? '';
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
            autovalidateMode: AutovalidateMode.onUserInteraction,
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
            autovalidateMode: AutovalidateMode.onUserInteraction,
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
            autovalidateMode: AutovalidateMode.onUserInteraction,
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
            autovalidateMode: AutovalidateMode.onUserInteraction,
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
            autovalidateMode: AutovalidateMode.onUserInteraction,
            decoration: const InputDecoration(hintText: 'Password'),
            validator: (String? value) {
              if (value!.isNotEmpty && value.length <= 6) {
                return 'Password must be greater than 6 characters';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          GetBuilder(
            init: ProfileController(),
            builder: (controller) {
              return ElevatedButton(
                onPressed: controller.inProgress ? null : onTapNextButton,
                child: controller.inProgress
                    ? const CircularProgressIndicator(
                    color: Colors.white, strokeWidth: 3)
                    : const Icon(Icons.arrow_forward_ios),
              );
            }
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
            GetBuilder(
              init: ProfileController(),
              builder: (controller) {
                return Text(_profileController.getSelectedPhotoTitle());
              }
            ),
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

    final bool result = await _profileController.updateProfile(_emailTEController.text.trim(), _firstNameTEController.text.trim(), _lastNameTEController.text.trim(), _mobileTEController.text.trim(), _passwordTEController.text);
    if(result){
      showSnackBarMessage(context, 'Profile has been updated!');
    }else{
      showSnackBarMessage(context, _profileController.errorMessage!, true);
    }
    setState(() {});

  }

  Future<void> _pickImage() async{
    ImagePicker _imagePicker = ImagePicker();
    XFile? pickedImage = await _imagePicker.pickImage(source: ImageSource.gallery);
    if(pickedImage!=null){
      _profileController.pickImage(pickedImage);
    }
  }

}
