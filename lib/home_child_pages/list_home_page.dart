import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:reach_prospects/dialogs/prospects/edit_prospect.dart';
import 'package:reach_prospects/main.dart';
import 'package:url_launcher/url_launcher.dart';
import '../library/constants.dart';
import '../cosmetic/styles.dart';
import '../library/functions.dart';

class ListHomePage extends StatefulWidget {
  final Map<String, String> mainHeader;
  final Function(Map<String, dynamic>, int) onSquareMoved;
  final int totalCheck;
  final String chosenCrm; // Initial selected value
  final String chosenDueDate; // Initial selected value
  final String chosenHotOrCold; // Initial selected value
  final String searchProspects;
  final Map<int, List<Map<String, dynamic>>> columnLabelMap;
  final Function(Map<String, dynamic>, Map<String, dynamic>, int) addNewNote;
  final String userId;

  const ListHomePage(
      {Key? key,
      required this.mainHeader,
      required this.onSquareMoved,
      required this.totalCheck,
      required this.chosenCrm,
      required this.chosenDueDate,
      required this.chosenHotOrCold,
      required this.searchProspects,
      required this.columnLabelMap,
      required this.addNewNote, required this.userId,})
      : super(key: key);

  @override
  ListHomePageState createState() => ListHomePageState();
}

class ListHomePageState extends State<ListHomePage> {
  int returnColumnIndex(int index) {
    int countTheIndex = 0;
    bool exit = false;
    widget.columnLabelMap.forEach((key, value) {
      if (!exit && value.isNotEmpty) {
        if (value.length <= index) {
          countTheIndex = key;
          index = index - value.length;
        } else {
          countTheIndex = key;
          exit = true;
        }
      }
    });
    return countTheIndex;
  }

