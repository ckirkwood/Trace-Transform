import processing.serial.*;

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
int motion;

int lbLastValue = 0;
int rbLastValue = 0;
int ldrLastValue = 0;
int leftPotLastValue = 0;
int rightPotLastValue = 0;
int redLastValue = 0;
int greenLastValue = 0;
int blueLastValue = 0;
int leftDistanceLastValue = 255;
int rightDistanceLastValue = 255;
int motionLastValue = 0;

PImage bulb1;
float x, y, w, h, rotation;

void setup() {
  myPort = new Serial(this, Serial.list()[1], 115200);
  size(600,600);
  bulb1 = loadImage("Trace1.jpg");
  x = width/2;
  y = height/2;
  w = 100;
  h = 200;
  rotation = 0.0;
}


void draw() {
  background(0);
  
  byte[] inBuffer = new byte[11];

  while (myPort.available() > 0) {
    inBuffer = myPort.readBytes();
    myPort.readBytes(inBuffer);

    if (inBuffer != null) {
      myString = new String(inBuffer);
      data = int(split(myString, ","));
      
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
  
  colour();
  //rotateBulb();
  
  imageMode(CENTER);
  image(bulb1, x, y, w, h);
  
  carousel();
  blur();
  shrink();
  
 
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

// default to white unless there's a drastic change, then fade back to white
void colour(){
  tint(red, green, blue);  
}
  
void blur() {
  filter(BLUR, (leftPot/25.5));
}

// needs snappier input from the arduino (or faster parsing on this end)
void carousel() {
  if (leftButton == 1) {
    x -=4;
  } else {
    x = x;
  }
  
  if (rightButton == 1) {
    x +=4;
  } else {
    x = x;
  }
}

// add something that ignores big jumps of 80cm+
void shrink() {
  if (leftDistance < leftDistanceLastValue - 5) {
    w = leftDistance/2;
    h = leftDistance;
    if (leftDistance < 50) {
        w = 25;
        h = 50;
      }
    leftDistanceLastValue = leftDistance;
  } else if (leftDistance > leftDistanceLastValue + 5) {
    w = leftDistance/2;
    h = leftDistance; 
      if (leftDistance > 199) {
        w = 100;
        h = 200;
      }
    leftDistanceLastValue = leftDistance;
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
  
  