import 'package:flutter/material.dart';
import 'package:guardix/constants/colors.dart';
import 'package:guardix/service/auth/auth_service.dart';
import 'package:guardix/service/auth/auth_user.dart';
import 'package:guardix/service/cloud/firebase_cloud_storage.dart';
import 'package:guardix/service/cloud/model/cloud_user.dart';
import 'package:guardix/utilities/dialogs/confirmation_dialog.dart';
import 'package:guardix/utilities/validation_utils.dart';

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
  bool _isInitialized = false;

  final _formKey = GlobalKey<FormState>();

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
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (!_isInitialized) {
      
    }
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
    );
  }
}
