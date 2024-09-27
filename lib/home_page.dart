// import 'dart:convert';
import 'package:flutter/cupertino.dart';
// import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:reach_prospects/dialogs/notes/add_note.dart';
import 'package:reach_prospects/dialogs/prospects/add_prospect.dart';
import 'package:reach_prospects/dialogs/tags/change_lead_type.dart';
import 'package:reach_prospects/library/http.dart';
import 'package:reach_prospects/dialogs/prospects/edit_prospect.dart';
import 'package:reach_prospects/home_child_pages/list_home_page.dart';
import 'package:url_launcher/url_launcher.dart';
import 'login_page.dart';
import 'main.dart';
import 'library/constants.dart';
import 'cosmetic/styles.dart';
import 'library/functions.dart';

class HomePage extends StatefulWidget {
  final String authToken;
  final String userId;
  final int role;
  final bool enteredByLogin;

  const HomePage({
    Key? key,
    required this.authToken,
    required this.userId,
    required this.role,
    required this.enteredByLogin,
  }) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  Map<String, String> mainHeader = {};
  Map<int, List<Map<String, dynamic>>> columnLabelMap = {};
  TextEditingController searchController = TextEditingController();
  String chosenCrm = 'CRMs'; // Initial selected value
  String chosenDueDate = 'All Action Dates'; // Initial selected value
  String chosenHotOrCold = 'All'; // Initial selected value
  String searchProspects = '';
  bool invertView = true;
  bool doneLoading = false;
  bool showAdmin = false;
  int totalCheck = 0;

  void changeHotLead(int columnIndex, int rowIndex) {
    setState(() {
      columnLabelMap[columnIndex]![rowIndex]['hotLead'] =
          !columnLabelMap[columnIndex]![rowIndex]['hotLead'];
    });
  }

  void changeColdLead(int columnIndex, int rowIndex) {
    setState(() {
      columnLabelMap[columnIndex]![rowIndex]['coldLead'] =
          !columnLabelMap[columnIndex]![rowIndex]['coldLead'];
    });
  }

  Future<void> _fetchAllStages() async {
    await _fetchProspects();
    await _fetchClients();
    await _getColumnMap();
    await _getAllTagIds();
    await _fetchUsers();
    await _getAllCompanies();
    setState(() {
      doneLoading = true;
    });
  }

  Future<void> _fetchProspects() async {
    int figureItOut = 0;
    // for (String e in settings[1] as List<String>) {
    // http.Response response = await http.post(
    //     Uri.parse('${settings[0]}/clients/getallprospectclients'),
    //     headers: mainHeader,
    //     body: jsonEncode({
    //       'savedSearchId': e,
    //       'pageNumber': 1,
    //       'pageSize': 100,
    //     }));
    // for (var element in List<Map<String, dynamic>>.from(
    //     jsonDecode(response.body)['data'])) {
    for (var element in List<Map<String, dynamic>>.from([])) {
      setState(() {
        element['columnIndex'] = figureItOut;
        element['nextStage'] = stageDropdownItems[figureItOut];
        // prospectLabels.add(element);
        if (!columnLabelMap.containsKey(figureItOut)) {
          columnLabelMap[figureItOut] = [];
        }
        columnLabelMap[figureItOut]!.add(element);
      });
    }
    figureItOut++;
    // }
  }

  Future<void> _fetchClients() async {
    int figureItOut = 0;
    // for (String e in settings[4] as List<String>) {
    // http.Response response =
    //     await http.post(Uri.parse('${settings[0]}/clients/getallclients'),
    //         headers: mainHeader,
    //         body: jsonEncode({
    //           'savedSearchId': e,
    //           'pageNumber': 1,
    //           'pageSize': 100,
    //         }));
    // for (var element in List<Map<String, dynamic>>.from(
    //     jsonDecode(response.body)['data'])) {
    for (var element in List<Map<String, dynamic>>.from([])) {
      setState(() {
        element['columnIndex'] = figureItOut;
        element['nextStage'] = stageDropdownItems[figureItOut];
        // prospectLabels.add(element);
        if (!columnLabelMap.containsKey(figureItOut)) {
          columnLabelMap[figureItOut] = [];
        }
        columnLabelMap[figureItOut]!.add(element);
      });
    }
    figureItOut++;
    // }
  }

