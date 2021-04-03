import 'package:google_maps_flutter/google_maps_flutter.dart';

class RideDetails{
  String pickUpAddress;
  String destinationAddress;
  LatLng pickUp;
  LatLng destination;
  String ride_request_id;
  String paymentMethod;
  String riderName;
  String riderPhone;

  RideDetails();
}