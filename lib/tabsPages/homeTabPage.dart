import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:taxi_express_driver/Assistants/assistantMethods.dart';
import 'package:taxi_express_driver/main.dart';
import 'package:taxi_express_driver/mapsConfig.dart';

class HomeTabPage extends StatefulWidget {

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.423424241, -122.213134131),
    zoom: 14.4123,
  );

  @override
  _HomeTabPageState createState() => _HomeTabPageState();
}

class _HomeTabPageState extends State<HomeTabPage> {
  Completer<GoogleMapController> _controller = Completer();

  GoogleMapController newGoogleMapController;

  double topPaddingOfMap = 0;

  Position currentPosition;

  var geoLocator = Geolocator();

  String driverStatusText = "Go Online !";

  Color driverStatusColor = Colors.grey;

  bool driverAvailable = false;

  void locatePosition() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    currentPosition = position;

    LatLng latLngPosition = LatLng(position.latitude, position.longitude);
    CameraPosition cameraPosition = new CameraPosition(
        target: latLngPosition, zoom: 14);
    newGoogleMapController.animateCamera(
        CameraUpdate.newCameraPosition(cameraPosition));
    /*var address = await AssistantMethods.searchCoordinateAdress(position, context);

    setState(() {
      address = address.toString();
    });
    print(address);*/

  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          mapType: MapType.normal,
          myLocationButtonEnabled: true,
          initialCameraPosition: HomeTabPage._kGooglePlex,
          myLocationEnabled: true,
          zoomGesturesEnabled: true,
          zoomControlsEnabled: true,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
            newGoogleMapController = controller;
            locatePosition();
          },
        ),

        Container(
          height: 140.0,
          width: double.infinity,
          color: Colors.black54,
        ),
        Positioned(
          top: 40.0,
          left: 0.0,
          right: 0.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Container(
                  // ignore: deprecated_member_use
                  child: RaisedButton(
                    onPressed: () {
                      if(driverAvailable != true){
                        putDriverOnline();
                        getLocationLiveUpdates();

                        setState(() {
                          driverStatusColor = Color.fromRGBO(146, 27, 31, 1);
                          driverStatusText = "You're Online !";
                          driverAvailable = true;
                        });
                        displayToastMessage("You're Online Now", context);

                      }
                      else{
                        putDriverOffline();
                        setState(() {
                          driverStatusColor = Colors.grey;
                          driverStatusText = "Go Online !";
                          driverAvailable = false;
                        });

                        displayToastMessage("You're Offline Now", context);
                      }
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    color: driverStatusColor,
                    child: Padding(
                      padding: const EdgeInsets.all(17.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            driverStatusText,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              height: 1.5,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            width: 12,
                          ),
                          Icon(
                            Icons.wifi,
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

      ],
    );
  }

  void putDriverOnline() async{
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    currentPosition = position;

    Geofire.initialize("availableDrivers");
    Geofire.setLocation(currentFirebaseUser.uid, currentPosition.latitude, currentPosition.longitude);

    rideRequestRef.onValue.listen((event) {

    });
  }

  void getLocationLiveUpdates(){
    homeTabPageStreamSubscription = Geolocator.getPositionStream().listen((Position position) {
      currentPosition = position;
      if(driverAvailable == true){
        Geofire.setLocation(currentFirebaseUser.uid, position.latitude, position.longitude);
      }
      LatLng latLng = LatLng(position.latitude, position.longitude);
      newGoogleMapController.animateCamera(CameraUpdate.newLatLng(latLng));
    });
  }

  void putDriverOffline(){
    Geofire.removeLocation(currentFirebaseUser.uid);
    rideRequestRef.onDisconnect();
    rideRequestRef.remove();
  }

  displayToastMessage(String msg, BuildContext context, ) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.black,
      textColor: Colors.white,
      fontSize: 20,
    );
  }
}