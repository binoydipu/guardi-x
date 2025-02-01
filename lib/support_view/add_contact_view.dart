import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:guardix/constants/colors.dart';
import 'package:guardix/utilities/dialogs/error_dialog.dart';

class AddContactsView extends StatefulWidget {
  const AddContactsView({super.key});

  @override
  State<AddContactsView> createState() => _AddContactsViewState();
}

class _AddContactsViewState extends State<AddContactsView> {
  List<Contact>? _contacts;
  List<Contact>? _filteredContacts;
  bool _isLoading = true;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchContacts();
    _searchController.addListener(_filterContacts);
  }

  Future _fetchContacts() async {
    if (await FlutterContacts.requestPermission()) {
      final contacts = await FlutterContacts.getContacts(
          withProperties: true, withPhoto: true);

      setState(() {
        _contacts = contacts;
        _filteredContacts = contacts;
        _isLoading = false;
      });
    } else {
      // ignore: use_build_context_synchronously
      showErrorDialog(context, 'Permission Denied');
    }
  }

  void _filterContacts() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredContacts = _contacts
          ?.where((contact) =>
              contact.displayName.length >= query.length &&
                  contact.displayName
                          .toLowerCase()
                          .substring(0, query.length) ==
                      query ||
              contact.phones.any((phone) =>
                  phone.number.length >= query.length &&
                  phone.number.toLowerCase().substring(0, query.length) ==
                      query))
          .toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: Colors.white),
        backgroundColor: midnightBlueColor,
        title: const Text(
          "Your Contacts",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      labelText: 'Search Contacts',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  // Prevents layout errors. Without Expanded, the Column widget containing the search bar and ListView.builder might cause an error.
                  // This happens because ListView.builder is infinite in height by default, and Flutter needs to know how much space it should take.
                  // Expanded forces it to fill the 'remaining space' inside the Column. Visual explanation is given bellow of the code!!
                  child: _filteredContacts == null || _filteredContacts!.isEmpty
                      ? const Center(child: Text('No Contact Found'))
                      : ListView.builder(
                          itemCount: _filteredContacts!.length,
                          itemBuilder: (context, index) {
                            Contact contact = _filteredContacts![index];
                            return ListTile(
                              onTap: () {},
                              title: Text(contact.displayName.isNotEmpty
                                  ? contact.displayName
                                  : "Unnamed Contact"),
                              subtitle: Text(contact.phones.isNotEmpty
                                  ? contact.phones.first.number
                                  : "Number Not Added"),
                              leading: (contact.photo != null &&
                                      contact.photo!.isNotEmpty)
                                  ? CircleAvatar(
                                      backgroundImage:
                                          MemoryImage(contact.photo!))
                                  : CircleAvatar(
                                      child: Text(contact.displayName.isNotEmpty
                                          ? contact.displayName[0]
                                          : '#')),
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }
}

/*
Without Expanded (❌ Incorrect behavior):

+----------------------+
| Search Bar (fixed)  |
+----------------------+
|                     |  
|   ListView (grows)  |  ❌ Might cause overflow issues
|                     |
+----------------------+
 */

/*
With Expanded (✅ Correct behavior):

+----------------------+
| Search Bar (fixed)  |
+----------------------+
|                     |  
|   ListView (fills)  |  ✅ Proper layout
|                     |
+----------------------+
 */
