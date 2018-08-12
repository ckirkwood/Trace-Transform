import processing.serial.*;

// create global variables for incoming serial data
Serial myPort;
String incomingData;
int[] data;
int leftButton;
int rightButton;
int pot1;
int pot2;
int pot3;
int pot4;
int pot5;
int pot6;
int pot7;
int pot8;
int pot9;
int xSlider;
int ySlider;
int ldr;
int red;
int green;
int blue;
int leftDistance;
int rightDistance;
int motion = 255;
int motionLastValue = 0;
int time = 0;
int lastTime = 0;
int dormant = 0;



void setup() {
  myPort = new Serial(this, Serial.list()[1], 230400);
}

void draw() {
  background(0);

  byte[] inBuffer = new byte[20];

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
      if (data.length > 19) {
        leftButton = data[0];
        rightButton = data[1];
        pot1 = data[2];
        pot2 = data[3];
        pot3 = data[4];
        pot4 = data[5];
        pot5 = data[6];
        pot6 = data[7];
        pot7 = data[8];
        pot8 = data[9];
        pot9 = data[10];
        xSlider = data[11];
        ySlider = data[12];       
        ldr = data[13];
        red = data[14];
        green = data[15];
        blue = data[16];
        leftDistance = data[17];
        rightDistance = data[18];
        motion = data[19];

        //println(leftButton, ", ", rightButton, ", ", pot1, ", ", pot2, ", ", pot3, ", ", pot4, ", ", pot5, ", ", pot6, ", ", pot7, ", ", pot8, ", ", pot9, ", ", xSlider, ", ", ySlider, ", ", ldr, ", ", red, ", ", green, ", ", blue, ", ", leftDistance, ", ", rightDistance, ", ", motion);
      }
    }
  }

  detectMotion();
}

void detectMotion() {

  if (motion == 255 &&  motion != motionLastValue) {
    motionLastValue = 255;
    time = millis();
  } else if (motion == 0) {
    motionLastValue = 0;
    dormant = millis();
    if ((dormant - time) < 10000) { 
      println("MOTION IN THE LAST 10 SECONDS");
    }
    if ((dormant - time) > 10000) { 
      println("NO MOTION FOR MORE THAN 10 SECONDS");
    }
  }
}
