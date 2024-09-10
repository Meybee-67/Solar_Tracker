//importer un module qui detecte la Plateforme
// ignore_for_file: unused_element

import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:solar_tracker/connection/no-data.dart';
import 'package:solar_tracker/screens/home_page.dart';
import 'package:wifi_iot/wifi_iot.dart';

class ConnectionPage extends StatefulWidget {
  const ConnectionPage({super.key});

  @override
  State<ConnectionPage> createState() => _ConnectionPageState();
}

class _ConnectionPageState extends State<ConnectionPage> {
  final String ssid = "Acces-point";
  final String password = "123456789";
  bool isConnecting = false;
  bool isConnected = false;

  @override
  void initState() {
    super.initState();
    initConnection();
  }

void initConnection() async {
  if (!await WiFiForIoTPlugin.isEnabled()) {
    if (!mounted) return; // Ajoutez cette ligne pour s'assurer que le widget est toujours monté
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('WiFi Disabled'),
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
  }
  try {
    String? currentSSID = await WiFiForIoTPlugin.getWiFiAPSSID();
    if (currentSSID != ssid) {
      if (!mounted) return; // Ajoutez cette ligne avant de changer l'état
      setState(() {
        isConnecting=false;
      });
      await WiFiForIoTPlugin.connect(
        ssid,
        password: password,
        joinOnce: true,
        security: NetworkSecurity.WPA,
        timeoutInSeconds: 10,
      );
      if (!mounted) return; // Vérifiez à nouveau avant de modifier l'état
      setState(() {
        isConnecting=false;
        isConnected = false;
      });
    } else {
      if (!mounted) return; // Encore ici avant de changer l'état
      setState(() {
        isConnecting = false;
        isConnected = true;
      });
    }
  } catch (e) {
    if (!mounted) return; // Vérifiez avant de montrer la boîte de dialogue
    setState(() {
      isConnecting = false;
      isConnected=true;
    });
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Start appplication...'),
        actions: [
          TextButton(
            onPressed: () {
              if (!mounted) return; // Vérifiez avant de naviguer
              Navigator.pop(context);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: isConnecting
            ? const CircularProgressIndicator()
            : isConnected
                ? const MyHomePage()
                :  NoDataPage()
      ),
    );
  }
}