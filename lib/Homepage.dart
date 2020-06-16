import 'package:flutter/material.dart';
import 'package:emudc_app/Bottombar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const serverIP = '61.220.105.114:9001';
var ip;
String url = 'http://$serverIP/iomfake/settings';

class NetworkHelper {
  var url;
  NetworkHelper(this.url);
  Future getData() async {
    http.Response response = await http.get(url);

    if (response.statusCode == 200) {
      String data = response.body;
      // print(jsonDecode(data));
      return jsonDecode(data);
    } else {
      print(response.statusCode);
    }
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void getIP() async {
    print('get ip');
    var networkHelper = NetworkHelper(url);
    var data = await networkHelper.getData();
    for (var i = 0; i < data.length; i++) {
      if (data[i]['key'] == 'ip') {
        ip = data[i]['value'];
      }
    }
    print(ip);
  }

  @override
  void initState() {
    super.initState();
    getIP();
  }

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
      floatingActionButton: FloatingActionButton(
        tooltip: 'Refresh', // used by assistive technologies
        child: Icon(Icons.refresh),
        onPressed: () {
          getIP();
        },
      ),
    );
  }
}
