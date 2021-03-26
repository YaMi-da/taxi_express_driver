import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class Users {
  String id;
  String name;
  String email;

  Users({this.id, this.name, this.email});

  Users.fromSnapshot(DataSnapshot dataSnapshot){
    id = dataSnapshot.key;
    email = dataSnapshot.value["email"];
    name = dataSnapshot.value["name"];
  }
}