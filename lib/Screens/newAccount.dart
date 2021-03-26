import 'dart:ui';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:taxi_express_driver/Screens/carInfoScreen.dart';
import 'package:taxi_express_driver/Screens/mainScreen.dart';
import 'package:taxi_express_driver/Widgets/loginLoad.dart';
import 'package:taxi_express_driver/Widgets/widgets.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:taxi_express_driver/main.dart';
import 'package:taxi_express_driver/mapsConfig.dart';

// ignore: must_be_immutable
class CreateNewAccount extends StatelessWidget {

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool _autoValidate = false;

  TextEditingController _username = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _pass = TextEditingController();
  TextEditingController _confirmPass = TextEditingController();
  TextEditingController _phone = TextEditingController();

  String validatePhone(value){
    if(value.isEmpty)
      return "*Phone Number Required.";
    else
      return null;
  }

  String validateUser(value){
    if(value.isEmpty)
      return "*Username Required.";
    else
      return null;
  }

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

  String confirmPass(value){
    if(value.isEmpty)
      return "*Password Must be Confirmed.";
    else if(value != _pass.text)
      return "Passwords Don't Match.";
    else
      return null;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Wallpaper(wallpaper: 'images\\newaccount_wallpaper.jpg'),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            brightness: Brightness.dark,
            backgroundColor: Colors.transparent,
            elevation: 0,
            iconTheme: IconThemeData(
              color: Colors.white,
              size: 35,
            ),
          ),

          body: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: size.width * 0.0,
                ),
                Stack(
                  children: [
                    Center(
                      child: ClipOval(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(
                              sigmaX: 3, sigmaY: 3),
                          child: CircleAvatar(
                            radius: size.width * 0.1,
                            backgroundColor: Colors.grey[400].withOpacity(0.4),
                            child: Icon(
                              FontAwesomeIcons.user,
                              color: Colors.white,
                              size: size.width * 0.09,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: size.height * 0.05,
                      left: size.width * 0.53 ,
                      child: Container(
                        height: size.width * 0.09,
                        width: size.width * 0.13,
                        decoration: BoxDecoration(
                          //color: Color.fromRGBO(146, 27, 31, 1),
                          color: Colors.blueAccent,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: 2,
                          ),
                        ),
                        child: Icon(
                          FontAwesomeIcons.arrowUp,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: size.width * 0.08,
                ),
                SingleChildScrollView(
                  child: Form(
                    // ignore: deprecated_member_use
                    autovalidate: _autoValidate,
                    key: formKey,
                    child: Column(
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
                                hintText: 'Username',
                                hintStyle: TextStyle(
                                  color: Colors.white70,
                                ),
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                  child: Icon(
                                    FontAwesomeIcons.user,
                                    size: 28,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              controller: _username,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                height: 1.5,
                              ),
                              keyboardType: TextInputType.name,
                              textInputAction: TextInputAction.next,
                              validator: validateUser,
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
                                hintText: 'Phone Number',
                                hintStyle: TextStyle(
                                  color: Colors.white70,
                                ),
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                  child: Icon(
                                    FontAwesomeIcons.phone,
                                    size: 28,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              controller: _phone,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                height: 1.5,
                              ),
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.next,
                              validator: validatePhone,
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
                                    FontAwesomeIcons.lock,
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
                              keyboardType: TextInputType.name,
                              textInputAction: TextInputAction.next,
                              validator: validatePass,
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
                                hintText: 'Confirm Password',
                                hintStyle: TextStyle(
                                  color: Colors.white70,
                                ),
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                  child: Icon(
                                    FontAwesomeIcons.lock,
                                    size: 28,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              controller: _confirmPass,
                              obscureText: true,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                height: 1.5,
                              ),
                              keyboardType: TextInputType.name,
                              textInputAction: TextInputAction.done,
                              validator: confirmPass,
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
                                  registerNewUser(context);
                                else
                                  _autoValidate = true;
                              },
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16.0),
                              ),
                              color: Color.fromRGBO(146, 27, 31, 1),
                              child: Text(
                                'Register',
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
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Already Have an Account?',
                              style: TextStyle(
                                height: 1.5,
                                fontFamily: "JosefinSans-Light",
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            GestureDetector(
                              onTap: (){
                                Navigator.pushNamed(context, '/');
                              },
                              child: Text(
                                'Login',
                                style: TextStyle(
                                  height: 1.5,
                                  fontFamily: "JosefinSans-Medium",
                                  color: Color.fromRGBO(255, 0, 9, 1),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void registerNewUser(BuildContext context) async{
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context){
          return LoginLoad(
            message: "Registering, Please Wait...",
          );
        }
    );

    final User firebaseUser = (await _firebaseAuth.
    createUserWithEmailAndPassword(email:_email.text, password: _pass.text
    ).catchError((errMsg){
      Navigator.pop(context);
      displayToastMessage("Error: " + errMsg.toString() , context);
    })).user;

    if(firebaseUser != null){

      Map userDataMap = {
        "name" : _username.text.trim(),
        "email" : _email.text.trim(),
        "phone" : _phone.text,
      };

      driversRef.child(firebaseUser.uid).set(userDataMap);

      currentFirebaseUser = firebaseUser;
      displayToastMessage("User Created Successfully. Now Enter Your Car Info.", context);

      Navigator.pushNamed(context, 'CarInfoScreen');
    }
    else {
      Navigator.pop(context);
      displayToastMessage("User Couldn't be Created", context);
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
