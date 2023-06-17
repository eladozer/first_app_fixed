import 'package:first_app/login_register/register.dart';
import 'package:first_app/others/bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:web_socket_channel/io.dart';
import 'package:first_app/others/user.dart';
import 'package:first_app/others/encryption.dart';
import '../others/ip_page.dart';

String url = "https://api.api-ninjas.com/v1/nutrition?query=";

class Login extends StatefulWidget {
  var adr = "";
  Login(var ad) {
    adr = ad;
  }
  @override
  LoginState createState() => LoginState();
}

class LoginState extends State<Login> {
  var _LogChannel;
  var adr = "";
  final control = TextEditingController();
  final ctrl = TextEditingController();
  @override
  void initState() {
    super.initState();
    adr = widget.adr;
    print("Entered Login");
  }

  @override
  void dispose() {
    control.dispose();
    ctrl.dispose();
    super.dispose();
    print("Login Finished");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyan[200],
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'CaloCalc - Login',
          style: TextStyle(fontSize: 40.0, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.teal,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 120,
            ),
            Padding(
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
                inputFormatters: [
                  FilteringTextInputFormatter.deny(RegExp(r"\s")),
                ],
                obscureText: true,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                    hintText: 'Enter secure password'),
                controller: ctrl,
              ),
            ),
            SizedBox(
              height: 45,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => Register(adr)));
              },
              child: Text(
                'Register',
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.teal),
              ),
            ),
            SizedBox(
              height: 45,
            ),
            Container(
              height: 50,
              width: 250,
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(20)),
              child: ElevatedButton(
                onPressed: () {
                  _LogChannel = IOWebSocketChannel.connect("ws://${adr}:8820");
                  var sub;
                  String message =
                      "Login,${control.text},${generateMd5(ctrl.text)}";
                  _LogChannel.sink.add(xor_dec_enc(message));
                  sub = _LogChannel.stream.listen(
                    (msg) {
                      print("Message Received: ${xor_dec_enc(msg)}");
                      var params = xor_dec_enc(msg).split(",");
                      if (params[0] == control.text) {
                        print("Has Login");
                        sub.cancel();
                        var data =
                            params[6].toString() + "/" + params[7].toString();
                        User u1 = User(
                            control.text,
                            double.parse(params[1]),
                            int.parse(params[2]),
                            int.parse(params[3]),
                            int.parse(params[4]),
                            int.parse(params[5]),
                            data,
                            params[9].toString(),
                            params[10].toString(),
                            params[13].toString(),
                            int.parse(params[12]),
                            int.parse(params[11]),
                            int.parse(params[14]),
                            int.parse(params[15]),
                            int.parse(params[16]),
                            int.parse(params[17]));
                        _LogChannel.sink.close();
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    BottomNavi(u1, adr),
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
                      } else {
                        setState(
                          () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Message: ${xor_dec_enc(msg)}'),
                                duration: Duration(seconds: 3),
                              ),
                            );
                          },
                        );
                      }
                      _LogChannel.sink.close();
                    },
                  );
                },
                child: Text(
                  'Login',
                  style: TextStyle(color: Colors.white, fontSize: 40),
                ),
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.teal),
                ),
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Container(
              height: 30,
              width: 150,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (_) => IP()));
                },
                child: Text(
                  'Enter New IP',
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.teal),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
