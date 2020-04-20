import 'package:flutter/material.dart';
import 'package:emudc_app/Bottombar.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // print(selectedIndex);
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      backgroundColor: Colors.brown,
      bottomNavigationBar: BottomBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'FAKE',
              style: TextStyle(
                fontSize: 60,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            Text(
              'DATA',
              style: TextStyle(
                fontSize: 60,
                fontWeight: FontWeight.bold,
                color: Colors.amber,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
