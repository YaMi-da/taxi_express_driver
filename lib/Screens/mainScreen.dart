import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:taxi_express_driver/tabsPages/homeTabPage.dart';
import 'package:taxi_express_driver/tabsPages/profileTabPage.dart';
import 'package:taxi_express_driver/tabsPages/profitTabPage.dart';
import 'package:taxi_express_driver/tabsPages/ratingTabPage.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with SingleTickerProviderStateMixin{

  TabController tabController;
  int selectedIndex = 0;

  void onItemClick(int index){
    setState(() {
      selectedIndex = index;
      tabController.index = selectedIndex;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    tabController.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.dark,
        toolbarHeight: 0,
        backgroundColor: Colors.black,
      ),
      body: TabBarView(
        physics: NeverScrollableScrollPhysics(),
        controller: tabController,
        children: [
          HomeTabPage(),
          ProfitTabPage(),
          RatingTabPage(),
          ProfileTabPage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items:<BottomNavigationBarItem> [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded, size: 35,),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.attach_money_rounded, size: 35,),
            label: "Profit",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star, size: 35,),
            label: "Rating",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, size: 35,),
            label: "Account",
          ),
        ],
        unselectedItemColor: Colors.black54,
        unselectedLabelStyle: TextStyle(fontSize: 15.0),
        selectedItemColor: Color.fromRGBO(146, 27, 31, 1),
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: TextStyle(fontSize: 15.0),
        showSelectedLabels: true,
        currentIndex: selectedIndex,
        onTap: onItemClick,
      ),
    );
  }
}
