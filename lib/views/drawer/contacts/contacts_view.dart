import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:guardix/constants/colors.dart';
import 'package:guardix/views/drawer/contacts/add_contact_view.dart';

class ContactsView extends StatefulWidget {
  const ContactsView({super.key});
  @override
  State<ContactsView> createState() => _ContactsViewState();
}

class _ContactsViewState extends State<ContactsView> {
  // ignore: unused_field
  List<Contact>? _contacts;
  //bool _isLoading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //backgroundColor: const Color.fromARGB(255, 129, 153, 173),
        centerTitle: true,
        title: TextButton.icon(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddContactsView()),
            );
          },
          icon: const Icon(
            Icons.person_add,
            color: midnightBlueColor,
            size: 35.0,
          ), // Add icon
          label: const Text(
            "Add New Contact",
            style: TextStyle(
              color: midnightBlueColor,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ), // Adjust color if needed
          ),
        ),
      ),
    );
  }
}