// ignore_for_file: collection_methods_unrelated_type

import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class ArchiveScreen extends StatefulWidget {
  const ArchiveScreen({Key? key}) : super(key: key);
  @override
  _ArchiveScreenState createState() => _ArchiveScreenState();
}

class _ArchiveScreenState extends State<ArchiveScreen> {

  //Get data
String tempR = "";
bool _isLoading = false;
String _temperatureR = '';
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
  Timer mytimer = Timer.periodic(Duration(seconds: 15), (timer) {
        fetchData();
        tempR = '$_temperatureR';
        setState(() {
        if(hotspot=true){
        dataRows.add(DataRow(cells: [
              DataCell(Text(DateFormat("dd/MM/yyyy HH:mm").format(DateTime.now()))),
              DataCell(Text(tempR)),
              const DataCell(Text("Wissembourg")),
            ]));}
        });
        //mytimer.cancel() //to terminate this timer
});
  super.initState();
  }
  
  List<DataRow> dataRows = [];
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text('Data Table',style:  GoogleFonts.roboto( color:const Color.fromARGB(255, 136, 107, 195),
              fontSize: 25,
              shadows: [
                    Shadow(
                      offset: const Offset(0, 4),
                      blurRadius: 4,
                      color: Colors.black.withOpacity(.15),
                    )
                  ])),
        backgroundColor: Color.fromARGB(255, 255, 254, 254),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
      child : Column(
        children: [
          if (dataRows.isNotEmpty)
            DataTable(
              columns: const [
                DataColumn(
                  label: Text(
                    "Time",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      // color: kBlack,
                    ),
                  ),
                  numeric: true,
                ),
                DataColumn(
                  label: Text(
                    "Temperature\n(°C)",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  numeric: true,
                ),
                DataColumn(
                  label: Text(
                    "City",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  numeric: true,
                ),
              ],
              rows: dataRows,
            ),
        ],
      ),
      )
  );
  }
  }