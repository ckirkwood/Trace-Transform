import processing.serial.*;

// create global variables for incoming serial data 
Serial myPort;
String incomingData;
int[] data;
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
int motion;

// set up values to detect state change
int lbLastValue = 0;
int rbLastValue = 0;
int ldrLastValue = 0;
int leftPotLastValue = 0;
float rightPotLastValue = -127.5;
int redLastValue = 0;
int greenLastValue = 0;
int blueLastValue = 0;
int leftDistanceLastValue = 255;
int rightDistanceLastValue = 255;
int motionLastValue = 0;

// create image variables
PImage[] bulb;
int files = 8;
float x, y, w, h, rotation;


void setup() {
  myPort = new Serial(this, Serial.list()[1], 115200);
  fullScreen();
  frameRate(60);
  
  // load all images named in series from 0.jpg
  bulb = new PImage[files];
  for(int i=0; i<bulb.length; i++){
    bulb[i]=loadImage(str(i) + ".jpg");
    }
 
  x = 0;
  y = height/2;
  w = height;
  h = height;
  rotation = 0.0;
}


void draw() {
  background(0);
  
  byte[] inBuffer = new byte[11];

  //read incoming data when serial port is available
  while (myPort.available() > 0) {
    inBuffer = myPort.readBytes();
    myPort.readBytes(inBuffer);

    // if new data is available, save it as a string and convert
    // to a list of integers
    if (inBuffer != null) {
      incomingData = new String(inBuffer);
      data = int(split(incomingData, ","));
      
      // assign each value to a variable
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
  
  // transformations to be applied before the image is loaded
  bulbBrightness();
  colour();
  //rotateBulb();
  
  // load all images in a horizontal line with space in between
  for(int i=0;i<bulb.length;i++){
    imageMode(CENTER);
    image(bulb[i], x+(w*i), y+150, w, h);
  }
 
  //transformations to be applied after the image is loaded
  carousel();
  upDown();
  blur();
  //shrink();
  
  // display incoming data for debugging
  int x = 20;
  int y = 30;
  text("Left Button: " + leftButton, x, y);
  text("Right Button: " + rightButton, x, y+15);
  text("Light level: " + ldr, x, y+30);
  text("Left Pot: " + leftPot, x, y+45);
  text("Right Pot: " + rightPot, x, y+60);
  text("RGB: " + red + ", " + green + ", " + blue, x, y+75);
  text("Left Distance: " + leftDistance, x, y+90);
  text("Right Distance: " + rightDistance, x, y+105);
  text("Motion: " + motion, x, y+120);
}



// TRANSFORMATION FUNCTIONS

void bulbBrightness() {
  tint(ldr);
}


// Add a slow fade back to white, and a new way to activate sensor
void colour() {
  if (leftButton == 1 && rightButton == 1) {
    tint(red, green, blue); 
  }
}
  
  
void blur() {
  filter(BLUR, (leftPot/25.5));
}


// needs snappier input from the arduino (or faster parsing on this end)
void carousel() {
  if (leftButton == 1) {
    x -= 20;
  //  if (x < 0-(w/2)) {
  //  x = width + (w/2);
  //  }
  } else {
    x = x;
  }
  
  if (rightButton == 1) {
    x += 20;
   // if (x > width + (w/2)) {
   // x = 0-(w/2);
   // }
  } else {
    x = x;
  }
}


void upDown() {
  float xyPot = float(rightPot) - 127.5;
  y = xyPot + 280;
}  


// add something that ignores big jumps of 80cm+
void shrink() {
  int dif = leftDistance - leftDistanceLastValue;
  if (dif > 80) {
      println("jump");
  }
  if (leftDistance < leftDistanceLastValue - 5) {
    w = leftDistance/2;
    h = leftDistance;
    if (leftDistance < 50) {
        w = 25;
        h = 50;
      }
  } else if (leftDistance > leftDistanceLastValue + 5) {
    w = leftDistance/2;
    h = leftDistance; 
      if (leftDistance > 199) {
        w = 100;
        h = 200;
      }
    } 
}


// Needs work - cancels out the button actions
void rotateBulb() {
  translate(width/2, height/2);
  if (rightPot > rightPotLastValue) {
    rotation += 0.2;
    rightPotLastValue = rightPot;
  }
  else if (rightPot < rightPotLastValue) {
    rotation -= 0.2;
    rightPotLastValue = rightPot;
  }
  rotate(rotation);
}