import 'package:firebase_database/firebase_database.dart';

class History{
  String paymentMethod;
  String createdAt;
  String status;
  String fares;
  String destination;
  String pickUp;

  History({this.paymentMethod, this.createdAt, this.status, this.fares, this.destination, this.pickUp});

  History.fromSnapShot(DataSnapshot snapshot){
    paymentMethod = snapshot.value["paymentMethod"];
    createdAt = snapshot.value["createdAt"];
    status = snapshot.value["status"];
    fares = snapshot.value["fares"];
    destination = snapshot.value["destinationAddress"];
    pickUp = snapshot.value["pickUpAddress"];
  }
}