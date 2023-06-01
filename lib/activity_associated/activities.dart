import 'dart:async';
import 'package:first_app/others/user.dart';
import 'package:flutter/material.dart';
import 'package:first_app/others/handle_csv.dart' as cs;
import 'package:csv/csv.dart';
import 'package:flutter/services.dart';
import 'package:web_socket_channel/io.dart';
import 'package:first_app/others/encryption.dart';

class Activities extends StatefulWidget {
  User u1 = User("", 0, 0, 0, 0, 0, "", "", "", "", 0, 0, 0, 0, 0, 0);
  Activities(User u2) {
    u1 = u2;
  }
  @override
  ActivitiesState createState() => ActivitiesState();
}

class ActivitiesState extends State<Activities> {
  User user = User("", 0, 0, 0, 0, 0, "", "", "", "", 0, 0, 0, 0, 0, 0);
  List<List<dynamic>> data = [];
  var control = TextEditingController();
  var items = [];
  var dv = 'Activity';
  var cond = ' Exercise or Sport (1 hour)';
  var condition = [];
  List times = ["Hour", "Hours", "Minutes", "Seconds", "Minute", "Second"];
  @override
  void initState() {
    super.initState();
    user = widget.u1;
    print("Entered Activities");
  }

  @override
  void dispose() {
    super.dispose();
    try {
      control.dispose();
    } catch (e) {
      print("NULL");
    }
  }

