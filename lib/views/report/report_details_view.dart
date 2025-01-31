import 'package:flutter/material.dart';
import 'package:guardix/constants/colors.dart';
import 'package:guardix/service/auth/auth_constants.dart';
import 'package:guardix/service/auth/auth_service.dart';
import 'package:guardix/service/cloud/cloud_report.dart';
import 'package:guardix/service/cloud/cloud_storage_exceptions.dart';
import 'package:guardix/service/cloud/firebase_cloud_storage.dart';
import 'package:guardix/utilities/decorations/input_decoration_template.dart';
import 'package:guardix/utilities/dialogs/delete_dialog.dart';
import 'package:guardix/utilities/dialogs/error_dialog.dart';
import 'package:guardix/utilities/dialogs/report_created_dialog.dart';
import 'package:guardix/utilities/dialogs/update_report_dialog.dart';
import 'package:guardix/utilities/validation_utils.dart';
import 'package:guardix/views/report/report_constants.dart';

class ReportDetailsView extends StatefulWidget {
  const ReportDetailsView({super.key});

  @override
  State<ReportDetailsView> createState() => _ReportDetailsViewState();
}

class _ReportDetailsViewState extends State<ReportDetailsView> {
  String? get userEmail => AuthService.firebase().currentUser!.email;

  late final FirebaseCloudStorage _cloudStorage;

  final _formKey = GlobalKey<FormState>();

  late final CloudReport report;
  late final TextEditingController _victimName;
  late final TextEditingController _victimAddress;
  late final TextEditingController _victimContact;
  late final TextEditingController _witnessName;
  late final TextEditingController _witnessContact;

  late final TextEditingController _dateOfCrime;
  late final TextEditingController _timeOfCrime;
  late final TextEditingController _locationOfCrime;
  late final TextEditingController _descriptionOfCrime;
  late final TextEditingController _injuryType;

  String? _selectedPoliceStation;
  String? _selectedStatus;
  late final List<String> _reportStatusList;

