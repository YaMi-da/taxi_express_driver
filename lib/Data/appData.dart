import 'package:flutter/material.dart';
import 'package:taxi_express_driver/Models/addresses.dart';

class AppData extends ChangeNotifier{
  Address pickUpLocation, destinationLocation;

  void updatePickUpLocationAddress(Address pickUpAddress){
    pickUpLocation = pickUpAddress;
    notifyListeners();
  }

  void updateDestinationLocationAddress(Address destinationAdress){
    destinationLocation = destinationAdress;
    notifyListeners();
  }
}