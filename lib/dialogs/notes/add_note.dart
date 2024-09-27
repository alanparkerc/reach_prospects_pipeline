import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
import '../../cosmetic/styles.dart';
// import '../../main.dart';
import '../../library/functions.dart';

class AddNoteDialog extends StatefulWidget {
  final Map<String, String> mainHeader;
  final Map<String, dynamic> prospect;
  final String userId;

  const AddNoteDialog(
      {Key? key,
      required this.mainHeader,
      required this.prospect,
      required this.userId})
      : super(key: key);

  @override
  AddNoteDialogState createState() => AddNoteDialogState();
}

class AddNoteDialogState extends State<AddNoteDialog> {
  TextEditingController addNoteController = TextEditingController();
  TextEditingController addTitleController = TextEditingController();
  TextEditingController userController = TextEditingController();
  Map<String, dynamic> returnNote = {};
  bool internalNote = false;
  bool showError = false;
  bool isSubmitting = false;

  Future<void> _addNote() async {
    String userId = widget.userId;
    if (userController.text == '') {
      setState(() {
        userController.text = returnGivenIdUserName(widget.userId);
      });
    } else {
      userId = returnGivenUserNameId(userController.text);
    }
    final Map<String, dynamic> reqBody = {
      "id": generateRandomId(),
      "clientId": widget.prospect['id'].toString(),
      "assignedUserId": userId,
      "title": addTitleController.text,
      "description": addNoteController.text,
      "assignedUserName": userController.text,
      "type": 2,
      "isInternal": internalNote,
      "updatedOn": DateTime.now().toString(),
    };

    // http.Response responseTags = await http.post(
    //     Uri.parse('${settings[0]}/datafeed/savenote'),
    //     headers: widget.mainHeader,
    //     body: jsonEncode(reqBody));
    // if (responseTags.statusCode == 200) {
    setState(() {
      returnNote = reqBody;
    });
    // }
  }

  void pageRoute(Map<String, dynamic> returnNote) {
    Navigator.of(context).pop(returnNote);
  }

  @override
  void dispose() {
    addNoteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: DecoratedBox(
          decoration: const BoxDecoration(border: Border(bottom: BorderSide())),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 32, 16),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Add Note'),
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context); // Close the dialog
                      },
                      style: rightTitleButtonStyle,
                      child: const Icon(
                        Icons.exit_to_app,
                        color: Colors.black,
                      ))
                ]),
          )),
      titlePadding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
      content: SizedBox(
        height: 450,
        width: 600,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Add Title*'),
                SizedBox(
                  width: 300,
                  child: TextField(
                    controller: addTitleController,
                    textAlign: TextAlign.start,
                    textAlignVertical: TextAlignVertical.top,
                    minLines: 4,
                    maxLines: 6,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Add title to prospect record',
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        floatingLabelAlignment: FloatingLabelAlignment.start),
                  ),
                )
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Add Note*'),
                SizedBox(
                  width: 300,
                  child: TextField(
                    controller: addNoteController,
                    textAlign: TextAlign.start,
                    textAlignVertical: TextAlignVertical.top,
                    minLines: 4,
                    maxLines: 6,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Add note to prospect record',
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        floatingLabelAlignment: FloatingLabelAlignment.start),
                  ),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                    'Assign user\n(Sets as logged in user if not selected)'),
                DropdownButton<String>(
                  focusNode: FocusNode(),
                  onChanged: (value) {
                    setState(() {
                      userController.text = value!;
                    });
                  },
                  value: userController.text,
                  items: returnUserNames()
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Text('Internal?'),
                wSixteenBox,
                Checkbox(
                  value: internalNote,
                  onChanged: (_) {
                    setState(() {
                      internalNote = !internalNote;
                    });
                  },
                ),
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
            isSubmitting
                ? Row(
                    children: [
                      loadingCircle(),
                      const Padding(
                        padding: EdgeInsets.fromLTRB(8, 0, 0, 0),
                        child: Text('Submitting...'),
                      )
                    ],
                  )
                : const SizedBox()
          ],
        ),
      ),
      actions: [
        Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 32, 16),
            child: ElevatedButton(
              onPressed: () async {
                // Check if any of the fields are empty
                if ((addNoteController.text.isNotEmpty) &&
                    (addTitleController.text.isNotEmpty)) {
                  setState(() {
                    isSubmitting = true;
                  });
                  await _addNote();
                  setState(() {
                    isSubmitting = false;
                  });
                  pageRoute(returnNote);
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
            )),
      ],
    );
  }
}
