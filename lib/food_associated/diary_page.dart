import 'package:flutter/material.dart';
import 'package:first_app/others/user.dart';

class FoodData extends StatefulWidget {
  User u1 = User("", 0, 0, 0, 0, 0, "", "", "", "", 0, 0, 0, 0, 0, 0);
  FoodData(User un) {
    u1 = un;
  }
  @override
  State<StatefulWidget> createState() {
    return FoodDataState();
  }
}

class FoodDataState extends State<FoodData> {
  User user = User("", 0, 0, 0, 0, 0, "", "", "", "", 0, 0, 0, 0, 0, 0);
  @override
  void initState() {
    super.initState();
    user = widget.u1;
    print("Entered Food Data");
  }

  @override
  void dispose() {
    super.dispose();
    print("Exited Food Data");
  }

  @override
  Widget build(BuildContext context) {
    var data = user.food_data;
    List dat = data.split("/");
    List dat2 = [];
    for (int i = 0; i < dat.length; i++) {
      if (dat[i] != "") {
        var changed = dat[i].split("+");
        dat2.add([changed[0], changed[1], changed[2], changed[3]]);
      }
    }
    return Scaffold(
      backgroundColor: Colors.indigo[300],
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'CaloCalc - Food Data',
          style: TextStyle(
            fontSize: 30.0,
            fontWeight: FontWeight.bold,
            color: Colors.blue[500],
          ),
        ),
        backgroundColor: Colors.cyan,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Table(
          columnWidths: {
            0: FractionColumnWidth(0.25),
            1: FractionColumnWidth(0.25),
            2: FractionColumnWidth(0.25),
            3: FractionColumnWidth(0.25),
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
                    'Date',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                TableCell(
                  child: Text(
                    'Calorie Goal',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                TableCell(
                  child: Text(
                    'Protein Goal',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                TableCell(
                  child: Text(
                    'Calories Burned Goal',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            ...List<TableRow>.generate(
              dat2.length,
              (index) => TableRow(
                children: [
                  TableCell(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        dat2[index][0],
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  TableCell(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        dat2[index][1],
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  TableCell(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        dat2[index][2],
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  TableCell(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        dat2[index][3],
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