  Future<void> _selectDate(BuildContext context) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (selectedDate != null) {
      setState(() {
        _dateOfCrime.text =
            "${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}";
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (selectedTime != null) {
      setState(() {
        _timeOfCrime.text = selectedTime.format(context);
      });
    }
  }

  String? _validateNotEmpty(String? value) {
    if (value == null || value.isEmpty) {
      return '*Required Field';
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

  bool _isInitialized = false;

  @override
  void initState() {
    _cloudStorage = FirebaseCloudStorage();
    _victimName = TextEditingController();
    _victimAddress = TextEditingController();
    _victimContact = TextEditingController();
    _witnessName = TextEditingController();
    _witnessContact = TextEditingController();
    _locationOfCrime = TextEditingController();
    _dateOfCrime = TextEditingController();
    _timeOfCrime = TextEditingController();
    _descriptionOfCrime = TextEditingController();
    _injuryType = TextEditingController();
    _reportStatusList = reportStatusList;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (!_isInitialized) {
      report = ModalRoute.of(context)?.settings.arguments as CloudReport;
      _victimName.text = report.victimName;
      _victimAddress.text = report.victimAddress;
      _victimContact.text = report.victimContact;
      _witnessName.text = report.witnessName;
      _witnessContact.text = report.witnessContact;
      _dateOfCrime.text = report.dateOfCrime;
      _timeOfCrime.text = report.timeOfCrime;
      _locationOfCrime.text = report.locationOfCrime;
      _descriptionOfCrime.text = report.descriptionOfCrime;
      _injuryType.text = report.injuryType;
      _selectedPoliceStation = report.policeStation;
      _selectedStatus = report.reportStatus;
      _isInitialized = true;
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _victimName.dispose();
    _victimAddress.dispose();
    _victimContact.dispose();
    _witnessName.dispose();
    _witnessContact.dispose();
    _locationOfCrime.dispose();
    _dateOfCrime.dispose();
    _timeOfCrime.dispose();
    _descriptionOfCrime.dispose();
    _injuryType.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: whiteColor,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          IconButton(
            onPressed: () async {
              bool isDeleted = await showDeleteDialog(
                  context: context,
                  title: 'Delete Report',
                  description:
                      'Are you sure want to delete this report?');
              if (context.mounted) {
                if (isDeleted) {
                  try {
                    _cloudStorage.deleteReport(
                        documentId: report.documentId);
                    bool reportDeleted = await showReportCreatedDialog(
                      context,
                      'Report updated successfully.',
                    );
                    if (reportDeleted) {
                      if (context.mounted) {
                        Navigator.of(context).pop();
                      }
                    }
                  } on CouldNotDeleteReportException catch (_) {
                    if (context.mounted) {
                      await showErrorDialog(
                        context,
                        'Could not delete report',
                      );
                    }
                  } on Exception catch (_) {}
                }
              }
            },
            icon: const Icon(
              Icons.delete,
              color: whiteColor,
            ),
          ),
        ],
        title: Text(
          report.category,
          style: const TextStyle(color: whiteColor),
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
                  'Personal Information',
                  style: TextStyle(
                    fontSize: 16,
                    color: blackColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 17),
                TextFormField(
                  controller: _victimName,
                  keyboardType: TextInputType.text,
                  decoration: buildInputDecoration(label: 'Victim Name'),
                  validator: (value) => _validateNotEmpty(value),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
                const SizedBox(height: 17),
                TextFormField(
                  controller: _victimAddress,
                  keyboardType: TextInputType.text,
                  decoration: buildInputDecoration(label: 'Victim Address'),
                  validator: (value) => _validateNotEmpty(value),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
                const SizedBox(height: 17),
                TextFormField(
                  controller: _victimContact,
                  keyboardType: TextInputType.phone,
                  decoration: buildInputDecoration(label: 'Victim Contact'),
                  validator: (value) => _validateContact(value),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
                const SizedBox(height: 17),
                TextFormField(
                  controller: _witnessName,
                  keyboardType: TextInputType.text,
                  decoration: buildInputDecoration(label: 'Witness Name'),
                  validator: (value) => _validateNotEmpty(value),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
                const SizedBox(height: 17),
                TextFormField(
                  controller: _witnessContact,
                  keyboardType: TextInputType.phone,
                  decoration: buildInputDecoration(label: 'Witness Contact'),
                  validator: (value) => _validateContact(value),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
                const SizedBox(height: 25),
                const Text(
                  'Crime Information',
                  style: TextStyle(
                    fontSize: 16,
                    color: blackColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 17),
                TextFormField(
                  controller: _dateOfCrime,
                  readOnly: true,
                  onTap: () => _selectDate(context),
                  decoration: buildInputDecoration(
                    label: 'Date of Crime',
                    suffixIcon: const Icon(
                      Icons.calendar_month,
                      color: midnightBlueColor,
                    ),
                  ),
                  validator: (value) => _validateNotEmpty(value),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
                const SizedBox(height: 17),
                TextFormField(
                  controller: _timeOfCrime,
                  readOnly: true,
                  onTap: () => _selectTime(context),
                  decoration: buildInputDecoration(
                    label: 'Time of Crime',
                    suffixIcon: const Icon(
                      Icons.access_time_filled,
                      color: midnightBlueColor,
                    ),
                  ),
                  validator: (value) => _validateNotEmpty(value),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
                const SizedBox(height: 17),
                TextFormField(
                  controller: _locationOfCrime,
                  keyboardType: TextInputType.text,
                  decoration: buildInputDecoration(label: 'Location of Crime'),
                  validator: (value) => _validateNotEmpty(value),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
                const SizedBox(height: 17),
                TextFormField(
                  controller: _descriptionOfCrime,
                  keyboardType: TextInputType.multiline,
                  maxLines: 5,
                  minLines: 1,
                  decoration:
                      buildInputDecoration(label: 'Description of Crime'),
                  validator: (value) => _validateNotEmpty(value),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
                const SizedBox(height: 17),
                TextFormField(
                  controller: _injuryType,
                  keyboardType: TextInputType.text,
                  decoration: buildInputDecoration(label: 'Any Injuries'),
                  validator: (value) => _validateNotEmpty(value),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
                const SizedBox(height: 25),
                const Text(
                  'Evidence Submission',
                  style: TextStyle(
                    fontSize: 16,
                    color: blackColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 17),
                DropdownButtonFormField(
                  value: _selectedPoliceStation,
                  items: policeStationList
                      .map(
                        (e) => DropdownMenuItem(
                          value: e,
                          child: Text(e),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedPoliceStation = value;
                    });
                  },
                  icon: const Icon(
                    Icons.arrow_drop_down,
                    color: midnightBlueColor,
                  ),
                  dropdownColor: Colors.blue[50],
                  decoration:
                      buildInputDecoration(label: 'Select Police Station'),
                  validator: (value) => _validateNotEmpty(value),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
                const SizedBox(height: 17),

                // only admin can update status
                userEmail == adminEmail
                    ? DropdownButtonFormField(
                        value: _selectedStatus,
                        items: _reportStatusList
                            .map(
                              (e) => DropdownMenuItem(
                                value: e,
                                child: Text(e),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedStatus = value;
                          });
                        },
                        icon: const Icon(
                          Icons.arrow_drop_down,
                          color: midnightBlueColor,
                        ),
                        dropdownColor: Colors.blue[50],
                        decoration:
                            buildInputDecoration(label: 'Select Status'),
                      )
                    : const SizedBox(),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        bool isSubmitted =
                            await showUpdateReportDialog(context);
                        if (context.mounted) {
                          if (isSubmitted) {
                            final victimName = _victimName.text;
                            final victimAddress = _victimAddress.text;
                            final victimContact = _victimContact.text;
                            final witnessName = _witnessName.text;
                            final witnessContact = _witnessContact.text;

                            final dateOfCrime = _dateOfCrime.text;
                            final timeOfCrime = _timeOfCrime.text;
                            final locationOfCrime = _locationOfCrime.text;
                            final descriptionOfCrime = _descriptionOfCrime.text;
                            final injuryType = _injuryType.text;
                            final policeStation = _selectedPoliceStation;
                            final reportStatus = _selectedStatus;

                            try {
                              _cloudStorage.updateReport(
                                  documentId: report.documentId,
                                  victimName: victimName,
                                  victimAddress: victimAddress,
                                  victimContact: victimContact,
                                  witnessName: witnessName,
                                  witnessContact: witnessContact,
                                  dateOfCrime: dateOfCrime,
                                  timeOfCrime: timeOfCrime,
                                  locationOfCrime: locationOfCrime,
                                  descriptionOfCrime: descriptionOfCrime,
                                  injuryType: injuryType,
                                  policeStation: policeStation!,
                                  reportStatus: reportStatus!);
                              bool reportUpdated =
                                  await showReportCreatedDialog(
                                context,
                                'Report updated successfully.',
                              );
                              if (reportUpdated) {
                                if (context.mounted) {
                                  Navigator.of(context).pop();
                                }
                              }
                            } on CouldNotUpdateReportException catch (_) {
                              if (context.mounted) {
                                await showErrorDialog(
                                  context,
                                  'Could not update report',
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
                              label: 'Undo',
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
                      'Update',
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
