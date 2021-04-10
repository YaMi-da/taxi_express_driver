import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:taxi_express_driver/Assistants/assistantMethods.dart';
import 'package:taxi_express_driver/Models/history.dart';

class HistoryItem extends StatelessWidget {

  final History history;
  HistoryItem({this.history});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: Row(
                  children: <Widget>[
                    Icon(
                      FontAwesomeIcons.mapMarkerAlt,
                      color: Color.fromRGBO(146, 27, 31, 1),
                      size: 18,
                    ),
                    SizedBox(width: 18,),
                    Expanded(
                      child: Container(
                        child: Text(
                          history.pickUp,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 5,),
                    Text(
                      '\$${history.fares}',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    )
                  ],
                ),
              ),

              SizedBox(height: 8,),

              Row(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Icon(
                    FontAwesomeIcons.mapMarkedAlt,
                    color: Color.fromRGBO(146, 27, 31, 1),
                    size: 18,
                  ),
                  SizedBox(width: 18,),
                  Text(
                    history.destination,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 15,),

              Text(
                AssistantMethods.formatTripDate(history.createdAt),
                style: TextStyle(
                  color: Colors.grey,
                ),
              )

            ],
          )
        ],
      ),
    );
  }
}