  Future<void> _getColumnMap() async {
    columnLabelMap.forEach((key, value) async {
      for (var element in value) {
        // var tags = element['tags'];
        element = await _fetchTags(element);
        element = await _fetchTasks(element);
      }
      if (value.isNotEmpty) {
        setState(() {
          totalCheck = totalCheck + value.length;
        });
      }
    });
  }

  Future<Map<String, dynamic>> _fetchTags(Map<String, dynamic> element) async {
    // http.Response responseTags = await http.get(
    //   Uri.parse(
    //       '${settings[0]}/tags/getallassociatedtags?id=${element['id']}&type=2'),
    //   headers: mainHeader,
    // );
    // if (responseTags.statusCode == 200) {
    // element['tags'] = jsonDecode(responseTags.body)['data'];
    element['tags'] = [];
    setState(() {
      element['hotLead'] =
          element['tags'].toString().toLowerCase().contains('hot lead');
      element['coldLead'] =
          element['tags'].toString().toLowerCase().contains('cold lead');
    });
    // }
    return element;
  }

  Future<Map<String, dynamic>> _fetchTasks(Map<String, dynamic> element) async {
    // http.Response responseTags = await http.get(
    //     Uri.parse('${settings[0]}/tasks/gettasksbyclient?id=${element['id']}'),
    //     headers: mainHeader);
    // http.Response responseNotes = await http.get(
    //   Uri.parse('${settings[0]}/datafeed/getNotes?id=${element['id']}&type=2'),
    //   headers: mainHeader,
    // );
    // if ((responseTags.statusCode == 200) && (responseNotes.statusCode == 200)) {
    // element['tasks'] = getTasks(jsonDecode(responseTags.body)['data'],
    //     jsonDecode(responseNotes.body)['data']);
    element['tasks'] = {};
    // element['holdTasks'] = jsonDecode(responseTags.body)['data'];
    element['holdTasks'] = [];
    // }
    return element;
  }

  Future<void> _getAllTagIds() async {
    // final http.Response response = await http
    //     .get(Uri.parse('${settings[0]}/tags/getalltags'), headers: mainHeader);
    // if (response.statusCode == 200) {
    // Map<String, dynamic> newResponseData = jsonDecode(response.body);
    // List<Map<String, dynamic>> tempTagIds =
    //     List<Map<String, dynamic>>.from(newResponseData['data']);
    List<Map<String, dynamic>> tempTagIds = [];
    for (String tagName in stageDropdownItems) {
      Map<String, dynamic> indexOf = tempTagIds.firstWhere((element) =>
          element['name']
              .toString()
              .toLowerCase()
              .contains(tagName.toLowerCase()));
      setState(() {
        tagIds.add(indexOf);
      });
    }
    // }
  }

  Future<void> _fetchUsers() async {
    // final http.Response response = await http.get(
    //     Uri.parse('${settings[0]}/datafeed/getalluserswithrole?code=1'),
    //     headers: mainHeader);
    // final http.Response responseSalesRep = await http.get(
    //     Uri.parse('${settings[0]}/datafeed/getalluserswithrole?code=10'),
    //     headers: mainHeader);
    // if (response.statusCode == 200) {
    // Map<String, dynamic> newResponseData = jsonDecode(response.body);
    Map<String, dynamic> newResponseData = {};

    setState(() {
      for (var e in newResponseData['data']) {
        userIds.add(e);
      }
    });
    // }
    // if (responseSalesRep.statusCode == 200) {
    // Map<String, dynamic> responseSalesRepData =
    //     jsonDecode(responseSalesRep.body);
    Map<String, dynamic> responseSalesRepData = {};
    setState(() {
      for (var e in responseSalesRepData['data']) {
        userIds.add(e);
      }
    });
    // }
  }

