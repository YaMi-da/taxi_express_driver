import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geocoder/services/base.dart';
import 'package:geocoder/services/distant_google.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taxi_express_driver/Assistants/assistantMethods.dart';
import 'package:taxi_express_driver/Data/appData.dart';
import 'package:taxi_express_driver/Screens/searchScreen.dart';
import 'dart:async';
import 'package:taxi_express_driver/Widgets/SearchDivider.dart';
import 'package:taxi_express_driver/Widgets/loginLoad.dart';


class MapPage2 extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MapPage2State();
}
class MapPage2State extends State<MapPage2> {

  Completer<GoogleMapController> _controller = Completer();
  GoogleMapController newGoogleMapController;
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints;


  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  Position currentPosition;
  var geoLocator = Geolocator();
  double bottomPaddingOfMap = 0;
  var add;



  /*getAdressBasedOnLocation(Position position) async{
    final coodinates = new Coordinates(position.latitude, position.longitude);
    var address = await Geocoder.google("AIzaSyAuBdVRNHIXcARUTjZEp68kyNrFRSk1Xwg").findAddressesFromCoordinates(coodinates);
    setState(() {
      add = address.first;
    });
    print("${add.addressLine} : ${add.coordinates.latitude} , ${add.coordinates.longitude}");
  }*/

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
            top: 45.0,
            left: 22.0,
            child: GestureDetector(
              onTap: (){
                scaffoldKey.currentState.openDrawer();
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
                    Icons.menu_rounded,
                    color: Colors.black,
                  ),
                  radius: 20.0,
                ),
              ),
            ),
          ),

          Positioned(
            left: 0.0,
            right: 0.0,
            bottom: 0.0,
            child: Container(
              height: 290,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15.0),
                  topRight: Radius.circular(15.0),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black,
                    blurRadius: 16.0,
                    spreadRadius: 0.5,
                    offset: Offset(0.7,0.7),
                  )
                ]
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 18.0,
                    horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 6.0,
                    ),
                    Text(
                      "Hello.",
                      style: TextStyle(
                        fontSize: 15.0,
                      ),
                    ),
                    SizedBox(
                      height: 2.0,
                    ),
                    Text(
                      "Where to?",
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    GestureDetector(
                      onTap: () async {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> SearchScreen()));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.grey[500].withOpacity(0.5),
                            borderRadius: BorderRadius.circular(50.0),
                            /*boxShadow: [
                              BoxShadow(
                                color: Colors.black54,
                                blurRadius: 6.0,
                                spreadRadius: 0.5,
                                offset: Offset(0.7,0.7),
                              ),
                            ]*/
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              SizedBox(
                                height: 30,
                                width: 10.0,
                              ),
                              Icon(
                                FontAwesomeIcons.search,
                                color: Color.fromRGBO(146, 27, 31, 1),
                              ),
                              SizedBox(
                                height: 20,
                                width: 10.0,
                              ),
                              Text(
                                "Search",
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 24.0,
                    ),
                    Row(
                      children: [
                        Icon(
                          FontAwesomeIcons.mapMarkerAlt,
                          color: Colors.grey,
                          size: 30,
                        ),
                        SizedBox(
                          width: 12.0,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Your Current Location",
                              style: TextStyle(
                                color: Color.fromRGBO(146, 27, 31, 1),
                                fontSize: 13.0,
                                fontWeight: FontWeight.bold,
                              ),),
                            SizedBox(height: 7.0,),
                            ConstrainedBox(
                              constraints: BoxConstraints(
                                minWidth: 300.0,
                                maxWidth: 310.0,
                                minHeight: 10.0,
                                maxHeight: 80.0,
                              ),
                              child: Text(
                                Provider.of<AppData>(context).pickUpLocation !=
                                    null ? Provider.of<AppData>(context)
                                    .pickUpLocation.placeName : "Your Current Location",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    SizedBox(
                      height: 13.0,
                    ),
                    DividerWidget(),
                    SizedBox(height: 16.0,),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<void> getPlaceDirection(context) async{

    showDialog(
      context: context,
      builder: (BuildContext context) => LoginLoad(message: "hold on...",)
    );

  }

}

