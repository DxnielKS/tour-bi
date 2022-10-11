import 'dart:ui';
import 'package:bicycle_hire_app/constants/customWidgets/our_text.dart';
import 'package:bicycle_hire_app/constants/loading/loading.dart';
import 'package:bicycle_hire_app/screens/authentication/validation.dart';
import 'package:bicycle_hire_app/services/requests/mapbox_walking.dart';
import 'package:flutter/cupertino.dart';
import 'package:bicycle_hire_app/services/globals.dart' as globals;
import 'package:flutter/material.dart';
import 'package:bicycle_hire_app/services/authHelpers/auth_service.dart';
import 'package:bicycle_hire_app/screens/authentication/register.dart';
import 'package:styled_widget/styled_widget.dart';

String email = '';
String password = '';
String guestName = '';

class SignIn extends StatefulWidget {
  final Function toggleView;
  AuthService auth;
  SignIn({required this.toggleView, required this.auth});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
  // String email = '';
  // String password = '';
  String error = '';
  // String guestName = '';

  String getEmail() {
    return email;
  }

  String getPassword() {
    return password;
  }

  @override
  Widget build(BuildContext context) {
    //OurTheme theme = OurTheme();

    return ValueListenableBuilder(
        valueListenable: globals.loading,
        builder: (BuildContext context, bool value, Widget? child) {
          return value
              ? Loading()
              : MaterialApp(
                  debugShowCheckedModeBanner: false,
                  title: 'Log in',
                  // theme: OurTheme.lightTheme,
                  // color: Colors.purple,
                  home: Scaffold(
                    extendBodyBehindAppBar: true,
                    extendBody: true,
                    appBar: AppBar(
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      title: OurText(text: 'Login',
                      color: Colors.white,
                      underlined: false,
                      fontSize: 24,),
                    ),
                    resizeToAvoidBottomInset: true,
                    // backgroundColor: purple,
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
                            child: SingleChildScrollView(
                          child: Column(children: <Widget>[
                            // SizedBox(
                            //   height: 100,
                            // ),
                            // Text("LOG IN",
                            //     style: TextStyle(
                            //       color: Colors.black,
                            //       fontSize: 20,
                            //       // fontWeight: FontWeight.bold,
                            //     )
                            //     // textAlign: TextAlign.center,
                            //     ),
                            SizedBox(
                              height: 50,
                            ),
                            Container(
                              height: 150,
                              width: 150,
                              child: Center(
                                child:
                                    Image.asset('assets/images/logo_nobg.png'),
                              ),
                            ),
                            LoginForm(
                              auth: widget.auth,
                            ),
                          ]),
                        ))),
                    floatingActionButtonLocation:
                        FloatingActionButtonLocation.miniEndDocked,
                    floatingActionButton: FloatingActionButton(
                      key: Key("Switch to Register Button"),
                      child: Icon(
                        Icons.assignment_ind_outlined,
                        size: 35,
                      ),
                      tooltip: 'Register',
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
                          SizedBox(width: 173), // 175 for android, 150 for iO
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 0.0),
                            child:  OurText(
                              text: "Register",
                              color: Colors.white,
                              underlined: false,
                              //textAlign: TextAlign.,
                            ),
                          ),
                        ])),
                  ),
                );
        });
  }
}

class LoginForm extends StatefulWidget {
  AuthService auth;
  LoginForm({required this.auth});
  //final Function toggleView;
  //LoginForm({required this.toggleView});

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  TextEditingController nicknameController = TextEditingController();
  Validator _validator = Validator();
  bool _isObscure = true;
  bool _isVisible = false;
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  String error = '';
  String guestError = '';
  String guestName = '';
  Key passwordKey = Key('');

  // final TapGestureRecognizer _gestureRecognizer = TapGestureRecognizer()
  //   ..onTap = () {
  //     if (kDebugMode) {
  //       print("Hello world from _gestureRecognizer");
  //     }
  //   };s

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      reverse: true,
      padding: EdgeInsets.all(20),
      // child: OurContainer(
      child:
          // Container(
          Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
            SizedBox(
              height: 10,
              width: 200,
            ),

