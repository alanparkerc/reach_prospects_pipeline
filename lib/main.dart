// ignore: avoid_web_libraries_in_flutter
import 'dart:html';
import 'package:flutter/material.dart';
import 'package:reach_prospects/home_page.dart';
import 'package:reach_prospects/login_page.dart';

String versionNumber = 'version 1.0.4+1';

const settings = prodSettings;

const devSettings = [
  //url root
  'https://reachmeapidevh.azurewebsites.net',
  [
    '8e4b3bab-ad42-4723-8cd3-cc6f8650d9cb',
    'e5eb441c-ae97-4bf9-893c-c32e44b06c08',
    '950c8a8b-a44c-4217-9ca4-3a7fa04556d1',
    '07c2dd37-3557-4501-bfb0-0c1aac48dfc2',
    '0982d3cb-9575-4459-a162-fcaf4dbbcc06',
    'b7244f9f-402b-4c04-b0da-c75c01665650',
    'e5b9c6ad-2b1e-4952-813d-52d6ff503fb3',
    'b0746f29-8b4a-498e-b1ef-90a6bbacdffe'
  ],
  //cold lead tag
  'cb636e52-d39e-45a0-becb-ebfdc742dd64',
  //hot lead tag
  '3a9b12f5-9000-44a9-b3ac-58d81dd84ebc',
  [
    '859ccb32-967d-4dad-860a-25cd4af62097',
    '52d0b52c-4708-4539-b88e-6b548e91dacb',
    'ebb9d936-66db-4332-b29f-f4e7b2b9fa2e',
    '89f3d52e-3d41-401b-bb3e-9609c3adb614',
    '499633a2-f183-447a-bbb3-99de89323c00',
    '6adc8547-a195-4ec7-8a03-2baf6221f699',
    '2f55c7cf-b8af-4924-a50c-9718890eef0e',
    '6247bcb0-32d5-4126-bf19-a3a9d8a3e24c'
  ],
  'https://dev.reach.marketing'
];

const prodSettings = [
  //url root
  'https://api.reach.marketing',
  [
    '6b69a274-2f07-4e86-9dc7-b4385aa8f9db',
    '70fcfd3e-f7cc-48be-809c-088da5e39648',
    '5583b530-83b9-42b0-b06d-d15ba2f80e99',
    'dec3a4b2-a93d-44dc-809e-f7e4fa6c6dfd',
    '8c861c7e-c602-4143-818d-a879d49da0cf',
    '6b39dfa3-879f-4893-84ad-e04e2efb1e31',
    '311681e0-5d1e-4fba-92ca-6e26eda828c6',
    '08866273-9ba0-4490-b77a-6f50c3312753'
  ],
  //cold lead tag
  '244773ce-f157-4cc0-ad22-c7b695b82c0b',
  //hot lead tag
  '494a5a97-e37f-4bff-95f8-f074aab36a0f',
  [
    '516b323d-03cf-43de-aba4-391255b9963e',
    '07a9cc22-f008-482c-8aa8-b40486862a6e',
    '2d994fed-600b-4927-94d3-8f050295d6a1',
    '4de48be9-3b41-4b3d-9f4b-7fe6eb92e5c2',
    '01efe23a-26f4-45d1-90a9-80291a4e1568',
    '77f885fb-4662-4e7d-b4f8-d1cff5554e6f',
    '0f2e5f1a-cff7-4875-9622-32a08d293ae0',
    '313a4635-23e5-4df4-a178-39c34e9703f8'
  ],
  'https://app.reach.marketing'
];

void main() async {
  var uri = Uri.dataFromString(window.location.href);
  var authToken = uri.queryParameters['authToken'];
  var userId = uri.queryParameters['userId'];
  var role = uri.queryParameters['role'];
  if ((authToken != null) && (userId != null) && (role != null)) {
    // Use the token for authentication
    runApp(MyApp(
      authToken: authToken,
      userId: userId,
      role: int.parse(role),
    ));
  } else {
    runApp(const LoginApp());
  }
}

class MyApp extends StatelessWidget {
  final String authToken;
  final String userId;
  final int role;

  const MyApp({
    super.key,
    required this.authToken,
    required this.userId,
    required this.role,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'REACH Prospect Pipeline',
        debugShowCheckedModeBanner: false,
        home: HomePage(
          authToken: authToken,
          userId: userId,
          role: role,
          enteredByLogin: false,
        ));
  }
}

class LoginApp extends StatelessWidget {
  const LoginApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        title: 'REACH Prospect Pipeline',
        debugShowCheckedModeBanner: false,
        home: LoginPage(
          failedLogin: false,
        ));
  }
}
