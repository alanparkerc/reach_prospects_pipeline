// import 'dart:convert';
// import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// import 'main.dart';

class ShowTasksPage extends StatefulWidget {
  final String authToken;
  final String userId;
  final int role;
  final Map<String, String> mainHeader;

  const ShowTasksPage({
    Key? key,
    required this.authToken,
    required this.userId,
    required this.role,
    required this.mainHeader,
  }) : super(key: key);

  @override
  ShowTasksPageState createState() => ShowTasksPageState();
}

class ShowTasksPageState extends State<ShowTasksPage> {
  TextEditingController searchController = TextEditingController();
  String searchAll = '';
  String chosenDueDate = 'All Action Dates'; // Initial selected value
  bool showAdmin = false;
  List<Map<String, dynamic>> userTasks = [];
  Future<void> _fetchAllStages() async {
    await _fetchTasksForUser();
  }

  Future<void> _fetchTasksForUser() async {
    // Remove API Calls for Demo Purposes
    // final http.Response responseMyTasks =
    //     await http.post(Uri.parse('${settings[0]}/tasks/getalltasks'),
    //         headers: widget.mainHeader,
    //         body: jsonEncode({
    //           "showOnlyMyTasks": true,
    //         }));
    // if (responseMyTasks.statusCode == 200) {
    setState(() {
      // userTasks = jsonDecode(responseMyTasks.body)['data'];
      userTasks = [];
    });
    // }
  }

  bool checkDateTime(DateTime dueDate) {
    if (chosenDueDate == 'All Action Dates') {
      return true;
    } else if (chosenDueDate == 'Overdue') {
      if (dueDate.isBefore(DateTime.now())) {
        return true;
      } else {
        return false;
      }
    } else if (chosenDueDate == 'Today') {
      if (dueDate.isAtSameMomentAs(DateTime.now())) {
        return true;
      } else {
        return false;
      }
    } else if (chosenDueDate == 'Upcoming') {
      if (dueDate.isAfter(DateTime.now())) {
        return true;
      } else {
        return false;
      }
    }
    return true;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _fetchAllStages(); // Fetch stages when initializing the widget
  }

  Widget returnTopRow() {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
              child: DropdownButton<String>(
                focusNode: FocusNode(),
                value: chosenDueDate,
                onChanged: (newValue) {
                  chosenDueDate = newValue!;
                },
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                items: ['All Action Dates', 'Overdue', 'Today', 'Upcoming']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                }).toList(),
              ),
            ),
            Expanded(
              child: TextField(
                onChanged: (_) {
                  setState(() {
                    searchAll = searchController.text;
                  });
                },
                controller: searchController,
                decoration: const InputDecoration(
                    hintText: 'Search...',
                    constraints: BoxConstraints(maxHeight: 32)),
              ),
            ),
          ],
        ));
  }

  Widget showColumnView() {
    int checkBack = 0;
    return SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 600,
        child: Material(
            color: Colors.transparent,
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: userTasks.length,
                itemBuilder: (context, index) {
                  if (checkDateTime(
                          DateTime.parse(userTasks[index]['dueDate'])) &&
                      ((searchAll == '') ||
                          (userTasks[index]['title']
                                  .toString()
                                  .toLowerCase()
                                  .contains(searchAll.toLowerCase()) ||
                              userTasks[index]['clientName']
                                  .toString()
                                  .toLowerCase()
                                  .contains(searchAll.toLowerCase()) ||
                              userTasks[index]['campaignName']
                                  .toString()
                                  .toLowerCase()
                                  .contains(searchAll.toLowerCase()) ||
                              userTasks[index]['assignedUserName']
                                  .toString()
                                  .toLowerCase()
                                  .contains(searchAll.toLowerCase()))) &&
                      (userTasks[index]['isCompleted'] != true)) {
                    checkBack++;
                  }
                  return (checkDateTime(
                              DateTime.parse(userTasks[index]['dueDate'])) &&
                          ((searchAll == '') ||
                              (userTasks[index]['title']
                                      .toString()
                                      .toLowerCase()
                                      .contains(searchAll.toLowerCase()) ||
                                  userTasks[index]['clientName']
                                      .toString()
                                      .toLowerCase()
                                      .contains(searchAll.toLowerCase()) ||
                                  userTasks[index]['campaignName']
                                      .toString()
                                      .toLowerCase()
                                      .contains(searchAll.toLowerCase()) ||
                                  userTasks[index]['assignedUserName']
                                      .toString()
                                      .toLowerCase()
                                      .contains(searchAll.toLowerCase()))) &&
                          (userTasks[index]['isCompleted'] != true))
                      ? SizedBox(
                          height: 50,
                          width: MediaQuery.of(context).size.width,
                          child: Material(
                              color: (checkBack % 2 == 0)
                                  ? Colors.transparent
                                  : Colors.white,
                              child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(16, 0, 16, 0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        width:
                                            (MediaQuery.of(context).size.width -
                                                    116) /
                                                5,
                                        child: Text(
                                          userTasks[index]['title'].toString(),
                                          style: const TextStyle(
                                            color: Colors.black,
                                          ),
                                          textAlign: TextAlign.start,
                                        ),
                                      ),
                                      SizedBox(
                                        width:
                                            (MediaQuery.of(context).size.width -
                                                    116) /
                                                5,
                                        child: Text(
                                          userTasks[index]['clientName']
                                              .toString(),
                                          style: const TextStyle(
                                            color: Colors.black,
                                          ),
                                          textAlign: TextAlign.start,
                                        ),
                                      ),
                                      SizedBox(
                                        width:
                                            (MediaQuery.of(context).size.width -
                                                    116) /
                                                5,
                                        child: Text(
                                          userTasks[index]['campaignName']
                                              .toString(),
                                          style: const TextStyle(
                                            color: Colors.black,
                                          ),
                                          textAlign: TextAlign.start,
                                        ),
                                      ),
                                      SizedBox(
                                        width:
                                            (MediaQuery.of(context).size.width -
                                                    116) /
                                                5,
                                        child: Text(
                                          DateFormat('MM/dd/yyyy').format(
                                              DateTime.parse(userTasks[index]
                                                      ['dueDate']
                                                  .toString())),
                                          style: const TextStyle(
                                            color: Colors.black,
                                          ),
                                          textAlign: TextAlign.start,
                                        ),
                                      ),
                                      SizedBox(
                                        width:
                                            (MediaQuery.of(context).size.width -
                                                    116) /
                                                5,
                                        child: Text(
                                          userTasks[index]['assignedUserName']
                                              .toString(),
                                          style: const TextStyle(
                                            color: Colors.black,
                                          ),
                                          textAlign: TextAlign.start,
                                        ),
                                      ),
                                    ],
                                  ))))
                      : const SizedBox();
                })));
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Material(
            color: Colors.transparent,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [returnTopRow(), showColumnView()])));
  }
}
