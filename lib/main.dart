import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(EmuApp());
}

class EmuApp extends StatelessWidget {
  const EmuApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'emuApp',
      home: widgetOptions.elementAt(selectedIndex),
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // print(selectedIndex);
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      backgroundColor: Colors.teal[900],
      bottomNavigationBar: BottomBar(),
      body: Center(
        child: Text(
          'FAKE DATA',
          style: TextStyle(
            fontSize: 60,
            fontWeight: FontWeight.bold,
            color: Colors.amber,
          ),
        ),
      ),
    );
  }
}

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  var futureKanban;

  @override
  void initState() {
    super.initState();
    futureKanban = fetchKanban();
    // print(futureKanban);
  }

  @override
  Widget build(BuildContext context) {
    // print(futureKanban);
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
      ),
      // bottomNavigationBar: BottomBar(),
      body: Center(
        child: FutureBuilder(
          future: futureKanban,
          builder: (context, snapshot) {
            List machine = [];
            List<Widget> cardList = [];
            // print(snapshot.data.machineNumber);
            if (snapshot.hasData) {
              machine = snapshot.data;
              // return Text(snapshot.data);
              for (var i = 1; i < machine.length; i++) {
                // print(machine[i]);
                // double cycleTime = machine[i]["cycleTime"];
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
                      ],
                    ),
                  ),
                );
              }
              return GridView(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4, //横轴三个子widget
                    childAspectRatio: 1.0 //宽高比为1时，子widget
                    ),
                children: cardList,
              );
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }

            // By default, show a loading spinner.
            return CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}

class GodMode extends StatelessWidget {
  // final List<ListItem> items = [];
  final items = List<ListItem>.generate(
    1000,
    (i) => i % 6 == 0
        ? HeadingItem("Heading $i")
        : MessageItem("Sender $i", "Message body $i"),
  );
  @override
  Widget build(BuildContext context) {
    // print(selectedIndex);
    return Scaffold(
      appBar: AppBar(
        title: Text('God Mode'),
      ),
      // bottomNavigationBar: BottomBar(),
      // body: Center(
      //   child: widgetOptions.elementAt(selectedIndex),
      // ),
      body: ListView.builder(
          // Let the ListView know how many items it needs to build.
          itemCount: items.length,
          // Provide a builder function. This is where the magic happens.
          // Convert each item into a widget based on the type of item it is.
          itemBuilder: (context, index) {
            final item = items[index];

            return ListTile(
              title: item.buildTitle(context),
              subtitle: item.buildSubtitle(context),
            );
          }),
      // backgroundColor: Colors.white,
    );
  }
}

abstract class ListItem {
  /// The title line to show in a list item.
  Widget buildTitle(BuildContext context);

  /// The subtitle line, if any, to show in a list item.
  Widget buildSubtitle(BuildContext context);
}

/// A ListItem that contains data to display a heading.
class HeadingItem implements ListItem {
  final String heading;

  HeadingItem(this.heading);

  Widget buildTitle(BuildContext context) {
    return Text(
      heading,
      style: Theme.of(context).textTheme.headline,
    );
  }

  Widget buildSubtitle(BuildContext context) => null;
}

/// A ListItem that contains data to display a message.
class MessageItem implements ListItem {
  final String sender;
  final String body;

  MessageItem(this.sender, this.body);

  Widget buildTitle(BuildContext context) => Text(sender);

  Widget buildSubtitle(BuildContext context) => Text(body);
}

class SettingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // print(selectedIndex);
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      // bottomNavigationBar: BottomBar(),
      // body: Center(
      //   child: widgetOptions.elementAt(selectedIndex),
      // ),
    );
  }
}

int selectedIndex = 0;

class BottomBar extends StatefulWidget {
  @override
  _BottomBarState createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
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

const TextStyle optionStyle =
    TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

List<Widget> widgetOptions = <Widget>[
  // Text(
  //   'Index 0: Home',
  //   style: optionStyle,
  // ),
  // Text(
  //   'Index 1: Business',
  //   style: optionStyle,
  // ),
  // Text(
  //   'Index 2: School',
  //   style: optionStyle,
  // ),
  HomePage(),
  Dashboard(),
  GodMode(),
  SettingPage()
];

// Future<http.Response> fetchKanban() {
//   return http.get(
//     'http://61.220.105.113:8885/ioms5data/analyze/kanban/machinestatus',
//     headers: {
//       "workShopNumber": "1",
//     },
//   );
// }

class Kanban {
  final String machineNumber;
  final String machineModel;
  final double cycleTime;

  Kanban({this.machineNumber, this.machineModel, this.cycleTime});

  factory Kanban.fromJson(Map<String, dynamic> json) {
    return Kanban(
      machineNumber: json['machineNumber'],
      machineModel: json['machineModel'],
      cycleTime: json['cycleTime'],
    );
  }
}

Future<dynamic> fetchKanban() async {
  // http.Response response = await http.get(
  //   'http://61.220.105.113:8885/ioms5data/analyze/kanban/machinestatus',
  //   headers: {
  //     "workShopNumber": "1",
  //   },
  // );

  // if (response.statusCode == 200) {
  //   // If the server did return a 200 OK response,
  //   // then parse the JSON.
  //   var data = jsonDecode(response.body);
  //   // print(data);
  //   return data;
  // } else {
  //   // If the server did not return a 200 OK response,
  //   // then throw an exception.
  //   throw Exception('Failed to load kanban');
  // }

  NetworkHelper networkHelper = NetworkHelper(url);
  var data = await networkHelper.getData();
  return data;
}

const url = 'http://61.220.105.113:8885/ioms5data/analyze/kanban/machinestatus';

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
