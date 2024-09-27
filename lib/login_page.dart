import 'package:flutter/material.dart';
import 'dart:convert';
// import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'cosmetic/styles.dart';
import 'home_page.dart';
// import 'main.dart';

class LoginPage extends StatefulWidget {
  final bool failedLogin;
  const LoginPage({super.key, required this.failedLogin});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoginFailed = false;
  bool choseToRemember = false;
  String? action;

  Map<String, dynamic> passData = {};

  Future<void> getCookie() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      action = prefs.getString('actions4');
    });
    if (action != null) {
      setState(() {
        if (!widget.failedLogin) {
          passData = json.decode(action!)[0];
        }
        setState(() {
          choseToRemember = json.decode(action!)[2]['choseToRemember'];
        });
        if (json.decode(action!)[2]['choseToRemember']) {
          _emailController.text = json.decode(action!)[1]['email'];
          _passwordController.text = json.decode(action!)[1]['password'];
        }
      });
    }
    if (passData.isNotEmpty) {
      pageRoute(passData);
    }
  }

  Future<void> setCookie(
    List<Map<String, dynamic>> value,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('actions4', json.encode(value));
  }

  Future<void> login() async {
    // final http.Response response = await http.post(
    //   Uri.parse('${settings[0]}/auth/login'),
    //   headers: {
    //     'accept': '*/*',
    //     'Content-Type': 'application/json',
    //     'Access-Control-Allow-Headers':
    //         'Origin, Content-Type, Accept, Authorization',
    //     'Access-Control-Allow-Origin': '*',
    //     'Access-Control-Allow-Methods': 'GET, POST, OPTIONS',
    //   },
    //   body: jsonEncode({
    //     'email': _emailController.text,
    //     'password': _passwordController.text,
    //   }),
    // );

    // if (response.statusCode == 200) {
    // Map<String, dynamic> responseData = json.decode(response.body);
    Map<String, dynamic> responseData = {};

    setState(() {
      passData = responseData['data'];
    });
    setCookie([
      responseData['data'],
      {'email': _emailController.text, 'password': _passwordController.text},
      {'choseToRemember': choseToRemember}
    ]);
    pageRoute(passData);
    // } else {
    //   // Login failed, handle the error.
    //   setState(() {
    //     _isLoginFailed = true;
    //   });
    // }
  }

  void pageRoute(Map<String, dynamic> passData) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => HomePage(
          authToken: passData['authToken'],
          userId: passData['id'],
          role: passData['type'],
          enteredByLogin: true,
        ),
        transitionDuration: const Duration(seconds: 0), // No animation
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    getCookie();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color.fromARGB(255, 211, 211, 211),
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 60),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      './lib/assets/reach.png', // Replace with your image path
                      height: 125,
                      width: 300,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    Text(
                      'Sign into the REACH DMS Dashboard', // Replace with your subheadliner text
                      style: Theme.of(context).textTheme.bodyMedium!,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                            labelText: 'Email',
                            constraints: BoxConstraints(
                              maxWidth: 350,
                            )),
                        style: Theme.of(context).textTheme.bodySmall!,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'Password',
                          constraints: BoxConstraints(
                            maxWidth: 350,
                          ),
                        ),
                        style: Theme.of(context).textTheme.bodySmall!,
                      ),
                      const SizedBox(height: 64),
                      ElevatedButton(
                        onPressed: () async {
                          setState(() {
                            _isLoginFailed =
                                false; // Reset the login failed state
                          });
                          await login();
                        },
                        style: custButStyle(context),
                        child: Text(
                          'Login',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 32),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Checkbox(
                              value: choseToRemember,
                              onChanged: (bool? value) {
                                setState(() {
                                  choseToRemember = !choseToRemember;
                                });
                              }),
                          Text(
                            'Remember Me', // Replace with your subheadliner text
                            style: Theme.of(context).textTheme.bodyMedium!,
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      if (_isLoginFailed)
                        Padding(
                          padding:
                              const EdgeInsets.fromLTRB(16.0, 32.0, 16.0, 0.0),
                          child: Text(
                            'Login failed. Improper Request.',
                            style: Theme.of(context).textTheme.labelSmall!,
                            textAlign: TextAlign.center,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
