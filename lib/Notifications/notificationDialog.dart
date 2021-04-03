import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:path/path.dart';
import 'package:taxi_express_driver/Assistants/assistantMethods.dart';
import 'package:taxi_express_driver/Models/rideDetails.dart';
import 'package:taxi_express_driver/Screens/newRideScreen.dart';
import 'package:taxi_express_driver/main.dart';
import 'package:taxi_express_driver/mapsConfig.dart';

class NotificationDialog extends StatelessWidget {

  final RideDetails rideDetails;
  NotificationDialog({this.rideDetails});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      backgroundColor: Colors.transparent,
      elevation: 3.0,
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
            SizedBox(height: 20.0,),
            Image.asset("images\\taxi.png", width: 120.0,),
            SizedBox(height: 10.0,),
            Text(
              "New Ride Request",
              style: TextStyle(fontSize: 20.0,),),
            SizedBox(height: 30.0,),
            Padding(
              padding: EdgeInsets.all(18.0),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        FontAwesomeIcons.mapMarkerAlt,
                        color: Color.fromRGBO(146, 27, 31, 1),
                        size: 18,
                      ),
                      SizedBox(width: 20.0,),
                      Expanded(
                        child: Container(
                          child: Text(rideDetails.pickUpAddress, style: TextStyle(fontSize: 18.0),),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20,),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        FontAwesomeIcons.mapMarkedAlt,
                        color: Color.fromRGBO(146, 27, 31, 1),
                        size: 18,
                      ),
                      SizedBox(width: 20.0,),
                      Expanded(
                        child: Container(
                          child: Text(rideDetails.destinationAddress, style: TextStyle(fontSize: 18.0),),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 15.0,),
                ],
              ),
            ),

            SizedBox(height: 15.0,),
            Divider(height: 2.0, color: Colors.black, thickness: 2.0,),
            SizedBox(height: 8.0,),

            Padding(padding: EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // ignore: deprecated_member_use
                  FlatButton(
                    onPressed: () {
                      assetAudioPlayer.stop();
                      Navigator.pop(context);
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: BorderSide(color: Color.fromRGBO(146, 27, 31, 1)),
                    ),
                    color: Colors.white,
                    textColor: Color.fromRGBO(146, 27, 31, 1),
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Cancel".toUpperCase(),
                      style: TextStyle(
                        fontSize: 14.0,
                      ),
                    ),
                  ),

                  SizedBox(width: 25.0,),

                  // ignore: deprecated_member_use
                  RaisedButton(
                    onPressed: () {
                      assetAudioPlayer.stop();
                      checkAvailabilityOfRide(context);
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: BorderSide(color: Color.fromRGBO(146, 27, 31, 1)),
                    ),
                    color: Color.fromRGBO(146, 27, 31, 1),
                    textColor: Colors.white,
                    child: Text(
                      "Accept".toUpperCase(),
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 10.0,),
          ],
        ),
      ),
    );
  }

  void checkAvailabilityOfRide(context){
    rideRequestRef.once().then((DataSnapshot dataSnapShot){
      Navigator.pop(context);
      String theRideId = "";
      if(dataSnapShot.value != null){
         theRideId = dataSnapShot.value.toString();
      }
      else{
        displayToastMessage("Ride Unavailable", context);
      }
      
      if(theRideId == rideDetails.ride_request_id){
        rideRequestRef.set("accepted");
        AssistantMethods.disableHomeTabLiveLocationUpdates();
        Navigator.push(context, MaterialPageRoute(builder: (context)=> NewRideScreen(rideDetails : rideDetails)));
      }
      else if(theRideId == "cancelled"){
        displayToastMessage("Ride has been cancelled", context);
      }
      else if(theRideId == "timeout"){
        displayToastMessage("Ride has expired", context);
      }
      else{
        displayToastMessage("Ride Unavailable", context);
      }
    });
  }

  displayToastMessage(String msg, BuildContext context, ) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Color.fromRGBO(146, 27, 31, 1),
      textColor: Colors.white,
      fontSize: 20,
    );
  }

}