            // Login text Widget
            // Center(
            //   child: Container(
            //     height: 40,
            //     width: 400,
            //     alignment: Alignment.center,
            //     child: Text("Log in",
            //         style: TextStyle(
            //           color: Colors.black,
            //           fontSize: 34,
            //           fontWeight: FontWeight.bold,
            //         )
            //         // textAlign: TextAlign.center,
            //         ),
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
              height: 140,
              width: 530,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(20),
                ),
                // color: Colors.white,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30)),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 25.0, right: 25),
                        child: TextFormField(
                          key: Key("Login Email Key"),
                          onChanged: (val) {
                            setState(() {
                              // widget.iconKey = Key(val);
                              email = val;
                              // print(widget.iconKey);
                            });
                          },
                          obscureText: false,
                          keyboardType: TextInputType.visiblePassword,
                          decoration: InputDecoration(
                            hintText: 'Email',
                            icon: Icon(Icons.email),
                          ),
                        ),
                      ),
                    ),
                    // OurTextForm(
                    //   // email text form
                    //   hintText: 'Email',
                    //   keyboardType: TextInputType.visiblePassword,
                    //   data: email,
                    //   isObscured: false,
                    //   icon: Icon(Icons.email),
                    //   iconKey: passwordKey,
                    // ),
                    Container(
                      margin: EdgeInsets.only(bottom: 3),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30)),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 25.0, right: 25),
                        child: TextFormField(
                          key: Key("Login Password Key"),
                          onChanged: (val) {
                            setState(() {
                              // widget.iconKey = Key(val);
                              password = val;
                              // print(widget.iconKey);
                            });
                          },
                          obscureText: true,
                          keyboardType: TextInputType.visiblePassword,
                          decoration: InputDecoration(
                            hintText: 'Password',
                            icon: Icon(Icons.lock),
                          ),
                        ),
                      ),
                    ),

                    // OurTextForm(
                    //   // password text form
                    //   hintText: 'Password',
                    //   keyboardType: TextInputType.visiblePassword,
                    //   data: password,
                    //   isObscured: true,
                    //   icon: Icon(Icons.lock),
                    //   iconKey: passwordKey,
                    // ),
                    // TextFormField(
                    //   onTap: () {
                    //     setState(() {
                    //       _isVisible = false;
                    //     });
                    //   },
                    //   onChanged: (val) {
                    //     setState(() {
                    //       password = val;
                    //     });
                    //   },
                    //   decoration: InputDecoration(
                    //       border: OutlineInputBorder(
                    //         borderSide:
                    //             BorderSide(color: Colors.black, width: 5.0),
                    //       ),
                    //       hintText: "Password",
                    //       contentPadding: EdgeInsets.all(20),
                    //       // Adding the visibility icon to toggle visibility of the password field
                    //       suffixIcon: IconButton(
                    //         icon: Icon(_isObscure
                    //             ? Icons.visibility_off
                    //             : Icons.visibility),
                    //         onPressed: () {
                    //           setState(() {
                    //             _isObscure = !_isObscure;
                    //           });
                    //         },
                    //       )),
                    //   obscureText: _isObscure,
                    // ),
                  ],
                ),
              ),
            ),

            // Submit Button
            Column(
              children: <Widget>[
                // OurButton(
                //   icon: Icon(Icons.arrow_forward_ios_rounded),
                //   formKey: _formKey,
                //   isAnon: false,
                // ),
                Container(
                  height: 50,
                  width: 115,
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: Colors.white.withOpacity(0.4), width: 4),
                    shape: BoxShape.circle,
                  ),
                  child: ElevatedButton(
                    key: Key('Login Button'),
                    style: ElevatedButton.styleFrom(
                      fixedSize: const Size(200, 200),
                      shape: const CircleBorder(),
                    ),
                    onPressed: () async {
                      if (_validator.validateEmail(email) == true &&
                          _validator.validatePassword(password) == true) {
                        WidgetsBinding.instance?.addPostFrameCallback((_) {
                          globals.loading.value = true;
                        });
                        dynamic logInAttempt =
                            await widget.auth.LogInWithEmail(email, password);
                        if (logInAttempt == null) {
                          WidgetsBinding.instance?.addPostFrameCallback((_) {
                            globals.loading.value = false;
                          });
                          setState(() {
                            error = 'Not a valid email/password';
                          });
                        }
                      } else {
                        setState(() {
                          error = 'Not a valid email/password';
                        });
                      }
                    },
                    child: Icon(Icons.arrow_forward_ios_rounded),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  '$error',
                  style: TextStyle(color: Colors.red),
                ),
                Divider(
                  thickness: 3,
                ),
                Center(
                  child: Container(
                    height: 50,
                    width: 400,
                    alignment: Alignment.center,
                    child: OurText(
                      text: "Guest Login",
                      fontSize: 18,
                      color: Colors.white, underlined: false,
                      // textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Container(
                  height: 70,
                  width: 530,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                      color: Colors.white),
                  child: Container(
                    margin: EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30)),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 25.0, right: 25),
                      child: TextFormField(
                        key: Key("Guest Login key"),
                        onChanged: (val) {
                          setState(() {
                            // widget.iconKey = Key(val);
                            guestName = val;
                            // print(widget.iconKey);
                          });
                        },
                        obscureText: false,
                        keyboardType: TextInputType.visiblePassword,
                        decoration: InputDecoration(
                          hintText: 'Nickname',
                          icon: Icon(Icons.person),
                        ),
                      ),
                    ),
                  ),
                  // OurTextForm(
                  //   // password text form
                  //   hintText: 'Nickname',
                  //   keyboardType: TextInputType.visiblePassword,
                  //   data: guestName,
                  //   isObscured: false,
                  //   icon: Icon(Icons.person_add_alt_1_rounded),
                  //   iconKey: passwordKey,
                  // ),
                  // TextFormField(
                  //     controller: nicknameController,
                  //     decoration: InputDecoration(
                  //       border: OutlineInputBorder(
                  //         borderSide:
                  //             BorderSide(color: Colors.black, width: 5.0),
                  //       ),
                  //       hintText: "Nickname",
                  //       contentPadding: EdgeInsets.all(20),
                  //     )),
                ),
                SizedBox(height: 20),
                // OurButton(
                //   icon: Icon(Icons.arrow_forward_ios_rounded),
                //   formKey: _formKey,
                //   isAnon: true,
                Container(
                  height: 50,
                  width: 115,
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: Colors.white.withOpacity(0.4), width: 4),
                    shape: BoxShape.circle,
                  ),
                  child: ElevatedButton(
                    key: Key('Guest Login Button'),
                    style: ElevatedButton.styleFrom(
                      fixedSize: const Size(200, 200),
                      shape: const CircleBorder(),
                    ),
                    onPressed: () async {
                      if (guestName != '') {
                        //print("errir");
                        WidgetsBinding.instance?.addPostFrameCallback((_) {
                          globals.loading.value = true;
                        });
                        //print("errir1");
                        dynamic logInAttempt =
                            await widget.auth.signInAnon(guestName);
                        //print("errir2");
                        if (logInAttempt == null) {
                          WidgetsBinding.instance?.addPostFrameCallback((_) {
                            globals.loading.value = false;
                          });
                        }
                      } else {
                        setState(() {
                          guestError = 'need a nickname';
                        });
                      }
                    },
                    child: Icon(Icons.arrow_forward_ios_rounded),
                  ),
                ),
                // Container(
                //     width: 285,
                //     height: 50,
                //     padding: EdgeInsets.only(top: 20),
                //     child: ElevatedButton(
                //       onPressed: () async {},
                //       child: Text('Log in as guest'),
                //       style: ElevatedButton.styleFrom(primary: Colors.grey),
                //     )),
                SizedBox(height: 20),
                Text(
                  '$guestError',
                  style: TextStyle(color: Colors.red),
                ),
              ],
            )
          ]),
      // ),
    );
  }
}

