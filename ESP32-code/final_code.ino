#include <WiFi.h>
#include <WebServer.h>
#include <ArduinoJson.h>


// Replace with your network credentials
const char* ssid = "Access-point";
const char* password = "123456789";

#define sensor A0
#define led 4
int An_1;
int sec=0;
int currentTime=0;
bool ledState=LOW;
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
