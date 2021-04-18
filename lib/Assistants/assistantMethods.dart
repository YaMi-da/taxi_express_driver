import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:taxi_express_driver/Assistants/requestAssistant.dart';
import 'package:taxi_express_driver/Models/Users.dart';
import 'package:taxi_express_driver/Models/addresses.dart';
import 'package:taxi_express_driver/Data/appData.dart';
import 'package:taxi_express_driver/Models/directionDetails.dart';
import 'package:taxi_express_driver/Models/history.dart';
import 'package:taxi_express_driver/main.dart';
import 'package:taxi_express_driver/mapsConfig.dart';

class AssistantMethods{
  /*static Future<dynamic> searchCoordinateAdress(Position position, context)
  async{
    var placeAdress;
    var st0, st1, st2, st3, st4, st6, st5;
    String url = "https://maps.googleapis"
        ".com/maps/api/geocode/json?latlng=${position.latitude},${position
        .longitude}&key=AIzaSyAuBdVRNHIXcARUTjZEp68kyNrFRSk1Xwg";

    var response = await RequestAssistant.getRequest(url);

    if(response != "failed"){
      //placeAdress = response["results"][0]["formatted_address"];
      st0 = response["results"][0]["address_components"][0]["long_name"];
      st1 = response["results"][0]["address_components"][1]["long_name"];
      st3 = response["results"][0]["address_components"][2]["long_name"];
      st4 = response["results"][0]["address_components"][3]["long_name"];
      st6 = response["results"][0]["address_components"][4]["long_name"];


      placeAdress = st0 + ", " + st1 + ", " + st4 + ", " + st6 +  ", " + st3;

      Address userPickUpAdress = new Address();
      userPickUpAdress.placeName = placeAdress;
      userPickUpAdress.latitude = position.latitude;
      userPickUpAdress.longitude = position.longitude;

      Provider.of<AppData>(context, listen: false).updatePickUpLocationAddress
        (userPickUpAdress);
    }
    return placeAdress;
  }*/

  static Future<DirectionDetails> obtainPlaceDirectionDetails(LatLng initialPosition, LatLng finalPosition) async{
    String directionURL = "https://maps.googleapis.com/maps/api/directions/json?origin=${initialPosition.latitude},${initialPosition.longitude}"
        "&destination=${finalPosition.latitude},${finalPosition.longitude}&key=AIzaSyAuBdVRNHIXcARUTjZEp68kyNrFRSk1Xwg";

    var res = await RequestAssistant.getRequest(directionURL);

    if(res == "failed"){
      return null;
    }

    DirectionDetails directionDetails = DirectionDetails();
    directionDetails.encodedPoints = res["routes"][0]["overview_polyline"]["points"];
    directionDetails.distanceText = res["routes"][0]["legs"][0]["distance"]["text"];
    directionDetails.distanceValue = res["routes"][0]["legs"][0]["distance"]["value"];
    directionDetails.durationText = res["routes"][0]["legs"][0]["duration"]["text"];
    directionDetails.durationValue = res["routes"][0]["legs"][0]["duration"]["value"];

    return directionDetails;
  }
  static int calculateFares(DirectionDetails directionDetails){

    double timeTravelledFare = (directionDetails.durationValue / 60) * 0.20;
    double distanceTravelledFare = (directionDetails.distanceValue / 1000) * 0.20;
    double totalFareAmount = timeTravelledFare + distanceTravelledFare;

    if(rideType == "regular"){
      return totalFareAmount.truncate();
    }

    else if(rideType == "SUV"){
      double result = (totalFareAmount.truncate()) * 2.0;
      return result.truncate();
    }
    else{
      return totalFareAmount.truncate();
    }

  }

  /*static void getCurrentOnlineUserInfo() async{
    firebaseUser = FirebaseAuth.instance.currentUser;
    String userId = firebaseUser.uid;
    DatabaseReference reference = FirebaseDatabase.instance.reference().child("Users").child("Riders").child(userId);
    
    reference.once().then((DataSnapshot dataSnapshot){
      if(dataSnapshot.value != null){
        usersCurrentInfo = Users.fromSnapshot(dataSnapshot);
      }
    });
  }*/

  static void disableHomeTabLiveLocationUpdates(){
    homeTabPageStreamSubscription.pause();
    Geofire.removeLocation(currentFirebaseUser.uid);
  }
  
  static void enableHomeTabLiveLocationUpdates(){
    homeTabPageStreamSubscription.resume();
    Geofire.setLocation(currentFirebaseUser.uid, currentPosition.latitude, currentPosition.longitude);
  }

  static void retrieveHistoryInfo(context){
    driversRef.child(currentFirebaseUser.uid).child("earnings").once().then((DataSnapshot dataSnapshot){
      if(dataSnapshot.value != null){
        String profit = dataSnapshot.value.toString();
        Provider.of<AppData>(context, listen: false).updateProfit(profit);
      }
    });

    driversRef.child(currentFirebaseUser.uid).child("history").once().then((DataSnapshot dataSnapshot){
      if(dataSnapshot.value != null){
        Map<dynamic, dynamic> keys = dataSnapshot.value;
        int tripCounter = keys.length;
        Provider.of<AppData>(context, listen: false).updateTripsCounter(tripCounter);

        List<String> tripHistoryKeys = [];
        keys.forEach((key, value) { 
          tripHistoryKeys.add(key);
        });

        Provider.of<AppData>(context, listen: false).updateTripKeys(tripHistoryKeys);
        obtainTripRequestsHistoryData(context);
      }
    });
  }

  static void obtainTripRequestsHistoryData(context){
    var keys = Provider.of<AppData>(context, listen: false).tripHistoryKeys;
    for(String key in keys){
      newRequestRef.child(key).once().then((DataSnapshot snapshot){
        if(snapshot.value != null){
          var history = History.fromSnapShot(snapshot);
          Provider.of<AppData>(context, listen: false).updateTripHistoryData(history);
        }
      });
    }
  }

  static String formatTripDate(String date){
    DateTime dateTime = DateTime.parse(date);
    String formattedDate = "${DateFormat.MMMd().format(dateTime)}, ${DateFormat.y().format(dateTime)} - ${DateFormat.jm().format(dateTime)}";
    return formattedDate;
  }
}