import 'dart:async';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:taxi_express_driver/Models/Users.dart';

import 'Models/drivers.dart';

String mapkey = "AIzaSyAuBdVRNHIXcARUTjZEp68kyNrFRSk1Xwg";

User firebaseUser;

Users usersCurrentInfo;

User currentFirebaseUser;

StreamSubscription<Position> homeTabPageStreamSubscription;

StreamSubscription<Position> rideStreamSubscription;

final assetAudioPlayer = AssetsAudioPlayer();

Position currentPosition;

Drivers driversInfo;

String title= "";

double starCounter= 0.0;

String rideType = "";