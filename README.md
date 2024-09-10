# Solar tracker and thermometer

This project is a starting point for a Flutter Apllication software which will be used for a Solar-tracker system.
This system will fulfil two main fuctions :

- mesure and display ambient temperature and brightness
  
- to orient itself according to brightness

The ESP32 card send data (via WiFi) to the app every 30s in a Json file and the App displays the sensor readings. It also warns you if you're not connected to the Access Point (AP) of the electronic card. 
