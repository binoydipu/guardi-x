import 'package:flutter/material.dart';
import 'package:guardix/constants/colors.dart';
import 'package:guardix/service/cloud/model/cloud_advocate.dart';

typedef AdvocateCallback = void Function(CloudAdvocate advocate);
typedef AdvocateContactCallback = void Function(String phoneNumber);

class AdvocateListView extends StatelessWidget {
  final Iterable<CloudAdvocate> advocates;
  final AdvocateCallback onTap;
  final AdvocateContactCallback onCall;
  final AdvocateContactCallback onMessage;

  const AdvocateListView({
    super.key,
    required this.advocates,
    required this.onTap,
    required this.onCall,
    required this.onMessage,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: advocates.length,
      itemBuilder: (context, index) {
        final advocate = advocates.elementAt(index);

        return InkWell(
          onTap: () {
            onTap(advocate);
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 255,
              constraints: const BoxConstraints(
                minWidth: 150,
                maxWidth: 200,
              ),
              decoration: BoxDecoration(
                color: softBlueColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: Image(
                      fit: BoxFit.contain, 
                      image: AssetImage('assets/images/lawyer.png') as ImageProvider,
                      height: 90,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text(
                          advocate.advocateName,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: midnightBlueColor,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          advocate.advocateType,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: const TextStyle(
                            color: blackColor,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          advocate.advocateAddress,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: const TextStyle(
                            color: blackColor,
                            fontSize: 14,
                          ),
                        ),
                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              onPressed: () => onCall(advocate.advocatePhone),
                              icon: const Icon(
                                Icons.call,
                                color: midnightBlueColor,
                              ),
                            ),
                            IconButton(
                              onPressed: () => onMessage(advocate.advocatePhone),
                              icon: const Icon(
                                Icons.message,
                                color: midnightBlueColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
