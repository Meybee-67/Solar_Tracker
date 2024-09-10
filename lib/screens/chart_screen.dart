import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:animated_flip_widget/animated_flip_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:solar_tracker/data/lux_chart.dart';
import 'package:solar_tracker/data/temperature-chart.dart';

class MyChartScreenPage extends StatefulWidget {
  MyChartScreenPage({Key? key}) : super(key: key);
  @override
  _MyChartScreenPageState createState() => _MyChartScreenPageState();
}

class _MyChartScreenPageState extends State<MyChartScreenPage> {
  DateTime now = DateTime.now();
  String formattedDate = DateFormat.yMMMMEEEEd().format(DateTime.now());

  //Get data
String temp="";
String bright="";
bool _isLoading = false;
String _temperature = "";
String _brightness = "";
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
          _brightness = json.decode(data.body)['brightness'];
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


@override
void initState() {
    Timer mytimer = Timer.periodic(const Duration(seconds: 15),(timer){
      fetchData();
      temp = '$_temperature';
      bright = '$_brightness';
      setState((){
    });
    });
    super.initState();
  }

  final controller = FlipController();
  FlipDirection direction = FlipDirection.horizontal;

  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text('Realtime chart',style:  GoogleFonts.roboto( color:Colors.white,
              fontSize: 25,
              shadows: [
                    Shadow(
                      offset: const Offset(0, 4),
                      blurRadius: 4,
                      color: Colors.black.withOpacity(.15),
                    )
                  ])),
        centerTitle: true,
  ),
      extendBodyBehindAppBar: true,
      body : DecoratedBox(
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/pictures/solar-2.jpg"), fit: BoxFit.cover),
          ),
      child :Stack(
      children: <Widget>[
        Positioned(
        top: 10,
        left : 20,
        child : AnimatedFlipWidget(
          front: const _FrontWidget(),
          back: const _BackWidget(),
          flipDirection: direction,
          controller: controller,
        ),
        ),
        Positioned(
          top :400,
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
          top :400,
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
            Text("Brightness :", style : GoogleFonts.roboto(color: Colors.black, fontSize: 14),textAlign: TextAlign.center),
            const SizedBox(height: 15), //gap
            Text(bright+"lux",style : GoogleFonts.roboto(color: Colors.black, fontSize: 20,fontWeight: FontWeight.bold),textAlign: TextAlign.center,)
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

class _FrontWidget extends StatelessWidget {
  const _FrontWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}

class _BackWidget extends StatelessWidget {
  const _BackWidget({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
  return Container(
      margin: const EdgeInsets.only(top:20),
          height :350,
          width : 350,
          decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          ),
          child : Positioned(
            top :5,
            left:20,
            child : MyLuxChartPage()
          ),
    );
  }
}