  Widget build(BuildContext context) {
    loadCSV();
    items = cs.activities(data);
    condition = cs.getDur(dv, data);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'CaloCalc - Activities',
          style: TextStyle(fontSize: 35.0, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color.fromARGB(255, 9, 9, 174),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LinearProgressIndicator(
              value:
                  user.cur_burned / user.burned, // current_burned / burned_goal
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(
                  Color.fromARGB(255, 4, 18, 128)),
              minHeight: 20.0, // Set the thickness of the progress bar
            ),
            Center(
              child: user.cur_burned / user.burned >= 1
                  ? Text(
                      'Current_Burned / Your Burned Goal = ${(100).toInt()}%',
                      style: TextStyle(fontSize: 14.0),
                    )
                  : Text(
                      'Current_Burned / Your Burned Goal = ${(user.cur_burned / user.burned * 100).toInt()}%',
                      style: TextStyle(fontSize: 14.0),
                    ),
            ),
            SizedBox(
              height: 50,
            ),
            Align(
              alignment: Alignment.topCenter,
              child: DropdownButton(
                iconSize: 24.0,
                value: dv,
                icon: const Icon(Icons.keyboard_arrow_down),
                // Array list of items
                items: items.map(
                  (var items) {
                    return DropdownMenuItem(
                      value: items,
                      child: Text(
                        items,
                        style: TextStyle(
                          fontSize: 14.0, // Set font size
                          color: Colors.black, // Set font color
                        ),
                      ),
                    );
                  },
                ).toList(),
                onChanged: (var newValue) {
                  setState(
                    () {
                      dv = newValue.toString();
                      condition = cs.getDur(dv, data);
                      cond = condition[0];
                    },
                  );
                },
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: DropdownButton(
                value: cond,
                icon: const Icon(Icons.keyboard_arrow_down),
                items: condition.map(
                  (var condition) {
                    return DropdownMenuItem(
                      value: condition,
                      child: Text(condition),
                    );
                  },
                ).toList(),
                onChanged: (var newValue) {
                  setState(
                    () {
                      cond = newValue.toString();
                    },
                  );
                },
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: TextField(
                style: TextStyle(fontSize: 14.0),
                decoration: InputDecoration(
                  hintText: "Enter Workout Duration",
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
                controller: control,
              ),
            ),
            SizedBox(
              height: 100,
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      Color.fromARGB(
                          255, 9, 9, 174)), // Set the desired color here
                ),
                child: Text("SUBMIT"),
                onPressed: () {
                  if (dv == "Activity") {
                    final snackBar = SnackBar(
                      content: Text('Cannot Submit Random Activity'),
                      duration: Duration(seconds: 5),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    Timer(
                      Duration(seconds: 5),
                      () {
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      },
                    );
                  } else if (control.text == "") {
                    final snackBar = SnackBar(
                      content: Text('Cannot Submit Timeless Activity'),
                      duration: Duration(seconds: 5),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    Timer(
                      Duration(seconds: 5),
                      () {
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      },
                    );
                  } else {
                    var burned = cs.burned(dv, cond, data);
                    var actual = 0.0;
                    var distance = 0.0;
                    if (!control.text.contains("and")) {
                      var list = control.text.split(" ");
                      for (int i = 1; i < list.length; i++) {
                        var numeric = double.parse(list[i - 1]);
                        if (maxSimilarity(list[i], times) * 100 >= 30) {
                          String ans = findClosest(list[i], times);
                          if (ans.toLowerCase() == "hour" ||
                              ans.toLowerCase() == "hours") {
                            actual = numeric * burned * user.weight;
                          } else if (ans.toLowerCase() == "minute" ||
                              ans.toLowerCase() == "minutes") {
                            actual = numeric * burned * user.weight / 60;
                          } else if (ans.toLowerCase() == "second" ||
                              ans.toLowerCase() == "seconds") {
                            actual = numeric * burned * user.weight / 3600;
                          }
                          if (dv.toLowerCase() == "running" &&
                              cond.contains("kmh")) {
                            var state = double.parse(cond.split(" ")[1]);
                            if (ans.toLowerCase() == "hour" ||
                                ans.toLowerCase() == "hours") {
                              distance += state * numeric;
                            } else if (ans.toLowerCase() == "minute" ||
                                ans.toLowerCase() == "minutes") {
                              distance += state * numeric / 60;
                            } else if (ans.toLowerCase() == "second" ||
                                ans.toLowerCase() == "seconds") {
                              distance += state * numeric / 3600;
                            }
                          } else if (dv.toLowerCase() == "cycling" &&
                              cond.contains("kmh")) {
                            var state = cond.split(" ")[1];
                            distance += cycling_dis(state, list.join(" "));
                          }
                        }
                      }
                    } else {
                      var time_list = control.text.split("and");
                      for (int i = 0; i < time_list.length; i++) {
                        var list = time_list[i];
                        double numeric =
                            double.parse(list.replaceAll(RegExp('[^0-9]'), ''));
                        String result =
                            list.replaceAll(RegExp(r'[^a-zA-Z]'), '');
                        if (maxSimilarity(result, times) * 100 >= 30) {
                          result = findClosest(result, times);
                          if (result.toLowerCase() == "hour" ||
                              result.toLowerCase() == "hours") {
                            actual += numeric * burned * user.weight;
                          } else if (result.toLowerCase() == "minute" ||
                              result.toLowerCase() == "minutes") {
                            actual += numeric * burned * user.weight / 60;
                          } else if (result.toLowerCase() == "second" ||
                              result.toLowerCase() == "seconds") {
                            actual += numeric * burned * user.weight / 3600;
                          }
                          if (dv.toLowerCase() == "running" &&
                              cond.contains("kmh")) {
                            var state = double.parse(cond.split(" ")[1]);
                            if (result.toLowerCase() == "hour" ||
                                result.toLowerCase() == "hours") {
                              distance += state * numeric;
                            } else if (result.toLowerCase() == "minute" ||
                                result.toLowerCase() == "minutes") {
                              distance += state * numeric / 60;
                            } else if (result.toLowerCase() == "second" ||
                                result.toLowerCase() == "seconds") {
                              distance += state * numeric / 3600;
                            }
                          } else if (dv.toLowerCase() == "cycling" &&
                              cond.contains("kmh")) {
                            var state = cond.split(" ")[1];
                            distance += cycling_dis(state, list);
                          }
                        }
                      }
                    }
                    var to_decrease = actual / 300 * 0.039;
                    user.set_weight(-to_decrease);
                    List weight_data_split = user.weight_data.split("/");
                    weight_data_split[0] += "-" + user.weight.toString();
                    weight_data_split[1] += "+" + DateTime.now().toString();
                    user.set_weight_data(weight_data_split.join("/"));
                    var weit_chan =
                        IOWebSocketChannel.connect("ws://10.0.0.8:8820");
                    String message = "Update Weight," +
                        user.name +
                        "," +
                        user.weight.toString();
                    weit_chan.sink.add(xor_dec_enc(message));
                    weit_chan.stream.listen(
                      (msg1) {
                        print("Recieved Message: ${xor_dec_enc(msg1)}");
                      },
                    );
                    // 300 cal = 0.039 kg
                    String msg = "";
                    if (dv.toLowerCase() == "running" && cond.contains("kmh")) {
                      user.set_running(distance.toInt());
                    } else if (dv.toLowerCase() == "cycling" &&
                        cond.contains("kmh")) {
                      user.set_cycling(distance.toInt());
                    }
                    _increaseCurBurn(actual.toInt());
                    var _detailsChannel =
                        IOWebSocketChannel.connect("ws://10.0.0.8:8820");
                    if (dv.toLowerCase().contains("running")) {
                      msg = "running," +
                          user.name +
                          "," +
                          actual.toInt().toString() +
                          "," +
                          distance.toInt().toString();
                    } else if (dv.toLowerCase() == "cycling") {
                      msg = "cycling," +
                          user.name +
                          "," +
                          actual.toInt().toString() +
                          "," +
                          distance.toInt().toString();
                    } else {
                      msg = "Random Activity," +
                          dv.toString() +
                          "," +
                          user.name +
                          "," +
                          actual.toInt().toString();
                    }
                    _detailsChannel.sink.add(xor_dec_enc(msg));
                    _detailsChannel.stream.listen(
                      (message) {
                        print("Message: ${xor_dec_enc(message)}");
                      },
                    );
                    _detailsChannel.sink.close();
                    user.set_activity_data(
                        dv.toString() + "-" + actual.toInt().toString());
                    final snackBar = SnackBar(
                      content: Text('Activity Submitted'),
                      duration: Duration(seconds: 5),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    Timer(
                      Duration(seconds: 5),
                      () {
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _increaseCurBurn(int new_burn) {
    setState(
      () {
        user.cur_burned += new_burn;
      },
    );
  }

  void loadCSV() async {
    final data2 = await rootBundle.loadString("assets/exercise_dataset.csv");
    var list2 = const CsvToListConverter().convert(data2);
    setState(
      () {
        data = list2;
      },
    );
  }

  double calculateJaccardSimilarity(String string1, String string2) {
    // Convert the strings to sets of characters
    final set1 = string1.split('').toSet();
    final set2 = string2.split('').toSet();

    // Calculate the intersection and union of the sets
    final intersection = set1.intersection(set2);
    final union = set1.union(set2);

    // Calculate the Jaccard similarity coefficient
    final similarity = intersection.length / union.length;
    return similarity;
  }

  double maxSimilarity(String s1, List l1) {
    double max = 0;
    for (int i = 0; i < l1.length; i++) {
      if (calculateJaccardSimilarity(s1, l1[i]) > max) {
        max = calculateJaccardSimilarity(s1, l1[i]);
      }
    }
    return max;
  }

  double cycling_dis(var state, var time) {
    var distance = 0.0;
    double numeric = double.parse(time.replaceAll(RegExp('[^0-9]'), ''));
    String result = time.replaceAll(RegExp(r'[^a-zA-Z]'), '');
    var stat = 0.0;
    if (state.contains("<")) {
      stat = 7.5;
    } else if (state.contains(">")) {
      stat = 22.5;
    } else if (state.contains("-")) {
      var li = state.split("-");
      stat = double.parse(
          ((double.parse(li[0]) + double.parse(li[1])) / 2).round().toString());
    }
    if (result.toLowerCase() == "hour" || result.toLowerCase() == "hours") {
      distance = stat * 1.6 * numeric;
    } else if (result.toLowerCase() == "minute" ||
        result.toLowerCase() == "minutes") {
      distance = stat * 1.6 * numeric / 60;
    } else if (result.toLowerCase() == "second" ||
        result.toLowerCase() == "seconds") {
      distance = stat * 1.6 * numeric / 3600;
    }
    return distance;
  }

  String findClosest(String s1, List l1) {
    String ans = "";
    double max = 0;
    for (int i = 0; i < l1.length; i++) {
      if (calculateJaccardSimilarity(s1, l1[i]) > max) {
        max = calculateJaccardSimilarity(s1, l1[i]);
        ans = l1[i];
      }
    }
    return ans;
  }
}
