#include <SimpleDHT.h>

// for DHT11,
//      VCC: 5V or 3V
//      GND: GND
//      DATA: 2
int pinDHT11 = 2;
SimpleDHT11 dht11;

// Motion Sensor
int pirPin = 7; // Input for HC-S501
int pirValue;   // Place to store read PIR Value

// Button
const int buttonPin = 4; // the number of the pushbutton pin
const int ledPin = 13;   // the number of the LED pin

void setup()
{
  Serial.begin(9600);
  pinMode(ledPin, OUTPUT);

  // Motion sensor
  pinMode(pirPin, INPUT);
  digitalWrite(ledPin, LOW);

  // Button
  pinMode(buttonPin, INPUT);
}

void loop()
{
  // Read the state of the pushbutton value
  int buttonState = digitalRead(buttonPin);

  // Check if the pushbutton is pressed or there is motion detected
  if (buttonState == HIGH || digitalRead(pirPin) == HIGH)
  {
    // Turn LED on
    digitalWrite(ledPin, HIGH);

    // Print messages
    if (buttonState == HIGH)
    {
      Serial.println("Button pushed");
    }
    if (digitalRead(pirPin) == HIGH)
    {
      Serial.println("Motion detected");
    }

    // Get temperature and humidity reading
    byte temperature = 0;
    byte humidity = 0;
    byte data[40] = {0};
    if (!dht11.read(pinDHT11, &temperature, &humidity, data))
    {
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
    }
    else
    {
      Serial.println("Failed to read temperature and humidity");
    }

    // Wait for 2 minutes before allowing another reading
    delay(120000); // 2-minute delay

    // Turn off LED
    digitalWrite(ledPin, LOW);
  }

  // Delay before next iteration
  delay(1000); // 1-second delay
}
