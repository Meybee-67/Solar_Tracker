// ignore_for_file: library_private_types_in_public_api, use_super_parameters

import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:solar_tracker/screens/home_page.dart';
import 'package:wifi_iot/wifi_iot.dart';

class NoDataPage extends StatefulWidget {
  const NoDataPage({Key? key}) : super(key: key);

  @override
  _NoDataPageState createState() => _NoDataPageState();
}

class _NoDataPageState extends State<NoDataPage>{
  @override
  Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      centerTitle: true,
          title: Text('Error',style:GoogleFonts.roboto(color:Colors.red, fontSize: 30,fontWeight: FontWeight.bold,
          shadows: [
                    Shadow(
                      offset: const Offset(0, 4),
                      blurRadius: 4,
                      color: Colors.black.withOpacity(.15),
                    )
                  ])),
          backgroundColor: Colors.white,
        ),
        body: Center(
        child: Column(
            children:<Widget>[
              Positioned(
                top:150,
                child : Image.asset("assets/pictures/data_not_found.jpg",scale:0.7,),
                ),
              Container(
                alignment: Alignment.center,
                child: Text('AP connection lost...',style: GoogleFonts.roboto(
                  color: Colors.black,
                  fontSize:16),)
              ),
              Positioned(
            bottom: 50,
            left: 30,
            child: ElevatedButton(
              onPressed: () {
                showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('WiFi disabled'),
        content: const Text('Please enable WiFi, and try again'),
        actions: [
          TextButton(
            onPressed: () async {
              if (!mounted) return; // Ajoutez cette ligne ici aussi
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const MyHomePage()),
                (Route<dynamic> route) => false
              );
              
            if (Platform.isAndroid) {
            await WiFiForIoTPlugin.setEnabled(true, shouldOpenSettings: true);
            }
            
            },
            child: const Text('Enable WiFi'),
          ),
        ],
      ),
    );
              },
              child: Text("Reconnect",style: GoogleFonts.roboto(color:Colors.black))
            ),
          )
            ],
          )
        ),
        );
  }
}