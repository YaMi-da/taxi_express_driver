import 'package:flutter/material.dart';

class LoginLoad extends StatelessWidget {
  String message;
  LoginLoad({this.message});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Color.fromRGBO(146, 27, 31, 1),
      child: Container(
        margin: EdgeInsets.all(9.0),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Color.fromRGBO(146, 27, 31, 1),
          borderRadius: BorderRadius.circular(6.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            children: [
              SizedBox(width: 6.0,),
              CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>
                (Colors.black),),
              SizedBox(width: 6.0,),
              Text(
                message,
                style: TextStyle(
                  color: Colors.white, fontSize: 15.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