// Scaffold(
//         backgroundColor: Colors.blueAccent,
//         appBar: AppBar(
//             elevation: 0,
//             backgroundColor: Colors.redAccent,
//             title: Text(
//               'Log in!',
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 color: Colors.black,
//                 fontWeight: FontWeight.bold,
//                 fontSize: 30,
//               ),
//             )),
//         body: SingleChildScrollView(
//           child: Column(children: [
//             Padding(padding: EdgeInsets.fromLTRB(20, 80, 20, 0)),
//             Container(
//               padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
//               child: Form(
//                 key: _formKey,
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: <Widget>[
//                     TextFormField(
//                       decoration: InputDecoration(
//                           hintText: 'Email:',
//                           fillColor: Colors.white60,
//                           filled: true),
//                       validator: (val) =>
//                           val!.isEmpty ? 'enter an email' : null,
//                       onChanged: (val) {
//                         email = val;
//                       },
//                     ),
//                     SizedBox(height: 20),
//                     TextFormField(
//                       decoration: InputDecoration(
//                           hintText: 'Password:',
//                           fillColor: Colors.white60,
//                           filled: true),
//                       validator: (val) =>
//                           val!.length < 6 ? 'enter an password' : null,
//                       obscureText: true,
//                       onChanged: (val) {
//                         password = val;
//                       },
//                     ),
//                     SizedBox(height: 10),
//                     ElevatedButton(
//                       onPressed: () async {
//                         if (_formKey.currentState!.validate()) {
//                           setState(() {
//                             loading = true;
//                           });
//                           dynamic logInAttempt =
//                               await _auth.LogInWithEmail(email, password);
//                           print(logInAttempt);
//                           if (logInAttempt == null) {
//                             setState(() {
//                               loading = false;
//                               error = 'Not a valid email/password';
//                             });
//                           }
//                         }
//                       },
//                       child: Text('Log In!'),
//                       style:
//                           ElevatedButton.styleFrom(primary: Colors.black45),
//                     ),
//                     SizedBox(height: 10),
//                     TextButton(
//                         onPressed: () {
//                           widget.toggleView();
//                         },
//                         style: TextButton.styleFrom(
//                           primary: Colors.pink,
//                           // shadowColor: Colors.white,
//                         ),
//                         child: Column(children: <Widget>[
//                           Text('Not a member?'),
//                           Text('Register here!'),
//                           SizedBox(height: 20),
//                           Text(
//                             '$error',
//                             style: TextStyle(color: Colors.red),
//                           ),
//                         ]))
//                   ],
//                 ),
//               ),
//             ),
//           ]),
//         ),
//       )

class OurTextForm extends StatefulWidget {
  final String hintText;
  final TextInputType keyboardType;
  final Icon icon;

  // final bool isUsername;
  String data;
  bool isObscured = false;

  Key iconKey;
  //String dataInput = '';

  OurTextForm(
      {Key? key,
      // required this.isUsername,
      required this.hintText,
      required this.data,
      required this.icon,
      required this.keyboardType,
      required this.iconKey,
      required this.isObscured})
      : super(key: key);
  @override
  State<OurTextForm> createState() => _OurTextFormState();

  String getData() {
    return data;
  }
}

class _OurTextFormState extends State<OurTextForm> {
  final _textController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Start listening to changes.
    _textController.addListener(_printLatestValue);
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the widget tree.
    // This also removes the _printLatestValue listener.
    _textController.dispose();
    super.dispose();
  }

  void _printLatestValue() {
    //print('Second text field: ${_textController.text}');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(30)),
        child: Padding(
            padding: const EdgeInsets.only(left: 25.0, right: 25),
            child: TextFormField(
              onChanged: (val) {
                setState(() {
                  widget.iconKey = Key(val);
                  email = val;
                });
              },
              obscureText: widget.isObscured,
              keyboardType: widget.keyboardType,
              decoration: InputDecoration(
                hintText: widget.hintText,
                icon: widget.icon,
              ),
            )));
  }
}

