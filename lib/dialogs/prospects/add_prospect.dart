import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
import 'package:reach_prospects/library/constants.dart';
import 'package:reach_prospects/library/http.dart';
// import 'dart:convert';
import '../../cosmetic/styles.dart';
// import '../../main.dart';
import '../../library/functions.dart';

String? getSalesId(String input) {
  if (input.toLowerCase().contains('jessika')) {
    return salesRepIds['jessika'];
  } else if (input.toLowerCase().contains('anhely')) {
    return salesRepIds['anhely'];
  } else {
    return salesRepIds['kayla'];
  }
}

class AddProspectDialog extends StatefulWidget {
  final Map<String, String> mainHeader;
  final Function(Map<String, dynamic>) addProspectDataHome;
  final String userId;

  const AddProspectDialog({
    Key? key,
    required this.mainHeader,
    required this.addProspectDataHome,
    required this.userId,
  }) : super(key: key);

  @override
  AddProspectDialogState createState() => AddProspectDialogState();
}

class AddProspectDialogState extends State<AddProspectDialog> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController companyController = TextEditingController();
  final TextEditingController salesRepController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addNoteController = TextEditingController();
  bool showError = false;

  Future<Map<String, dynamic>> addProspect(String brandId) async {
    String getRandomId = '';
    bool clientId = false;

    while (clientId == false) {
      getRandomId = generateRandomId();

      // http.Response responseClient = await http.get(
      //   Uri.parse('${settings[0]}/clients/getclientdetails?id=$getRandomId'),
      //   headers: widget.mainHeader,
      // );
      // Map<String, dynamic> responseClientDetails =
      //     jsonDecode(responseClient.body);
      // if ((responseClient.statusCode == 200) &&
      // (responseClientDetails['data'] == null)) {
      clientId = true;
      // }
    }

    // http.Response responseTags =
    //     await http.post(Uri.parse('${settings[0]}/clients/saveclient'),
    //         headers: widget.mainHeader,
    //         body: jsonEncode({
    //           'id': getRandomId,
    //           'firstName': firstNameController.text,
    //           'lastName': lastNameController.text,
    //           'phoneNumber': phoneNumberController.text,
    //           'email': emailController.text,
    //           'addedNote': addNoteController.text,
    //           'isProspect': true,
    //           'salesRepId': getSalesId(salesRepController.text),
    //           'brand': companyController.text,
    //           'brandId': brandId
    //         }));
    // if (responseTags.statusCode == 200) {
    String stageTagId = await saveNewTags(getRandomId, 0, widget.mainHeader);

    // await http.post(Uri.parse('${settings[0]}/datafeed/savenote'),
    //     headers: widget.mainHeader,
    //     body: jsonEncode({
    //       "id": generateRandomId(),
    //       "clientId": getRandomId,
    //       "assignedUserId": widget.userId,
    //       "title": 'New Note',
    //       "description": addNoteController.text,
    //       "type": 2,
    //       "isInternal": true,
    //       "updatedOn": DateTime.now().toString(),
    //       "addFiles": [],
    //       "noteFiles": []
    //     }));
    return {
      // 'client': jsonDecode(responseTags.body)['data'].toString(),
      'client': '',
      'tag': stageTagId,
    };
    // }
    // return {
    //   'client': '',
    //   'tag': '',
    // };
  }

  void pageRoute() {
    Navigator.pop(
      context,
    );
  }

  @override
  void dispose() {
    // Dispose of the controllers when they are no longer needed
    firstNameController.dispose();
    lastNameController.dispose();
    companyController.dispose();
    salesRepController.dispose();
    phoneNumberController.dispose();
    emailController.dispose();
    addNoteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        const Text('Add Prospect'),
        TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            style: clearButtonStyle,
            child: const Icon(
              Icons.exit_to_app,
              color: Colors.black,
            ))
      ]),
      content: SizedBox(
        width: 600,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          // mainAxisSize: MainAxisSize.min,
          children: [
            returnSpaceBetweenValue('First Name*', firstNameController),
            returnSpaceBetweenValue('Last Name*', lastNameController),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              const Text('Company*'),
              DropdownButton<String>(
                onChanged: (value) {
                  setState(() {
                    companyController.text = value!;
                  });
                },
                focusNode: FocusNode(),
                value: companyController.text,
                items: returnCompanyNames()
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ]),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              const Text('Sales Rep*'),
              DropdownButton<String>(
                onChanged: (value) {
                  setState(() {
                    salesRepController.text = value!;
                  });
                },
                focusNode: FocusNode(),
                value: salesRepController.text,
                items: ['', 'Anhely', 'Jessika', 'Kayla']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ]),
            returnSpaceBetweenValue('Phone Number*', phoneNumberController),
            returnSpaceBetweenValue('Email*', emailController),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Add Note'),
                SizedBox(
                  width: 300,
                  child: TextField(
                    controller: addNoteController,
                    textAlign: TextAlign.end,
                    minLines: 4,
                    maxLines: 6,
                    decoration: const InputDecoration(
                        labelText: 'Add note to prospect record (optional)'),
                  ),
                )
              ],
            ),
            showError
                ? const Text('Wrong Data entered',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                      inherit: false,
                    ))
                : const SizedBox(),
          ],
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () async {
            // Check if any of the fields are empty
            if (firstNameController.text.isNotEmpty &&
                lastNameController.text.isNotEmpty &&
                companyController.text.isNotEmpty &&
                salesRepController.text.isNotEmpty &&
                phoneNumberController.text.isNotEmpty &&
                emailController.text.isNotEmpty) {
              Map e = companiesIds.firstWhere(
                  (element) => (element['name'] == companyController.text));

              // All fields are non-empty, proceed with Navigator.pop
              Map<String, dynamic> prospectInfo =
                  await addProspect(e['id'].toString());

              Map<String, dynamic> addingProspect = {
                "id": prospectInfo['client'],
                "firstName": firstNameController.text,
                "lastName": lastNameController.text,
                "brand": companyController.text,
                "brandId": e['id'].toString(),
                "salesRep": salesRepController.text,
                "salesRepId": getSalesId(salesRepController.text),
                "email": emailController.text,
                "phone": phoneNumberController.text,
                "isProspect": true,
                "fullName":
                    '${firstNameController.text} ${lastNameController.text}',
                "hotLead": false,
                "coldLead": false,
                "columnIndex": 0,
                "nextStage": 'New Prospect',
                'tasks': {},
                'tags': [
                  {
                    "id": prospectInfo['tag'],
                    "name": "Sales | New Prospect",
                  }
                ],
              };

              widget.addProspectDataHome(addingProspect);

              pageRoute();
            } else {
              setState(() {
                showError = true;
              });
            }
          },
          style: clearButtonStyle,
          child: Text(
            'Submit',
            style: mainStyle,
          ),
        ),
      ],
    );
  }

  Row returnSpaceBetweenValue(String theLabel, TextEditingController control) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(theLabel),
        SizedBox(
          width: 300,
          child: TextField(
            controller: control,
            textAlign: TextAlign.end,
            decoration: InputDecoration(labelText: theLabel),
          ),
        )
      ],
    );
  }
}
