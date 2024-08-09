#include <WiFi.h>
#include <WebServer.h>
#include <ArduinoJson.h>
#include <Servo.h>


// Replace with your network credentials
const char* ssid = "Access-point";
const char* password = "123456789";

//Define sensors & variables

#define sensor A0

// LDR pin connections (photoresistors)
#define ldrlt A2 //LDR top left - BOTTOM LEFT
#define ldrrt A3 //LDR top rigt - BOTTOM RIGHT 
#define ldrld A0 //LDR down left - TOP LEFT
#define ldrrd  A1 //ldr down rigt - TOP RIGHT

// 180 horizontal & vertical angle MAX
int servohLimitHigh = 180;
int servohLimitLow = 180;

//Initialize the two servos
Servo horizontal;
Servo vertical;
int servoh = 90; 
int servov = 90; 
int servovLimitHigh = 120;
int servovLimitLow = 15;

//Initialize temperature sensor
int An_1;
void(* resetFunc) (void) = 0;

WebServer server(80);

void handleData();
void handleMorse();

String readDSTemperatureC() {
  An_1 = analogRead(sensor);
  float voltage= An_1 * (3.3/4095.0);
  float tempC = (voltage - 0.58)/0.007;
  return String(tempC);
}

String RoundedTemperature(){
   An_1 = analogRead(sensor);
  float voltage= An_1 * (3.3/4095.0);
  int tempR = (voltage - 0.58)/0.007;
  return String(tempR);
}
