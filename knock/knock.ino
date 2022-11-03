// these constants won't change:
const int knockSensor = A0;  // the piezo is connected to analog pin 0
const int threshold = 100;   // threshold value to decide when the detected sound is a knock or not


// these variables will change:
int sensorReading = 0;  // variable to store the value read from the sensor pin

void setup() {
  Serial.begin(9600);       // use the serial port
}

void loop() {
  // read the sensor and store it in the variable sensorReading:
  sensorReading = analogRead(knockSensor);

  // if the sensor reading is greater than the threshold:
  if (sensorReading >= threshold) {
    // send the string "Knock!" back to the computer, followed by newline
    Serial.println("Knock!");
    Serial.println(sensorReading);
  }
  delay(50);  // delay to avoid overloading the serial port buffer
}
