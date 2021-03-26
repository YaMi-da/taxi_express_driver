import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:flutter/widgets.dart';
import 'package:taxi_express_driver/Assistants/requestAssistant.dart';
import 'package:taxi_express_driver/Data/appData.dart';
import 'package:taxi_express_driver/Models/addresses.dart';
import 'package:taxi_express_driver/Models/placesPredictions.dart';
import 'package:taxi_express_driver/Widgets/SearchDivider.dart';
import 'package:taxi_express_driver/Widgets/loginLoad.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}


class _SearchScreenState extends State<SearchScreen> {

  TextEditingController pickUpController = TextEditingController();
  TextEditingController destinationController = TextEditingController();
  List<PlacePredictions> placePredictionList = [];


  @override
  Widget build(BuildContext context) {

    String placeAdress = Provider.of<AppData>(context).pickUpLocation.placeName ?? "";
    pickUpController.text = placeAdress;


    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.dark,
        toolbarHeight: 0,
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 230.0,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30.0),
                  bottomRight: Radius.circular(30.0),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black,
                    blurRadius: 9.0,
                    spreadRadius: 0.5,
                    offset: Offset(0.7, 0.7),
                  )
                ]
              ),

              child: Padding(
                padding: EdgeInsets.only(left: 20.0, top: 25.0, right: 25.0,
                    bottom: 20.0),
                child: Column(
                  children: [
                    SizedBox(height: 5.0,),
                    Stack(
                      children: [
                        GestureDetector(
                          onTap: (){
                            Navigator.pop(context);
                          },
                          child: Icon(
                            Icons.arrow_back_ios,
                          ),
                        ),
                        Center(
                          child: Text(
                            "Where Do You Want To Go?",
                            style: TextStyle(
                              height: 1.2,
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 20.0,),
                    Row(
                      children: [
                        Icon(
                          FontAwesomeIcons.mapMarkerAlt,
                          color: Color.fromRGBO(146, 27, 31, 1),
                          size: 18,
                        ),
                        SizedBox(width: 18.0,),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[500].withOpacity(0.5),
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(3.0),
                              child: TextField(
                                cursorColor: Color.fromRGBO(146, 27, 31, 1),
                                textInputAction: TextInputAction.next,
                                controller: pickUpController,
                                decoration: InputDecoration(
                                  hintText: "Your Pick Up Location",
                                  hintStyle: TextStyle(
                                    height: 1.5,
                                  ),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.only(left: 11.0,
                                      top: 8, bottom: 8.0),
                                ),
                                style: TextStyle(
                                  height: 1.5,
                                ),
                              ),
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
                        SizedBox(width: 18.0,),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[500].withOpacity(0.5),
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(3.0),
                              child: TextField(
                                onChanged: (val){
                                  findPlace(val);
                                },
                                cursorColor: Color.fromRGBO(146, 27, 31, 1),
                                textInputAction: TextInputAction.done,
                                controller: destinationController,
                                decoration: InputDecoration(
                                  hintText: "Where do You Wanna go?",
                                  hintStyle: TextStyle(
                                    height: 1.5,
                                  ),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.only(left: 11.0,
                                      top: 8, bottom: 8.0),
                                ),
                                style: TextStyle(
                                  height: 1.5,
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 10,),

            (placePredictionList.length>0) ?
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: ListView.separated(
                padding: EdgeInsets.all(0.0),
                itemBuilder: (context, index){
                  return PredictionTile(placePredictions: placePredictionList[index],);
                },
                separatorBuilder: (BuildContext context, int index) => DividerWidget(),
                itemCount: placePredictionList.length,
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
              ),
            ) : Container()
          ],
        ),
      ),
    );
  }

  void findPlace(String placename)async{
    if(placename.length>1){
      String autoCompleteURL= "https://maps.googleapis"
          ".com/maps/api/place/autocomplete/json?input=$placename&key"
          "=AIzaSyAuBdVRNHIXcARUTjZEp68kyNrFRSk1Xwg&sessiontoken=1234567890&components=country:ma";
      var res = await RequestAssistant.getRequest(autoCompleteURL);
      if(res == "failed"){
        return;
      }
      if(res["status"] == "OK"){
        var predictions = res["predictions"];
        var placesList = (predictions as List).map((e) => PlacePredictions.fromJson(e)).toList();
        setState(() {
          placePredictionList = placesList;
        });

      }
    }
  }
}

class PredictionTile extends StatelessWidget {

  SearchScreen searchScreen = new SearchScreen();

  final PlacePredictions placePredictions;
  PredictionTile({Key key, this.placePredictions}) : super(key : key);


  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return FlatButton(
      padding: EdgeInsets.all(0.0),
      onPressed: () {

        getPlaceAdressDetails(placePredictions.place_id, context);

      },
      child: Container(
        child: Column(
          children: [
            SizedBox(width: 10.0,),
            Row(
              children: [
                Icon(FontAwesomeIcons.searchLocation, color: Color.fromRGBO(146, 27, 31, 1) ,),
                SizedBox(
                  width: 14.0,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10.0,),
                      Text(
                        placePredictions.main_text,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 16.0),
                      ),
                      SizedBox(height: 5.0,),
                      Text(
                        placePredictions.secondary_text,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 12.0, color: Colors.grey),
                      ),
                      SizedBox(height: 10.0,),
                    ],
                  ),
                )
              ],
            ),
            SizedBox(width: 10.0,),
          ],
        ),
      ),
    );
  }

  void getPlaceAdressDetails(String placeId, context) async{

    showDialog(
      context: context,
      builder: (BuildContext context) => LoginLoad(message: "Setting Your "
          "Destination",)
    );

    String placeDetailsURL = "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=AIzaSyAuBdVRNHIXcARUTjZEp68kyNrFRSk1Xwg";

    var res = await RequestAssistant.getRequest(placeDetailsURL);

    Navigator.pop(context);

    if(res == "failed"){
      return;
    }
    var placeAdress;
    var st0, st1;

    if(res["status"] == "OK"){
      st0 = res["result"]["name"];
      st1 = res["result"]["formatted_address"];

      Address destinationAddress = Address();

      destinationAddress.placeId = placeId;
      destinationAddress.latitude = res["result"]["geometry"]["location"]["lat"];
      destinationAddress.longitude = res["result"]["geometry"]["location"]["lng"];

      placeAdress = st0 + ", " + st1;

      destinationAddress.placeName = placeAdress;

      Provider.of<AppData>(context, listen: false).updateDestinationLocationAddress(destinationAddress);
      print("this is where u wanna go ::");
      print(placeAdress);
      
      Navigator.pop(context, "obtainDirection");
    }
  }

}

