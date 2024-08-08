# Solar tracker : final version

The main objective of this project is to design a solar tracker capable of powering different sensors (temperature, brightness, humidity...).

The various functions that this system must perform are:
  - displaying the temperature/brightness/humididty
  - ressearching the maximum of brightness in order to supply the system by solar energy (control the angle of the solar pannel)


I decided to develop a Flutter application that displays the temperature and luminosity, the ESP32 send (via WiFi) each 15 sec a jsonFile with all the data the sensors get.
The main screen of the application displays these data and the date, on the others screens, there are datatables and realtime charts.
I also added a time-picker : the user can put the ESP32 in the "Light sleep" mode and decide the time the WiFi will be disabled, in order to save energy when we're not unsing this system, or when there's not enough light.
