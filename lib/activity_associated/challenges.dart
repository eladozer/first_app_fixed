import 'package:flutter/material.dart';
import 'package:first_app/others/user.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:web_socket_channel/io.dart';
import 'package:first_app/others/encryption.dart';

class Challenges extends StatefulWidget {
  User u1 = User("", 0, 0, 0, 0, 0, "", "", "", "", 0, 0, 0, 0, 0, 0);
  Challenges(User u2) {
    u1 = u2;
  }
  @override
  ChallengesState createState() => ChallengesState();
}

class ChallengesState extends State<Challenges> {
  User user = User("", 0, 0, 0, 0, 0, "", "", "", "", 0, 0, 0, 0, 0, 0);
  String button_text1 = "Follow";
  String button_text2 = "Follow";
  String text1 = "Unfollow";
  String text2 = "Unfollow";
  var visibility1 = false;
  var visibility2 = false;
  var visibility3 = true;
  var visibility4 = true;
  var application_channel;
  var bar = AppBar(
    centerTitle: true,
    title: Text(
      'CaloCalc - Monthly Challenge',
      style: TextStyle(fontSize: 27.0, fontWeight: FontWeight.bold),
    ),
    backgroundColor: Colors.cyan,
    automaticallyImplyLeading: false,
  );
  List running = [
    '100 KM Running',
    '200 KM Running',
    '300 KM Running',
    '400 KM Running',
    '500 KM Running',
    '600 KM Running',
    '700 KM Running',
    '800 KM Running',
    '900 KM Running',
    '1000 KM Running',
    '1100 KM Running',
    '1200 KM Running',
  ];
  List cycling = [
    '100 KM Cycling',
    '200 KM Cycling',
    '300 KM Cycling',
    '400 KM Cycling',
    '500 KM Cycling',
    '600 KM Cycling',
    '700 KM Cycling',
    '800 KM Cycling',
    '900 KM Cycling',
    '1000 KM Cycling',
    '1100 KM Cycling',
    '1200 KM Cycling',
  ];
  @override
  void initState() {
    super.initState();
    user = widget.u1;
    print("Entered Challenges");
  }

  @override
  Widget build(BuildContext context) {
    print(user.running.toString() + "," + user.cycling.toString());
    return data(user.challenge_one, user.challenge_two);
  }

