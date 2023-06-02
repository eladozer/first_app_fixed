import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import 'package:first_app/others/user.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

String url = "https://api.api-ninjas.com/v1/nutrition?query=";
var key = "Key1986";

String xor_dec_enc(String text) {
  List<int> encrypted = [];
  for (int i = 0; i < text.length; i++) {
    int charCode = text.codeUnitAt(i) ^ key.codeUnitAt(i % key.length);
    encrypted.add(charCode);
  }
  return String.fromCharCodes(encrypted);
}

class MyApp extends StatefulWidget {
  User u1 = User("", 0, 0, 0, 0, 0, "", "", "", "", 0, 0, 0, 0, 0, 0);
  MyApp(User un) {
    u1 = un;
  }
  @override
  State<StatefulWidget> createState() {
    return MyAppState();
  }
}

class MyAppState extends State<MyApp> with SingleTickerProviderStateMixin {
  User user = User("", 0, 0, 0, 0, 0, "", "", "", "", 0, 0, 0, 0, 0, 0);
  var _mainChannel;
  var mealChannel;
  var meal_data;
  final control = TextEditingController();
  @override
  void initState() {
    super.initState();
    user = widget.u1;
    print("Entered Main");
  }

  @override
  void dispose() {
    control.dispose();
    super.dispose();
    print("Exited Main");
  }

