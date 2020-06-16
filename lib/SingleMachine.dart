import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:emudc_app/Homepage.dart';

String url = 'http://$serverIP/iomfake';

class NetworkHelper {
  NetworkHelper(this.url, this.machineNumber);

  final String url;
  String machineNumber;

  Future getData() async {
    http.Response response = await http.get(url, headers: {
      "machineNumber": machineNumber,
    });

    if (response.statusCode == 200) {
      String data = response.body;
      // print(jsonDecode(data));
      return jsonDecode(data);
    } else {
      print(response.statusCode);
    }
  }
}

class SingleMachine extends StatefulWidget {
  final title;
  SingleMachine(this.title);
  @override
  _SingleMachineState createState() => _SingleMachineState(title);
}

class _SingleMachineState extends State<SingleMachine> {
  final title;
  _SingleMachineState(this.title);
  Future<dynamic> fetchKanban() async {
    NetworkHelper networkHelper = NetworkHelper(url, title);
    var data = await networkHelper.getData();
    return data;
  }

  final myController1 = TextEditingController();
  final myController2 = TextEditingController();
  final myController3 = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController1.dispose();
    myController2.dispose();
    myController3.dispose();
    super.dispose();
  }

  var machines;
  @override
  void initState() {
    super.initState();
    machines = fetchKanban();
  }

  var temp;
  List<Widget> machineList = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$title'),
      ),
      body: Center(
        child: FutureBuilder(
          future: machines,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              temp = snapshot.data;
              var action;
              if (temp['status'] == 1 || temp['status'] == 2) {
                action = 'Running';
              } else {
                action = 'Abnormal';
              }
              machineList.add(_tile('Cycle Time', temp['cycleTime'].toString(),
                  Icons.account_balance_wallet, context, myController1));
              machineList.add(_tile('Mode', action,
                  Icons.account_balance_wallet, context, myController2));
              machineList.add(_tile('Duration', '',
                  Icons.account_balance_wallet, context, myController3));
              return ListView(
                children: machineList,
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
        child: Icon(Icons.send),
        onPressed: () async {
          if (myController1.text == '') {
            myController1.text = temp['cycleTime'].toString();
          }
          if (myController2.text == '') {
            myController2.text = temp['status'].toString();
          }
          if (myController3.text == '') {
            myController3.text = '0';
          }
          Map data = {
            'machineNumber': title,
            'cycleTime': int.parse(myController1.text),
            'status': int.parse(myController2.text),
            'interval': int.parse(myController3.text),
          };

          String body = json.encode(data);
          print(body);
          await http.post(
            url,
            headers: {"Content-Type": "application/json"},
            body: body,
          );
          Navigator.pop(context);
        },
      ),
    );
  }
}

ListTile _tile(String title, String subtitle, IconData icon,
    BuildContext context, TextEditingController controller) {
  return ListTile(
    title: Text(title,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 20,
        )),
    subtitle: TextField(
      textAlign: TextAlign.end,
      style: TextStyle(
        fontSize: 20,
      ),
      decoration: InputDecoration(
        hintText: subtitle,
      ),
      controller: controller,
    ),
    leading: Icon(
      icon,
      color: Colors.white,
      size: 20,
    ),
    // onTap: null,
  );
}
