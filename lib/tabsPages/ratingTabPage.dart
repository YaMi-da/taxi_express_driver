import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:taxi_express_driver/Widgets/SearchDivider.dart';

import '../mapsConfig.dart';


class RatingTabPage extends StatefulWidget {
  @override
  _RatingTabPageState createState() => _RatingTabPageState();
}

class _RatingTabPageState extends State<RatingTabPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(73, 74, 80, 1),
      body: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        backgroundColor: Colors.transparent,
        child: Container(
          margin: EdgeInsets.all(5.0),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 22.0,),
              Text(
                "Your Rating",
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.black54,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 22.0,),

              DividerWidget(),

              SizedBox(height: 16.0,),

              SmoothStarRating(
                rating: starCounter,
                borderColor: Colors.black,
                color: Color.fromRGBO(146, 27, 31, 1),
                allowHalfRating: true,
                starCount: 5,
                size: 45,
                isReadOnly: true,
              ),

              SizedBox(height: 14.0,),

              Text(
                title,
                style: TextStyle(fontSize: 35.0, color: Color.fromRGBO(146, 27, 31, 1),),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 16.0,),



            ],
          ),
        ),
      ),
    );
  }
}