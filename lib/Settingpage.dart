import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const ip = '61.220.105.113:8885';
const url = 'http://$ip/ioms5data/analyze/kanban/machinestatus';

class NetworkHelper {
  NetworkHelper(this.url);

  final String url;

  Future getData() async {
    http.Response response = await http.get(url, headers: {
      "workShopNumber": "1",
    });

    if (response.statusCode == 200) {
      String data = response.body;
      // print(jsonDecode(data));
      return jsonDecode(data)["data"];
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
  Future<dynamic> fetchKanban() async {
    NetworkHelper networkHelper = NetworkHelper(url);
    var data = await networkHelper.getData();
    return data;
  }

  var machines;
  @override
  void initState() {
    super.initState();
    machines = fetchKanban();
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
          future: machines,
          builder: (context, snapshot) {
            // List temp = [];
            // List<Widget> machineList = [];

            if (snapshot.hasData) {
              // temp = snapshot.data;
              // for (var i = 0; i < temp.length; i++) {
              //   machineList.add(
              //     _tile(temp[i]['machineNumber'], temp[i]['machineModel'],
              //         Icons.devices),
              //   );
              // }
              return ListView(
                children: <Widget>[
                  _tile('IP', 'fakedata', Icons.network_wifi),
                ],
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
