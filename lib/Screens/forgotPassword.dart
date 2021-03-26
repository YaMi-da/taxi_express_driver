import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:taxi_express_driver/Widgets/app-wallpaper.dart';
import 'package:form_field_validator/form_field_validator.dart';


// ignore: must_be_immutable
class ForgotPassword extends StatelessWidget {

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  void validate(){
    if(formKey.currentState.validate())
      print("Validated");
    else
      print("Not Validated");
  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Wallpaper(wallpaper: 'images\\login_wallpaper.jpg'),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            brightness: Brightness.dark,
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              onPressed: (){
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
                size: 35,
              ),
            ),
            title: Text(
              'Forgot Password',
              style: TextStyle(
                color: Colors.white,
                height: 1.5,
                fontSize: 27,
                fontFamily: "JosefinSans-Medium",
              ),
            ),
            centerTitle: true,
          ),
          body: Column(
            children: [
              Center(
                child: Column(
                  children: [
                    SizedBox(
                      height: size.height * 0.1,
                    ),
                    Container(
                      width: size.width * 0.9,
                      child: Text(
                        'Enter your email, we will send instructions to reset your password.',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 19,
                          fontFamily: "JosefinSans-Light",
                          fontWeight: FontWeight.w700,
                          height: 1.5,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 18,
                    ),
                    Form(
                      autovalidateMode: AutovalidateMode.always,
                      key: formKey,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                            child : Center(
                              child: TextFormField(
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
                          SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15.0),
                            child: Container(
                              height: size.height * 0.09,
                              width: size.width * 0.95,
                              // ignore: deprecated_member_use
                              child: RaisedButton(
                                onPressed: validate,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16.0),
                                ),
                                color: Color.fromRGBO(146, 27, 31, 1),
                                child: Text(
                                  'Send',
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
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
