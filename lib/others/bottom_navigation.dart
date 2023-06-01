import 'package:first_app/activity_associated/activities.dart';
import 'package:first_app/activity_associated/challenges.dart';
import 'package:first_app/activity_associated/todays_activities.dart';
import 'package:first_app/food_associated/diary_page.dart';
import 'package:first_app/food_associated/main_page.dart';
import 'package:first_app/others/account_details.dart';
import 'package:first_app/others/user.dart';
import 'package:first_app/weight_associated/weight_graph.dart';
import 'package:flutter/material.dart';

class BottomNavi extends StatefulWidget {
  User un = User("", 0, 0, 0, 0, 0, "", "", "", "", 0, 0, 0, 0, 0, 0);
  BottomNavi(User u2) {
    un = u2;
  }
  @override
  NaviState createState() => NaviState();
}

class NaviState extends State<BottomNavi> {
  User user = User("", 0, 0, 0, 0, 0, "", "", "", "", 0, 0, 0, 0, 0, 0);
  int _currentIndex = 0;
  List _pages = [];
  @override
  void initState() {
    super.initState();
    user = widget.un;
    _pages = [
      MyApp(user),
      FoodData(user),
      WeightGraph(user),
      Activities(user),
      TodaysActivitys(user),
      Challenges(user),
      AccountDetails(user)
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.shifting,
        selectedItemColor: Colors.greenAccent,
        unselectedItemColor: Colors.white,
        currentIndex: _currentIndex,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Main',
              backgroundColor: Colors.lightBlue),
          BottomNavigationBarItem(
            icon: Icon(Icons.food_bank_outlined),
            label: 'Food Data',
            backgroundColor: Colors.cyan,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_chart_outlined),
            label: 'Weight Graph',
            backgroundColor: Colors.green[800],
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center),
            label: 'Activities',
            backgroundColor: Color.fromARGB(255, 9, 9, 174),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.sports_outlined),
            label: 'Todays Activitys',
            backgroundColor: Colors.green[800],
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.run_circle_outlined),
            label: 'Challenges',
            backgroundColor: Colors.cyan,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_box_rounded),
            label: 'Account Data',
            backgroundColor: Color.fromARGB(255, 9, 9, 174),
          ),
        ],
        onTap: (index) {
          setState(
            () {
              _currentIndex = index;
            },
          );
        },
      ),
    );
  }
}
