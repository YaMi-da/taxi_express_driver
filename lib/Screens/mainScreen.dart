import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:provider/provider.dart';
import 'package:taxi_express_driver/Data/appData.dart';
import 'package:taxi_express_driver/Models/directionDetails.dart';
import 'package:taxi_express_driver/Widgets/SearchDivider.dart';
import 'package:taxi_express_driver/Widgets/createMap2.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geocoder/services/base.dart';
import 'package:geocoder/services/distant_google.dart';

import 'package:taxi_express_driver/Assistants/assistantMethods.dart';
import 'package:taxi_express_driver/Screens/searchScreen.dart';
import 'package:taxi_express_driver/Widgets/loginLoad.dart';
import 'package:taxi_express_driver/mapsConfig.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}


class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin{


  Completer<GoogleMapController> _controller = Completer();
  GoogleMapController newGoogleMapController;
  List<LatLng> polylineCoordinates = [];
  Set<Polyline> polylineSet = {};
  Set<Marker> markerSet = {};
  Set<Circle> circleSet = {};

  double rideDetailsContainerHeight = 0;
  double requestRiderContainerHeight = 0;
  double searchContainerHeight = 290;

  bool drawerOpen = true;

  DatabaseReference rideRequestRef;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    AssistantMethods.getCurrentOnlineUserInfo();
  }

  void saveRideRequest(){
    rideRequestRef = FirebaseDatabase.instance.reference().child("Ride Requests");
    
    var pickUp = Provider.of<AppData>(context, listen: false).pickUpLocation;
    var destination = Provider.of<AppData>(context, listen: false).destinationLocation;

    Map pickUpLocMap = {
      "latitude" : pickUp.latitude.toString(),
      "longitude" : pickUp.longitude.toString(),
    };

    Map destinationLocMap = {
      "latitude" : destination.latitude.toString(),
      "longitude" : destination.longitude.toString(),
    };

    Map rideInfoMap = {
      "driverId" : "waiting..",
      "paymentMethod" : "cash",
      "pickUp" : pickUpLocMap,
      "destination" : destinationLocMap,
      "createdAt" : DateTime.now().toString(),
      "riderName" : usersCurrentInfo.name,
      "riderEmail" : usersCurrentInfo.email,
      "pickUpAdress" : pickUp.placeName,
      "destinationAdress" : destination.placeName,
    };

    rideRequestRef.push().set(rideInfoMap);
  }

  void cancelRideRequest(){
    rideRequestRef.remove();


  }

  void displayRequestRiderContainer(){
    setState(() {
      requestRiderContainerHeight = 260;
      rideDetailsContainerHeight = 0;
      bottomPaddingOfMap = 260.0;
      drawerOpen = true;
    });

    saveRideRequest();
  }

  resetApp(){
    setState(() {
      drawerOpen = true;
      searchContainerHeight = 290;
      rideDetailsContainerHeight = 0;
      requestRiderContainerHeight = 0;
      bottomPaddingOfMap = 290.0;

      polylineSet.clear();
      markerSet.clear();
      circleSet.clear();
      polylineCoordinates.clear();
    });

    locatePosition();
  }

  void displayRideDetailsContainer() async{
     await getPlaceDirection();

     setState(() {
       searchContainerHeight = 0;
       rideDetailsContainerHeight = 245.0;
       bottomPaddingOfMap = 245.0;
       drawerOpen = false;
     });
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png)).buffer.asUint8List();
  }


  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  DirectionDetails tripDirectionDetails;

  Position currentPosition;
  var geoLocator = Geolocator();
  double bottomPaddingOfMap = 0;
  var add;


  void locatePosition() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    currentPosition = position;

    LatLng latLngPosition = LatLng(position.latitude, position.longitude);
    CameraPosition cameraPosition = new CameraPosition(
        target: latLngPosition, zoom: 14);
    newGoogleMapController.animateCamera(
        CameraUpdate.newCameraPosition(cameraPosition));
    var address = await AssistantMethods.searchCoordinateAdress(position, context);

    setState(() {
      address = address.toString();
    });
    print(address);

  }

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.423424241, -122.213134131),
    zoom: 14.4123,
  );




  String googleAPIKey = "AIzaSyAuBdVRNHIXcARUTjZEp68kyNrFRSk1Xwg";

  @override
  Widget build(BuildContext context) {
    const colorizeColors = [
      Colors.purple,
      Colors.blue,
      Colors.yellow,
      Colors.red,
    ];

    const colorizeTextStyle = TextStyle(
      fontSize: 40.0,
    );

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        brightness: Brightness.dark,
        toolbarHeight: 0,
        backgroundColor: Colors.black,
      ),
      drawer: Container(
        color: Colors.white,
        width: 250,
        child: Drawer(
          child: ListView(
            children: [
              Container(
                height: 165,
                child: DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.grey[400].withOpacity(0.4),
                        child: Icon(
                          FontAwesomeIcons.user,
                          size: 30,
                          color: Color.fromRGBO(146, 27, 31, 1),
                        ),
                      ),
                      SizedBox(height: 16.0, width: 20,),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Profile",
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 6.0,),
                          Text("Visit Profile"),
                        ],
                      )
                    ],
                  ),
                ),
              ),

              DividerWidget(),

              SizedBox(height: 12.0,),

              ListTile(
                leading: Icon(
                  Icons.history,
                ),
                title: Text(
                  "History",
                  style: TextStyle(
                    fontSize: 15.0,
                  ),
                ),
              ),
              ListTile(
                leading: Icon(
                  Icons.person,
                ),
                title: Text(
                  "Visit Profile",
                  style: TextStyle(
                    fontSize: 15.0,
                  ),
                ),
              ),
              ListTile(
                leading: Icon(
                  Icons.info,
                ),
                title: Text(
                  "About",
                  style: TextStyle(
                    fontSize: 15.0,
                  ),
                ),
              ),
              GestureDetector(
                onTap: (){
                  FirebaseAuth.instance.signOut();
                  Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
                },
                child: ListTile(
                  leading: Icon(
                    Icons.logout,
                  ),
                  title: Text(
                    "Log Out",
                    style: TextStyle(
                      fontSize: 15.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Stack(
        children: <Widget>[
          GoogleMap(
            padding: EdgeInsets.only(bottom: bottomPaddingOfMap),
            mapType: MapType.normal,
            myLocationButtonEnabled: true,
            initialCameraPosition: _kGooglePlex,
            myLocationEnabled: true,
            zoomGesturesEnabled: true,
            zoomControlsEnabled: true,
            polylines: polylineSet,
            markers: markerSet,
            circles: circleSet,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
              newGoogleMapController = controller;

              setState(() {
                bottomPaddingOfMap = 290.0;
              });
              locatePosition();
            },
          ),

          Positioned(
            top: 38.0,
            left: 22.0,
            child: GestureDetector(
              onTap: (){
                if(drawerOpen){
                  scaffoldKey.currentState.openDrawer();
                }
                else{
                  resetApp();
                }
              },
              child: Container(
                decoration: BoxDecoration(
                    color: Color.fromRGBO(146, 27, 31, 1),
                    borderRadius: BorderRadius.circular(22.0),
                    boxShadow: [BoxShadow(
                      color: Colors.black,
                      blurRadius: 6.0,
                      spreadRadius: 0.5,
                      offset: Offset(
                        0.7,
                        0.7,
                      ),
                    ),
                    ]
                ),
                child: CircleAvatar(
                  backgroundColor: Color.fromRGBO(146, 27, 31, 1),
                  child: Icon(
                    (drawerOpen) ? Icons.menu_rounded : Icons.close_rounded,
                    color: Colors.black,
                  ),
                  radius: 20.0,
                ),
              ),
            ),
          ),

        ],
      ),
    );
  }

  Future<void> getPlaceDirection() async{
    var initialPos = Provider.of<AppData>(context, listen: false).pickUpLocation;
    var finalPos = Provider.of<AppData>(context, listen: false).destinationLocation;

    var pickUpLatLng = LatLng(initialPos.latitude, initialPos.longitude);
    var destinationLatLng = LatLng(finalPos.latitude, finalPos.longitude);

    showDialog(
      context: context,
      builder: (BuildContext context) => LoginLoad(message: "hold on",)
    );

    var details = await AssistantMethods.obtainPlaceDirectionDetails(pickUpLatLng, destinationLatLng);
    setState(() {
      tripDirectionDetails = details;
    });

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

   newGoogleMapController.animateCamera(CameraUpdate.newLatLngBounds(latLngBounds, 70));

    final Uint8List pickUpIcon = await getBytesFromAsset('images\\pickup_marker.png', 110);
    final Uint8List destinationIcon = await getBytesFromAsset('images\\destination_marker.png', 100);

   Marker pickUpMarker = Marker(
     icon: BitmapDescriptor.fromBytes(pickUpIcon),
     infoWindow: InfoWindow(title: initialPos.placeName, snippet: "You're Here"),
     position: pickUpLatLng,
     markerId: MarkerId("pickUpId"),
   );


    Marker destinationMarker = Marker(
      icon: BitmapDescriptor.fromBytes(destinationIcon),
      infoWindow: InfoWindow(title: finalPos.placeName, snippet: "Your Destination"),
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

}