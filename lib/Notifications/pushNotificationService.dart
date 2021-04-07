import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:taxi_express_driver/Models/rideDetails.dart';
import 'package:taxi_express_driver/Notifications/notificationDialog.dart';
import 'package:taxi_express_driver/main.dart';
import 'package:taxi_express_driver/mapsConfig.dart';
import 'dart:io' show Platform;

class PushNotificationService{
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging();

  Future initialize(context) async{
    firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async{
        retrieveRideRequestInfo(getRideRequestId(message), context);
      },
      onLaunch: (Map<String, dynamic> message)async{
        retrieveRideRequestInfo(getRideRequestId(message), context);
      },
      onResume: (Map<String, dynamic> message) async{
        retrieveRideRequestInfo(getRideRequestId(message), context);
      },
    );
  }
  
  Future<String> getToken()async{
    String token = await firebaseMessaging.getToken();
    print("This is token : ");
    print(token);
    driversRef.child(currentFirebaseUser.uid).child("token").set(token);
    
    firebaseMessaging.subscribeToTopic("alldrivers");
    firebaseMessaging.subscribeToTopic("allriders");
  }

  String getRideRequestId(Map<String, dynamic> message){
    String rideRequestId;
    if(Platform.isAndroid){
      rideRequestId = message['data']['ride_request_id'];
    }
    else{
      rideRequestId = message['ride_request_id'];
    }
    return rideRequestId;
  }

  void retrieveRideRequestInfo(String rideRequestId, BuildContext context){
    newRequestRef.child(rideRequestId).once().then((DataSnapshot dataSnapshot){
      if(dataSnapshot.value != null){

        assetAudioPlayer.open(Audio("sounds\\alert.mp3"));
        assetAudioPlayer.play();

        double pickUpLocLat = double.parse(dataSnapshot.value['pickUp']['latitude'].toString());
        double pickUpLocLng = double.parse(dataSnapshot.value['pickUp']['longitude'].toString());
        String pickUpAddress = dataSnapshot.value['pickUpAddress'].toString();

        double destinationLocLat = double.parse(dataSnapshot.value['destination']['latitude'].toString());
        double destinationLocLng = double.parse(dataSnapshot.value['pickUp']['longitude'].toString());
        String destinationAddress = dataSnapshot.value['destinationAddress'].toString();

        String paymentMethod = dataSnapshot.value['paymentMethod'].toString();

        String rider_name = dataSnapshot.value["riderName"];
        String rider_phone = dataSnapshot.value["riderPhone"];
      
        RideDetails rideDetails = RideDetails();
        rideDetails.ride_request_id = rideRequestId;
        rideDetails.pickUpAddress = pickUpAddress;
        rideDetails.destinationAddress = destinationAddress;
        rideDetails.pickUp = LatLng(pickUpLocLat, pickUpLocLng);
        rideDetails.destination = LatLng(destinationLocLat, destinationLocLng);
        rideDetails.paymentMethod = paymentMethod;
        rideDetails.riderName = rider_name;
        rideDetails.riderPhone = rider_phone;

        print("information ::");
        print(rideDetails.pickUpAddress);
        print(rideDetails.destinationAddress);
        
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) => NotificationDialog(rideDetails: rideDetails,),
        );
      }
    });
  }
}