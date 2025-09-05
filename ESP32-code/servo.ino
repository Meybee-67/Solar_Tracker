#include <ESP32Servo.h>

Servo monServo;

void setup() {
  Serial.begin(9600);
  monServo.attach(9);
  monServo.write(180);  // Position initiale à 180°
  Serial.println("Position initiale : 180°");
  delay(1000);
}

void loop() {
  // Mouvement de 180° à 90° (sens horaire)
  for (int angle = 90; angle <= 180; angle++) {
    monServo.write(angle);
    Serial.print("Angle actuel : ");
    Serial.print(angle);
    Serial.println("°");
    delay(15);
  }

  delay(1000);  // Pause à 90°

  // Retour à 180° (sens anti-horaire)
  for (int angle = 180; angle >= 90; angle--) {
    monServo.write(angle);
    Serial.print("Angle actuel : ");
    Serial.print(angle);
    Serial.println("°");
    delay(15);
  }

  delay(1000);  // Pause à 0°
}
