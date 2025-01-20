import 'dart:io';

import 'package:flutter/material.dart';
import 'package:guardix/constants/colors.dart';
import 'package:guardix/utilities/decorations/input_decoration_template.dart';
import 'package:guardix/utilities/dialogs/submit_report_dialog.dart';
import 'package:image_picker/image_picker.dart';

class ReportFormView extends StatefulWidget {
  const ReportFormView({super.key});

  @override
  State<ReportFormView> createState() => _ReportFormViewState();
}

class _ReportFormViewState extends State<ReportFormView> {
  final _formKey = GlobalKey<FormState>();

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
  late final TextEditingController _evidenceImage;

  late final ImagePicker _imagePicker;

  final List<String> _policeStationList = [
    '',
    'Sylhet',
    'Moulovibazar',
    'Hobiganj',
    'Sunamgonj',
    'Dhaka',
    'Chittagong',
  ];

  String? _selectedPoliceStation;
  List<XFile>? _selectedImages = [];
  String _imagesErrorText = 'Optional';

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

  Future<void> _pickImages() async {
    final List<XFile>? images = await _imagePicker.pickMultiImage(limit: 4);

    if (images != null && images.isNotEmpty) {
      setState(() {
        if (images.length > 5) {
          _imagesErrorText = '*At most 5 images';
          _selectedImages = null;
          _evidenceImage.text = '';
        } else {
          _imagesErrorText = '';
          _selectedImages = images;
          _evidenceImage.text = _selectedImages![0].name;
          String imageNames = '';
          for (final image in images) {
            imageNames =
                imageNames == '' ? image.name : '$imageNames, ${image.name}';
          }
          _evidenceImage.text = imageNames;
        }
      });
    }
  }

  String? _validateNotEmpty(String? value) {
    if (value == null || value.isEmpty) {
      return '*Required Field';
    }
    return null;
  }

  @override
  void initState() {
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
    _selectedPoliceStation = _policeStationList[0];
    _imagePicker = ImagePicker();
    _evidenceImage = TextEditingController();

    _injuryType.addListener(() {});

    super.initState();
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
    _evidenceImage.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String category =
        ModalRoute.of(context)?.settings.arguments as String;

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
        title: Text(
          'Report $category',
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
                  validator: (value) => _validateNotEmpty(value),
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
                  validator: (value) => _validateNotEmpty(value),
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
                  keyboardType: TextInputType.text,
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
                  items: _policeStationList
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
                TextField(
                  controller: _evidenceImage,
                  readOnly: true,
                  onTap: () => _pickImages(),
                  decoration: buildInputDecoration(
                    label: 'Attach Pictures',
                    suffixIcon: const Icon(
                      Icons.image,
                      color: midnightBlueColor,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 1.0, left: 16.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      _imagesErrorText,
                      style: TextStyle(
                            color: _imagesErrorText == 'Optional' ? midnightBlueColor : crimsonRedColor, 
                            fontSize: 12,
                          ),
                    ),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  height: 100,
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 5,
                    ),
                    itemCount: _selectedImages?.length ?? 0,
                    itemBuilder: (context, index) {
                      return Image.file(
                        File(_selectedImages![index].path),
                        fit: BoxFit.cover,
                      );
                    },
                  ),
                ),
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        bool isSubmitted =
                            await showReportSubmissionDialog(context);
                        if (context.mounted) {
                          if (isSubmitted) {
                            // String victimName = _victimName.text;
                            // String victimAddress = _victimAddress.text;
                            // String victimContact = _victimContact.text;
                            // String witnessName = _witnessName.text;
                            // String witnessContact = _witnessContact.text;

                            // String dateOfCrime = _dateOfCrime.text;
                            // String timeOfCrime = _timeOfCrime.text;
                            // String locationOfCrime = _locationOfCrime.text;
                            // String descriptionOfCrime = _descriptionOfCrime.text;
                            // String injuryType = _injuryType.text;
                            // TODO: Save in Firebase Cloud
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
