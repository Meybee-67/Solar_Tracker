#include <WiFi.h>
#include <WebServer.h>
#include <ArduinoJson.h>
#include <Servo.h>
#include <Wire.h>
#include "DFRobot_INA219.h"

//Define I2C bus
DFRobot_INA219_IIC     ina219(&Wire, INA219_I2C_ADDRESS4);

// Revise the following two paramters according to actula reading of the INA219 and the multimeter
// for linearly calibration
float ina219Reading_mA = 1000;
float extMeterReading_mA = 1000;



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

//Functions to read temperature
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

//Function to get brightness
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

void loop() 
{
  int lt = analogRead(ldrlt); // Top left
  int rt = analogRead(ldrrt); // Top right
  int ld = analogRead(ldrld); // Down left
  int rd = analogRead(ldrrd); // Down rigt
  
  // read potentiometers  
  int dtime = 10; //analogRead(4)/20;
  int tol = 50; //analogRead(5)/4;
  
  int avt = (lt + rt) / 2; // Average value top
  int avd = (ld + rd) / 2; // Average value down
  int avl = (lt + ld) / 2; // Average value left
  int avr = (rt + rd) / 2; // Average value right

  int dvert = avt - avd; // Check the diffirence of up and down
  int dhoriz = avl - avr;// Check the diffirence og left and rigt

  if (-1*tol > dvert || dvert > tol) // check if the diffirence is in the tolerance else change vertical angle
  {
  if (avt > avd)
  {
    servov = ++servov;
     if (servov > servovLimitHigh) 
     { 
      servov = servovLimitHigh;
     }
  }
  else if (avt < avd)
  {
    servov= --servov;
    if (servov < servovLimitLow)
  {
    servov = servovLimitLow;
  }
  }
  vertical.write(servov);
  }
  
  if (-1*tol > dhoriz || dhoriz > tol) // check if the diffirence is in the tolerance else change horizontal angle
  {
  if (avl > avr)
  {
    servoh = --servoh;
    if (servoh < servohLimitLow)
    {
    servoh = servohLimitLow;
    }
  }
  else if (avl < avr)
  {
    servoh = ++servoh;
     if (servoh > servohLimitHigh)
     {
     servoh = servohLimitHigh;
     }
  }
  else if (avl = avr)
  {
    // nothing
  }
  horizontal.write(servoh);
  }
   delay(dtime);
}

//Send data to server
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
