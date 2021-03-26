import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:taxi_express_driver/Widgets/app-wallpaper.dart';
import 'package:taxi_express_driver/main.dart';
import 'package:taxi_express_driver/mapsConfig.dart';

class CarInfoScreen extends StatelessWidget {

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool _autoValidate = false;

  TextEditingController _carModel = TextEditingController();
  TextEditingController _carNumber = TextEditingController();
  TextEditingController _carLicensePlace = TextEditingController();
  TextEditingController _carColor = TextEditingController();

  String validateModel(value){
    if(value.isEmpty)
      return "*Model Required.";
    else
      return null;
  }
  String validateNumber(value){
    if(value.isEmpty)
      return "*Number Required.";
    else
      return null;
  }
  String validateLicense(value){
    if(value.isEmpty)
      return "*License Plate Required.";
    else
      return null;
  }
  String validateColor(value){
    if(value.isEmpty)
      return "*Model Required.";
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
                SizedBox(height: size.width * 0.05,
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
                              FontAwesomeIcons.car,
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
                                hintText: 'Car Model',
                                hintStyle: TextStyle(
                                  color: Colors.white70,
                                ),
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                  child: Icon(
                                    FontAwesomeIcons.car,
                                    size: 28,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              controller: _carModel,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                height: 1.5,
                              ),
                              keyboardType: TextInputType.name,
                              textInputAction: TextInputAction.next,
                              validator: validateModel,
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
                                hintText: 'Car Number',
                                hintStyle: TextStyle(
                                  color: Colors.white70,
                                ),
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                  child: Icon(
                                    FontAwesomeIcons.car,
                                    size: 28,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              controller: _carNumber,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                height: 1.5,
                              ),
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.next,
                              validator: validateNumber,
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
                                hintText: 'License Place',
                                hintStyle: TextStyle(
                                  color: Colors.white70,
                                ),
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                  child: Icon(
                                    FontAwesomeIcons.car,
                                    size: 28,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              controller: _carLicensePlace,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                height: 1.5,
                              ),
                              keyboardType: TextInputType.name,
                              textInputAction: TextInputAction.next,
                              validator: validateLicense,
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
                                hintText: 'Car Color',
                                hintStyle: TextStyle(
                                  color: Colors.white70,
                                ),
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                  child: Icon(
                                    FontAwesomeIcons.car,
                                    size: 28,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              controller: _carColor,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                height: 1.5,
                              ),
                              keyboardType: TextInputType.name,
                              textInputAction: TextInputAction.done,
                              validator: validateColor,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 30,
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
                                  saveDriverCarInfo(context);
                                else
                                  _autoValidate = true;
                              },
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16.0),
                              ),
                              color: Color.fromRGBO(146, 27, 31, 1),
                              child: Padding(
                                padding: const EdgeInsets.all(17.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Register Your Car',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        height: 1.5,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Icon(
                                      FontAwesomeIcons.checkCircle,
                                      color: Colors.white,
                                      size: 30.0,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
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

  void saveDriverCarInfo(context){
    String userId = currentFirebaseUser.uid;

    Map carInfoMap = {
      "car_color" : _carColor.text,
      "car_number" : _carNumber.text,
      "car_license" : _carLicensePlace.text,
      "car_color" : _carColor.text,
    };
    
    driversRef.child(userId).child("car_info").set(carInfoMap);

    displayToastMessage("Car Registered Successfully. You Can Log In.", context);

    Navigator.pushNamed(context, '/');
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
