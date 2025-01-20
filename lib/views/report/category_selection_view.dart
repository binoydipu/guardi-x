import 'package:flutter/material.dart';
import 'package:guardix/constants/colors.dart';
import 'package:guardix/constants/routes.dart';
import 'package:guardix/utilities/decorations/input_decoration_template.dart';

class CategorySelectionView extends StatefulWidget {
  const CategorySelectionView({super.key});

  @override
  State<CategorySelectionView> createState() => _CategorySelectionViewState();
}

class _CategorySelectionViewState extends State<CategorySelectionView> {
  final List<String> _categoryList = [
    '',
    'Eve Teasing',
    'Robbery',
    'Missing Human',
    'Kidnapping',
    'Accident',
    'Missing Things',
  ];

  String? _selectedCategory;
  bool isButtonActive = false;

  @override
  void initState() {
    _selectedCategory = _categoryList[0];
    super.initState();
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
        title: const Text(
          'Crime Report',
          style: TextStyle(color: whiteColor),
        ),
        centerTitle: true,
        backgroundColor: midnightBlueColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 30),
            DropdownButtonFormField(
              value: _selectedCategory,
              items: _categoryList
                  .map(
                    (e) => DropdownMenuItem(
                      value: e,
                      child: Text(e),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value;
                  isButtonActive = (_selectedCategory != null && _selectedCategory?.compareTo('') != 0);
                });
              },
              icon: const Icon(
                Icons.arrow_drop_down,
                color: midnightBlueColor,
              ),
              dropdownColor: Colors.blue[50],
              decoration: buildInputDecoration(label: 'Select Category'),
            ),
            const Spacer(),
            Container(
              alignment: Alignment.center,
              child: const Column(
                children: [
                  Text(
                    'Disclaimer',
                    style: TextStyle(
                      color: blackColor,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Selecting the right crime Category is vital for accurate reporting and prompt response from law enforcement. Choose the category that best matches your incident to streamline the reporting process and ensure effective handling. Thank you for contributing to community safety and security.',
                    style: TextStyle(
                      color: blackColor,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: isButtonActive 
                ? () {
                  Navigator.of(context).pushNamed(
                    reportFormRoute,
                    arguments: _selectedCategory,
                  );
                } : null,
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
    );
  }
}