  Future openDialog() => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            "Meal Prompt",
            textAlign: TextAlign.center,
          ),
          content: TextField(
            autofocus: true,
            decoration: InputDecoration(
              hintText: "Enter Meal: (weight) + (type food)",
            ),
            controller: control,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, control.text);
              },
              child: Text("SUBMIT"),
            ),
          ],
        ),
      );

  void _incrementCal(int ca) {
    setState(
      () {
        user.current_cal = ca;
      },
    );
  }

  void _incrementProt(int pro) {
    setState(
      () {
        user.current_prot = pro;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    meal_data = user.meal_data;
    List meals = [];
    for (int i = 0; i < meal_data.length; i++) {
      meals.add(meal_data[i]);
    }
    return Scaffold(
      appBar: AppBar(
        leading: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              height: 45,
              width: 45,
              child: CircularPercentIndicator(
                animation: true,
                percent: user.current_cal / user.cal >= 1
                    ? 1
                    : user.current_cal / user.cal,
                radius: 22.5,
                progressColor: user.current_cal / user.cal >= 1
                    ? Colors.green
                    : Colors.white,
                circularStrokeCap: CircularStrokeCap.round,
                lineWidth: 5,
                center: Text(
                  'Calories',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
        actions: [
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                height: 45,
                width: 45,
                child: CircularPercentIndicator(
                  animation: true,
                  percent: user.current_prot / user.prot >= 1
                      ? 1
                      : user.current_prot / user.prot,
                  radius: 22.5,
                  progressColor: user.current_prot / user.prot >= 1
                      ? Colors.green
                      : Colors.white,
                  circularStrokeCap: CircularStrokeCap.round,
                  lineWidth: 5,
                  center: Text(
                    'Proteins',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
        centerTitle: true,
        title: Text(
          'CaloCalc',
          style: TextStyle(fontSize: 40.0, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Table(
          columnWidths: {
            0: FractionColumnWidth(0.2),
            1: FractionColumnWidth(0.3),
            2: FractionColumnWidth(0.2),
            3: FractionColumnWidth(0.3),
          },
          border: TableBorder.all(
            color: Colors.black,
            width: 3.0,
            style: BorderStyle.solid,
          ),
          children: [
            TableRow(
              children: [
                TableCell(
                  child: Text(
                    'Time',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                TableCell(
                  child: Text(
                    'Meal Name',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                TableCell(
                  child: Text(
                    'Calories',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                TableCell(
                  child: Text(
                    'Proteins',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            ...List<TableRow>.generate(
              meals.length,
              (index) {
                if (meals[index].isNotEmpty) {
                  return TableRow(
                    children: [
                      TableCell(
                        child: Padding(
                          padding: EdgeInsets.all(2.0),
                          child: Text(
                            meals[index].split("-")[0].toString(),
                            textAlign: TextAlign.center,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: EdgeInsets.all(2.0),
                          child: Text(
                            meals[index].split("-")[1].toString(),
                            textAlign: TextAlign.center,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: EdgeInsets.all(2.0),
                          child: Text(
                            meals[index].split("-")[2].toString(),
                            textAlign: TextAlign.center,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: EdgeInsets.all(2.0),
                          child: Text(
                            meals[index].split("-")[3].toString(),
                            textAlign: TextAlign.center,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  );
                } else {
                  return TableRow(
                    children: [
                      TableCell(
                        child: Padding(
                          padding: EdgeInsets.all(2.0),
                          child: Text(
                            meals[index],
                            textAlign: TextAlign.center,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: EdgeInsets.all(2.0),
                          child: Text(
                            meals[index],
                            textAlign: TextAlign.center,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: EdgeInsets.all(2.0),
                          child: Text(
                            meals[index],
                            textAlign: TextAlign.center,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: EdgeInsets.all(2.0),
                          child: Text(
                            meals[index],
                            textAlign: TextAlign.center,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  );
                }
              },
            )
          ],
        ),
      ),
      floatingActionButton: Align(
        alignment: Alignment.bottomCenter,
        child: FloatingActionButton(
          child: Text('+', style: TextStyle(fontSize: 40.0)),
          onPressed: () async {
            var mealPrompt = await openDialog();
            if (mealPrompt == null) {
            } else {
              var list;
              if (mealPrompt == null) {
                list = [];
              } else {
                list = mealPrompt.split("and");
              }
              for (int i = 0; i < list.length; i++) {
                mealChannel = IOWebSocketChannel.connect("ws://10.0.0.8:8820");
                var item = list[i];
                String changed = "";
                if (item[0] != " ") {
                  if (item.split(" ")[0].contains("gr")) {
                    changed = item.split(" ")[0].replaceAll("gr", "g") +
                        " " +
                        item.split(" ")[1];
                  }
                } else {
                  item = item.substring(1);
                  if (item.split(" ")[0].contains("gr")) {
                    changed = item.split(" ")[0].replaceAll("gr", "g") +
                        " " +
                        item.split(" ")[1];
                  }
                }
                item = changed;
                if (item[0] == " ") {
                  String prompt = url + item.substring(1);
                  mealChannel.sink.add(xor_dec_enc(
                      "Food," + user.name + "," + prompt.toString()));
                } else {
                  String prompt = url + item;
                  mealChannel.sink.add(xor_dec_enc(
                      "Food," + user.name + "," + prompt.toString()));
                }
                var sub1;
                sub1 = mealChannel.stream.listen(
                  (msg) {
                    print("Message Recieved: $msg");
                    String body = xor_dec_enc(msg);
                    var nameStart = body.indexOf("name");
                    var nameEnd = nameStart + 4;
                    var calStart = body.indexOf("calories");
                    var calEnd = calStart + 8;
                    var protStart = body.indexOf("protein_g");
                    var protEnd = protStart + 9;
                    var nameStr = body.substring(
                        nameEnd + 4, find(nameEnd + 4, body, '"'));
                    var calStr =
                        body.substring(calEnd + 3, find(calEnd + 3, body, ','));
                    var protStr = body.substring(
                        protEnd + 3, find(protEnd + 3, body, ','));
                    print(nameStr + ": " + calStr + "," + protStr);
                    var newCal =
                        double.parse(calStr).toInt() + user.current_cal;
                    var newProt =
                        double.parse(protStr).toInt() + user.current_prot;
                    var sub;
                    String message = "Update Food," +
                        user.name +
                        "," +
                        newCal.toString() +
                        "," +
                        newProt.toString();
                    _mainChannel =
                        IOWebSocketChannel.connect("ws://10.0.0.8:8820");
                    _mainChannel.sink.add(xor_dec_enc(message));
                    sub = _mainChannel.stream.listen(
                      (msg) {
                        print("Recieved Message:${xor_dec_enc(msg)}");
                        sub.cancel();
                      },
                    );
                    _mainChannel.sink.close();
                    _incrementCal(newCal);
                    _incrementProt(newProt);
                    sub1.cancel();
                    mealChannel.sink.close();
                    var time = (DateTime.now().hour + 3).toString() +
                        ":" +
                        DateTime.now().minute.toString() +
                        ":" +
                        DateTime.now().second.toString() +
                        ":" +
                        DateTime.now().millisecond.toString();
                    user.meal_data.add(time.toString() +
                        "-" +
                        nameStr +
                        "-" +
                        calStr +
                        "-" +
                        protStr);
                  },
                );
              }
              List weight_data_split = user.weight_data.split("/");
              for (int j = 0; j < list.length; j++) {
                List dat = list[j].split(" ");
                var weight = dat[0];
                if (dat[0] == "") weight = dat[1];
                var weit;
                String numericString = weight.replaceAll(RegExp('[^0-9]'), '');
                String nonNumericString = weight.replaceAll(
                    RegExp(r'[^a-zA-Z]'), ''); // extracts non-numbers
                print(nonNumericString);
                if (nonNumericString == "gr") {
                  weit = double.parse(numericString) / 1000;
                } else if (nonNumericString == "kg") {
                  weit = double.parse(numericString);
                } else {
                  weit = double.parse(numericString) / 2.20462262;
                }
                user.set_weight(weit);
              }
              weight_data_split[0] += "-" + user.weight.toString();
              weight_data_split[1] += "+" + DateTime.now().toString();
              user.set_weight_data(weight_data_split.join("/"));
              var _weightChan =
                  IOWebSocketChannel.connect("ws://10.0.0.8:8820");
              String message =
                  "Update Weight," + user.name + "," + user.weight.toString();
              _weightChan.sink.add(xor_dec_enc(message));
              var sub;
              sub = _weightChan.stream.listen(
                (msg) {
                  print("Recieved Message:${xor_dec_enc(msg)}");
                  sub.cancel();
                },
              );
              _weightChan.sink.close();
            }
          },
        ),
      ),
    );
  }

  int find(int start, String str, String action) {
    int i = start;
    while (str[i] != action) {
      i++;
    }
    return i;
  }
}
