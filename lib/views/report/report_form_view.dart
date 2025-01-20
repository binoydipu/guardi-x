import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:guardix/constants/colors.dart';
import 'package:guardix/utilities/decorations/input_decoration_template.dart';

class ReportFormView extends StatefulWidget {
  const ReportFormView({super.key});

  @override
  State<ReportFormView> createState() => _ReportFormViewState();
}

class _ReportFormViewState extends State<ReportFormView> {
  late final TextEditingController _victimName;
  late final TextEditingController _victimAddress;
  late final TextEditingController _victimContact;
  late final TextEditingController _witnessName;
  late final TextEditingController _witnessContact;

  late final TextEditingController _locationOfCrime;
  late final TextEditingController _injuryType;

  String? dateOfCrime;
  String? timeOfCrime;

  @override
  void initState() {
    _victimName = TextEditingController();
    _victimAddress = TextEditingController();
    _victimContact = TextEditingController();
    _witnessName = TextEditingController();
    _witnessContact = TextEditingController();
    _locationOfCrime = TextEditingController();
    _injuryType = TextEditingController();
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
    _injuryType.dispose();
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
          child: Column(
            children: [
              const Text(
                'Personal Information',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 17),
              TextField(
                controller: _victimName,
                keyboardType: TextInputType.text,
                decoration: buildInputDecoration(label: 'Victim Name'),
              ),
              const SizedBox(height: 17),
              TextField(
                controller: _victimAddress,
                keyboardType: TextInputType.text,
                decoration: buildInputDecoration(label: 'Victim Address'),
              ),
              const SizedBox(height: 17),
              TextField(
                controller: _victimContact,
                keyboardType: TextInputType.phone,
                decoration: buildInputDecoration(label: 'Victim Contact'),
              ),
              const SizedBox(height: 17),
              TextField(
                controller: _witnessName,
                keyboardType: TextInputType.text,
                decoration: buildInputDecoration(label: 'Witness Name'),
              ),
              const SizedBox(height: 17),
              TextField(
                controller: _witnessContact,
                keyboardType: TextInputType.phone,
                decoration: buildInputDecoration(label: 'Witness Contact'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
