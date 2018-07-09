#include <Wire.h>
#include "Adafruit_TCS34725.h"
#include <math.h>

// set to false if using a common cathode LED
#define commonAnode true

// our RGB -> eye-recognized gamma color
byte gammatable[256];


Adafruit_TCS34725 tcs = Adafruit_TCS34725(TCS34725_INTEGRATIONTIME_50MS, TCS34725_GAIN_4X);

void setup() {
  Serial.begin(9600);
  //Serial.println("Color View Test!");

  if (tcs.begin()) {
    Serial.println("111111");
  } else {
    Serial.println("No TCS34725 found ... check your connections");
    while (1); // halt!
  }
 
  
  
  // thanks PhilB for this gamma table!
  // it helps convert RGB colors to what humans see
  for (int i=0; i<256; i++) {
    float x = i;
    x /= 255;
    x = pow(x, 2.5);
    x *= 255;
      
    if (commonAnode) {
      gammatable[i] = 255 - x;
    } else {
      gammatable[i] = x;      
    }
    //Serial.println(gammatable[i]);
  }
}


void loop() {
  uint16_t clear, red, green, blue;

  tcs.setInterrupt(false);      // turn on LED

  delay(60);  // takes 50ms to read 
  
  tcs.getRawData(&red, &green, &blue, &clear);

  tcs.setInterrupt(true);  // turn off LED
  
  // Figure out some basic hex code for visualization
  uint32_t sum = clear;
  float r, g, b;
  r = red; r /= sum;
  g = green; g /= sum;
  b = blue; b /= sum;
  r *= 256; g *= 256; b *= 256;
  //Serial.print("\t");
  //Serial.print((int)r, HEX); Serial.print((int)g, HEX); Serial.print((int)b, HEX); 
  //Serial.print("\n");

  //Serial.print((int)r ); Serial.print(" "); Serial.print((int)g);Serial.print(" ");  Serial.println((int)b );

 // Serial.print("C:\t"); Serial.print(clear);
 // Serial.print("\tR:\t"); Serial.print(red);
 // Serial.print("\tG:\t"); Serial.print(green);
 // Serial.print("\tB:\t"); Serial.print(blue);

  Serial.print(round(r)); Serial.print(" "); Serial.print(round(g)); Serial.print(" "); Serial.print(round(b)); Serial.print(" "); Serial.print('\n');
}