  Scaffold data(var cond1, var cond2) {
    if (user.challenge_one == true) {
      if (user.challenge_two == true) {
        return Scaffold(
          appBar: bar,
          body: Container(
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey,
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  running[DateTime.now().month - 1].toString(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                ),
                SizedBox(height: 16.0),
                Text(
                  'You Have All Month To Reach ${int.parse(running[DateTime.now().month - 1].toString().split(" ")[0])} KMS',
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
                Visibility(
                  visible: visibility3,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: CircularPercentIndicator(
                      radius: 40.0,
                      lineWidth: 8.0,
                      percent: user.running /
                          int.parse(running[DateTime.now().month - 1]
                              .toString()
                              .split(" ")[0]),
                      center: new Text(
                        (user.running /
                                    int.parse(running[DateTime.now().month - 1]
                                        .toString()
                                        .split(" ")[0]))
                                .toString() +
                            "%",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15.0,
                        ),
                      ),
                      progressColor: Colors.blue,
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.cyan), // Set the desired color here
                      ),
                      onPressed: () {
                        change_chal(text1, visibility3, 1);
                        if (text1.toLowerCase() == "unfollow") {
                          application_channel =
                              IOWebSocketChannel.connect("ws://10.0.0.8:8820");
                          String msg = "Update Chal," + user.name + ",1,0";
                          application_channel.sink.add(xor_dec_enc(msg));
                          application_channel.sink.close();
                        } else {
                          application_channel =
                              IOWebSocketChannel.connect("ws://10.0.0.8:8820");
                          String msg = "Update Chal," + user.name + ",1,1";
                          application_channel.sink.add(xor_dec_enc(msg));
                          application_channel.sink.close();
                        }
                      },
                      child: Text(text1),
                    ),
                  ],
                ),
                SizedBox(
                  height: 150,
                ),
                Text(
                  cycling[DateTime.now().month - 1].toString(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                ),
                SizedBox(height: 16.0),
                Text(
                  'You Have All Month To Reach ${int.parse(cycling[DateTime.now().month - 1].toString().split(" ")[0])} KMS',
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
                Visibility(
                  visible: visibility4,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: CircularPercentIndicator(
                      radius: 40.0,
                      lineWidth: 8.0,
                      percent: user.cycling /
                          int.parse(cycling[DateTime.now().month - 1]
                              .toString()
                              .split(" ")[0]),
                      center: new Text(
                        (user.cycling /
                                    int.parse(cycling[DateTime.now().month - 1]
                                        .toString()
                                        .split(" ")[0]))
                                .toString() +
                            "%",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15.0,
                        ),
                      ),
                      progressColor: Colors.blue,
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.cyan), // Set the desired color here
                      ),
                      onPressed: () {
                        change_chal(text2, visibility4, 2);
                        if (text2.toLowerCase() == "unfollow") {
                          application_channel =
                              IOWebSocketChannel.connect("ws://10.0.0.8:8820");
                          String msg = "Update Chal," + user.name + ",2,0";
                          application_channel.sink.add(xor_dec_enc(msg));
                          application_channel.sink.close();
                        } else {
                          application_channel =
                              IOWebSocketChannel.connect("ws://10.0.0.8:8820");
                          String msg = "Update Chal," + user.name + ",2,1";
                          application_channel.sink.add(xor_dec_enc(msg));
                          application_channel.sink.close();
                        }
                      },
                      child: Text(text2),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      } else {
        return Scaffold(
          appBar: bar,
          body: Container(
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey,
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  running[DateTime.now().month - 1].toString(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                ),
                SizedBox(height: 16.0),
                Text(
                  'You Have All Month To Reach ${int.parse(running[DateTime.now().month - 1].toString().split(" ")[0])} KMS',
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
                Visibility(
                  visible: visibility3,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: CircularPercentIndicator(
                      radius: 40.0,
                      lineWidth: 8.0,
                      percent: user.running /
                          int.parse(running[DateTime.now().month - 1]
                              .toString()
                              .split(" ")[0]),
                      center: new Text(
                        (user.running /
                                    int.parse(running[DateTime.now().month - 1]
                                        .toString()
                                        .split(" ")[0]))
                                .toString() +
                            "%",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15.0,
                        ),
                      ),
                      progressColor: Colors.blue,
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.cyan), // Set the desired color here
                      ),
                      onPressed: () {
                        change_chal(text1, visibility3, 1);
                        if (text1.toLowerCase() == "unfollow") {
                          application_channel =
                              IOWebSocketChannel.connect("ws://10.0.0.8:8820");
                          String msg = "Update Chal," + user.name + ",1,0";
                          application_channel.sink.add(xor_dec_enc(msg));
                          application_channel.sink.close();
                        } else {
                          application_channel =
                              IOWebSocketChannel.connect("ws://10.0.0.8:8820");
                          String msg = "Update Chal," + user.name + ",1,1";
                          application_channel.sink.add(xor_dec_enc(msg));
                          application_channel.sink.close();
                        }
                      },
                      child: Text(text1),
                    ),
                  ],
                ),
                SizedBox(
                  height: 150,
                ),
                Text(
                  cycling[DateTime.now().month - 1].toString(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                ),
                SizedBox(height: 16.0),
                Text(
                  'You Have All Month To Reach ${int.parse(cycling[DateTime.now().month - 1].toString().split(" ")[0])} KMS',
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
                Visibility(
                  visible: visibility2,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: CircularPercentIndicator(
                      radius: 40.0,
                      lineWidth: 8.0,
                      percent: user.cycling /
                          int.parse(cycling[DateTime.now().month - 1]
                              .toString()
                              .split(" ")[0]),
                      center: new Text(
                        (user.cycling /
                                    int.parse(cycling[DateTime.now().month - 1]
                                        .toString()
                                        .split(" ")[0]))
                                .toString() +
                            "%",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15.0,
                        ),
                      ),
                      progressColor: Colors.blue,
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.cyan), // Set the desired color here
                      ),
                      onPressed: () {
                        change_chal(button_text2, visibility2, 2);
                        if (button_text2.toLowerCase() == "unfollow") {
                          application_channel =
                              IOWebSocketChannel.connect("ws://10.0.0.8:8820");
                          String msg = "Update Chal," + user.name + ",2,0";
                          application_channel.sink.add(xor_dec_enc(msg));
                          application_channel.sink.close();
                        } else {
                          application_channel =
                              IOWebSocketChannel.connect("ws://10.0.0.8:8820");
                          String msg = "Update Chal," + user.name + ",2,1";
                          application_channel.sink.add(xor_dec_enc(msg));
                          application_channel.sink.close();
                        }
                      },
                      child: Text(button_text2),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }
    } else if (user.challenge_two == true) {
      return Scaffold(
        appBar: bar,
        body: Container(
          padding: EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey,
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                running[DateTime.now().month - 1].toString(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                'You Have All Month To Reach ${int.parse(running[DateTime.now().month - 1].toString().split(" ")[0])} KMS',
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
              Visibility(
                visible: visibility1,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: CircularPercentIndicator(
                    radius: 40.0,
                    lineWidth: 8.0,
                    percent: user.running /
                        int.parse(running[DateTime.now().month - 1]
                            .toString()
                            .split(" ")[0]),
                    center: new Text(
                      (user.running /
                                  int.parse(running[DateTime.now().month - 1]
                                      .toString()
                                      .split(" ")[0]))
                              .toString() +
                          "%",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15.0,
                      ),
                    ),
                    progressColor: Colors.blue,
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Colors.cyan), // Set the desired color here
                    ),
                    onPressed: () {
                      change_chal(button_text1, visibility1, 1);
                      if (button_text1.toLowerCase() == "unfollow") {
                        application_channel =
                            IOWebSocketChannel.connect("ws://10.0.0.8:8820");
                        String msg = "Update Chal," + user.name + ",1,0";
                        application_channel.sink.add(xor_dec_enc(msg));
                        application_channel.sink.close();
                      } else {
                        application_channel =
                            IOWebSocketChannel.connect("ws://10.0.0.8:8820");
                        String msg = "Update Chal," + user.name + ",1,1";
                        application_channel.sink.add(xor_dec_enc(msg));
                        application_channel.sink.close();
                      }
                    },
                    child: Text(button_text1),
                  ),
                ],
              ),
              SizedBox(
                height: 150,
              ),
              Text(
                cycling[DateTime.now().month - 1].toString(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                'You Have All Month To Reach ${int.parse(cycling[DateTime.now().month - 1].toString().split(" ")[0])} KMS',
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
              Visibility(
                visible: visibility4,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: CircularPercentIndicator(
                    radius: 40.0,
                    lineWidth: 8.0,
                    percent: user.cycling /
                        int.parse(cycling[DateTime.now().month - 1]
                            .toString()
                            .split(" ")[0]),
                    center: new Text(
                      (user.cycling /
                                  int.parse(cycling[DateTime.now().month - 1]
                                      .toString()
                                      .split(" ")[0]))
                              .toString() +
                          "%",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15.0,
                      ),
                    ),
                    progressColor: Colors.blue,
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Colors.cyan), // Set the desired color here
                    ),
                    onPressed: () {
                      change_chal(text2, visibility4, 2);
                      if (text2.toLowerCase() == "unfollow") {
                        application_channel =
                            IOWebSocketChannel.connect("ws://10.0.0.8:8820");
                        String msg = "Update Chal," + user.name + ",2,0";
                        application_channel.sink.add(xor_dec_enc(msg));
                        application_channel.sink.close();
                      } else {
                        application_channel =
                            IOWebSocketChannel.connect("ws://10.0.0.8:8820");
                        String msg = "Update Chal," + user.name + ",2,1";
                        application_channel.sink.add(xor_dec_enc(msg));
                        application_channel.sink.close();
                      }
                    },
                    child: Text(text2),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }
    return Scaffold(
      appBar: bar,
      body: Container(
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey,
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              running[DateTime.now().month - 1].toString(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'You Have All Month To Reach ${int.parse(running[DateTime.now().month - 1].toString().split(" ")[0])} KMS',
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
            Visibility(
              visible: visibility1,
              child: Align(
                alignment: Alignment.centerRight,
                child: CircularPercentIndicator(
                  radius: 40.0,
                  lineWidth: 8.0,
                  percent: user.running /
                      int.parse(running[DateTime.now().month - 1]
                          .toString()
                          .split(" ")[0]),
                  center: new Text(
                    (user.running /
                                int.parse(running[DateTime.now().month - 1]
                                    .toString()
                                    .split(" ")[0]))
                            .toString() +
                        "%",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15.0,
                    ),
                  ),
                  progressColor: Colors.blue,
                ),
              ),
            ),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Colors.cyan), // Set the desired color here
                  ),
                  onPressed: () {
                    change_chal(button_text1, visibility1, 1);
                    if (button_text1.toLowerCase() == "unfollow") {
                      application_channel =
                          IOWebSocketChannel.connect("ws://10.0.0.8:8820");
                      String msg = "Update Chal," + user.name + ",1,0";
                      application_channel.sink.add(xor_dec_enc(msg));
                      application_channel.sink.close();
                    } else {
                      application_channel =
                          IOWebSocketChannel.connect("ws://10.0.0.8:8820");
                      String msg = "Update Chal," + user.name + ",1,1";
                      application_channel.sink.add(xor_dec_enc(msg));
                      application_channel.sink.close();
                    }
                  },
                  child: Text(button_text1),
                ),
              ],
            ),
            SizedBox(
              height: 150,
            ),
            Text(
              cycling[DateTime.now().month - 1].toString(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'You Have All Month To Reach ${int.parse(cycling[DateTime.now().month - 1].toString().split(" ")[0])} KMS',
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
            Visibility(
              visible: visibility2,
              child: Align(
                alignment: Alignment.centerRight,
                child: CircularPercentIndicator(
                  radius: 40.0,
                  lineWidth: 8.0,
                  percent: user.cycling /
                      int.parse(cycling[DateTime.now().month - 1]
                          .toString()
                          .split(" ")[0]),
                  center: new Text(
                    (user.cycling /
                                int.parse(cycling[DateTime.now().month - 1]
                                    .toString()
                                    .split(" ")[0]))
                            .toString() +
                        "%",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15.0,
                    ),
                  ),
                  progressColor: Colors.blue,
                ),
              ),
            ),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Colors.cyan), // Set the desired color here
                  ),
                  onPressed: () {
                    change_chal(button_text2, visibility2, 2);
                    if (button_text2.toLowerCase() == "unfollow") {
                      application_channel =
                          IOWebSocketChannel.connect("ws://10.0.0.8:8820");
                      String msg = "Update Chal," + user.name + ",2,0";
                      application_channel.sink.add(xor_dec_enc(msg));
                      application_channel.sink.close();
                    } else {
                      application_channel =
                          IOWebSocketChannel.connect("ws://10.0.0.8:8820");
                      String msg = "Update Chal," + user.name + ",2,1";
                      application_channel.sink.add(xor_dec_enc(msg));
                      application_channel.sink.close();
                    }
                  },
                  child: Text(button_text2),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void change_chal(var text, var vis, var chal) {
    setState(
      () {
        if (text.toLowerCase() == "unfollow") {
          text = "Follow";
        } else {
          text = "Unfollow";
        }
        if (chal == 1) {
          user.set_chal_one(!user.challenge_one);
        } else {
          user.set_chal_two(!user.challenge_two);
        }
        vis = !vis;
      },
    );
  }
}
