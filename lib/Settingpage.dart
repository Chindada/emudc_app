import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:emudc_app/Homepage.dart';

String url = 'http://$serverIP/iomfake/settings';

class NetworkHelper {
  NetworkHelper(this.url);

  final String url;

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

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  Future<dynamic> getSettings() async {
    var networkHelper = NetworkHelper(url);
    var data = await networkHelper.getData();
    return data;
  }

  var settings;
  @override
  void initState() {
    super.initState();
    settings = getSettings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
            child: IconButton(
              icon: Icon(Icons.search),
              tooltip: 'Search',
              iconSize: 30,
              onPressed: null,
            ),
          ),
        ],
      ),
      body: Center(
        child: FutureBuilder(
          future: settings,
          builder: (context, snapshot) {
            // List temp = [];
            List<Widget> settingList = [];

            if (snapshot.hasData) {
              var temp = snapshot.data;
              for (var i = 0; i < temp.length; i++) {
                settingList.add(
                  _tile(temp[i]['key'], temp[i]['value'], Icons.accessible),
                );
              }
              return ListView(
                children: settingList,
              );
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            return CircularProgressIndicator();
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Refresh', // used by assistive technologies
        child: Icon(Icons.refresh),
        onPressed: null,
      ),
    );
  }
}

ListTile _tile(String title, String subtitle, IconData icon) => ListTile(
      title: Text(title,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 20,
          )),
      subtitle: Text(subtitle),
      leading: Icon(
        icon,
        color: Colors.blue[500],
      ),
    );
