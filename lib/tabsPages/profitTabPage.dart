import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taxi_express_driver/Data/appData.dart';
import 'package:taxi_express_driver/Screens/historyScreen.dart';
import 'package:taxi_express_driver/Widgets/SearchDivider.dart';

class ProfitTabPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: Colors.black87,
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 150),
            child: Column(
              children: [
                Text(
                  'Total Profit',
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 10,),
                Text(
                  "\$${Provider.of<AppData>(context, listen: false).profit}",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 60,
                  ),
                ),
              ],
            ),
          ),
        ),
        // ignore: deprecated_member_use
        FlatButton(
          padding: EdgeInsets.all(0),
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => HistoryScreen()));
          },
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            child: Row(
              children: [
                Image.asset("images\\normal_car.png", width: 70,),
                SizedBox(width: 16,),
                Text(
                  'Total Trips',
                  style: TextStyle(fontSize: 16),
                ),
                Expanded(
                  child: Container(
                    child: Text(
                      Provider.of<AppData>(context, listen: false).countTrip.toString(),
                      textAlign: TextAlign.end,
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        DividerWidget(),


      ],
    );
  }
}