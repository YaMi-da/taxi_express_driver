import 'package:firebase_database/firebase_database.dart';

class Drivers{
  String email;
  String name;
  String phone;
  String id;
  String car_color;
  String car_license;
  String car_model;
  String car_number;

  Drivers({this.email, this.name, this.phone, this.id, this.car_color, this.car_license, this.car_model, this.car_number});
  Drivers.fromSnapShot(DataSnapshot dataSnapShot){
    id = dataSnapShot.key;
    phone = dataSnapShot.value["phone"];
    email = dataSnapShot.value["email"];
    name = dataSnapShot.value["name"];
    car_color = dataSnapShot.value["car_info"]["car_color"];
    car_license = dataSnapShot.value["car_info"]["car_license"];
    car_model = dataSnapShot.value["car_info"]["car_model"];
    car_number = dataSnapShot.value["car_info"]["car_number"];
  }
}