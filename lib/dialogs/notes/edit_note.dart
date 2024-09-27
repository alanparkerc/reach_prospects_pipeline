import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
import '../../cosmetic/styles.dart';
// import '../../main.dart';
import '../../library/functions.dart';

class EditNoteDialog extends StatefulWidget {
  final Map<String, String> mainHeader;
  final Map<String, dynamic> prospect;
  final Map<String, dynamic> note;
  final String userId;

  const EditNoteDialog(
      {Key? key,
      required this.mainHeader,
      required this.prospect,
      required this.note,
      required this.userId})
      : super(key: key);

  @override
  EditNoteDialogState createState() => EditNoteDialogState();
}

class EditNoteDialogState extends State<EditNoteDialog> {
  final TextEditingController addNoteController = TextEditingController();
  final TextEditingController addTitleController = TextEditingController();
  Map<String, dynamic> returnNote = {};
  bool internalNote = false;
  bool showError = false;

  Future<void> editNote() async {
    final Map<String, dynamic> reqBody = {
      "id": widget.note['id'].toString(),
      "clientId": widget.prospect['id'].toString(),
      "assignedUserId": widget.userId,
      "title": addTitleController.text,
      "description": addNoteController.text,
      "assignedUserName": returnGivenIdUserName(widget.userId),
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
    addTitleController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    addNoteController.text = widget.note['description'];
    addTitleController.text = widget.note['title'];
    returnNote = widget.note;
    internalNote = widget.note['isInternal'] == true;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text('Edit Note'),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop(returnNote); // Close the dialog
                },
                style: clearButtonStyle,
                child: const Icon(
                  Icons.exit_to_app,
                  color: Colors.black,
                ))
          ]),
      content: SizedBox(
        height: 400,
        width: 600,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Edit Title'),
                SizedBox(
                  width: 300,
                  child: TextField(
                    controller: addTitleController,
                    textAlign: TextAlign.start,
                    minLines: 4,
                    maxLines: 6,
                    decoration: const InputDecoration(
                        labelText:
                            'Edit title of the note on the prospect record.\n'),
                  ),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Edit Note'),
                SizedBox(
                  width: 300,
                  child: TextField(
                    controller: addNoteController,
                    textAlign: TextAlign.start,
                    minLines: 4,
                    maxLines: 6,
                    decoration: const InputDecoration(
                        labelText:
                            'Add description of the note on the prospect record.\n'),
                  ),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Text('Internal?'),
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
          ],
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () async {
            // Check if any of the fields are empty
            if ((addNoteController.text.isNotEmpty) &&
                (addTitleController.text.isNotEmpty)) {
              await editNote();
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
        ),
      ],
    );
  }
}
