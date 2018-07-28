import processing.serial.*;

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

void setup() {
  myPort = new Serial(this, Serial.list()[1], 230400);
  size(200, 200);
}

void draw() {
  background(0);

  byte[] inBuffer = new byte[11];
  
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

  int x = 20;
  int y = 30;
  fill(255);
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
