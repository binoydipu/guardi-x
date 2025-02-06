import 'package:flutter/material.dart';
import 'package:guardix/service/auth/auth_service.dart';
import 'package:guardix/service/cloud/model/cloud_legal_info.dart';
import 'package:guardix/service/cloud/firebase_cloud_storage.dart';
import 'package:guardix/utilities/dialogs/delete_dialog.dart';
import 'package:guardix/views/drawer/legal_info/legal_info_list_view.dart';

class LegalInfoView extends StatefulWidget {
  const LegalInfoView({super.key});

  @override
  State<LegalInfoView> createState() => _LegalInfoViewState();
}

class _LegalInfoViewState extends State<LegalInfoView> {
  late final FirebaseCloudStorage _cloudStorage;
  String get userEmail => AuthService.firebase().currentUser!.email;

  @override
  void initState() {
    _cloudStorage = FirebaseCloudStorage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.only(left: 16.0, right: 16.0),
            child: Text(
              'Legal Informations:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: StreamBuilder(
              stream: _cloudStorage.getAllLegalInfos(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                  case ConnectionState.active:
                    if (snapshot.hasData) {
                      final allLegalInfos = snapshot.data as Iterable<CloudLegalInfo>;
                      return LegalInfoListView(
                        legalInfos: allLegalInfos,
                        onLongPress: (legalInfo) async {
                          bool isDeleted = await showDeleteDialog(
                            context: context,
                            title: 'Delete Legal Info',
                            description: 'Do you want to delete this legal info?',
                          );
                          if(isDeleted) {
                            _cloudStorage.deleteLegalInfo(
                              documentId: legalInfo.documentId);
                          }
                        },
                      );
                    } else {
                      return const Center(child: Text('No Legal Information found.'));
                    }
                  default:
                    return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
