import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class MyTemperatureChartPage extends StatefulWidget {
  MyTemperatureChartPage({Key? key}) : super(key: key);
  @override
  _MyTemperatureChartPageState createState() => _MyTemperatureChartPageState();
}

class _MyTemperatureChartPageState extends State<MyTemperatureChartPage> {
  late List<LiveData> chartData;
  late ChartSeriesController _chartSeriesController;

//Get data
bool _isLoading = false;
String _temperatureR = "";
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
          _temperatureR = json.decode(data.body)['temperature'];
          _isLoading = false;
        });
      } else {
        setState(() {
          _temperatureR = "Failed to fetch data";
          _isLoading = false;
          hotspot = false;
        });
      }
    } catch (e) {
      log("", error: e, name: "error");
      setState(() {
        _temperatureR = "Failed to fetch data";
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
      String tempR = '$_temperatureR';
      setState(() {
        if(hotspot=true){
        double? tempRD = double.tryParse(tempR);
        chartData.add(LiveData(DateTime.now(),tempRD));
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
                text:'Temperature',
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
            color: const Color.fromARGB(255, 126, 205, 245),
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
                    minimum: -10,
                    maximum: 40,
                    interval: 5,
                    title: AxisTitle(text: '(°C)')))));
  }


  List<LiveData> getChartData() {
    return <LiveData>[
      LiveData(DateTime.now(), 0),
      LiveData(DateTime.now(),0),
      LiveData(DateTime.now(), 5),
    ];
  }
}

class LiveData {
  LiveData(this.time, this.speed);
  final DateTime time;
  final double? speed;
}