import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_gauges/gauges.dart';

class MyPowerScreenPage extends StatefulWidget {
  MyPowerScreenPage({Key? key}) : super(key: key);
  @override
  _MyPowerScreenPageState createState() => _MyPowerScreenPageState();
}

class _MyPowerScreenPageState extends State<MyPowerScreenPage> {
  //Get data
  String power="";
  String current="";
  String voltage="";
  String _power="";
  String _current="";
  String _voltage="";
  bool _isLoading = false;
  bool hotspot = true;
  double Pow=0.0;

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
          _power = json.decode(data.body)['power'];
          _current=json.decode(data.body)['current'];
          _voltage=json.decode(data.body)['voltage'];
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
          hotspot = false;
        });
      }
    } catch (e) {
      log("", error: e, name: "error");
      setState(() {
        _isLoading = false;
        hotspot=false;
      });
    }
    _isLoading = false;
  }

  @override
void initState() {
    Timer mytimer = Timer.periodic(const Duration(seconds: 15),(timer){
      fetchData();
      current = '$_current';
      voltage= '$_voltage';
      power ='$_power';
      setState((){
        if(power.isEmpty){
        Pow=0.0;
      }
      else{
        Pow=double.parse(power);
      }
        });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title : Text("Wattmeter (Solar panel)",style:  GoogleFonts.roboto( color:const Color.fromARGB(255, 136, 107, 195),
              fontSize: 25,
              shadows: [
                    Shadow(
                      offset: const Offset(0, 4),
                      blurRadius: 4,
                      color: Colors.black.withOpacity(.15),
                    )
                  ])
        ),
      ),
      body : Stack(
        children: <Widget>[
        Positioned(
        top: 20,
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
            child :  SfRadialGauge(
              axes: <RadialAxis>[
                RadialAxis(
                  minimum: 0,
                  maximum: 1000,
                  annotations: <GaugeAnnotation>[
                    GaugeAnnotation(widget: Text(power+'mW',style: const TextStyle(fontSize: 25,fontWeight: FontWeight.bold)),
                    angle: 90,positionFactor: 0.5)],
                  ranges: <GaugeRange>[
            GaugeRange(
                startValue: 0,
                endValue: Pow,
                color: Colors.amber,
                startWidth: 10,
                endWidth: 10),
                  ]
                  )
                  ]),
          ),
        ),
        ),
        Positioned(
          top :450,
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
            Text("Voltage :", style : GoogleFonts.roboto(color: Colors.black, fontSize: 14),textAlign: TextAlign.center),
            const SizedBox(height: 15), //gap
            Text(voltage+"V",style : GoogleFonts.roboto(color: Colors.black, fontSize: 20,fontWeight: FontWeight.bold),textAlign: TextAlign.center,)
            ]
          )
            )
          ),
          Positioned(
          top :450,
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
            Text("Current :", style : GoogleFonts.roboto(color: Colors.black, fontSize: 14),textAlign: TextAlign.center),
            const SizedBox(height: 15), //gap
            Text(current+"mA",style : GoogleFonts.roboto(color: Colors.black, fontSize: 20,fontWeight: FontWeight.bold),textAlign: TextAlign.center,)
            ]
          )
            )
          ),
      ]
      )
    );
}
}