final AuthService _auth = AuthService();

class OurButton extends StatelessWidget {
  // final String text;
  final bool isAnon;
  final GlobalKey<FormState> formKey;
  final Icon icon;
  // final String username;
  // final String? password;

  const OurButton({
    Key? key,
    // required this.text,
    // required this.username,
    // this.password,
    required this.isAnon,
    required this.formKey,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 115,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white.withOpacity(0.4), width: 4),
        // borderRadius: BorderRadius.circular(12),
        // gradient: LinearGradient(
        //   begin: Alignment.topRight,
        //   end: Alignment.bottomLeft,
        //   colors: [
        //     Colors.white,
        //     Colors.black,
        //   ],
        // ),
        shape: BoxShape.circle,
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          fixedSize: const Size(200, 200),
          shape: const CircleBorder(),
        ),
        onPressed: () async {
          if (formKey.currentState!.validate()) {
            // setState(() {
            //   loading = true;
            // });
            dynamic logInAttempt = await _auth.LogInWithEmail(email, password);
            if (guestName != '') {
              WidgetsBinding.instance?.addPostFrameCallback((_) {
                globals.loading.value = true;
              });
              dynamic logInAttempt = await _auth.signInAnon(guestName);
              if (logInAttempt == null) {
                WidgetsBinding.instance?.addPostFrameCallback((_) {
                  globals.loading.value = false;
                });
              }
            } else {
              //   setState(() {
              //     guestName = 'need a nickname';
              //   });
              // }
            }
          }
        },
        //   if (_formKey.currentState!.validate()) {
        //     WidgetsBinding.instance?.addPostFrameCallback((_) {
        //       globals.loading.value = true;
        //     });
        //     dynamic logInAttempt = await _auth.LogInWithEmail(email, password);
        //     if (logInAttempt == null) {
        //       WidgetsBinding.instance?.addPostFrameCallback((_) {
        //         globals.loading.value = false;
        //       });
        //       setState(() {
        //         error = 'Not a valid email/password';
        //       });
        //     }
        //   }
        // },
        child: icon,
        // style: ElevatedButton.styleFrom(primary: Colors.grey),
      ),
    );
  }
}