  Future<void> _getAllCompanies() async {
    // final http.Response response = await http.get(
    //     Uri.parse('${settings[0]}/companies/getallcompanies'),
    //     headers: mainHeader);
    // if (response.statusCode == 200) {
    // Map<String, dynamic> newResponseData = jsonDecode(response.body);
    Map<String, dynamic> newResponseData = {};

    setState(() {
      companiesIds = List<Map<String, dynamic>>.from(newResponseData['data']);
    });
    // }
  }

  Future<void> onSquareMoved(
      Map<String, dynamic> prospectSquare, int columnIndex) async {
    await saveNewTags(prospectSquare['id'], columnIndex, mainHeader);
    await deleteTags(
        prospectSquare['id'], prospectSquare['columnIndex'], mainHeader);
    setState(() {
      columnLabelMap[prospectSquare['columnIndex']]!.remove(prospectSquare);
    });
    prospectSquare = returnTagsAndAll(prospectSquare, columnIndex);
    prospectSquare['nextStage'] = stageDropdownItems[columnIndex];
    prospectSquare['columnIndex'] = columnIndex;
    setState(() {
      if (columnLabelMap[columnIndex] != null) {
        columnLabelMap[columnIndex]!.add(prospectSquare);
      } else {
        columnLabelMap[columnIndex] = [prospectSquare]; // Initialize the list
      }
    });
  }

  Future<void> addProspectDataHome(Map<String, dynamic> addingProspect) async {
    setState(() {
      columnLabelMap[0]!.add(addingProspect);
    });
  }

