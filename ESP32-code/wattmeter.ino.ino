#include <Wire.h>
#include "DFRobot_INA219.h"

DFRobot_INA219_IIC     ina219(&Wire, INA219_I2C_ADDRESS4);

// Revise the following two paramters according to actula reading of the INA219 and the multimeter
// for linearly calibration
float ina219Reading_mA = 1000;
float extMeterReading_mA = 1000;

void setup(void) 
{
    Wire.begin();
    Serial.begin(115200);
    while(!Serial);
    Serial.println();
    while(ina219.begin() != true) {
        Serial.println("INA219 begin failed");
        delay(2000);
    }
    ina219.linearCalibrate(ina219Reading_mA, extMeterReading_mA);
    Serial.println();
}

void loop(void)
{
    Serial.print("BusVoltage:   ");
    Serial.print(ina219.getBusVoltage_V(), 2);
    Serial.println("V");
    Serial.print("ShuntVoltage: ");
    Serial.print(ina219.getShuntVoltage_mV(), 3);
    Serial.println("mV");
    Serial.print("Current:      ");
    Serial.print(ina219.getCurrent_mA(), 1);
    Serial.println("mA");
    Serial.print("Power:        ");
    Serial.print(ina219.getPower_mW(), 1);
    Serial.println("mW");
    Serial.println("");
    delay(1000);
}