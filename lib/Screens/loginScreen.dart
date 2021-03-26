import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:taxi_express_driver/Widgets/loginLoad.dart';
import 'package:taxi_express_driver/Widgets/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:taxi_express_driver/main.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {


  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool _autoValidate = false;
  TextEditingController _email = TextEditingController();
  TextEditingController _pass = TextEditingController();


  String validatePass(value){
    if(value.isEmpty)
      return "*Password Required.";
    else if(value.length < 6)
      return "Should be At Least 6 Characters.";
    else if(value.length > 15)
      return "Should be Less Than 15 Characters.";
    else
      return null;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Wallpaper(
          wallpaper: 'images\\login_wallpaper.jpg',
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            toolbarHeight: 0,
            elevation: 0,
            brightness: Brightness.dark,
            backgroundColor: Colors.transparent,
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: size.width * 0.5,
                ),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Taxi Express',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 50,
                        ),
                      ),
                      Text(
                        'Driver',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 40,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: size.width * 0.3,),
                SingleChildScrollView(
                  child: Form(
                    // ignore: deprecated_member_use
                    autovalidate: _autoValidate,
                    key: formKey,
                    child:
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                            child : Center(
                              child: TextFormField(
                                cursorColor: Colors.white,
                                decoration: InputDecoration(
                                  contentPadding: new EdgeInsets.symmetric(vertical: 25.0, horizontal: 10.0),
                                  filled: true,
                                  fillColor: Colors.grey[500].withOpacity(0.3),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.transparent, width: 1, style: BorderStyle.solid),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white, width: 1, style: BorderStyle.solid),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  errorBorder: new OutlineInputBorder(
                                    borderSide: new BorderSide(color: Colors.red, width: 3.0),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  focusedErrorBorder: new OutlineInputBorder(
                                    borderSide: new BorderSide(color: Colors.red, width: 3.0),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  errorStyle: TextStyle(
                                    color: Colors.red,
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  hintText: 'Email',
                                  hintStyle: TextStyle(
                                    color: Colors.white70,
                                  ),
                                  prefixIcon: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                    child: Icon(
                                      FontAwesomeIcons.envelope,
                                      size: 28,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                controller: _email,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  height: 1.5,
                                ),
                                keyboardType: TextInputType.emailAddress,
                                textInputAction: TextInputAction.next,
                                validator: MultiValidator(
                                  [
                                    RequiredValidator(errorText: "*Email Required."),
                                    EmailValidator(errorText: "Not a Valid Email."),
                                  ]
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                            child : Center(
                              child: TextFormField(
                                cursorColor: Colors.white,
                                decoration: InputDecoration(
                                  contentPadding: new EdgeInsets.symmetric(vertical: 25.0, horizontal: 10.0),
                                  filled: true,
                                  fillColor: Colors.grey[500].withOpacity(0.3),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.transparent, width: 1, style: BorderStyle.solid),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white, width: 1, style: BorderStyle.solid),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  errorBorder: new OutlineInputBorder(
                                    borderSide: new BorderSide(color: Colors.red, width: 3.0),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  focusedErrorBorder: new OutlineInputBorder(
                                    borderSide: new BorderSide(color: Colors.red, width: 3.0),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  errorStyle: TextStyle(
                                    color: Colors.red,
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  hintText: 'Password',
                                  hintStyle: TextStyle(
                                    color: Colors.white70,
                                  ),
                                  prefixIcon: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                    child: Icon(
                                      FontAwesomeIcons.envelope,
                                      size: 28,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                controller: _pass,
                                obscureText: true,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  height: 1.5,
                                ),
                                textInputAction: TextInputAction.done,
                                validator: validatePass,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15.0),
                            child: GestureDetector(
                              onTap: () => Navigator.pushNamed(context, 'Forgot Password'),
                              child: Text(
                                'Forgot Password',
                                style: TextStyle(
                                  height: 1.5,
                                  fontFamily: "JosefinSans-Light",
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 25,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15.0),
                            child: Container(
                              height: size.height * 0.09,
                              width: size.width * 0.95,
                        // ignore: deprecated_member_use
                              child: RaisedButton(
                                onPressed: () {
                                  if(formKey.currentState.validate())
                                    loginAndAuthenticateUser(context);
                                  else
                                    _autoValidate =true;
                                },
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16.0),
                                ),
                                color: Color.fromRGBO(146, 27, 31, 1),
                                child: Text(
                                  'Login as Driver',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    height: 1.5,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pushNamed(context, 'Create New Account'),
                  child: Container(
                    child: Text(
                      ('New Here? Create an Account'),
                      style: TextStyle(
                        fontFamily: "JosefinSans-Light",
                        height: 1.5,
                        color: Colors.white,
                        fontSize: 17,
                      ),
                    ),
                    decoration: BoxDecoration(
                        border:
                        Border(bottom: BorderSide(
                          width: 1,
                          color: Colors.white,
                        ))
                    ),
                  ),
                ),

              ],
            ),
          ),
        ),
      ],
    );
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  loginAndAuthenticateUser(BuildContext context) async{
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context){
          return LoginLoad(
            message: "Authenticating, Please Wait...",
          );
        }
    );

    final User firebaseUser = (await _firebaseAuth.
    signInWithEmailAndPassword(email:_email.text, password: _pass.text
    ).catchError((errMsg){
      Navigator.pop(context);
      displayToastMessage("Error: " + errMsg.toString() , context);
    })).user;

    if(firebaseUser != null){
      driversRef.child(firebaseUser.uid).once().then((DataSnapshot snap){
        if(snap.value != null){
          Navigator.pushNamedAndRemoveUntil(context, 'MainScreen', (route) => false);
          displayToastMessage("Logged In", context);
        }
        else{
          Navigator.pop(context);
          _firebaseAuth.signOut();
          displayToastMessage("Account Doesn't exist.", context);
        }
      });
    }
    else{
      Navigator.pop(context);
      displayToastMessage("Error Occured. Can't sign in.", context);
    }
  }

  displayToastMessage(String msg, BuildContext context, ) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.TOP,
      backgroundColor: Color.fromRGBO(146, 27, 31, 1),
      textColor: Colors.white,
      fontSize: 20,
    );
  }
}
