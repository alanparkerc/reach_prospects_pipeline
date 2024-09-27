import 'dart:math';
import 'package:intl/intl.dart';
import 'constants.dart';

Map<String, dynamic> returnTagsAndAll(
    Map<String, dynamic> prospectSquare, int columnIndex) {
  int stageIndex = -1;
  List<Map> saveTags = [];
  for (Map e in prospectSquare['tags']) {
    int i = 0;
    for (String element in stageDropdownItems) {
      if (e['name'].toLowerCase().contains(element.toLowerCase())) {
        stageIndex = i;
      }
      i++;
    }
    if ((stageIndex != -1) && stageIndex == prospectSquare['columnIndex']) {
      saveTags.add(e);
      stageIndex = -1;
    }
  }
  for (Map e in saveTags) {
    prospectSquare['tags'].remove(e);
  }
  prospectSquare['tags'].add(tagIds[columnIndex]);
  return prospectSquare;
}

bool showBasedOnDropdown(String chosenCrm, String searchProspects,
    String selectedValue2, String selectedValue3, Map<String, dynamic> e) {
  if (checkCRM(chosenCrm, e['salesRep'].toString()) &&
      checkSearch(e['fullName'].toString(), searchProspects) &&
      getStatusOfDueDate(selectedValue2, calcDueDate(e)) &&
      checkHotColdLeads(selectedValue3, e)) {
    return true;
  }
  return false;
}

bool checkHotColdLeads(String selectedValue3, Map<String, dynamic> e) {
  return ((selectedValue3 == 'All') ||
      ((selectedValue3 == 'Hot') && (e['hotLead'] == true)) ||
      ((selectedValue3 == 'Cold') && (e['coldLead'] == true)));
}

bool checkCRM(String selectedValue, String salesRep) {
  return ((selectedValue == 'CRMs') || salesRep.contains(selectedValue));
}

bool checkSearch(String fullName, String searchProspects) {
  return ((fullName.toLowerCase().contains(searchProspects.toLowerCase())));
}

String calcDueDate(Map<String, dynamic> e) {
  return (((e['tasks'] != null)) && (e['tasks']['uncompletedElement'] != null))
      ? DateFormat('yyyy-MM-dd')
          .format(DateTime.parse(e['tasks']['uncompletedElement']!['dueDate']))
          .toString()
      : 'N/A'.toString();
}

int totalBasedOnSalesRep(
    List<Map<String, dynamic>> column, String selectedValue) {
  int columnTotal = 0;
  if (selectedValue != 'CRMs') {
    for (Map<String, dynamic> eIndex in column) {
      if (eIndex['salesRep']
          .toString()
          .toLowerCase()
          .contains(selectedValue.toLowerCase())) {
        columnTotal++;
      }
    }
    return columnTotal;
  }
  return column.length;
}

Map<String, dynamic> getTasks(List tasksList, List notesList) {
  Map<String, dynamic> returnList = {};

  int newestCompleted = 0;
  int oldestDue = 0;
  int newestNote = 0;

  for (var element in tasksList) {
    if ((element['isCompleted'] == true) &&
        (element['completedOn'] != null) &&
        (DateTime.parse(element['completedOn']).millisecondsSinceEpoch >
            newestCompleted)) {
      newestCompleted =
          DateTime.parse(element['completedOn']).millisecondsSinceEpoch;
      returnList['completedElement'] = element;
    }

    if ((element['dueDate'] != null) && (element['isCompleted'] != true)) {
      if (oldestDue == 0) {
        oldestDue = DateTime.parse(element['dueDate']).millisecondsSinceEpoch;
        returnList['uncompletedElement'] = element;
      }
      if (DateTime.parse(element['dueDate']).millisecondsSinceEpoch <
          oldestDue) {
        oldestDue = DateTime.parse(element['dueDate']).millisecondsSinceEpoch;
        returnList['uncompletedElement'] = element;
      }
    }
  }

  if (notesList.isNotEmpty) {
    notesList.sort((b, a) => a['updatedOn'].compareTo(b['updatedOn']));
    newestNote =
        DateTime.parse(notesList[0]['updatedOn']).millisecondsSinceEpoch;
    newestCompleted = newestNote;
    returnList['completedElement'] = notesList[0];
    returnList['completedElement']['completedOn'] = notesList[0]['updatedOn'];
  }
  returnList['newestCompleted'] = newestCompleted;
  returnList['oldestDue'] = oldestDue;
  return returnList;
}

List<String> returnCompanyNames() {
  List<String> names = [''];
  for (Map e in companiesIds) {
    names.add(e['name'].toString());
  }
  return names;
}

List<String> returnUserNames() {
  List<String> names = [''];
  for (Map e in userIds) {
    if (names.contains('${e['firstName']} ${e['lastName']}') != true) {
      names.add('${e['firstName']} ${e['lastName']}');
    }
  }
  return names;
}

String returnGivenIdUserName(String id) {
  for (Map e in userIds) {
    if (e['id'].toString().contains(id)) {
      return '${e['firstName']} ${e['lastName']}';
    }
  }
  return '';
}

String returnGivenUserNameId(String name) {
  Map e = userIds.firstWhere((element) =>
      (name.contains('${element['firstName']} ${element['lastName']}') ==
          true));
  return e['id'];
}

String generateRandomId() {
  final id = List<String>.generate(36, (index) {
    if (index == 8 || index == 13 || index == 18 || index == 23) {
      return '-';
    }
    final randomInt =
        Random().nextInt(16); // Generate a random hexadecimal digit (0-15)
    return randomInt.toRadixString(16); // Convert it to a hexadecimal string
  });
  return id.join(); // Join the list to create the final ID
}

bool getStatusOfDueDate(String input, String date) {
  if (input == 'All Action Dates') {
    return true;
  }
  if (date == 'N/A' && input == 'Overdue') {
    return false;
  }
  if (date == 'N/A' && input != 'Overdue') {
    return true;
  }

  final today = DateTime.now();
  final parsedDate = DateTime.parse(date);

  if (input == 'Overdue') {
    if (today.day == parsedDate.day) {
      return false;
    } else {
      return today.isAfter(parsedDate);
    }
  } else if (input == 'Today') {
    return today.day == parsedDate.day;
  } else if (input == 'Upcoming') {
    return today.isBefore(parsedDate);
  }
  return true;
}
