#include <Wire.h>
#include "DFRobot_INA219.h"
#include <WiFi.h>
#include <WebServer.h>
#include <ArduinoJson.h>
#include <WiFiClient.h>


DFRobot_INA219_IIC     ina219(&Wire, INA219_I2C_ADDRESS4);

// Revise the following two paramters according to actula reading of the INA219 and the multimeter
// for linearly calibration
float ina219Reading_mA = 1000;
float extMeterReading_mA = 1000;

// Replace with your network credentials
const char* ssid = "Access-point";
const char* password = "123456789";

#define sensor A0
#define led 4
// LDR pin connections (photoresistors)
#define ldrlt A2 //LDR top left - BOTTOM LEFT
#define ldrrt A3 //LDR top rigt - BOTTOM RIGHT 
#define ldrld A6 //LDR down left - TOP LEFT
#define ldrrd  A1 //ldr down rigt - TOP RIGHT

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

void checkClient(){

  WiFiClient myclient = server.client();

  if(myclient==0){
    Serial.println("client not connected");
  }
  if(myclient.available()){
    Serial.println("client available");
  }  
  if(myclient.connected()){
    Serial.println("client connected");
  }
}

String getAvgBrightness(int list[]){
  int max_list = list[0];
  for (byte i = 0; i < sizeof(list); i+=1){
    if(max_list<list[i]){
      max_list = list[i];
      }
    }
    return(String(max_list));
  }

//Function to read brightness
String readBrightness(){
  int An_1 = getAvgBrightness(avg_list).toInt();
  int lux = -An_1*pow(2.71*11.72)*0.79;
  return String(lux);
}

void setup() {

  //Begin I2C
  Wire.begin();
  ina219.linearCalibrate(ina219Reading_mA, extMeterReading_mA);
  
  //Begin server
  Serial.begin(115200);
  Serial.print("Connecting to WiFi");
  WiFi.softAP(ssid, password);
  Serial.println("Hotspot WiFi démarré");
  Serial.print("IP Address: ");
  Serial.println(WiFi.softAPIP());
  server.on("/data", HTTP_GET, handleData);
  server.on("/morse", HTTP_POST, handleMorse);

  server.begin();
  Serial.println("Server started");
}

void handleData() {
  StaticJsonDocument<200> jsonDoc;
  jsonDoc["temperature"] = readDSTemperatureC();
  jsonDoc["rounded temperature"] = RoundedTemperature();
  jsonDoc["brightness"]= readBrightness();
  jsonDoc["voltage"]= ina219.getBusVoltage_V();
  jsonDoc["current"]=ina219.getCurrent_mA();
  jsonDoc["power"]=ina219.getPower_mW();
  String jsonString;
  serializeJson(jsonDoc, jsonString);
  server.sendHeader("Content-Type", "application/json");
  server.send(200, "application/json", jsonString);
}

//Get data from ESP32
void handleMorse() {
    String message = server.arg("message");
    Serial.println(message);
    esp_sleep_enable_timer_wakeup(message.toInt()*1000000); //light sleep
    esp_light_sleep_start();
    resetFunc(); //reset
}

void loop(){}
