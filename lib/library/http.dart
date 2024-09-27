// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'constants.dart';
// import '../../main.dart';
import 'functions.dart';

// Removed API Calls for Demo Purposes

Future<String> saveNewTags(
    String clientId, int index, Map<String, String> mainHeader) async {
  String returnId = generateRandomId();

  // await http.post(Uri.parse('${settings[0]}/tags/saveassociatedtags'),
  //     headers: mainHeader,
  //     body: jsonEncode({
  //       "id": returnId,
  //       "clientId": clientId,
  //       "tagIds": [tagIds[index]['id']]
  //     }));

  return returnId;
}

Future<void> deleteTags(
    String clientId, int oldIndex, Map<String, String> mainHeader) async {
  // http.Response getAssocTagsResponse = await http.get(
  //     Uri.parse('${settings[0]}/tags/getallassociatedtags?id=$clientId&type=2'),
  //     headers: mainHeader);
  // if (getAssocTagsResponse.statusCode == 200) {
  // List getAssocTagsResponseData =
  //     jsonDecode(getAssocTagsResponse.body)['data'];
  // List getAssocTagsResponseData = [];
  // Map e = getAssocTagsResponseData.firstWhere((element) => element['name']
  //     .toString()
  //     .toLowerCase()
  //     .contains(stageDropdownItems[oldIndex].toLowerCase()));
  // await http.delete(
  //     Uri.parse(
  //         '${settings[0]}/tags/deleteassociatedtag/${e['id'].toString()}'),
  //     headers: mainHeader);
  // }
}
