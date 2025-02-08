import 'package:flutter/material.dart';
import 'package:guardix/constants/colors.dart';
import 'package:guardix/service/cloud/cloud_storage_exceptions.dart';
import 'package:guardix/service/cloud/firebase_cloud_storage.dart';
import 'package:guardix/utilities/decorations/input_decoration_template.dart';
import 'package:guardix/utilities/dialogs/add_advocate_dialog.dart';
import 'package:guardix/utilities/dialogs/confirmation_dialog.dart';
import 'package:guardix/utilities/dialogs/error_dialog.dart';
import 'package:guardix/utilities/dialogs/report_created_dialog.dart';
import 'package:guardix/utilities/validation_utils.dart';

class AddNewAdvocate extends StatefulWidget {
  const AddNewAdvocate({super.key});

  @override
  State<AddNewAdvocate> createState() => _AddNewAdvocateState();
}

class _AddNewAdvocateState extends State<AddNewAdvocate> {
  late final FirebaseCloudStorage _cloudStorage;

  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _advocateName;
  late final TextEditingController _advocateType;
  late final TextEditingController _advocateEmail;
  late final TextEditingController _advocatePhone;
  late final TextEditingController _advocateAddress;

  String? _validateNotEmpty(String? value) {
    if (value == null || value.isEmpty) {
      return '*Required Field';
    }
    return null;
  }

  String? _validateEmailAddress(String? value) {
    if (value == null || value.isEmpty) {
      return '*Required Field';
    } else if (!ValidationUtils.validateEmail(value)) {
      return '*Invalid Email Address';
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
    _advocateType = TextEditingController();
    _advocateName = TextEditingController();
    _advocateEmail = TextEditingController();
    _advocateAddress = TextEditingController();
    _advocatePhone = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _advocateName.dispose();
    _advocateEmail.dispose();
    _advocateAddress.dispose();
    _advocatePhone.dispose();
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
                        'Are you sure you want to discard the new advocate? All unsaved changes will be lost.',
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
          'Add New Advocate',
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
                const Text(
                  'Advocate Information',
                  style: TextStyle(
                    fontSize: 16,
                    color: blackColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 17),
                TextFormField(
                  controller: _advocateName,
                  keyboardType: TextInputType.text,
                  decoration: buildInputDecoration(label: 'Advocate Name'),
                  validator: (value) => _validateNotEmpty(value),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
                const SizedBox(height: 17),
                TextFormField(
                  controller: _advocateType,
                  keyboardType: TextInputType.text,
                  decoration: buildInputDecoration(label: 'Advocate Type'),
                  validator: (value) => _validateNotEmpty(value),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
                const SizedBox(height: 17),
                TextFormField(
                  controller: _advocateEmail,
                  keyboardType: TextInputType.text,
                  decoration: buildInputDecoration(label: 'Advocate Email'),
                  validator: (value) => _validateEmailAddress(value),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
                const SizedBox(height: 17),
                TextFormField(
                  controller: _advocatePhone,
                  keyboardType: TextInputType.phone,
                  decoration: buildInputDecoration(label: 'Advocate Phone'),
                  validator: (value) => _validateContact(value),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
                const SizedBox(height: 17),
                TextFormField(
                  controller: _advocateAddress,
                  keyboardType: TextInputType.text,
                  decoration: buildInputDecoration(label: 'Advocate Address'),
                  validator: (value) => _validateNotEmpty(value),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        bool isSubmitted = await showAddAdvocateDialog(context);
                        if (context.mounted) {
                          if (isSubmitted) {
                            try {
                              _cloudStorage.addNewAdvocate(
                                advocateName: _advocateName.text,
                                advocateType: _advocateType.text,
                                advocateEmail: _advocateEmail.text,
                                advocatePhone: _advocatePhone.text,
                                advocateAddress: _advocateAddress.text,
                              );
                              bool reportCreated =
                                  await showReportCreatedDialog(
                                context,
                                'Advocate added successfully.',
                              );
                              if (reportCreated) {
                                if (context.mounted) {
                                  Navigator.of(context).pop();
                                }
                              }
                            } on CouldNotCreateAdvocateException catch (_) {
                              if (context.mounted) {
                                await showErrorDialog(
                                  context,
                                  'Could not add advocate',
                                );
                              }
                            } on Exception catch (_) {}
                          }
                        }
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
                      'Proceed',
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
