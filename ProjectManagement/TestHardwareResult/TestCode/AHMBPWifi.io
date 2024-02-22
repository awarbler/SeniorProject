#include <SimpleDHT.h>
#include <WiFiS3.h>

#include "arduino_secrets.h" 

// WiFi credentials
char ssid[] = SECRET_SSID;        // your network SSID (name)
char pass[] = SECRET_PASS;        // your network password (use for WPA, or use as key for WEP)
int status = WL_IDLE_STATUS;      // the WiFi radio's status

// DHT setup
int pinDHT11 = 2;
SimpleDHT11 dht11;

// Motion Sensor setup
int pirPin = 7;
int pirValue;

// Button setup
const int buttonPin = 4;
const int ledPin = 13;

void setup() {
  Serial.begin(9600);

  // WiFi setup
  connectToWiFi();

  // DHT setup
  pinMode(pinDHT11, INPUT);

  // Motion Sensor setup
  pinMode(pirPin, INPUT);
  digitalWrite(ledPin, LOW);

  // Button setup
  pinMode(buttonPin, INPUT);
}

void loop() {
  // Read the state of the pushbutton value
  int buttonState = digitalRead(buttonPin);

  // Check if the pushbutton is pressed or there is motion detected
  if (buttonState == HIGH || digitalRead(pirPin) == HIGH) {
    // Turn LED on
    digitalWrite(ledPin, HIGH);

    // Print messages
    if (buttonState == HIGH) {
      Serial.println("Button pushed");
    }
    if (digitalRead(pirPin) == HIGH) {
      Serial.println("Motion detected");
    }

    // Get temperature and humidity reading
    byte temperature = 0;
    byte humidity = 0;
    byte data[40] = {0};
    if (!dht11.read(pinDHT11, &temperature, &humidity, data)) {
      // Print temperature in Celsius
      Serial.print("Temperature (C): ");
      Serial.print((int)temperature);
      Serial.println(" °C");

      // Convert temperature to Fahrenheit
      float temperatureF = (temperature * 1.8) + 32;

      // Print temperature in Fahrenheit
      Serial.print("Temperature (F): ");
      Serial.print(temperatureF);
      Serial.println(" °F");

      // Print humidity
      Serial.print("Humidity: ");
      Serial.print((int)humidity);
      Serial.println(" %");
    } else {
      Serial.println("Failed to read temperature and humidity");
    }

    // Wait for 2 minutes before allowing another reading
    delay(2000); // 2-minute delay

    // Turn off LED
    digitalWrite(ledPin, LOW);
  }

  // Delay before next iteration
  delay(1000); // 1-second delay
}

void connectToWiFi() {
  //Attempt to connect to WiFi network:
  while (status != WL_CONNECTED) {
    Serial.print("Attempting to connect to WPA SSID: ");
    Serial.println(ssid);
    // Connect to WPA/WPA2 network:
    status = WiFi.begin(ssid, pass);
    // wait 10 seconds for connection:
    delay(10000);
  }

  // You're connected now, so print out the data:
  Serial.print("You're connected to the network");
  printWifiData();
}

void printWifiData() {
  // Print your board's IP address:
  IPAddress ip = WiFi.localIP();
  Serial.print("IP Address: ");
  Serial.println(ip);

  // Print your MAC address:
  byte mac[6];
  WiFi.macAddress(mac);
  Serial.print("MAC address: ");
  printMacAddress(mac);
}

void printMacAddress(byte mac[]) {
  for (int i = 5; i >= 0; i--) {
    if (mac[i] < 16) {
      Serial.print("0");
    }
    Serial.print(mac[i], HEX);
    if (i > 0) {
      Serial.print(":");
    }
  }
  Serial.println();
}
