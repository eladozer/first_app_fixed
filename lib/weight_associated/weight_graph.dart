import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:first_app/others/user.dart';

class WeightGraph extends StatefulWidget {
  User un = User("", 0, 0, 0, 0, 0, "", "", "", "", 0, 0, 0, 0, 0, 0);
  WeightGraph(User u1) {
    un = u1;
  }
  @override
  WeightGraphState createState() => WeightGraphState();
}

class WeightGraphState extends State<WeightGraph> {
  User user = User("", 0, 0, 0, 0, 0, "", "", "", "", 0, 0, 0, 0, 0, 0);
  @override
  void initState() {
    super.initState();
    user = widget.un;
    print("Entered Weight");
  }

  @override
  void dispose() {
    super.dispose();
    print("Weight done");
  }

  List<charts.Series<Weight, DateTime>> _createSampleData(List<Weight> data2) {
    final myData = data2;
    return [
      new charts.Series<Weight, DateTime>(
        id: 'Weight',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (Weight dat, _) => dat.date_time,
        measureFn: (Weight dat, _) => dat.value,
        data: myData,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    var seriesList;
    List<Weight> matches = [];
    List data2 = user.weight_data.split("/");
    List weight = data2[0].split("-");
    List td = data2[1].split("+");
    for (int i = 0; i < weight.length; i++) {
      Weight w1 = Weight(DateTime.parse(td[i]), double.parse(weight[i]));
      matches.add(w1);
    }
    seriesList = _createSampleData(matches);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'CaloCalc - Weight Graph',
          style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.green[800],
        automaticallyImplyLeading: false,
      ),
      body: charts.TimeSeriesChart(
        seriesList,
        animate: true,
        dateTimeFactory: const charts.LocalDateTimeFactory(),
        primaryMeasureAxis: charts.NumericAxisSpec(
          tickProviderSpec:
              new charts.BasicNumericTickProviderSpec(zeroBound: false),
        ),
      ),
    );
  }
}

class Weight {
  final double value;
  final DateTime date_time;
  Weight(this.date_time, this.value);
}
