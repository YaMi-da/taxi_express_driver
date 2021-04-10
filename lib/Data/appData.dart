import 'package:flutter/material.dart';
import 'package:taxi_express_driver/Models/addresses.dart';
import 'package:taxi_express_driver/Models/history.dart';

class AppData extends ChangeNotifier{
  String profit = "0";
  int countTrip = 0;
  List<String> tripHistoryKeys = [];
  List<History> tripHistoryDataList = [];

  void updateProfit(String updatedProfit){
    profit = updatedProfit;
    notifyListeners();
  }

  void updateTripsCounter(int tripCounter){
    countTrip = tripCounter;
    notifyListeners();
  }

  void updateTripKeys(List<String> newKeys ){
    tripHistoryKeys = newKeys;
    notifyListeners();
  }

  void updateTripHistoryData(History eachHistory ){
    tripHistoryDataList.add(eachHistory);
    notifyListeners();
  }

}