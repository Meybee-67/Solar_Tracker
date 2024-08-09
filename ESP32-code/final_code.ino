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
  An_1 = getAvgBrightness(avg_list).toInt();
  int lux = -An_1*pow(2.71*11.72)*0.79;
  return String(lux);
}

void setup() {
  
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
}

//Send data to server
void handleData() {
  StaticJsonDocument<200> jsonDoc;
  jsonDoc["temperature"] = readDSTemperatureC();
  jsonDoc["rounded temperature"] = RoundedTemperature();
  jsonDoc["brightness"]= readBrightness();
  String jsonString;
  serializeJson(jsonDoc, jsonString);
  server.sendHeader("Content-Type", "application/json");
  server.send(200, "application/json", jsonString);
}

//Get data from ESP32
void handleMorse() {
    String message = server.arg("message");
    Serial.println(message);
    digitalWrite(led,LOW);
    esp_sleep_enable_timer_wakeup(message.toInt()*1000000); //light sleep
    esp_light_sleep_start();
    digitalWrite(led,HIGH);
    resetFunc(); //reset
}
