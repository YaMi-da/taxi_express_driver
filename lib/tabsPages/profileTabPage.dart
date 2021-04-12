import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:taxi_express_driver/main.dart';
import 'package:taxi_express_driver/mapsConfig.dart';

class ProfileTabPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 300,
              decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(40.0),
                    bottomRight: Radius.circular(40.0),
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    driversInfo.name,
                    style: TextStyle(
                      fontSize: 65.0,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 15,),
                  SizedBox(
                    height: 0,
                    width: 340,
                    child: Divider(
                      color:  Color.fromRGBO(146, 27, 31, 1),
                      thickness: 3,
                    ),
                  ),
                  SizedBox(height: 20,),
                  Text(
                    "Driver",
                    style: TextStyle(
                      fontSize: 25.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 35.0,),

            InfoCard(
              text: driversInfo.phone,
              icon: Icons.phone_rounded,
              onPressed: () async{
                print("phone number");
              },
            ),

            SizedBox(
              height: 0,
              width: 340,
              child: Divider(
                color: Colors.black,
                thickness: 2,
              ),
            ),

            InfoCard(
              text: driversInfo.email,
              icon: Icons.email_rounded,
              onPressed: () async{
                print("email");
              },
            ),

            SizedBox(
              height: 0,
              width: 340,
              child: Divider(
                color: Colors.black,
                thickness: 2,
              ),
            ),

            InfoCard(
              text: driversInfo.car_color + " " + driversInfo.car_model + " " + driversInfo.car_number,
              icon: Icons.car_repair,
              onPressed: () async{
                print("car info");
              },
            ),

            SizedBox(
              height: 0,
              width: 340,
              child: Divider(
                color: Colors.black,
                thickness: 2,
              ),
            ),

            SizedBox(height: 50,),

            GestureDetector(
              onTap: (){
                Geofire.removeLocation(currentFirebaseUser.uid);
                rideRequestRef.onDisconnect();
                rideRequestRef.remove();
                rideRequestRef = null;

                FirebaseAuth.instance.signOut();
                Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
              },
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                color: Color.fromRGBO(146, 27, 31, 1),
                margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 125.0),
                child: ListTile(
                  trailing: Icon(
                    Icons.logout,
                    color: Colors.white,
                  ),
                  title: Text(
                    "Sign Out",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class InfoCard extends StatelessWidget {

  final String text;
  final IconData icon;
  Function onPressed;

  InfoCard({this.text, this.icon, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Card(
        shadowColor: Colors.transparent,
        color: Colors.transparent,
        margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
        child: ListTile(
          leading: Icon(
            icon,
            color: Colors.black,
          ),
          title: Text(
            text,
            style: TextStyle(
              color: Colors.black,
              fontSize: 16.0,
            ),
          ),
        ),
      ),
    );
  }
}

