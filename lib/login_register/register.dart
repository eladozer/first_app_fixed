import 'package:first_app/others/bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:web_socket_channel/io.dart';
import 'package:first_app/others/user.dart';
import 'package:first_app/others/encryption.dart';

class Register extends StatefulWidget {
  @override
  RegState createState() => RegState();
}

class RegState extends State<Register> {
  var _regChannel;
  final control = TextEditingController();
  final ctrl = TextEditingController();
  final cntl = TextEditingController();
  final control2 = TextEditingController();
  final ctrl2 = TextEditingController();
  final ctrl1 = TextEditingController();
  @override
  void initState() {
    super.initState();
    print("Entered Register");
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    control.dispose();
    ctrl.dispose();
    control2.dispose();
    ctrl2.dispose();
    ctrl1.dispose();
    cntl.dispose();
    super.dispose();
    print("Register Finished");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'CaloCalc - Register',
          style: TextStyle(fontSize: 35.0, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 75,
            ),
            Padding(
              //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                inputFormatters: [
                  FilteringTextInputFormatter.deny(RegExp(r"\s")),
                ],
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Username',
                    hintText: 'Enter valid username id'),
                controller: control,
              ),
            ),
            Padding(
              padding:
                  EdgeInsets.only(left: 15.0, right: 15.0, top: 15, bottom: 0),
              //padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                obscureText: true,
                inputFormatters: [
                  FilteringTextInputFormatter.deny(RegExp(r"\s")),
                ],
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                    hintText: 'Enter secure password'),
                controller: ctrl,
              ),
            ),
            SizedBox(
              height: 17,
            ),
            Padding(
              //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.deny(RegExp(r"\s")),
                ],
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Weight',
                    hintText: 'Enter weight in kilograms'),
                controller: cntl,
              ),
            ),
            Padding(
              padding:
                  EdgeInsets.only(left: 15.0, right: 15.0, top: 15, bottom: 0),
              //padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.deny(RegExp(r"\s")),
                ],
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Calorie',
                    hintText: 'Enter first calorie goal'),
                controller: control2,
              ),
            ),
            Padding(
              padding:
                  EdgeInsets.only(left: 15.0, right: 15.0, top: 15, bottom: 0),
              //padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.deny(RegExp(r"\s")),
                ],
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Protein',
                    hintText: 'Enter first protein goal'),
                controller: ctrl2,
              ),
            ),
            Padding(
              padding:
                  EdgeInsets.only(left: 15.0, right: 15.0, top: 15, bottom: 0),
              //padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.deny(RegExp(r"\s")),
                ],
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Burned',
                    hintText: 'Enter first Calories Burned goal'),
                controller: ctrl1,
              ),
            ),
            SizedBox(
              height: 45,
            ),
            ElevatedButton(
              onPressed: () {
                if (control.text == " ") {
                } else {
                  var channel =
                      IOWebSocketChannel.connect("ws://10.0.0.8:8820");
                  String msg = "In User,${control.text}";
                  channel.sink.add(xor_dec_enc(msg));
                  channel.stream.listen(
                    (message1) {
                      String msg = xor_dec_enc(message1);
                      if (msg == "False") {
                        if (!isNumeric(cntl.text) ||
                            !isNumeric(control2.text) ||
                            !isNumeric(ctrl2.text) ||
                            !isNumeric(ctrl1.text)) {
                        } else if (int.parse(cntl.text) == 0 ||
                            int.parse(control2.text) == 0 ||
                            int.parse(ctrl2.text) == 0 ||
                            int.parse(ctrl1.text) == 0) {
                        } else {
                          _regChannel =
                              IOWebSocketChannel.connect("ws://10.0.0.8:8820");
                          String message =
                              "Register,${control.text},${generateMd5(ctrl.text)},${cntl.text},${control2.text},${ctrl2.text},${ctrl1.text}";
                          _regChannel.sink.add(xor_dec_enc(message));
                          User u1 = new User(
                              control.text,
                              double.parse(cntl.text),
                              int.parse(control2.text),
                              int.parse(ctrl2.text),
                              0,
                              0,
                              cntl.text + "/" + (DateTime.now()).toString(),
                              "",
                              "",
                              "",
                              int.parse(ctrl1.text),
                              0,
                              0,
                              0,
                              0,
                              0);
                          var sub;
                          sub = _regChannel.stream.listen(
                            (msg) {
                              if (xor_dec_enc(msg).toLowerCase() == "no") {
                                sub.cancel();
                                _regChannel.sink.close();
                                return;
                              } else {
                                sub.cancel();
                                _regChannel.sink.close();
                                Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder: (context, animation,
                                            secondaryAnimation) =>
                                        BottomNavi(u1),
                                    transitionsBuilder: (context, animation,
                                        secondaryAnimation, child) {
                                      var begin = Offset(1.0, 0.0);
                                      var end = Offset.zero;
                                      var curve = Curves.ease;

                                      var tween = Tween(begin: begin, end: end)
                                          .chain(CurveTween(curve: curve));

                                      return SlideTransition(
                                        position: animation.drive(tween),
                                        child: child,
                                      );
                                    },
                                  ),
                                );
                              }
                            },
                          );
                        }
                      } else {
                        print("In User");
                        setState(
                          () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content:
                                    Text('Cant Register An Exisiting User'),
                                duration: Duration(seconds: 3),
                              ),
                            );
                          },
                        );
                      }
                      channel.sink.close();
                    },
                  );
                }
              },
              child: Text("Register"),
            ),
          ],
        ),
      ),
    );
  }

  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    // TODO according to DartDoc num.parse() includes both (double.parse and int.parse)
    return double.parse(s) != null || int.parse(s) != null;
  }
}
