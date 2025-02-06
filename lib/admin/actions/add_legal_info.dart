import 'package:flutter/material.dart';
import 'package:guardix/constants/colors.dart';
import 'package:guardix/service/cloud/cloud_storage_exceptions.dart';
import 'package:guardix/service/cloud/firebase_cloud_storage.dart';
import 'package:guardix/utilities/decorations/input_decoration_template.dart';
import 'package:guardix/utilities/dialogs/add_advocate_dialog.dart';
import 'package:guardix/utilities/dialogs/error_dialog.dart';
import 'package:guardix/utilities/dialogs/report_created_dialog.dart';

class AddLegalInfo extends StatefulWidget {
  const AddLegalInfo({super.key});

  @override
  State<AddLegalInfo> createState() => _AddLegalInfoState();
}

class _AddLegalInfoState extends State<AddLegalInfo> {
  late final FirebaseCloudStorage _cloudStorage;

  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _lawTitle;
  late final TextEditingController _lawDescription;

  String? _validateNotEmpty(String? value) {
    if (value == null || value.isEmpty) {
      return '*Required Field';
    }
    return null;
  }

  @override
  void initState() {
    _cloudStorage = FirebaseCloudStorage();
    _lawTitle = TextEditingController();
    _lawDescription = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _lawTitle.dispose();
    _lawDescription.dispose();
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
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            : null,
        title: const Text(
          'Add New Legal Info',
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
                  'Legal Information',
                  style: TextStyle(
                    fontSize: 16,
                    color: blackColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 17),
                TextFormField(
                  controller: _lawTitle,
                  keyboardType: TextInputType.text,
                  decoration: buildInputDecoration(label: 'Law Title'),
                  validator: (value) => _validateNotEmpty(value),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
                const SizedBox(height: 17),
                TextFormField(
                  controller: _lawDescription,
                  keyboardType: TextInputType.multiline,
                  maxLines: 15,
                  minLines: 3,
                  decoration: buildInputDecoration(label: 'Law Description'),
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
                              _cloudStorage.addNewLegalInfo(
                                  lawTitle: _lawTitle.text,
                                  lawDescription: _lawDescription.text,
                                );
                              bool lawAdded = await showReportCreatedDialog(
                                context,
                                'Legal Info added successfully.',
                              );
                              if (lawAdded) {
                                if (context.mounted) {
                                  Navigator.of(context).pop();
                                }
                              }
                            } on CouldNotCreateLawException catch (_) {
                              if (context.mounted) {
                                await showErrorDialog(
                                  context,
                                  'Could not add new legal info',
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
