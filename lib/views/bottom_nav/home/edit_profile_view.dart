import 'dart:io';

import 'package:flutter/material.dart';
import 'package:guardix/constants/colors.dart';
import 'package:guardix/service/auth/auth_service.dart';
import 'package:guardix/service/auth/auth_user.dart';
import 'package:guardix/service/cloud/firebase_cloud_storage.dart';
import 'package:guardix/service/cloud/model/cloud_user.dart';
import 'package:guardix/utilities/decorations/input_decoration_template.dart';
import 'package:guardix/utilities/dialogs/confirmation_dialog.dart';
import 'package:guardix/utilities/validation_utils.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileView extends StatefulWidget {
  const EditProfileView({super.key});

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  AuthUser? get user => AuthService.firebase().currentUser;
  late final TextEditingController _name;
  late final TextEditingController _phone;
  late final TextEditingController _email;
  late final TextEditingController _password;

  late final FirebaseCloudStorage _cloudStorage;

  String? get userId => AuthService.firebase().currentUser!.id;

  late final ImagePicker _imagePicker;
  XFile? _selectedImage;
  late CloudUser cloudUser;

  final _formKey = GlobalKey<FormState>();

  Future<void> _pickImage() async {
    final XFile? image =
        await _imagePicker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = image;
      });
    }
  }

  String? _validateNotEmpty(String? value) {
    if (value == null || value.isEmpty) {
      return '*Required Field';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return '*Required Field';
    } else if (!ValidationUtils.validateEmail(value)) {
      return '*Invalid Email';
    }
    return null;
  }

  String? _validateContact(String? value) {
    if (value == null || value.isEmpty) {
      return '*Required Field';
    } else if (!ValidationUtils.validateMobile(value)) {
      return '*Invalid Number';
    }
    return null;
  }

  @override
  void initState() {
    _cloudStorage = FirebaseCloudStorage();
    _name = TextEditingController();
    _email = TextEditingController();
    _phone = TextEditingController();
    _password = TextEditingController();
    _imagePicker = ImagePicker();
    _getUser();
    super.initState();
  }

  void _getUser() async {
    cloudUser = await _cloudStorage.getUser(userId: userId!);
    _name.text = cloudUser.userName;
    _email.text = cloudUser.email;
    _phone.text = cloudUser.phone;
  }

  @override
  void didChangeDependencies() {
    setState(() {
      _getUser();
    });
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _phone.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Navigator.canPop(context)
            ? IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: whiteColor,
                ),
                onPressed: () async {
                  bool discard = await showConfirmationDialog(
                    context: context,
                    title: 'Discard Changes',
                    description:
                        'Are you sure you want to discard changes in profile? All unsaved changes will be lost.',
                  );
                  if (discard) {
                    if (context.mounted) {
                      Navigator.of(context).pop();
                    }
                  }
                },
              )
            : null,
        title: const Text(
          'Edit Profile',
          style: TextStyle(color: whiteColor),
        ),
        centerTitle: true,
        backgroundColor: midnightBlueColor,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                GestureDetector(
                  onTap: () => _pickImage(),
                  child: CircleAvatar(
                    radius: 70,
                    backgroundImage: _selectedImage != null
                        ? FileImage(File(_selectedImage!.path))
                        : const AssetImage('assets/images/profile_pic.png')
                            as ImageProvider,
                    child: _selectedImage == null
                        ? const Icon(
                            Icons.camera_alt,
                            size: 40,
                            color: Colors.grey,
                          )
                        : null,
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _name,
                  keyboardType: TextInputType.text,
                  decoration: buildInputDecoration(label: 'Name'),
                  validator: (value) => _validateNotEmpty(value),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
                const SizedBox(height: 17),
                TextFormField(
                  controller: _email,
                  keyboardType: TextInputType.emailAddress,
                  decoration: buildInputDecoration(label: 'Email Address'),
                  validator: (value) => _validateEmail(value),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
                const SizedBox(height: 17),
                TextFormField(
                  controller: _phone,
                  keyboardType: TextInputType.phone,
                  decoration: buildInputDecoration(label: 'Phone Number'),
                  validator: (value) => _validateContact(value),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
                const SizedBox(height: 25),
                const Text(
                  'Verify Yourself: ',
                  style: TextStyle(
                    fontSize: 16,
                    color: blackColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 17),
                TextFormField(
                  controller: _password,
                  keyboardType: TextInputType.text,
                  decoration:
                      buildInputDecoration(label: 'Confirm With Password'),
                  validator: (value) => _validateNotEmpty(value),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
                const SizedBox(height: 25),
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        // TODO: Re-authenticate User
                        // TODO: Update Profile
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text('Fill all required fields'),
                            action: SnackBarAction(
                              label: 'Ok',
                              onPressed: () {},
                            ),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: midnightBlueColor,
                    ),
                    child: const Text(
                      'Update Profile',
                      style: TextStyle(
                        color: whiteColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
