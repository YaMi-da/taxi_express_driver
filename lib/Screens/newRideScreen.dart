import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:taxi_express_driver/Assistants/assistantMethods.dart';
import 'package:taxi_express_driver/Assistants/mapsKitAssistant.dart';
import 'package:taxi_express_driver/Data/appData.dart';
import 'package:taxi_express_driver/Models/rideDetails.dart';
import 'package:taxi_express_driver/Widgets/collectFareDialog.dart';
import 'package:taxi_express_driver/Widgets/loginLoad.dart';
import 'package:taxi_express_driver/main.dart';
import 'package:taxi_express_driver/mapsConfig.dart';

class NewRideScreen extends StatefulWidget {

  final RideDetails rideDetails;
  NewRideScreen({this.rideDetails});

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.423424241, -122.213134131),
    zoom: 14.4123,
  );

  @override
  _NewRideScreenState createState() => _NewRideScreenState();
}

class _NewRideScreenState extends State<NewRideScreen> {

  Completer<GoogleMapController> _controller = Completer();

  double bottomPaddingOfMap = 0;

  GoogleMapController newRideGoogleMapController;
  Set<Marker> markerSet = Set<Marker>();
  Set<Circle> circleSet = Set<Circle>();
  Set<Polyline> polylineSet = Set<Polyline>();
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  var geoLocator = Geolocator();
  var locationOptions = LocationOptions(accuracy: LocationAccuracy.bestForNavigation);
  Position myPosition;
  String status = "accepted";
  String durationRide = "";
  bool isRequestingDirection = false;
  String btnTitle = "Arrived";
  Color btnColor = Color.fromRGBO(99, 99, 99, 1);
  Timer timer;
  int durationCounter = 0;

