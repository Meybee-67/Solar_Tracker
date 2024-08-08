#include <WiFi.h>
#include <WebServer.h>
#include <ArduinoJson.h>

// Replace with your network credentials
const char* ssid = "Access-point";
const char* password = "123456789";

#define sensor A0
#define led 4
#define lux A1
int An_1;
int An_0;
bool ledState=LOW;
void(* resetFunc) (void) = 0;

WebServer server(80);

void handleData();
void handleMorse();

String readDSTemperatureC() {
  An_0 = analogRead(sensor);
  float voltage= An_0 * (3.3/4095.0);
  float tempC = (voltage - 0.58)/0.007;
  return String(tempC);
}

String RoundedTemperature(){
   An_0 = analogRead(sensor);
  float voltage= An_0 * (3.3/4095.0);
  int tempR = (voltage - 0.58)/0.007;
  return String(tempR);
}

String readBrightness(){
  An_1 = analogRead(lux);
  float voltage= An_1 * (3.3/4095.0);
  int lux = -An_1*pow(2.71*11.72)*0.79;
  return String(lux);
}

void setup() {

  currentTime = millis();
  //initalize led
  pinMode(led,OUTPUT);
  digitalWrite(led,LOW);

  //begin server
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

void loop(){
  server.handleClient();
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
