import 'package:flutter/material.dart';
import 'package:first_app/others/user.dart';

class TodaysActivitys extends StatefulWidget {
  User u1 = User("", 0, 0, 0, 0, 0, "", "", "", "", 0, 0, 0, 0, 0, 0);
  TodaysActivitys(User u2) {
    u1 = u2;
  }
  @override
  TodaysActivityState createState() => TodaysActivityState();
}

class TodaysActivityState extends State<TodaysActivitys> {
  User user = User("", 0, 0, 0, 0, 0, "", "", "", "", 0, 0, 0, 0, 0, 0);
  @override
  void initState() {
    super.initState();
    user = widget.u1;
    print("Entered Data");
  }

  @override
  Widget build(BuildContext context) {
    var activ_dat = user.activity_data;
    List activs = [];
    for (int i = 0; i < activ_dat.length; i++) {
      activs.add(activ_dat[i]);
    }
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'CaloCalc - My Activities',
          style: TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.green[800],
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Table(
          columnWidths: {
            0: FractionColumnWidth(0.5),
            1: FractionColumnWidth(0.5),
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
                    'Activity Name',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                TableCell(
                  child: Text(
                    'Calories Burned',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            ...List<TableRow>.generate(
              activs.length,
              (index) {
                if (activs[index].isNotEmpty) {
                  return TableRow(
                    children: [
                      TableCell(
                        child: Padding(
                          padding: EdgeInsets.all(5.0),
                          child: Text(
                            activs[index].split("-")[0].toString(),
                            textAlign: TextAlign.center,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: EdgeInsets.all(5.0),
                          child: Text(
                            activs[index].split("-")[1].toString(),
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
                          padding: EdgeInsets.all(5.0),
                          child: Text(
                            activs[index],
                            textAlign: TextAlign.center,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: EdgeInsets.all(5.0),
                          child: Text(
                            activs[index],
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
    );
  }
}
