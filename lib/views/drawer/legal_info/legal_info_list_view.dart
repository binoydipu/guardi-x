import 'package:flutter/material.dart';
import 'package:guardix/constants/colors.dart';
import 'package:guardix/service/cloud/model/cloud_legal_info.dart';

typedef AdvocateCallback = void Function(CloudLegalInfo advocate);

class LegalInfoListView extends StatelessWidget {
  final Iterable<CloudLegalInfo> legalInfos;
  final AdvocateCallback onLongPress;

  const LegalInfoListView({
    super.key,
    required this.legalInfos,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: legalInfos.length,
      itemBuilder: (context, index) {
        final legalInfo = legalInfos.elementAt(index);

        return InkWell(
          onLongPress: () {
            onLongPress(legalInfo);
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Title: ${legalInfo.lawTitle}',
                  style: const TextStyle(
                    color: midnightBlueColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  legalInfo.lawDescription,
                  textAlign: TextAlign.justify,
                  style: const TextStyle(
                    color: blackColor,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
