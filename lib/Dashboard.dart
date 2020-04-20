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

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  Future<dynamic> fetchKanban() async {
    NetworkHelper networkHelper = NetworkHelper(url);
    var data = await networkHelper.getData();
    return data;
  }

  var futureKanban;

  @override
  void initState() {
    super.initState();
    futureKanban = fetchKanban();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
      ),
      body: Center(
        child: FutureBuilder(
          future: futureKanban,
          builder: (context, snapshot) {
            List machine = [];
            List<Widget> cardList = [];
            if (snapshot.hasData) {
              machine = snapshot.data;
              for (var i = 0; i < machine.length; i++) {
                num cycleTime = machine[i]["cycleTime"];
                var cardColor;
                if (machine[i]["status"] == 5) {
                  cardColor = Colors.green;
                } else if (machine[i]["status"] == 3) {
                  cardColor = Colors.red[900];
                } else if (machine[i]["status"] == 4) {
                  cardColor = Colors.red;
                } else {
                  cardColor = Colors.grey;
                }
                cardList.add(
                  Container(
                    margin: EdgeInsets.all(3),
                    color: cardColor,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Center(
                          child: Text(machine[i]["machineNumber"]),
                        ),
                        Center(
                          child: Text(machine[i]["machineModel"]),
                        ),
                        Center(
                          child: Text(cycleTime.toString()),
                        ),
                      ],
                    ),
                  ),
                );
              }
              return GridView(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  childAspectRatio: 1.0,
                ),
                children: cardList,
              );
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            return CircularProgressIndicator();
          },
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   tooltip: 'Refresh', // used by assistive technologies
      //   child: Icon(Icons.refresh),
      //   onPressed: () {
      //     Dashboard();
      //   },
      // ),
    );
  }
}