  void addNewNote(Map<String, dynamic> returnedNote,
      Map<String, dynamic> columnProspect, int columnIndex) {
    setState(() {
      columnLabelMap[columnProspect['columnIndex']]![columnIndex]['tasks']
          ["completedElement"] = returnedNote;
      columnLabelMap[columnProspect['columnIndex']]![columnIndex]['tasks']
          ["completedElement"]['completedOn'] = returnedNote['updatedOn'];
      columnLabelMap[columnProspect['columnIndex']]![columnIndex]['tasks']
              ['newestCompleted'] =
          DateTime.parse(returnedNote['updatedOn']).millisecondsSinceEpoch;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    columnLabelMap = {};
    mainHeader = {
      'Authorization': 'Bearer ${widget.authToken}',
      'accept': '*/*',
      'Content-Type': 'application/json'
    };
    _fetchAllStages(); // Fetch stages when initializing the widget
  }

  Widget returnEmptyDragColumn(int columnIndex) {
    return DragTarget<Map<String, dynamic>>(
        onAccept: (Map<String, dynamic> trialvalue) async {
      setState(() {
        doneLoading = false;
      });
      await onSquareMoved(trialvalue, columnIndex);
      setState(() {
        doneLoading = true;
      });
    }, builder: (context, candidates, rejected) {
      return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Material(
              color: const Color.fromARGB(255, 211, 211, 211),
              shape: const RoundedRectangleBorder(
                  side: BorderSide(color: Colors.white, width: 5),
                  borderRadius: BorderRadius.all(Radius.circular(5.0))),
              child: SizedBox(
                  width: 280,
                  height: MediaQuery.of(context).size.height - 104,
                  child: Padding(
                      padding: const EdgeInsets.fromLTRB(16.0, 32, 16, 16),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              stageDropdownItems[columnIndex],
                              style: mainStyle,
                              overflow: TextOverflow.ellipsis,
                            )
                          ])))));
    });
  }

  Widget returnTopRow() {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
              child: ElevatedButton(
                onPressed: () {
                  if (doneLoading) {
                    setState(() {
                      invertView = !invertView;
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    elevation: 0,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        side: BorderSide(color: Colors.black))),
                child: (invertView)
                    ? const Icon(Icons.list, color: Colors.black)
                    : const Icon(Icons.filter_alt_outlined,
                        color: Colors.black),
              ),
            ),
            (widget.enteredByLogin)
                ? ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        elevation: 0,
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0)),
                            side: BorderSide(color: Colors.black))),
                    onPressed: () {
                      Navigator.of(context).push(
                        PageRouteBuilder(
                          pageBuilder: (_, __, ___) => const LoginPage(
                            failedLogin: true,
                          ),
                          transitionDuration:
                              const Duration(seconds: 0), // No animation
                        ),
                      );
                    },
                    child: Text(
                      'Logout',
                      style: mainStyle,
                    ))
                : const SizedBox(),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
              child: DropdownButton<String>(
                focusNode: FocusNode(),
                value: chosenCrm,
                onChanged: (newValue) {
                  if (doneLoading) {
                    setState(() {
                      chosenCrm = newValue!;
                    });
                  }
                },
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                items: ['CRMs', 'Anhely', 'Jessika', 'Kayla']
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
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
              child: DropdownButton<String>(
                focusNode: FocusNode(),
                value: chosenDueDate,
                onChanged: (newValue) {
                  if (doneLoading) {
                    setState(() {
                      chosenDueDate = newValue!;
                    });
                  }
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
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
              child: DropdownButton<String>(
                focusNode: FocusNode(),
                value: chosenHotOrCold,
                onChanged: (newValue) {
                  if (doneLoading) {
                    setState(() {
                      chosenHotOrCold = newValue!;
                    });
                  }
                },
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                items: ['All', 'Hot', 'Cold']
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
                  if (doneLoading) {
                    setState(() {
                      searchProspects = searchController.text;
                    });
                  }
                },
                controller: searchController,
                decoration: const InputDecoration(
                    hintText: 'Search...',
                    constraints: BoxConstraints(maxHeight: 32)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
              child: ElevatedButton(
                onPressed: () async {
                  if (doneLoading) {
                    await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AddProspectDialog(
                          mainHeader: mainHeader,
                          addProspectDataHome: addProspectDataHome,
                          userId: widget.userId,
                        ); // Display the custom dialog
                      },
                    ).then((value) => setState(() {
                          doneLoading = false;
                          columnLabelMap = {};
                        }));
                    _fetchAllStages();
                  }
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    elevation: 0,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        side: BorderSide(color: Colors.black))),
                child: Text(
                  'Add Prospect',
                  style: mainStyle,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ));
  }

  SingleChildScrollView showColumnView() {
    return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Material(
            color: Colors.transparent,
            child: Row(
              children: [
                for (var columnIndex = 0;
                    columnIndex < stageDropdownItems.length;
                    columnIndex++)
                  if (columnLabelMap.containsKey(columnIndex) &&
                      (columnLabelMap[columnIndex]!.isNotEmpty))
                    DragTarget<Map<String, dynamic>>(
                        onAccept: (Map<String, dynamic> trialvalue) async {
                      if (!columnLabelMap[columnIndex]!.contains(trialvalue)) {
                        setState(() {
                          doneLoading = false;
                        });
                        await onSquareMoved(trialvalue, columnIndex);
                        setState(() {
                          doneLoading = true;
                        });
                      }
                    }, builder: (context, candidates, rejected) {
                      return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Material(
                              color: const Color.fromARGB(255, 211, 211, 211),
                              shape: const RoundedRectangleBorder(
                                  side:
                                      BorderSide(color: Colors.white, width: 5),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5.0))),
                              // shape: Border.all(color: Colors.white, width: 5),
                              surfaceTintColor: Colors.blueGrey,
                              child: SizedBox(
                                  width: 280,
                                  child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          16.0, 32, 16, 16),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                              height: 28,
                                              child: Text(
                                                '${stageDropdownItems[columnIndex]} | ${totalBasedOnSalesRep(columnLabelMap[columnIndex]!, chosenCrm)}',
                                                style: mainStyle,
                                                overflow: TextOverflow.ellipsis,
                                              )),
                                          SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height -
                                                180,
                                            child: SingleChildScrollView(
                                                child: (!doneLoading)
                                                    ? CircularProgressIndicator(
                                                        // Show loading icon when isLoading is true
                                                        valueColor:
                                                            AlwaysStoppedAnimation<
                                                                Color>(
                                                          Theme.of(context)
                                                              .colorScheme
                                                              .onSurface,
                                                        ), // Customize color
                                                      )
                                                    : ListView.builder(
                                                        shrinkWrap: true,
                                                        itemCount:
                                                            columnLabelMap[
                                                                    columnIndex]!
                                                                .length,
                                                        itemBuilder:
                                                            (context, index) {
                                                          return (showBasedOnDropdown(
                                                                  chosenCrm,
                                                                  searchProspects,
                                                                  chosenDueDate,
                                                                  chosenHotOrCold,
                                                                  columnLabelMap[
                                                                          columnIndex]![
                                                                      index]))
                                                              ? Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .fromLTRB(
                                                                          0,
                                                                          8,
                                                                          0,
                                                                          0),
                                                                  child: Draggable<
                                                                          Map<String,
                                                                              dynamic>>(
                                                                      data: columnLabelMap[columnIndex]![
                                                                          index],
                                                                      feedback: Material(
                                                                          elevation:
                                                                              5,
                                                                          borderRadius: const BorderRadius.all(Radius.circular(
                                                                              5.0)),
                                                                          color: Colors
                                                                              .white,
                                                                          child: SizedBox(
                                                                              width: 218,
                                                                              child: mainDraggable(columnLabelMap[columnIndex]![index], columnIndex, index))),
                                                                      child: mainDraggable(columnLabelMap[columnIndex]![index], columnIndex, index)),
                                                                )
                                                              : const SizedBox();
                                                        })),
                                          )
                                        ],
                                      )))));
                    })
                  else
                    returnEmptyDragColumn(columnIndex),
              ],
            )));
  }

  Widget mainDraggable(
      Map<String, dynamic> prospect, int columnIndex, int rowIndex) {
    return Material(
        borderRadius: const BorderRadius.all(Radius.circular(5.0)),
        elevation: 5,
        color: getStatusOfDueDate(
                'Overdue',
                ((prospect['tasks'] != null) &&
                        (prospect['tasks']['uncompletedElement'] != null))
                    ? DateFormat('yyyy-MM-dd')
                        .format(DateTime.parse(prospect['tasks']
                            ['uncompletedElement']!['dueDate']))
                        .toString()
                    : 'N/A'.toString())
            ? Colors.red
            : Colors.white,
        child: ElevatedButton(
            onPressed: () async {
              if (doneLoading) {
                var text =
                    '${settings[5]}/pages/prospect-details/${prospect['id']}';
                !await launchUrl(Uri.parse(text));
              }
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                elevation: 0,
                padding: const EdgeInsets.all(
                  4,
                ),
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    side: BorderSide(color: Colors.white))),
            child: SizedBox(
                height: 170,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
                          child: Text(
                            prospect['fullName'],
                            style: mainStyle,
                            textAlign: TextAlign.start,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Padding(
                            padding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ((prospect['hotLead'] != null) &&
                                        (prospect['hotLead']))
                                    ? hotIcon()
                                    : Container(),
                                ((prospect['coldLead'] != null) &&
                                        (prospect['coldLead']))
                                    ? coldIcon()
                                    : Container(),
                              ],
                            )),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          prospect['brand'],
                          style: main1Style,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    Row(children: [
                      Text(
                        'CRM: ',
                        style: mainStyle,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        '${prospect['salesRep']}',
                        style: main1Style,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ]),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(children: [
                          Text(
                            'Last Action: ',
                            style: mainStyle,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            ((prospect['tasks'] != null) &&
                                    (prospect['tasks']['completedElement'] !=
                                        null))
                                ? '${prospect['tasks']['completedElement']['title']}'
                                : 'None',
                            style: main1Style,
                            overflow: TextOverflow.ellipsis,
                          )
                        ]),
                        Text(
                          ((prospect['tasks'] != null) &&
                                  (prospect['tasks']['completedElement'] !=
                                      null))
                              ? DateFormat('MM/dd/yyyy')
                                  .format(DateTime.parse(prospect['tasks']
                                      ['completedElement']!['completedOn']))
                                  .toString()
                              : 'N/A'.toString(),
                          style: main1Style,
                          overflow: TextOverflow.ellipsis,
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Next Action: ',
                              style: mainStyle,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              ((prospect['tasks'] != null) &&
                                      (prospect['tasks']
                                              ['uncompletedElement'] !=
                                          null))
                                  ? '${prospect['tasks']['uncompletedElement']['title']}'
                                  : 'None',
                              style: main1Style,
                              overflow: TextOverflow.ellipsis,
                            )
                          ],
                        ),
                        Text(
                          ((prospect['tasks'] != null) &&
                                  (prospect['tasks']['uncompletedElement'] !=
                                      null))
                              ? DateFormat('MM/dd/yyyy')
                                  .format(DateTime.parse(prospect['tasks']
                                      ['uncompletedElement']!['dueDate']))
                                  .toString()
                              : 'N/A'.toString(),
                          style: main1Style,
                          overflow: TextOverflow.ellipsis,
                        )
                      ],
                    ),
                    Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 4),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton(
                                onPressed: () async {
                                  if (doneLoading) {
                                    await showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return ChangeLeadTypeDialog(
                                          prospect: prospect,
                                          mainHeader: mainHeader,
                                          columnIndex: columnIndex,
                                          rowIndex: rowIndex,
                                          changeHotLead: changeHotLead,
                                          changeColdLead: changeColdLead,
                                        );
                                      },
                                    );
                                  }
                                },
                                style: rightHomeButtonStyle,
                                child: const Row(
                                  children: [
                                    Icon(
                                      IconData(
                                        0xf672,
                                        fontFamily: CupertinoIcons.iconFont,
                                        fontPackage:
                                            CupertinoIcons.iconFontPackage,
                                      ),
                                      color: Colors.black,
                                    ),
                                    Icon(
                                      IconData(
                                        0xf7e7,
                                        fontFamily: CupertinoIcons.iconFont,
                                        fontPackage:
                                            CupertinoIcons.iconFontPackage,
                                      ),
                                      color: Colors.black,
                                    )
                                  ],
                                )),
                            ElevatedButton(
                              onPressed: () async {
                                if (doneLoading) {
                                  var tester = await showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AddNoteDialog(
                                        mainHeader: mainHeader,
                                        prospect: prospect,
                                        userId: widget.userId,
                                      );
                                    },
                                  );
                                  if ((tester != null) && tester.isNotEmpty) {
                                    Map<String, dynamic> returnedNote = tester;
                                    setState(() {
                                      prospect['tasks']["completedElement"] =
                                          returnedNote;
                                      prospect['tasks']["completedElement"]
                                              ['completedOn'] =
                                          returnedNote['updatedOn'];
                                      prospect['tasks']['newestCompleted'] =
                                          DateTime.parse(
                                                  returnedNote['updatedOn'])
                                              .millisecondsSinceEpoch;
                                    });
                                  }
                                }
                              },
                              style: rightHomeButtonStyle,
                              child: const Icon(
                                Icons.notes_rounded,
                                color: Colors.black,
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                if (doneLoading) {
                                  await showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return EditProspect(
                                        prospect: prospect,
                                        mainHeader: mainHeader,
                                        onSquareMoved: onSquareMoved,
                                        userId: widget.userId,
                                      );
                                    },
                                  ).then((value) => setState(() {}));
                                }
                              },
                              style: rightHomeButtonStyle,
                              child: const Icon(
                                Icons.settings,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ))
                  ],
                ))));
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(children: [
          SingleChildScrollView(
              child: Material(
                  color: Colors.transparent,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      returnTopRow(),
                      invertView
                          ? showColumnView()
                          : ListHomePage(
                              mainHeader: mainHeader,
                              onSquareMoved: onSquareMoved,
                              totalCheck: totalCheck,
                              chosenCrm: chosenCrm,
                              chosenDueDate: chosenDueDate,
                              chosenHotOrCold: chosenHotOrCold,
                              searchProspects: searchProspects,
                              columnLabelMap: columnLabelMap,
                              addNewNote: addNewNote,
                              userId: widget.userId,
                            ),
                      Padding(
                          padding: const EdgeInsets.fromLTRB(8, 0, 0, 4),
                          child: Text(versionNumber)),
                    ],
                  )))
        ]));
  }
}
