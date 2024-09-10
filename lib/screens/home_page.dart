import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:solar_tracker/connection/no-data.dart';
import 'package:solar_tracker/screens/buttom_bar.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

//Constants
String tempR = "";
bool _isLoading = false;
String _temperature= '';
bool hotspot = true;

Future<void> fetchData() async {
  setState(() {
    _isLoading = true;
  });
    try {
      final temperature = await http.get(
        Uri.parse('http://192.168.4.1/data'),
      );
      log("this is the response: $temperature");

      if (temperature.statusCode == 200) {
        setState(() {
          _temperature = json.decode(temperature.body)['rounded temperature'];
          _isLoading = false;
        });
      } else {
        setState(() {
          _temperature = "Failed to fetch data";
          _isLoading = false;
          hotspot = false;
        });
      }
    } catch (e) {
      log("", error: e, name: "error");
      setState(() {
        _temperature = "Failed to fetch data";
        _isLoading = false;
        hotspot=false;
      });
    }
    _isLoading = false;
  }

void initState() {
  Timer mytimer = Timer.periodic(Duration(seconds: 5), (timer) {
        fetchData();
        tempR = '$_temperature';
        setState(() {
        });
        //mytimer.cancel() //to terminate this timer
});
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:Stack(
          children : [
              hotspot
              // ignore: prefer_interpolation_to_compose_strings
              ? BottomBarWidget()
              : const NoDataPage(),
            ]
            //show time on UI
        )
          );
  }
}