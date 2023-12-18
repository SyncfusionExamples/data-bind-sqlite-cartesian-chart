import 'dart:math';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'helper.dart';
import 'model.dart';

void main() {
  runApp(MyApp());
}

final chartKey = GlobalKey<ChartState>();
List<SalesData> salesData = <SalesData>[];

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage();

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fluttter charts using SQL db'),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
                height: 500,
                child: Chart(
                  key: chartKey,
                )),
            CRUDOperations()
          ],
        ),
      ),
    );
  }
}

class Chart extends StatefulWidget {
  Chart({Key? key}) : super(key: key);
  @override
  ChartState createState() => ChartState();
}

class ChartState extends State<Chart> {
  ChartState({Key? key});

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(series: <SplineSeries<SalesData, num>>[
      SplineSeries<SalesData, num>(
          animationDuration: 0,
          dataSource: salesData,
          xValueMapper: (SalesData sales, _) => sales.xValue,
          yValueMapper: (SalesData sales, _) => sales.yValue,
          name: 'Sales')
    ]);
  }
}

class CRUDOperations extends StatefulWidget {
  @override
  CRUDOperationsState createState() => CRUDOperationsState();
}

class CRUDOperationsState extends State<CRUDOperations> {
  late DataBaseHelper dbHelper;
  late int count;
  late SalesData data;
  @override
  void initState() {
    super.initState();
    count = 1;
    dbHelper = DataBaseHelper.instance;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
                onPressed: () async {
                  dbHelper.add(
                      SalesData(xValue: count, yValue: getRandomInt(10, 20)));
                  salesData = await dbHelper.getSales();
                  chartKey.currentState!.setState(() {});
                  count++;
                },
                child: Text('Add')),
            ElevatedButton(
                onPressed: () async {
                  // dbHelper.deleteTable();
                  salesData = await dbHelper.getSales();
                  if (salesData.isNotEmpty) {
                    data = salesData.last;
                    dbHelper.delete(
                        salesData[salesData.indexOf(data)].xValue!.toInt());
                    salesData = await dbHelper.getSales();
                    chartKey.currentState!.setState(() {});
                    count--;
                  }
                },
                child: Text('Delete')),
          ],
        ));
  }

  int getRandomInt(int min, int max) {
    final Random random = Random();
    return min + random.nextInt(max - min);
  }
}
