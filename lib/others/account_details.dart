import 'package:first_app/login_register/login.dart';
import 'package:first_app/others/encryption.dart';
import 'package:first_app/others/user.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';

class AccountDetails extends StatefulWidget {
  User un = User("", 0, 0, 0, 0, 0, "", "", "", "", 0, 0, 0, 0, 0, 0);
  AccountDetails(User u2) {
    un = u2;
  }
  @override
  AccountDeatilsState createState() => AccountDeatilsState();
}

class AccountDeatilsState extends State<AccountDetails> {
  User user = User("", 0, 0, 0, 0, 0, "", "", "", "", 0, 0, 0, 0, 0, 0);
  final control = TextEditingController();
  @override
  void initState() {
    super.initState();
    user = widget.un;
    print("Entered Data");
  }

  void dispose() {
    super.dispose();
    control.dispose();
    print("Exited Data");
  }

  Future openDialog() => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Change Data", textAlign: TextAlign.center),
          content: TextField(
            autofocus: true,
            decoration: InputDecoration(hintText: "Enter New Value"),
            controller: control,
          ),
          actions: [TextButton(onPressed: submit, child: Text("SUBMIT"))],
        ),
      );
  void submit() {
    Navigator.of(context).pop(control.text);
  }

  void _change_name(var new_name) {
    setState(
      () {
        user.name = new_name;
      },
    );
  }

  void _change_weight_data(var new_data) {
    setState(
      () {
        user.weight = double.parse(new_data);
      },
    );
  }

  void _change_cal_goal(var new_data) {
    setState(
      () {
        user.cal = int.parse(new_data);
      },
    );
  }

  void _change_prot_goal(var new_data) {
    setState(
      () {
        user.prot = int.parse(new_data);
      },
    );
  }

  void _change_burned_goal(var new_data) {
    setState(
      () {
        user.burned = int.parse(new_data);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'CaloCalc - My Data',
          style: TextStyle(fontSize: 40.0, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color.fromARGB(255, 9, 9, 174),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                SizedBox(
                  width: 15,
                ),
                Text(
                  "Name: " + user.name,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Color.fromARGB(255, 116, 10,
                                209)), // Set the desired color here
                      ),
                      onPressed: () async {
                        var data = await openDialog();
                        if (data == null) {
                          return;
                        } else {
                          var _detailsChannel =
                              IOWebSocketChannel.connect("ws://10.0.0.8:8820");
                          _detailsChannel.sink.add(xor_dec_enc(
                              "Update Name," + user.name + "," + data));
                          _detailsChannel.stream.listen(
                            (msg) {
                              print("Message Recieved ${xor_dec_enc(msg)}");
                              _change_name(data);
                              _detailsChannel.sink.close();
                            },
                          );
                        }
                      },
                      child: Text('Change Value'),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                SizedBox(
                  width: 15,
                ),
                Text(
                  "Weight: " + user.weight.toInt().toString(),
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Color.fromARGB(255, 116, 10,
                                209)), // Set the desired color here
                      ),
                      onPressed: () async {
                        var data = await openDialog();
                        if (data == null) {
                          return;
                        } else if (!isNumeric(data)) {
                          print("NO BONK");
                        } else if (int.parse(data) == 0) {
                          return;
                        } else {
                          var _detailsChannel =
                              IOWebSocketChannel.connect("ws://10.0.0.8:8820");
                          var dat = user.weight_data.split("/");
                          dat[0] += "-" + data;
                          dat[1] += "+" + DateTime.now().toString();
                          var new_dat = dat.join("/");
                          user.set_weight_data(new_dat);
                          _detailsChannel.sink.add(xor_dec_enc(
                              "Update Weight Data," +
                                  user.name +
                                  "," +
                                  data.toString()));
                          _detailsChannel.stream.listen(
                            (msg) {
                              print("Message Recieved ${xor_dec_enc(msg)}");
                              _change_weight_data(data);
                              _detailsChannel.sink.close();
                            },
                          );
                        }
                      },
                      child: Text('Change Value'),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                SizedBox(
                  width: 15,
                ),
                Text(
                  "Calorie Goal: " + user.cal.toString(),
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Color.fromARGB(255, 116, 10,
                                209)), // Set the desired color here
                      ),
                      onPressed: () async {
                        var data = await openDialog();
                        if (data == null) {
                          return;
                        } else if (!isNumeric(data)) {
                          print("NO BONK");
                        } else if (int.parse(data) == 0) {
                          return;
                        } else {
                          var _detailsChannel =
                              IOWebSocketChannel.connect("ws://10.0.0.8:8820");
                          _detailsChannel.sink.add(xor_dec_enc(
                              "Update Cal Goal," +
                                  user.name +
                                  "," +
                                  data.toString()));
                          _detailsChannel.stream.listen(
                            (msg) {
                              print("Message Recieved ${xor_dec_enc(msg)}");
                              _change_cal_goal(data);
                              _detailsChannel.sink.close();
                            },
                          );
                        }
                      },
                      child: Text('Change Value'),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                SizedBox(
                  width: 15,
                ),
                Text(
                  "Protein Goal: " + user.prot.toString(),
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Color.fromARGB(255, 116, 10,
                                209)), // Set the desired color here
                      ),
                      onPressed: () async {
                        var data = await openDialog();
                        if (data == null) {
                          return;
                        } else if (!isNumeric(data)) {
                          print("NO BONK");
                        } else if (int.parse(data) == 0) {
                          return;
                        } else {
                          var _detailsChannel =
                              IOWebSocketChannel.connect("ws://10.0.0.8:8820");
                          _detailsChannel.sink.add(xor_dec_enc(
                              "Update Prot Goal," +
                                  user.name +
                                  "," +
                                  data.toString()));
                          _detailsChannel.stream.listen(
                            (msg) {
                              print("Message Recieved ${xor_dec_enc(msg)}");
                              _change_prot_goal(data);
                              _detailsChannel.sink.close();
                            },
                          );
                        }
                      },
                      child: Text('Change Value'),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                SizedBox(
                  width: 15,
                ),
                Text(
                  "Burned Goal: " + user.burned.toString(),
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Color.fromARGB(255, 116, 10,
                                209)), // Set the desired color here
                      ),
                      onPressed: () async {
                        var data = await openDialog();
                        if (data == null) {
                          return;
                        } else if (!isNumeric(data)) {
                          print("NO BONK");
                        } else if (int.parse(data) == 0) {
                          return;
                        } else {
                          var _detailsChannel =
                              IOWebSocketChannel.connect("ws://10.0.0.8:8820");
                          _detailsChannel.sink.add(xor_dec_enc(
                              "Update Burned Goal," +
                                  user.name +
                                  "," +
                                  data.toString()));
                          _detailsChannel.stream.listen(
                            (msg) {
                              print("Message Recieved ${xor_dec_enc(msg)}");
                              _change_burned_goal(data);
                              _detailsChannel.sink.close();
                            },
                          );
                        }
                      },
                      child: Text('Change Value'),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                SizedBox(
                  width: 15,
                ),
                Text(
                  "Password: **********",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Color.fromARGB(255, 116, 10,
                                209)), // Set the desired color here
                      ),
                      onPressed: () async {
                        var data = await openDialog();
                        if (data == null) {
                          return;
                        } else {
                          var _detailsChannel =
                              IOWebSocketChannel.connect("ws://10.0.0.8:8820");
                          _detailsChannel.sink.add(xor_dec_enc("Update Pas," +
                              user.name +
                              "," +
                              generateMd5(data).toString()));
                          _detailsChannel.stream.listen(
                            (msg) {
                              print("Message Recieved $msg");
                              _detailsChannel.sink.close();
                            },
                          );
                        }
                      },
                      child: Text('Change Value'),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                SizedBox(
                  width: 15,
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.center,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Color.fromARGB(255, 116, 10,
                                209)), // Set the desired color here
                      ),
                      onPressed: () {
                        var _detailsChannel =
                            IOWebSocketChannel.connect("ws://10.0.0.8:8820");
                        _detailsChannel.sink
                            .add(xor_dec_enc("Logout," + user.name));
                        _detailsChannel.stream.listen(
                          (msg) {
                            print("Message Recieved $msg");
                            _detailsChannel.sink.close();
                          },
                        );
                        Navigator.push(context,
                            MaterialPageRoute(builder: (_) => Login()));
                      },
                      child: Text('LOGOUT'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.tryParse(s) != null;
  }
}
