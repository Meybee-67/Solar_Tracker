import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class MyLuxChartPage extends StatefulWidget {
  MyLuxChartPage({Key? key}) : super(key: key);
  @override
  _MyLuxChartPageState createState() => _MyLuxChartPageState();
}

class _MyLuxChartPageState extends State<MyLuxChartPage> {
  late List<LiveData> chartData;
  late ChartSeriesController _chartSeriesController;

//Get data
bool _isLoading = false;
String _brightness = "";
bool hotspot = true;

Future<void> fetchData() async {
  setState(() {
    _isLoading = true;
  });
    try {
      final data = await http.get(
        Uri.parse('http://192.168.4.1/data'),
      );
      log("this is the response: $data");

      if (data.statusCode == 200) {
        setState(() {
          _brightness = json.decode(data.body)['brightness'];
          _isLoading = false;
        });
      } else {
        setState(() {
          _brightness = "Failed to fetch data";
          _isLoading = false;
          hotspot = false;
        });
      }
    } catch (e) {
      log("", error: e, name: "error");
      setState(() {
        _brightness = "Failed to fetch data";
        _isLoading = false;
        hotspot=false;
      });
    }
    _isLoading = false;
  }


  @override
  void initState() {
    chartData = getChartData();
    Timer mytimer = Timer.periodic(const Duration(seconds: 15),(timer){
      fetchData();
      String bright = '$_brightness';
      setState(() {
        if(hotspot=true){
        double? brightR = double.tryParse(bright);
        chartData.add(LiveData(DateTime.now(),brightR));
      chartData.removeAt(0);
      _chartSeriesController.updateDataSource(
      addedDataIndex: chartData.length - 1, removedDataIndex: 0);
      }});
    });
    super.initState();
  }

  Widget build(BuildContext context) {
    return SafeArea(
    child : Scaffold(
            body: SfCartesianChart(
              title: const ChartTitle(
                text:'Brightness',
                alignment: ChartAlignment.near,
                  textStyle: TextStyle(
                    color: Color.fromARGB(255, 0, 0, 0),
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  )
              ),
                series: <LineSeries<LiveData, DateTime>>[
          LineSeries<LiveData, DateTime>(
            onRendererCreated: (ChartSeriesController controller) {
              _chartSeriesController = controller;
            },
            dataSource: chartData,
            color: Colors.amber,
            xValueMapper: (LiveData sales, _) => sales.time,
            yValueMapper: (LiveData sales, _) => sales.speed,
          )
        ],
                primaryXAxis: DateTimeCategoryAxis(
                    majorGridLines: MajorGridLines(width: 0),
                    dateFormat: DateFormat.Hms(),
                    edgeLabelPlacement: EdgeLabelPlacement.shift,
                    intervalType: DateTimeIntervalType.hours,
                    interval: 6,
                    ),
                primaryYAxis: const NumericAxis(
                    axisLine: AxisLine(width: 0),
                    majorTickLines: MajorTickLines(size: 0),
                    minimum: 700,
                    maximum: 100000,
                    interval: 3000,
                    title: AxisTitle(text: '(lux)')))));
  }


  List<LiveData> getChartData() {
    return <LiveData>[
      LiveData(DateTime.now(), 100),
      LiveData(DateTime.now(),100),
      LiveData(DateTime.now(), 100),
    ];
  }
}

class LiveData {
  LiveData(this.time, this.speed);
  final DateTime time;
  final double? speed;
}