  int returnColumnAndRowIndex(int index) {
    bool exit = false;
    widget.columnLabelMap.forEach((key, value) {
      if (!exit && value.isNotEmpty) {
        if (value.length <= index) {
          index = index - value.length;
        } else {
          exit = true;
        }
      }
    });
    return index;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  double listWidth() {
    return (MediaQuery.of(context).size.width - 100) / 7;
  }

  Widget listColumnLabel(String label1) {
    return SizedBox(
      width: listWidth(),
      child: Text(
        label1,
        style: mainStyle,
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget showListView() {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Material(
            color: const Color.fromARGB(255, 211, 211, 211),
            shape: const RoundedRectangleBorder(
                side: BorderSide(color: Colors.white, width: 5),
                borderRadius: BorderRadius.all(Radius.circular(5.0))),
            child: SizedBox(
                width: MediaQuery.of(context).size.width - 32,
                child: Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 32, 16, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: [
                          listColumnLabel('Full Name'),
                          listColumnLabel('Company'),
                          listColumnLabel('Sales Rep'),
                          listColumnLabel(
                            'Last Action\nDate',
                          ),
                          listColumnLabel('Next Action\nDate'),
                          listColumnLabel('Stage'),
                          listColumnLabel(
                            'Action',
                          ),
                        ]),
                        SizedBox(
                            height: MediaQuery.of(context).size.height - 190,
                            child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: widget.totalCheck,
                                itemBuilder: (context, index) {
                                  return showBasedOnDropdown(
                                          widget.chosenCrm,
                                          widget.searchProspects,
                                          widget.chosenDueDate,
                                          widget.chosenHotOrCold,
                                          widget.columnLabelMap[
                                                  returnColumnIndex(index)]![
                                              returnColumnAndRowIndex(index)])
                                      ? Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 0, 0, 8),
                                          child: Material(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(5.0)),
                                              elevation: 5,
                                              shadowColor: Colors.black,
                                              color: Colors.white,
                                              child: Column(children: [
                                                SizedBox(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height /
                                                            12,
                                                    child: Material(
                                                      shape: Border.all(
                                                          color: Colors.black),
                                                      color: getStatusOfDueDate(
                                                              'Overdue',
                                                              (widget.columnLabelMap[returnColumnIndex(index)]?[returnColumnAndRowIndex(index)]['tasks'][
                                                                          'uncompletedElement'] !=
                                                                      null)
                                                                  ? DateFormat('yyyy-MM-dd')
                                                                      .format(DateTime.parse(widget.columnLabelMap[returnColumnIndex(index)]![returnColumnAndRowIndex(index)]['tasks']['uncompletedElement']![
                                                                          'dueDate']))
                                                                      .toString()
                                                                  : 'N/A'
                                                                      .toString())
                                                          ? const Color.fromARGB(
                                                              131, 244, 67, 54)
                                                          : Colors.white,
                                                      child: Row(
                                                        children: [
                                                          SizedBox(
                                                            width: listWidth(),
                                                            child:
                                                                ElevatedButton(
                                                              onPressed: () async {
                                                                var text =
                                                                '${settings[5]}/pages/prospect-details/${widget
                                                                              .columnLabelMap[
                                                                          returnColumnIndex(
                                                                              index)]![returnColumnAndRowIndex(
                                                                          index)]['id']}';
                                                                !await launchUrl(Uri.parse(text));
                                                              },
                                                              style:
                                                                  titleButtonStyle,
                                                              child: Text(
                                                                widget.columnLabelMap[
                                                                        returnColumnIndex(
                                                                            index)]![returnColumnAndRowIndex(
                                                                        index)]['fullName'] ??
                                                                    '',
                                                                style:
                                                                    mainStyle,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: listWidth(),
                                                            child: Text(
                                                              widget.columnLabelMap[
                                                                      returnColumnIndex(
                                                                          index)]![returnColumnAndRowIndex(
                                                                      index)]['brand'] ??
                                                                  '',
                                                              style: mainStyle,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: listWidth(),
                                                            child: Text(
                                                              '${widget.columnLabelMap[returnColumnIndex(index)]![returnColumnAndRowIndex(index)]['salesRep']}',
                                                              style: mainStyle,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: listWidth(),
                                                            child: Text(
                                                              (widget.columnLabelMap[returnColumnIndex(index)]?[returnColumnAndRowIndex(index)]
                                                                              ['tasks']
                                                                          [
                                                                          'completedElement'] !=
                                                                      null)
                                                                  ? DateFormat(
                                                                          'MM/dd/yyyy')
                                                                      .format(DateTime.parse(
                                                                          widget.columnLabelMap[returnColumnIndex(index)]![returnColumnAndRowIndex(index)]['tasks']['completedElement']
                                                                              ['completedOn']))
                                                                  : 'None',
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: listWidth(),
                                                            child: Text(
                                                              (widget.columnLabelMap[returnColumnIndex(index)]![returnColumnAndRowIndex(index)]
                                                                              ['tasks']
                                                                          [
                                                                          'uncompletedElement'] !=
                                                                      null)
                                                                  ? DateFormat(
                                                                          'MM/dd/yyyy')
                                                                      .format(DateTime.parse(
                                                                          widget.columnLabelMap[returnColumnIndex(index)]![returnColumnAndRowIndex(index)]['tasks']['uncompletedElement']![
                                                                              'dueDate']))
                                                                      .toString()
                                                                  : 'N/A'
                                                                      .toString(),
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: listWidth(),
                                                            child: Text(
                                                              stageDropdownItems[
                                                                  returnColumnIndex(
                                                                      index)],
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: listWidth(),
                                                            child:
                                                                ElevatedButton(
                                                              onPressed:
                                                                  () async {
                                                                await showDialog(
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (BuildContext
                                                                          context) {
                                                                    return EditProspect(
                                                                      prospect: widget
                                                                              .columnLabelMap[
                                                                          returnColumnIndex(
                                                                              index)]![returnColumnAndRowIndex(
                                                                          index)],
                                                                      
                                                                      mainHeader:
                                                                          widget
                                                                              .mainHeader,
                                                                      onSquareMoved:
                                                                          widget
                                                                              .onSquareMoved, userId: widget.userId,
                                                                     
                                                                    );
                                                                  },
                                                                ).then((value) =>
                                                                    setState(
                                                                        () {}));
                                                              },
                                                              style:
                                                                  titleButtonStyle,
                                                              child: const Icon(
                                                                Icons.settings,
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ))
                                              ])))
                                      : const SizedBox();
                                })),
                      ],
                    )))));
  }

  @override
  Widget build(BuildContext context) {
    return showListView();
  }
}
