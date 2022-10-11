import 'dart:ui';
import 'package:bicycle_hire_app/constants/customWidgets/our_text.dart';
import 'package:bicycle_hire_app/constants/loading/loading.dart';
import 'package:bicycle_hire_app/services/authHelpers/auth_service.dart';
import 'package:bicycle_hire_app/screens/authentication/validation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bicycle_hire_app/screens/authentication/toggle.dart';
import 'package:bicycle_hire_app/services/globals.dart' as globals;


class Register extends StatefulWidget {
  AuthService auth;
  final Function toggleView;
  Register({required this.toggleView, required this.auth});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    //OurTheme theme = OurTheme();

    return loading
        ? Loading()
        : MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Sign Up',
            home: Scaffold(
              extendBodyBehindAppBar: true,
              extendBody: true,
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                title:OurText(text: 'Register',
                  color: Colors.white,
                  underlined: false,
                  fontSize: 24,),
              ),
              resizeToAvoidBottomInset: true,
              body: Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [
                      Colors.purple,
                      Colors.blue,
                    ],
                  )),
                  child: SafeArea(
                    minimum: EdgeInsets.fromLTRB(0, 0, 0, 0),
                    top: true,
                    child: SingleChildScrollView(
                      child: Column(children: <Widget>[
                        SizedBox(
                          height: 50,
                        ),
                        Container(
                          height: 150,
                          width: 150,
                          child: Center(
                            child: Image.asset('assets/images/logo_nobg.png'),
                          ),
                        ),
                        SignUp(
                          auth: widget.auth,
                        ),
                      ]),
                    ),
                  ),
              ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.miniEndDocked,
              floatingActionButton: FloatingActionButton(
                key: Key("Switch to Sign in Button"),
                child: Icon(
                  Icons.assignment_ind_outlined,
                  size: 35,
                ),
                tooltip: 'Log In',
                splashColor: Color.fromARGB(255, 61, 131, 255),
                backgroundColor: Colors.blue,
                onPressed: () {
                  widget.toggleView();
                },
              ),
              bottomNavigationBar: BottomAppBar(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  shape: CircularNotchedRectangle(),
                  color: Colors.blue,
                  elevation: 0,
                  child: Row(children: [
                    Container(
                      padding: EdgeInsets.all(20),
                      child: OurText(
                        text: "Codebreakers, Inc",
                        underlined: false,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 175),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(7.0, 30.0, 0.0, 0.0),
                      child: OurText(
                        text: "Log In",
                        color: Colors.white,
                        underlined: false,
                        //textAlign: TextAlign.,
                      ),
                    ),
                  ])),
            ),
          );
  }
}

class SignUp extends StatefulWidget {
  AuthService auth;
  SignUp({required this.auth});
  @override
  _SignUp createState() => _SignUp();
}

class _SignUp extends State<SignUp> {
  TextEditingController nicknameController = TextEditingController();
  bool _isObscure = true;
  bool _isVisible = false;
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _pass = TextEditingController();
  String email = '';
  String password = '';
  String confirmPassword = '';
  String firstName = '';
  String lastName = '';
  String age = '';
  String error = '';
  bool loading = false;
  bool samePassword = true;
  Validator _validator = new Validator();

  // final TapGestureRecognizer _gestureRecognizer = TapGestureRecognizer()
  //   ..onTap = () {
  //     if (kDebugMode) {
  //       print("Hello world from _gestureRecognizer");
  //     }
  //   };s

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : SingleChildScrollView(
            reverse: true,
            padding: EdgeInsets.all(20),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 0,
                    width: 100,
                  ),

                  // Login text Widget
                  // Center(
                  //   child: Container(
                  //     height: 50,
                  //     width: 200,
                  //     alignment: Alignment.topCenter,
                  //     child: Text(
                  //       "Register:",
                  //       style: TextStyle(
                  //         color: Colors.black,
                  //         fontSize: 35,
                  //         fontWeight: FontWeight.bold,
                  //       ),
                  //       // textAlign: TextAlign.center,
                  //     ),
                  //   ),
                  // ),

                  // SizedBox(
                  //   height: 10,
                  //   width: 10,
                  // ),

