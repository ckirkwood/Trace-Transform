  #include <Wire.h>
#include "Adafruit_TCS34725.h"
#include <math.h>

Adafruit_TCS34725 tcs = Adafruit_TCS34725(TCS34725_INTEGRATIONTIME_50MS, TCS34725_GAIN_4X);

const int leftButton = 0; 
const int rightButton = 1; 
const int motionSensor = 2;
const int leftTrigger = 3;
const int leftEcho = 4;
const int rightTrigger = 5;
const int rightEcho = 6;


void setup() {
  Serial.begin(230400);

   if (tcs.begin()) {
    Serial.println("1");
  } else {
    Serial.println("0");
    while (1); 
  }

  pinMode(leftButton, INPUT_PULLUP);
  pinMode(rightButton, INPUT_PULLUP);
  pinMode(leftTrigger, OUTPUT);
  pinMode(leftEcho, INPUT); 
  pinMode(rightTrigger, OUTPUT);
  pinMode(rightEcho, INPUT); 
}
 

void loop() {
  //ANALOGUE INPUTS
  int ldr = readPot(0);
  int pot1 = readPotInverse(1);
  int pot2 = readPotInverse(2);
  int pot3 = readPotInverse(3);
  int pot4 = readPotInverse(4);
  int pot5 = readPotInverse(5);
  int pot6 = readPotInverse(6);
  int pot7 = readPotInverse(7);
  int pot8 = readPotInverse(8);
  int pot9 = readPotInverse(9);
  int xSlider = readPot(10);
  int ySlider = readPotInverse(11);
  

  // ULTRASONIC DISTANCE SENSORS
  int leftD = leftDistance();
  int rightD = rightDistance();

  // ARCADE BUTTONS
  int leftB = button1();
  int rightB = button2();

  // MOTION SENSOR
  int pir = motion();
  
  // RGB COLOUR SENSOR
  uint16_t clear, red, green, blue;

  tcs.setInterrupt(false);      // turn on LED
  delay(60);  // takes 50ms to read 
  tcs.getRawData(&red, &green, &blue, &clear);
  tcs.setInterrupt(true);  // turn off LED
  
  // Calibrate values
  uint32_t sum = clear;
  float r, g, b;
  r = red; r /= sum;
  g = green; g /= sum;
  b = blue; b /= sum;
  r *= 256; g *= 256; b *= 256;

  Serial.print(leftB); Serial.print(",");
  Serial.print(rightB); Serial.print(",");
  Serial.print(pot1); Serial.print(",");
  Serial.print(pot2); Serial.print(",");
  Serial.print(pot3); Serial.print(",");
  Serial.print(pot4); Serial.print(",");
  Serial.print(pot5); Serial.print(",");
  Serial.print(pot6); Serial.print(",");
  Serial.print(pot7); Serial.print(",");
  Serial.print(pot8); Serial.print(",");
  Serial.print(pot9); Serial.print(",");
  Serial.print(xSlider); Serial.print(",");
  Serial.print(ySlider); Serial.print(",");
  Serial.print(ldr); Serial.print(",");
  Serial.print(round(r)); Serial.print(",");
  Serial.print(round(g)); Serial.print(",");
  Serial.print(round(b)); Serial.print(",");
  Serial.print(leftD); Serial.print(",");
  Serial.print(rightD); Serial.print(",");
  Serial.print(pir); Serial.print(", ");
  Serial.println("0");
}



int readPot(int p) {
  int i;
  int sval = 0;

  for (i = 0; i < 5; i++) {
    sval = sval + analogRead(p);    // sensor on analog pin 0
  }

  sval = sval / 5;    // average
  sval = sval / 4;    // scale to 8 bits (0 - 255)
  return sval;
}

int readPotInverse(int p) {
  int i;
  int sval = 0;

  for (i = 0; i < 5; i++) {
    sval = sval + analogRead(p);    // sensor on analog pin 0
  }

  sval = sval / 5;    // average
  sval = sval / 4;    // scale to 8 bits (0 - 255)
  int inverse = map(sval, 255, 0, 0, 255);
  return inverse;
}

int leftDistance() {
  long duration;
  int distance;
  
  digitalWrite(leftTrigger, LOW);
  delayMicroseconds(2);
  digitalWrite(leftTrigger, HIGH);
  delayMicroseconds(10);
  digitalWrite(leftTrigger, LOW);

  duration = pulseIn(leftEcho, HIGH);
  distance = (duration/2) / 29.1;
  if (distance > 255) {
    distance = 255; // cap readings at 255cm
  }

  return distance;
}

int rightDistance() {
  long duration;
  int distance;
  
  digitalWrite(rightTrigger, LOW);
  delayMicroseconds(2);
  digitalWrite(rightTrigger, HIGH);
  delayMicroseconds(10);
  digitalWrite(rightTrigger, LOW);

  duration = pulseIn(rightEcho, HIGH);
  distance = (duration/2) / 29.1;
  if (distance > 255) {
    distance = 255; // cap readings at 255cm
  }

  return distance;
}

int button1() {
  int buttonState = 0;
  buttonState = digitalRead(leftButton);
  return !buttonState;
}

int button2() {
  int buttonState = 0;
  buttonState = digitalRead(rightButton);
  return !buttonState;
}

int motion() {
  int pirState = LOW;
  int val = 0;

  val = digitalRead(motionSensor);
  if (val == HIGH) {
    int m = 255;
    return m;
    if (pirState == LOW) {
      pirState = HIGH;
    } else {
      if (pirState == HIGH) {
        pirState = LOW;
      }
    }
  } else {
     int m = 0;
     return m;
  }
}