  @override
  void initState() {
    super.initState();
    acceptRideRequest();
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png)).buffer.asUint8List();
  }

  void getRideLiveLocationUpdates() {
    LatLng oldPosition = LatLng(0,0);

    rideStreamSubscription = Geolocator.getPositionStream().listen((Position position) async {
      currentPosition = position;
      myPosition = position;
      LatLng mPosition = LatLng(position.latitude, position.longitude);
      var rot = MapKitAssistant.getMarkerRotation(oldPosition.latitude, oldPosition.longitude, myPosition.latitude, myPosition.longitude);

      final Uint8List driverIcon =  await getBytesFromAsset('images\\car_marker.png', 110);

      Marker animatingMarker = Marker(
        markerId: MarkerId("animating"),
        position: mPosition,

        icon: BitmapDescriptor.fromBytes(driverIcon),
        infoWindow: InfoWindow(title: "Current Location"),
      );

      setState(() {
        CameraPosition cameraPosition = new CameraPosition(target: mPosition, zoom: 17);
        newRideGoogleMapController.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
        markerSet.removeWhere((marker) => marker.markerId.value == "animating");
        markerSet.add(animatingMarker);
      });

      oldPosition = mPosition;
      updateRideDetails();

      String rideRequestId= widget.rideDetails.ride_request_id;
      Map locMap = {
        "latitude": currentPosition.latitude.toString(),
        "longitude": currentPosition.longitude.toString(),
      };
      newRequestRef.child(rideRequestId).child("driver_location").set(locMap);
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.dark,
        toolbarHeight: 0,
        backgroundColor: Colors.black,
      ),
      body: Stack(
        children: [
          GoogleMap(
            padding: EdgeInsets.only(bottom: bottomPaddingOfMap),
            mapType: MapType.normal,
            myLocationButtonEnabled: true,
            initialCameraPosition: NewRideScreen._kGooglePlex,
            myLocationEnabled: true,
            zoomGesturesEnabled: true,
            zoomControlsEnabled: true,
            markers: markerSet,
            circles: circleSet,
            polylines: polylineSet,
            onMapCreated: (GoogleMapController controller) async{
              _controller.complete(controller);
              newRideGoogleMapController = controller;

              setState(() {
                bottomPaddingOfMap = 290.0;
              });
              var currentLatLng = LatLng(currentPosition.latitude, currentPosition.longitude);
              var pickUpLatLng = widget.rideDetails.pickUp;

              await getPlaceDirection(currentLatLng, pickUpLatLng);

              getRideLiveLocationUpdates();


            },
          ),

          Positioned(
            left: 0.0,
            right: 0.0,
            bottom: 0.0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(16.0), topRight: Radius.circular(16.0)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 16.0,
                    spreadRadius: 0.5,
                    offset: Offset(0.7, 0.7),
                  ),
                ],
              ),
              height: 270.0,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 18.0),
                child: Column(
                  children: [
                    Text(
                      durationRide,
                      style: TextStyle(fontSize: 14.0, color: Color.fromRGBO(146, 27, 31, 1)),
                    ),
                    SizedBox(height: 6.0,),
                    SizedBox(height: 6.0,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(widget.rideDetails.riderName, style: TextStyle(fontSize: 24.0),),
                        Padding(
                          padding: EdgeInsets.only(right: 10.0),
                          child: Icon(Icons.smartphone_rounded),
                        ),
                      ],
                    ),

                    SizedBox(height: 26.0,),

                    Row(
                      children: [
                        Icon(
                          FontAwesomeIcons.mapMarkerAlt,
                          color: Color.fromRGBO(146, 27, 31, 1),
                          size: 18,
                        ),
                        SizedBox(width: 10.0,),
                        Expanded(
                          child: Container(
                            child: Text(
                              widget.rideDetails.pickUpAddress,
                              style: TextStyle(fontSize: 18.0),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        )
                      ],
                    ),

                    SizedBox(height: 16.0,),

                    Row(
                      children: [
                        Icon(
                          FontAwesomeIcons.mapMarkedAlt,
                          color: Color.fromRGBO(146, 27, 31, 1),
                          size: 18,
                        ),
                        SizedBox(width: 10.0,),
                        Expanded(
                          child: Container(
                            child: Text(
                              widget.rideDetails.destinationAddress,
                              style: TextStyle(fontSize: 18.0),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        )
                      ],
                    ),

                    SizedBox(height: 26.0,),

                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      // ignore: deprecated_member_use
                      child: RaisedButton(
                        onPressed: () async{
                          if(status == "accepted"){
                            status = "arrived";
                            String rideRequestId= widget.rideDetails.ride_request_id;
                            newRequestRef.child(rideRequestId).child("status").set(status);

                            setState(() {
                              btnTitle = "Hit The Road";
                              btnColor = Color.fromRGBO(146, 27, 31, 1);
                            });
                            showDialog(
                              context: context,
                              builder: (BuildContext context) => LoginLoad(message: "Hold On...",),
                            );

                            await getPlaceDirection(widget.rideDetails.pickUp, widget.rideDetails.destination);

                            Navigator.pop(context);
                          }
                          else if (status == "arrived"){
                            status = "onTheWay";
                            String rideRequestId= widget.rideDetails.ride_request_id;
                            newRequestRef.child(rideRequestId).child("status").set(status);
                            setState(() {
                              btnTitle = "End Trip";
                              btnColor = Colors.black;
                            });

                            initTimer();
                          }
                          else if (status == "onTheWay"){
                            endTheTrip();
                          }
                        },

                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        color: btnColor,
                        child: Padding(
                          padding: EdgeInsets.all(17.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                btnTitle,
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Icon(
                                FontAwesomeIcons.taxi,
                                color: Colors.white,
                                size: 26.0,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),

                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }


  Future<void> getPlaceDirection(LatLng pickUpLatLng, LatLng destinationLatLng) async{

    showDialog(
        context: context,
        builder: (BuildContext context) => LoginLoad(message: "hold on",)
    );

    var details = await AssistantMethods.obtainPlaceDirectionDetails(pickUpLatLng, destinationLatLng);

    Navigator.pop(context);

    print("encoded points");
    print(details.encodedPoints);

    PolylinePoints polylinePoints = PolylinePoints();
    List<PointLatLng> decodedPolylinePointResults = polylinePoints.decodePolyline(details.encodedPoints);

    polylineCoordinates.clear();

    if(decodedPolylinePointResults.isNotEmpty){
      decodedPolylinePointResults.forEach((PointLatLng pointLatLng) {
        polylineCoordinates.add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
      });
    }

    polylineSet.clear();

    setState(() {
      Polyline polyline = Polyline(
        color: Color.fromRGBO(146, 27, 31, 1),
        polylineId: PolylineId("PolylineID"),
        jointType: JointType.round,
        points: polylineCoordinates,
        width: 5,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        geodesic: true,
      );
      polylineSet.add(polyline);
    });

    LatLngBounds latLngBounds;
    if(pickUpLatLng.latitude > destinationLatLng.latitude && pickUpLatLng.longitude > destinationLatLng.longitude){
      latLngBounds = LatLngBounds(southwest: destinationLatLng, northeast: pickUpLatLng);
    }
    else if(pickUpLatLng.longitude > destinationLatLng.longitude){
      latLngBounds = LatLngBounds(southwest: LatLng(pickUpLatLng.latitude, destinationLatLng.longitude), northeast: LatLng(destinationLatLng
          .latitude, pickUpLatLng.longitude));
    }
    else if(pickUpLatLng.latitude > destinationLatLng.latitude){
      latLngBounds = LatLngBounds(southwest: LatLng(destinationLatLng.latitude, pickUpLatLng.longitude), northeast: LatLng(pickUpLatLng
          .latitude, destinationLatLng.longitude));
    }
    else{
      latLngBounds = LatLngBounds(southwest: pickUpLatLng, northeast: destinationLatLng);
    }

    newRideGoogleMapController.animateCamera(CameraUpdate.newLatLngBounds(latLngBounds, 70));

    final Uint8List pickUpIcon = await getBytesFromAsset('images\\pickup_marker.png', 110);
    final Uint8List destinationIcon = await getBytesFromAsset('images\\destination_marker.png', 100);

    Marker pickUpMarker = Marker(
      icon: BitmapDescriptor.fromBytes(pickUpIcon),
      position: pickUpLatLng,
      markerId: MarkerId("pickUpId"),
    );


    Marker destinationMarker = Marker(
      icon: BitmapDescriptor.fromBytes(destinationIcon),
      position: destinationLatLng,
      markerId: MarkerId("destinationId"),
    );

    setState(() {
      markerSet.add(pickUpMarker);
      markerSet.add(destinationMarker);
    });

    Circle pickUpCircle = Circle(
      fillColor: Colors.blueAccent,
      center: pickUpLatLng,
      radius: 5,
      strokeColor: Colors.blueAccent,
      strokeWidth: 4,
      circleId: CircleId("pickUpId"),
    );

    Circle destinationCircle = Circle(
      fillColor: Colors.black,
      center: destinationLatLng,
      radius: 5,
      strokeColor: Colors.black,
      strokeWidth: 4,
      circleId: CircleId("destinationId"),
    );

    setState(() {
      circleSet.add(pickUpCircle);
      circleSet.add(destinationCircle);
    });
  }

  void acceptRideRequest(){
    String rideRequestId= widget.rideDetails.ride_request_id;
    newRequestRef.child(rideRequestId).child("status").set("accepted");
    newRequestRef.child(rideRequestId).child("driver_name").set(driversInfo.name);
    newRequestRef.child(rideRequestId).child("driver_phone").set(driversInfo.phone);
    newRequestRef.child(rideRequestId).child("driver_id").set(driversInfo.id);
    newRequestRef.child(rideRequestId).child("car_details").set('${driversInfo.car_color} - ${driversInfo.car_model}');

    Map locMap = {
      "latitude": currentPosition.latitude.toString(),
      "longitude": currentPosition.longitude.toString(),
    };
    newRequestRef.child(rideRequestId).child("driver_location").set(locMap);

    driversRef.child(currentFirebaseUser.uid).child("history").child(rideRequestId).set(true);
  }

  void updateRideDetails() async{
    if(isRequestingDirection == false){
      isRequestingDirection = true;
      if(myPosition == null){
        return;
      }

      var posLatLng = LatLng(myPosition.latitude, myPosition.longitude);
      LatLng destinationLatLng;

      if(status == "accepted"){
        destinationLatLng = widget.rideDetails.pickUp;
      }
      else{
        destinationLatLng = widget.rideDetails.destination;
      }

      var directionDetails = await AssistantMethods.obtainPlaceDirectionDetails(posLatLng, destinationLatLng);
      if(directionDetails != null){
        setState(() {
          durationRide = directionDetails.durationText;
        });
      }

      isRequestingDirection = false;
    }

  }
  
  void initTimer(){
    const interval = Duration(seconds: 1);
    timer = Timer.periodic(interval, (timer) {
      durationCounter++;
    });
  }

  endTheTrip()async{
    timer.cancel();
    
    showDialog(
      context: context,
      builder: (BuildContext context) => LoginLoad(message: "Hold On...",),
    );
    
    var currentLatLng = LatLng(myPosition.latitude, myPosition.longitude);
    var directionalDetails = await AssistantMethods.obtainPlaceDirectionDetails(widget.rideDetails.pickUp, currentLatLng);

    Navigator.pop(context);

    int fareAmount = AssistantMethods.calculateFares(directionalDetails);

    String rideRequestId = widget.rideDetails.ride_request_id;
    newRequestRef.child(rideRequestId).child("fares").set(fareAmount.toString());
    newRequestRef.child(rideRequestId).child("status").set("ended");
    rideStreamSubscription.cancel();

    showDialog(
      context: context,
      builder: (BuildContext context) => CollectFareDialog(paymentMethod: widget.rideDetails.paymentMethod, fareAmount: fareAmount,),
    );

    saveEarnings(fareAmount);

  }

  void saveEarnings(int fareAmount){
    driversRef.child(currentFirebaseUser.uid).child("earnings").once().then((DataSnapshot dataSnapShot){
      if(dataSnapShot.value != null){
        double oldEarnings = double.parse(dataSnapShot.value.toString());
        double totalEarnings = fareAmount + oldEarnings;

        driversRef.child(currentFirebaseUser.uid).child("earnings").set(totalEarnings.toStringAsFixed(2));
      }
      else{
        double totalEarnings = fareAmount.toDouble();
        driversRef.child(currentFirebaseUser.uid).child("earnings").set(totalEarnings.toStringAsFixed(2));
      }
    });
  }

}
