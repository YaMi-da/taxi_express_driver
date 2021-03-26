import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:taxi_express_driver/Models/Users.dart';

String mapkey = "AIzaSyAuBdVRNHIXcARUTjZEp68kyNrFRSk1Xwg";

User firebaseUser;

Users usersCurrentInfo;

User currentFirebaseUser;

StreamSubscription<Position> homeTabPageStreamSubscription;