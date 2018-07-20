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

public class fullSerialTest extends PApplet {



String myString;
int[] data;
Serial myPort;

int leftButton;
int rightButton;
int ldr;
int leftPot;
int rightPot;
int red;
int green;
int blue;
int leftDistance;
int rightDistance;
int motion ;

public void setup() {
  
  myPort = new Serial(this, Serial.list()[1], 115200);
}


public void draw() {
  byte[] inBuffer = new byte[11];

  while (myPort.available() > 0) {
    inBuffer = myPort.readBytes();
    myPort.readBytes(inBuffer);

    if (inBuffer != null) {
      myString = new String(inBuffer);
      data = PApplet.parseInt(split(myString, ","));

      if (data.length > 10) {
        leftButton = data[0];
        rightButton = data[1];
        ldr = data[2];
        leftPot = data[3];
        rightPot = data[4];
        red = data[5];
        green = data[6];
        blue = data[7];
        leftDistance = data[8];
        rightDistance = data[9];
        motion = data[10];
      }
    }
  }

  text("Left Button: " + leftButton, 10, 10);

}
  public void settings() {  size(800, 600); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "fullSerialTest" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
