import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import processing.serial.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class serial_multiInput extends PApplet {



int[] serialInArray = new int[4]; // Where we'll put what we receive
int serialCount = 0;     // A count of how many bytes we receive
int red;
int green;
int blue;
int distance;
Serial myPort;

boolean firstContact = false;  // Whether we've heard from the microcontroller

public void setup() {
  // Stage size
 noStroke();  // No border on the next thing drawn

 String portName = Serial.list()[1];
 myPort = new Serial(this, portName, 9600);
}

public void draw() {
  background(0);
  ellipse (width/2, height/2, distance, distance);
  fill(red, green, blue);

}

public void serialEvent(Serial myPort) {
 // read a byte from the serial port:
 int inByte = myPort.read();
 // if this is the first byte received, and it's an A,
 // clear the serial buffer and note that you've
 // had first contact from the microcontroller.
 // Otherwise, add the incoming byte to the array:
 if (firstContact == false) {
 if (inByte == 'A') {
  myPort.clear();   // clear the serial port buffer
  firstContact = true;  // you've had first contact from the microcontroller
  myPort.write('A');  // ask for more
 }
 }
 else {
 // Add the latest byte from the serial port to array:
 serialInArray[serialCount] = inByte;
 serialCount++;
 // If we have 4 bytes:
 if (serialCount > 3 ) {
  red = serialInArray[0];
  green = serialInArray[1];
  blue = serialInArray[2];
  distance = serialInArray[3];


  // print the values (for debugging purposes only):
  println(red + ", " + green + ", " + blue + ", " + distance);
  // Send a capital A to request new sensor readings:
  myPort.write('A');
  // Reset serialCount:
  serialCount = 0;
 }
 }
}
  public void settings() {  size(400, 400); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "serial_multiInput" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
