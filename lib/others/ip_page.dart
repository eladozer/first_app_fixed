import 'package:first_app/food_associated/main_page.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import '../login_register/login.dart';

class IP extends StatefulWidget {
  @override
  IPState createState() => IPState();
}

class IPState extends State<IP> {
  TextEditingController control = TextEditingController();
  @override
  void initState() {
    super.initState();
    print("Entered IP");
  }

  @override
  void dispose() {
    control.dispose();
    super.dispose();
    print("IP Finished");
  }

  @override
  Widget build(BuildContext context) {
    var check;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'CaloCalc',
          style: TextStyle(fontSize: 40.0, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color.fromARGB(255, 213, 134, 7),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 150,
            ),
            Padding(
              padding:
                  EdgeInsets.only(left: 25.0, right: 25.0, top: 25, bottom: 0),
              child: TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter IP Address To Connect'),
                controller: control,
              ),
            ),
            SizedBox(
              height: 100,
            ),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  Color.fromARGB(255, 213, 134, 7),
                ), // Set the desired color here
              ),
              child: Text("SUBMIT"),
              onPressed: () {
                if (control.text.split(".").length != 4) {
                  print("Not Valid");
                } else {
                  var splited = control.text.split(".");
                  if (valid(int.parse(splited[0].toString())) &&
                      valid(int.parse(splited[1].toString())) &&
                      valid(int.parse(splited[2].toString())) &&
                      valid(int.parse(splited[3].toString()))) {
                    check =
                        IOWebSocketChannel.connect("ws://${control.text}:8820");
                    var msg = "Check";
                    check.sink.add(xor_dec_enc(msg));
                    var sub;
                    sub = check.stream.listen(
                      (msg1) {
                        if (xor_dec_enc(msg1) == "YES") {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder:
                                  (context, animation, secondaryAnimation) =>
                                      Login(control.text),
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
                  } else {
                    setState(
                      () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Invalid IP Address'),
                            duration: Duration(seconds: 3),
                          ),
                        );
                      },
                    );
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  bool valid(int num) {
    bool ans1 = num <= 255;
    bool ans2 = num >= 0;
    return ans2 && ans1;
  }
}
