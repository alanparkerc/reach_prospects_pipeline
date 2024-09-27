// import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:reach_prospects/library/constants.dart';
// import 'package:http/http.dart' as http;
import '../../cosmetic/styles.dart';
// import '../../main.dart';
import '../../library/functions.dart';

class EditProspect extends StatefulWidget {
  final Map<String, dynamic> prospect;
  final Map<String, String> mainHeader;
  final Function(Map<String, dynamic>, int) onSquareMoved;
  final String userId;

  const EditProspect({
    super.key,
    required this.prospect,
    required this.mainHeader,
    required this.onSquareMoved,
    required this.userId,
  });

  @override
  EditProspectState createState() => EditProspectState();
}

class EditProspectState extends State<EditProspect> {
  Map<String, dynamic> modifyProspect = {};
  bool invalidProspectEdit = false;
  bool isLoading = false;
  String nextAction = '';
  Map<String, dynamic> addTask = {};

  Future<void> _selectDate() async {
    final DateTime picked = (await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    ))!;
    setState(() {
      modifyProspect['pickedDate'] = picked;
    });
  }

  Future<void> saveClientTask(DateTime pickedDate, int changeStageIndex) async {
    // change task
    if (nextAction != '') {
      // http.Response responseGetClientTasks = await http.get(
      //   Uri.parse(
      //       '${settings[0]}/tasks/gettasksbyclient?id=${widget.prospect['id'].toString()}'),
      //   headers: widget.mainHeader,
      // );
      // if (responseGetClientTasks.statusCode == 200) {
      // List<Map<String, dynamic>> clientTasks =
      //     List<Map<String, dynamic>>.from(
      //         jsonDecode(responseGetClientTasks.body)['data']);
      List<Map<String, dynamic>> clientTasks = [];
      for (Map<String, dynamic> task in clientTasks) {
        if ((task['isCompleted'] != true) &&
            (task['assignedUserId'] == widget.userId)) {
          task['isCompleted'] = true;
          task['completedOn'] = DateTime.now().toString();
          // http.Response responseTaskMarked = await http.post(
          //     Uri.parse('${settings[0]}/tasks/marktask'),
          //     headers: widget.mainHeader,
          //     body: jsonEncode(task));
          // if (responseTaskMarked.statusCode == 200) {
          // } else {}
        }
      }
      // }

      bool gotTaskValidation = false;
      String getRandomId = '';
      while (gotTaskValidation == false) {
        getRandomId = generateRandomId();

        // http.Response taskResponse = await http.get(
        //   Uri.parse('${settings[0]}/tasks/gettaskdetails?id=$getRandomId'),
        //   headers: widget.mainHeader,
        // );
        // Map<String, dynamic> taskResponseDetails =
        //     jsonDecode(taskResponse.body);
        // if ((taskResponse.statusCode == 200) &&
        // (taskResponseDetails['data'] == null)) {
        gotTaskValidation = true;
        // }
      }
      Map<String, dynamic> addTheTask = {
        "id": getRandomId,
        "title": nextAction.toString(),
        "priority": 1,
        "description": "Do the task from the title",
        "dueDate": pickedDate.toString(),
        "clientId": modifyProspect['id'].toString(),
        "isCompleted": false,
        'assignedUserId': widget.userId,
        'assignedUserName': returnGivenIdUserName(widget.userId)
      };
      // http.Response responseAddedTheTask = await http.post(
      //     Uri.parse('${settings[0]}/tasks/savetask'),
      //     headers: widget.mainHeader,
      //     body: jsonEncode(addTheTask));
      // if (responseAddedTheTask.statusCode == 200) {
      setState(() {
        addTask = addTheTask;
      });
      // }
    }
    // change stage
    if ((changeStageIndex != -1) &&
        (changeStageIndex != modifyProspect['columnIndex'])) {
      await widget.onSquareMoved(modifyProspect, changeStageIndex);
    }
  }

  void pageRoute() {
    Navigator.pop(context, addTask);
  }

  @override
  void dispose() {
    // Dispose of the controllers when they are no longer needed
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    modifyProspect = widget.prospect;
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      contentPadding: const EdgeInsets.all(12.0),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Quick Edit", style: mainStyle),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
                // Close the dialog
              },
              style: clearButtonStyle,
              child: const Icon(
                Icons.exit_to_app_sharp,
                color: Colors.black,
              ),
            ),
          ],
        ),
        const Text(
          "Set Next Action",
          style: TextStyle(color: Colors.black),
        ),
        DropdownButton<String>(
          onChanged: (value) {
            setState(() {
              nextAction = value!;
            });
          },
          value: nextAction,
          items: ['', 'Phone Call', 'Email', 'Other']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
        ElevatedButton(
          onPressed: _selectDate,
          style: clearButtonStyle,
          child: Text(
            (modifyProspect['pickedDate'] != null)
                ? DateFormat('MM/dd/yyyy')
                    .format(modifyProspect['pickedDate'])
                    .toString()
                : DateFormat('MM/dd/yyyy').format(DateTime.now()).toString(),
            style: mainStyle,
          ),
        ),
        const Text(
          "Move Stage",
          style: TextStyle(color: Colors.black),
        ),
        DropdownButton<String>(
          onChanged: (value) {
            setState(() {
              modifyProspect['nextStage'] = value;
            });
          },
          value: modifyProspect['nextStage'],
          items:
              stageDropdownItems.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
        ElevatedButton(
          onPressed: () async {
            int index = stageDropdownItems.indexOf(modifyProspect['nextStage']);
            if ((modifyProspect['columnIndex'] == index) &&
                (nextAction == '')) {
              setState(() {
                invalidProspectEdit = true;
              });
            } else {
              await saveClientTask(
                  modifyProspect['pickedDate'] ?? DateTime.now(), index);
              pageRoute();
            }
          },
          style: clearButtonStyle,
          child: Text(
            'Submit',
            style: mainStyle,
          ),
        ),
        invalidProspectEdit
            ? const Text(
                'A next action or stage must be selected to continue...',
                style: TextStyle(color: Colors.red),
              )
            : const SizedBox(),
      ],
    );
  }
}