                  // Wrong Password text
                  Visibility(
                    visible: _isVisible,
                    maintainSize: true,
                    maintainAnimation: true,
                    maintainState: true,
                    child: Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.all(10),
                      child: Text(
                        "Wrong credentials entered",
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ),

                  // Textfields for username and password fields
                  Container(
                    height: 500,
                    width: 530,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(30),
                        ),
                        color: Colors.transparent),
                    child: Form(
                      key: _formKey,
                      child: SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(30)),
                              child: TextFormField(
                                key: Key('emailfield'),
                                onTap: () {
                                  setState(() {
                                    _isVisible = false;
                                  });
                                },
                                onChanged: (val) {
                                  setState(() {
                                    email = val;
                                  });
                                },
                                validator: (val) =>
                                    !(_validator.validateEmail(val!))
                                        ? 'enter a valid email'
                                        : null,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Email",
                                    contentPadding: EdgeInsets.all(20)),
                                onEditingComplete: () =>
                                    FocusScope.of(context).nextFocus(),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(30)),
                              child: TextFormField(
                                controller: _pass,
                                key: Key('passwordfield'),
                                onTap: () {
                                  setState(() {
                                    _isVisible = false;
                                  });
                                },
                                onChanged: (val) {
                                  setState(() {
                                    password = val;
                                  });
                                },
                                validator: (val) => !(_validator
                                        .validatePassword(val!))
                                    ? 'enter a password with 6 or more characters, one symbol and a capital letter'
                                    : null,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Password",
                                    contentPadding: EdgeInsets.all(20),
                                    // Adding the visibility icon to toggle visibility of the password field
                                    suffixIcon: IconButton(
                                      icon: Icon(_isObscure
                                          ? Icons.visibility_off
                                          : Icons.visibility),
                                      onPressed: () {
                                        setState(() {
                                          _isObscure = !_isObscure;
                                        });
                                      },
                                    )),
                                obscureText: _isObscure,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(30)),
                              child: TextFormField(
                                key: Key('confirmfield'),
                                onTap: () {
                                  setState(() {
                                    _isVisible = false;
                                  });
                                },
                                onChanged: (val) {
                                  setState(() {
                                    confirmPassword = val;
                                  });
                                },
                                validator: (val) {
                                  if (val == _pass.text) {
                                    //print("Same");
                                    return null;
                                  } else {
                                    //print('no');
                                    return 'The passwords are not the same, please write the same password.';
                                  }
                                },
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Password Confirmation",
                                    contentPadding: EdgeInsets.all(20),
                                    // Adding the visibility icon to toggle visibility of the password field
                                    suffixIcon: IconButton(
                                      icon: Icon(_isObscure
                                          ? Icons.visibility_off
                                          : Icons.visibility),
                                      onPressed: () {
                                        setState(() {
                                          _isObscure = !_isObscure;
                                        });
                                      },
                                    )),
                                obscureText: _isObscure,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Divider(
                              thickness: 3,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(30)),
                              child: TextFormField(
                                key: Key('firstnamefield'),
                                onTap: () {
                                  setState(() {
                                    _isVisible = false;
                                  });
                                },
                                onChanged: (val) {
                                  setState(() {
                                    firstName = val;
                                  });
                                },
                                validator: (val) =>
                                    !(_validator.validateName(val!))
                                        ? 'enter a name'
                                        : null,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "First Name",
                                    contentPadding: EdgeInsets.all(20)),
                                onEditingComplete: () =>
                                    FocusScope.of(context).nextFocus(),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(30)),
                              child: TextFormField(
                                key: Key('lastnamefield'),
                                onTap: () {
                                  setState(() {
                                    _isVisible = false;
                                  });
                                },
                                onChanged: (val) {
                                  setState(() {
                                    lastName = val;
                                  });
                                },
                                validator: (val) =>
                                    !(_validator.validateName(val!))
                                        ? 'enter a name'
                                        : null,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Surname",
                                    contentPadding: EdgeInsets.all(20)),
                                onEditingComplete: () =>
                                    FocusScope.of(context).nextFocus(),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(30)),
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                key: Key('agefield'),
                                onTap: () {
                                  setState(() {
                                    _isVisible = false;
                                  });
                                },
                                onChanged: (val) {
                                  setState(() {
                                    age = val;
                                  });
                                },
                                validator: (val) => !(_validator
                                        .validateAge(val!))
                                    ? 'You need to be 18 or older to continue..'
                                    : null,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Age",
                                    contentPadding: EdgeInsets.all(20)),
                                onEditingComplete: () =>
                                    FocusScope.of(context).nextFocus(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Submit Button
                  Column(
                    children: <Widget>[
                      Container(
                          width: 200,
                          height: 70,
                          padding: EdgeInsets.only(top: 20),
                          child: ElevatedButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                WidgetsBinding.instance
                                    ?.addPostFrameCallback((_) {
                                  globals.loading.value = true;
                                });

                                await widget.auth
                                    .CreateAccount(email, password, firstName,
                                        lastName, age)
                                    .then((value) {
                                  if (value is String) {
                                    //print('its a string');
                                    WidgetsBinding.instance
                                        ?.addPostFrameCallback((_) {
                                      globals.loading.value = false;
                                    });
                                    setState(() {
                                      loading = false;
                                      value = value.replaceAll(
                                          RegExp('\\[.*?\\]'), '');
                                      error = value;
                                    });
                                  }
                                });
                              }
                            },
                            child: OurText(text: 'Register',
                              color: Colors.white,
                              underlined: false,
                              fontSize: 20,),
                            key: Key("SignUpButton"),
                            style: ElevatedButton.styleFrom(
                                primary: Colors.black45),
                          )),
                      SizedBox(height: 20),
                      Text(
                        '$error',
                        style: TextStyle(color: Colors.red),
                      ),
                      SizedBox(height: 25),
                      Text(
                        '$error',
                        style: TextStyle(color: Colors.red),
                      ),
                    ],
                  )
                ]));
  }
}
