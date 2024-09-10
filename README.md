# Solar tracker and thermometer

This project is a starting point for a Flutter Apllication software which will be used for a Solar-tracker system.
This system which is composed of a solar panel/servomotors/structure/sensors and electronic card, will fulfil two main fuctions :

- mesure and display ambient temperature and brightness
  
- to orient itself according to brightness

The ESP32 card send data (via WiFi) to the app every 30s in a Json file and the App displays the sensor readings. I also added some functionalities like a data table and a graphic which allows you to see the evolution of temperature and brightness. The app also warns you if you're not connected to the Access Point (AP) of the electronic card.
Since the ESP32 card and the servomotors are powered by the solar panel, I developped a page that allows the user to switch on the light sleep mode. Thanks to this fuctionality, the battery will save energy when the brightness is too low.
