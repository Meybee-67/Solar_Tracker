import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:solar_tracker/data/temperature-chart.dart';

class MyTemperatureChartScreenPage extends StatefulWidget {
  MyTemperatureChartScreenPage({Key? key}) : super(key: key);
  @override
  _MyTemperatureChartScreenPageState createState() => _MyTemperatureChartScreenPageState();
}

class _MyTemperatureChartScreenPageState extends State<MyTemperatureChartScreenPage> {
  DateTime now = DateTime.now();
  String formattedDate = DateFormat.yMMMMEEEEd().format(DateTime.now());

  //Get data
String temp="";
bool _isLoading = false;
String _temperature = "";
bool hotspot = true;
String average="";

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
          _temperature = json.decode(data.body)['temperature'];
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

//Find average
// ignore: non_constant_identifier_names
double? findAverage(List <double?>Temperature){
  double? avg=0.0;
  if(Temperature.length>1)
    {
    for(int j=1; j<Temperature.length; j++ ){
      avg!= (avg+Temperature[j]!)/(Temperature.length-1);
    }
    }
  return(avg);
}

@override
void initState() {
    Timer mytimer = Timer.periodic(const Duration(seconds: 15),(timer){
      fetchData();
      temp = '$_temperature';
      setState((){
        if(hotspot==true){
        double? tempRD = double.tryParse(temp);
        readTemperature.add(tempRD);
    }});
    });
    super.initState();
  }

  List <double?> readTemperature=[];
  Widget build(BuildContext context){
    return Scaffold(
      body : DecoratedBox(
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/pictures/solar-2.jpg"), fit: BoxFit.cover),
          ),
      child :Stack(
      children: <Widget>[
        Positioned(
        top: 40,
        left : 20,
        child :
          Container(
          margin: const EdgeInsets.only(top:20),
          height :350,
          width : 350,
          decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          ),
          child : Positioned(
            top :5,
            left:20,
            child : MyTemperatureChartPage()
          ),
        ),
        ),
        Positioned(
          top :500,
          left : 20,
          child: Container(
            margin: const EdgeInsets.only(bottom: (150 * .155) / 4),
            padding: const EdgeInsets.all(20),
            height: 125,
            width :150,
            decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                blurRadius: 20,
                spreadRadius: 1,
                color: Colors.black.withOpacity(.25))
          ],
          borderRadius: BorderRadius.circular(20),
          ),
          child : Column(
          children :[
            Text("Current \n Temperature :", style : GoogleFonts.roboto(color: Colors.black, fontSize: 14),textAlign: TextAlign.center),
            const SizedBox(height: 15), //gap
            Text(temp+"°C",style : GoogleFonts.roboto(color: Colors.black, fontSize: 20,fontWeight: FontWeight.bold),textAlign: TextAlign.center,)
            ]
          )
            )
          ),
          Positioned(
          top :500,
          right : 20,
          child: Container(
            margin: const EdgeInsets.only(bottom: (150 * .155) / 4),
            padding: const EdgeInsets.all(20),
            height: 125,
            width :150,
            decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                blurRadius: 20,
                spreadRadius: 1,
                color: Colors.black.withOpacity(.25))
          ],
          borderRadius: BorderRadius.circular(20),
          ),
          child : Column(
          children :[
            Text("Average \n Temperature :", style : GoogleFonts.roboto(color: Colors.black, fontSize: 14),textAlign: TextAlign.center),
            const SizedBox(height: 15), //gap
            if(readTemperature.isNotEmpty)
            Text("${findAverage(readTemperature)}°C",style : GoogleFonts.roboto(color: Colors.black, fontSize: 20,fontWeight: FontWeight.bold),textAlign: TextAlign.center,)
            ]
          )
            )
          ),
      ]
      ),
      )
    );
}
}