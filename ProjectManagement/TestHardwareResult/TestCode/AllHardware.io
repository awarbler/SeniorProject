#include <SimpleDHT.h>

// for DHT11, 
//      VCC: 5V or 3V
//      GND: GND
//      DATA: 2
int pinDHT11 = 2;
SimpleDHT11 dht11;

// Motion Sensor
int pirPin = 7; // Input for HC-S501

int pirValue; // Place to store read PIR Value

// button // constants won't change. They're used here to set pin numbers:
const int buttonPin = 4;  // the number of the pushbutton pin
const int ledPin = 13;    // the number of the LED pin
// variables will change: button 
int buttonState = 0;  // variable for reading the pushbutton status

void setup() {
  Serial.begin(9600);
  pinMode(ledPin, OUTPUT);

  // motion sensor
  pinMode(pirPin, INPUT);
  digitalWrite(ledPin, LOW);

  // button
    // initialize the LED pin as an output:
  pinMode(ledPin, OUTPUT);
  // initialize the pushbutton pin as an input:
  pinMode(buttonPin, INPUT);

}

void loop() {
  // start working...Temp sensor
  Serial.println("=================================");
  Serial.println("Sample DHT11...");

  // read the state of the pushbutton value:
  buttonState = digitalRead(buttonPin);

  // check if the pushbutton is pressed. If it is, the buttonState is HIGH:
  if (buttonState == HIGH) {
    // turn LED on:
    digitalWrite(ledPin, HIGH);
    // print button pushed message:
    Serial.println("Button pushed");
  } else {
    // turn LED off:
    digitalWrite(ledPin, LOW);
  }

// motion sensor
  pirValue = digitalRead(pirPin);
  digitalWrite(ledPin, pirValue);
  
  if (pirValue == HIGH) {
    // print motion detected message:
    Serial.println("Motion detected");
  }
  
  // read with raw sample data. Temp 
  byte temperature = 0;
  byte humidity = 0;
  byte data[40] = {0};
  if (dht11.read(pinDHT11, &temperature, &humidity, data)) {
    Serial.print("Read DHT11 failed");
    return;
  }
  // temp
  Serial.print("Sample RAW Bits: ");
  for (int i = 0; i < 40; i++) {
    Serial.print((int)data[i]);
    if (i > 0 && ((i + 1) % 4) == 0) {
      Serial.print(' ');
    }
  }
  // temp 
  Serial.println("");
  
  Serial.print("Sample OK: ");
  Serial.print((int)temperature); Serial.print(" *C, ");
  Serial.print((int)humidity); Serial.println(" %");
  
  // DHT11 sampling rate is 1HZ. temp 
  delay(5000);

}
