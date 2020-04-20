import 'package:flutter/material.dart';
import 'package:emudc_app/Dashboard.dart';
import 'package:emudc_app/Godmode.dart';
import 'package:emudc_app/Settingpage.dart';

int selectedIndex = 0;

class BottomBar extends StatefulWidget {
  @override
  _BottomBarState createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  void onItemTapped(int index) {
    setState(() {
      // selectedIndex = index;
      if (index == 1) {
        // Navigator.pop(context);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Dashboard()));
      } else if (index == 2) {
        // Navigator.pop(context);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => GodMode()));
      } else if (index == 3) {
        // Navigator.pop(context);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => SettingPage()));
      }
      // print(selectedIndex);
    });
  }

  @override
  Widget build(BuildContext context) {
    // print(selectedIndex);
    return BottomNavigationBar(
      showSelectedLabels: false,
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          title: Text('Start'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.dashboard),
          title: Text(''),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.flare),
          title: Text('God '),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          title: Text(''),
        ),
      ],
      // currentIndex: selectedIndex,
      // selectedItemColor: Colors.amber[800],
      onTap: onItemTapped,
    );
  }
}
