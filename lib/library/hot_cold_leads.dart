// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import '../../main.dart';

Future<Map<String, dynamic>> deleteHotLead(Map<String, dynamic> element,
    List tagIds, Map<String, String> mainHeader) async {
  Map foundE = {};
  for (Map e in tagIds) {
    if (e['name'].toString().toLowerCase().contains('hot lead')) {
      foundE = e;
    }
  }
  if (foundE.isNotEmpty) {
    // http.Response deleteHotResponse = await http.delete(
    //     Uri.parse(
    //         '${settings[0]}/tags/deleteassociatedtag/${foundE['id'].toString()}'),
    //     headers: mainHeader);
    // if (deleteHotResponse.statusCode == 200) {
    element = await _refetchTags(element, mainHeader);
    // }
  }
  return element;
}

Future<Map<String, dynamic>> saveHotLead(Map<String, dynamic> element,
    String clientId, Map<String, String> mainHeader) async {
  // http.Response saveHotResponse =
  //     await http.post(Uri.parse('${settings[0]}/tags/saveassociatedtags'),
  //         headers: mainHeader,
  //         body: jsonEncode({
  //           "clientId": clientId,
  //           "tagIds": [settings[3]]
  //         }));
  // if (saveHotResponse.statusCode == 200) {
  element = await _refetchTags(element, mainHeader);
  // }
  return element;
}

Future<Map<String, dynamic>> deleteColdLead(Map<String, dynamic> element,
    List tagIds, Map<String, String> mainHeader) async {
  Map foundE = {};
  for (Map e in tagIds) {
    if (e['name'].toString().toLowerCase().contains('cold lead')) {
      foundE = e;
    }
  }
  if (foundE.isNotEmpty) {
    // http.Response deleteColdResponse = await http.delete(
    //     Uri.parse(
    //         '${settings[0]}/tags/deleteassociatedtag/${foundE['id'].toString()}'),
    //     headers: mainHeader);
    // if (deleteColdResponse.statusCode == 200) {
    element = await _refetchTags(element, mainHeader);
    // }
  }
  return element;
}

Future<Map<String, dynamic>> saveColdLead(Map<String, dynamic> element,
    String clientId, Map<String, String> mainHeader) async {
  // http.Response saveColdResponse =
  //     await http.post(Uri.parse('${settings[0]}/tags/saveassociatedtags'),
  //         headers: mainHeader,
  //         body: jsonEncode({
  //           "clientId": clientId,
  //           "tagIds": [settings[2]]
  //         }));
  // if (saveColdResponse.statusCode == 200) {
  element = await _refetchTags(element, mainHeader);
  // }
  return element;
}

Future<Map<String, dynamic>> _refetchTags(
    Map<String, dynamic> element, Map<String, String> mainHeader) async {
  // http.Response responseTags = await http.get(
  //   Uri.parse(
  //       '${settings[0]}/tags/getallassociatedtags?id=${element['id']}&type=2'),
  //   headers: mainHeader,
  // );
  // if (responseTags.statusCode == 200) {
  // element['tags'] = jsonDecode(responseTags.body)['data'];
  element['tags'] = [];
  element['hotLead'] =
      element['tags'].toString().toLowerCase().contains('hot lead');
  element['coldLead'] =
      element['tags'].toString().toLowerCase().contains('cold lead');
  // }
  return element;
}
