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
int rgbButton;
int leftDistance;
int rightDistance;
int motion;

// set up values to detect state change
int lbLastValue = 0;
int rbLastValue = 0;
int buttonCount = 0;

int ldrLastValue = 0;
int pot1LastValue = 0;
int pot2LastValue = 0;
int pot3LastValue = 0;
int pot4LastValue = 0;
int pot5LastValue = 0;
int pot6LastValue = 0;
int pot7LastValue = 0;
int pot8LastValue = 0;
int pot9LastValue = 0;
int xSliderLastValue = 0;
int ySliderLastValue = 0;

int redLastValue = 0;
int greenLastValue = 0;
int blueLastValue = 0;

int leftDistanceLastValue = 0;
int rightDistanceLastValue = 0;

int motionLastValue = 0;
int time = 0;
int dormant = 0;
boolean powerSaverLaunched = false;
boolean powerSaverStopped = false;

int xStream_1_start = int(random(width));
int xStream_2_start = int(random(width));
int xStream_3_start = int(random(width));

int yStream_1_start = int(random(height));
int yStream_2_start = int(random(height));
int yStream_3_start = int(random(height));

float cellsize = 2; // Dimensions of each cell in the grid
float columns, rows;   // Number of columns and rows in our system

// create image variables
PImage[] bulb;
int files = 7;
float x, y, w, h;


void setup() {
  myPort = new Serial(this, Serial.list()[1], 230400);
  fullScreen(P3D);
  frameRate(60);

  // load all images named in series from 0.jpg
  bulb = new PImage[files];
  for (int i=0; i<bulb.length; i++) {
    bulb[i]=loadImage(str(i) + ".png");
  }

  // set image starting position and dimensions
  x = width/2;
  y = height/2;
  w = 670;
  h = 670;
}


void draw() {
  background(0);

  byte[] inBuffer = new byte[21];

  //read incoming data when serial port is available
  while (myPort.available() > 0) {
    inBuffer = myPort.readBytes();
    myPort.readBytes(inBuffer);

    if (inBuffer != null) {
      incomingData = new String(inBuffer);
      data = int(split(incomingData, ","));

      // if new data is available, save it as a string and convert
      // to a list of integers
      if (data.length > 20 && data[0] < 2 && data[1] < 2) {
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
        rgbButton = data[17];
        leftDistance = data[18];
        rightDistance = data[19];
        motion = data[20];
      }
    }
  }


  // Capture button inputs between a range of 0-6
  if (rightButton != rbLastValue) {  // ignore new values if the button is held
    if (rightButton == 1) {
      buttonCount += 1;
      rbLastValue = 1;
    } else if (rightButton == 0) {
      rbLastValue = 0;
    }
  }

  if (leftButton != lbLastValue) {
    if (leftButton == 1) {
      buttonCount -= 1;
      lbLastValue = 1;
    } else if (leftButton == 0) {
      lbLastValue = 0;
    }
  }

  // limit buttonCount to a range from -1 (off) to the number of images available
  if (buttonCount < 0) {
    buttonCount = 0;
  }
  if (buttonCount > 6) {
    buttonCount = 6;
  }

  int x = 20;
  int y = 30;
  fill(255);
  text("Left Button: " + leftButton, x, y);
  text("Right Button: " + rightButton, x, y+15);
  text("Pot 1: " + pot1, x, y+30);
  text("Pot 2: " + pot2, x, y+45);
  text("Pot 3: " + pot3, x, y+60);
  text("Pot 4: " + pot4, x, y+75);
  text("Pot 5: " + pot5, x, y+90);
  text("Pot 6: " + pot6, x, y+105);
  text("Pot 7: " + pot7, x, y+120);
  text("Pot 8: " + pot8, x, y+135);
  text("Pot 9: " + pot9, x, y+150);
  text("Horizontal slider: " + xSlider, x, y+165);
  text("Vertical slider: " + ySlider, x, y+180);
  text("Light level: " + ldr, x, y+195);
  text("RGB: " + red + ", " + green + ", " + blue, x, y+210);
  text("RGB Button: " + rgbButton, x, y+225);
  text("Left Distance: " + leftDistance, x, y+240);
  text("Right Distance: " + rightDistance, x, y+255);
  text("Motion: " + motion, x, y+270);

  //println(leftButton, " | ", rightButton, " | ", pot1, " | ", pot2, " | ", pot3, " | ", pot4, " | ", pot5, " | ", pot6, " | ", pot7, " | ", pot8, " | ", pot9, " | ", xSlider, " | ", ySlider, " | ", ldr, " | ", red, " | ", green, " | ", blue, " | ", rgbButton, " | ", leftDistance, " | ", rightDistance, " | ", motion);


  // set dimensions for explode function
  columns = w / cellsize;  // Calculate # of columns
  rows = h / cellsize;  // Calculate # of rows


  // PRE DISPLAY TRANSFORMATIONS //
  rotateBulb(); // left distance
  glitch();
  explode();

  // DISPLAY IMAGE //
  imageSelect(); // buttons

  // POST-DISPLAY TRANSFORMATIONS //
  bulbBrightness(); // ldr
  colour(); // colour sensor
  blur();
  scaleBulb(); // right distance
  leftRight(); // slider
  upDown(); // slider
  xStream1();
  xStream2();
  xStream3();
  yStream1();
  yStream2();
  yStream3();
  detectMotion();
}


// IMAGE NAVIGATION //

// move through a bank of images using 2 buttons
void imageSelect() {
  imageMode(CENTER);
  image(bulb[buttonCount], x, y, w, h);
}


// display all images on a single row
void singleRow() {
  if (buttonCount == 7) {
    for (int i=0; i<7; i++) {
      imageMode(CENTER);
      image(bulb[i], (x/5)+(200*i), y, 200, 200);
    }
  }

  // add an image to the row with each button press
  /*  if (buttonCount == -1) {
   background(0);
   } else if (buttonCount == 0) {
   for(int i=0;i<1;i++){
   imageMode(CENTER);
   image(bulb[i], (x/5)+(200*i), y, 200, 200);
   }
   } else if (buttonCount == 1) {
   for(int i=0;i<2;i++){
   imageMode(CENTER);
   image(bulb[i], (x/5)+(200*i), y, 200, 200);
   }
   } else if (buttonCount == 2) {
   for(int i=0;i<3;i++){
   imageMode(CENTER);
   image(bulb[i], (x/5)+(200*i), y, 200, 200);
   }
   } else if (buttonCount == 3) {
   for(int i=0;i<4;i++){
   imageMode(CENTER);
   image(bulb[i], (x/5)+(200*i), y, 200, 200);
   }
   } else if (buttonCount == 4) {
   for(int i=0;i<5;i++){
   imageMode(CENTER);
   image(bulb[i], (x/5)+(200*i), y, 200, 200);
   }
   } else if (buttonCount == 5) {
   for(int i=0;i<6;i++){
   imageMode(CENTER);
   image(bulb[i], (x/5)+(200*i), y, 200, 200);
   }
   } else if (buttonCount == 6) {
   for(int i=0;i<7;i++){
   imageMode(CENTER);
   image(bulb[i], (x/5)+(200*i), y, 200, 200);
   }
   }*/
}



// TRANSFORMATION FUNCTIONS //

void bulbBrightness() {
  tint(ldr);
}


// Add a slow fade back to white, and a new way to activate sensor
void colour() {
  if (rgbButton == 1) {
    tint(red, green, blue);
  }
}


void upDown() {
  float yPos = map(ySlider, 0, 255, height, 0);
  y = yPos;
}


void leftRight() {
  float xPos = map(xSlider, 0, 255, 0, width);
  x = xPos;
}
void xStream1() {
  int pot = int(map(pot1, 0, 255, 0, 20));

  if (pot != pot1LastValue);
  for (int i=0; i<pot; i++) {
    image(bulb[0], xStream_1_start, i*50, 50, 50);
    pot1LastValue = pot;
  }

  if (pot == 0) {
    if (xStream_1_start < 100) {
      xStream_1_start += int(random(200));
    } else if (xStream_1_start > (width-100)) {
      xStream_1_start -= int(random(200));
    } else {
      xStream_1_start += int(random(-200, 200));
    }
  }

  if (xStream_1_start < 0 || xStream_1_start > width) {
    xStream_1_start = width/4;
  }
}


void xStream2() {
  int pot = int(map(pot2, 0, 255, 0, 20));

  if (pot != pot2LastValue);
  for (int i=0; i<pot; i++) {
    image(bulb[1], xStream_2_start, i*50, 50, 50);
    pot1LastValue = pot;
  }

  if (pot == 0) {
    if (xStream_2_start < 100) {
      xStream_2_start += int(random(200));
    } else if (xStream_2_start > (width-100)) {
      xStream_2_start -= int(random(200));
    } else {
      xStream_2_start += int(random(-200, 200));
    }
  }

  if (xStream_2_start < 0 || xStream_2_start > width) {
    xStream_2_start = width/4;
  }
}


void xStream3() {
  int pot = int(map(pot3, 0, 255, 0, 20));

  if (pot != pot3LastValue);
  for (int i=0; i<pot; i++) {
    image(bulb[2], xStream_3_start, i*50, 50, 50);
    pot3LastValue = pot;
  }

  if (pot == 0) {
    if (xStream_3_start < 100) {
      xStream_3_start += int(random(200));
    } else if (xStream_3_start > (width-100)) {
      xStream_3_start -= int(random(200));
    } else {
      xStream_3_start += int(random(-200, 200));
    }
  }

  if (xStream_3_start < 0 || xStream_3_start > width) {
    xStream_3_start = width/4;
  }
}


void yStream1() {
  int pot = int(map(pot4, 0, 255, 0, 30));

  if (pot != pot4LastValue);
  for (int i=0; i<pot; i++) {
    image(bulb[3], i*50, yStream_1_start, 50, 50);
    pot4LastValue = pot;
  }

  if (pot == 0) {
    if (yStream_1_start < 100) {
      yStream_1_start += int(random(200));
    } else if (yStream_1_start > (height-100)) {
      yStream_1_start -= int(random(200));
    } else {
      yStream_1_start += int(random(-200, 200));
    }
  }

  if (yStream_1_start < 0 || yStream_1_start > height) {
    yStream_1_start = height/4;
  }
}


void yStream2() {
  int pot = int(map(pot5, 0, 255, 0, 30));

  if (pot != pot5LastValue);
  for (int i=0; i<pot; i++) {
    image(bulb[4], i*50, yStream_2_start, 50, 50);
    pot5LastValue = pot;
  }

  if (pot == 0) {
    if (yStream_2_start < 100) {
      yStream_2_start += int(random(200));
    } else if (yStream_1_start > (height-100)) {
      yStream_2_start -= int(random(200));
    } else {
      yStream_2_start += int(random(-200, 200));
    }
  }

  if (yStream_2_start < 0 || yStream_2_start > height) {
    yStream_2_start = height/4;
  }
}


void yStream3() {
  int pot = int(map(pot6, 0, 255, 0, 30));

  if (pot != pot6LastValue);
  for (int i=0; i<pot; i++) {
    image(bulb[5], i*50, yStream_3_start, 50, 50);
    pot6LastValue = pot;
  }

  if (pot == 0) {
    if (yStream_3_start < 100) {
      yStream_3_start += int(random(200));
    } else if (yStream_3_start > (height-100)) {
      yStream_3_start -= int(random(200));
    } else {
      yStream_3_start += int(random(-200, 200));
    }
  }

  if (yStream_3_start < 0 || yStream_3_start > height) {
    yStream_3_start = height/4;
  }
}


void scaleBulb() {
  int pot = int(map(pot7, 0, 255, 0, 670)); 
  w = int(pot);
  h = int(pot);
}


void rotateBulb() {
  int pot = int(map(pot8, 0, 255, 0, 360)); 

  translate(width/2, height/2);
  rotate(radians(pot));
  translate(-width/2, -height/2);
}



void explode() {
  float rd = map(rightDistance, 255, 0, 255, 0);
  if (rd > 20) {
    rd = 20;
  }
  float scale = map(rd, 20, 0, 0, 3000);
  

  // Begin loop for columns
  for ( int i = 0; i < columns; i++) {
    // Begin loop for rows
    for ( int j = 0; j < rows; j++) {
      float x = i*cellsize + cellsize/2;  // x position
      float y = j*cellsize + cellsize/2;  // y position
      int loc = int(x + y*670);  // Pixel array location
      color c = bulb[buttonCount].pixels[loc];  // Grab the color
      // Calculate a z position as a function of mouseX and pixel brightness
      float z = (scale / float(width)) * brightness(bulb[buttonCount].pixels[loc]) - 20.0;
      // Translate to the location, set fill and stroke, and draw the rect
      pushMatrix();
      translate(x + 386, y + 115, z);
      fill(c, 240);
      if (scale == 0) {
        fill(c, 0);
      }
      noStroke();
      rectMode(CENTER);
      rect(0, 0, cellsize, cellsize);
      popMatrix();
    }
  }
}


void glitch() {
  if (pot9 != 255) {
    int rp = int(map(pot9, 0, 255, 0, 670));
    w = rp;
    h = rp;
    
    int rp2 = int(map(pot9, 0, 255, 0, width));
    
    // Begin loop for columns
    for ( int i = 0; i < columns; i++) {
      // Begin loop for rows
      for ( int j = 0; j < rows; j++) {
        float x = i*cellsize + cellsize/2;  // x position
        float y = j*cellsize + cellsize/2;  // y position
        int loc = int(x + y*w);  // Pixel array location
        color c = bulb[0].pixels[loc];  // Grab the color
        // Calculate a z position as a function of mouseX and pixel brightness
        float z = (rp2 / float(width)) * brightness(bulb[0].pixels[loc]) + 20.0;
        // Translate to the location, set fill and stroke, and draw the rect
        pushMatrix();
        translate(x + 380, y + 110, z);
        fill(c, 255);
        if (rp2 > 10) {
          fill(c, 0); // remove the original image while explosion is live
        }
        noStroke();
        rectMode(CENTER);
        rect(0, 0, cellsize, cellsize);
        popMatrix();
      }
    }
  }
}




// slows down the rest of the sketch by far too much
void blur() {
  float ld = map(leftDistance, 255, 0, 255, 0);
  if (ld > 20) {
    ld = 20;
  }
  float inverse = map(ld, 20, 0, 0, 5);
  filter(BLUR, inverse);
}


void detectMotion() {
  if (motion == 255 &&  motion != motionLastValue) {
    motionLastValue = 255;
    time = millis();
  } else if (motion == 0) {
    motionLastValue = 0;
    dormant = millis();
  }


  if ((dormant - time) < 6000 && powerSaverStopped == false) {
    launch("/Users/trace/Desktop/stopPowerSaver.app");
    powerSaverStopped = true;
  } else if ((dormant - time) > 100000 && powerSaverStopped == true) { 
    launch("/Users/trace/Desktop/startPowerSaver.app");
    powerSaverStopped = false;
  }
  
  println(time, " | ", dormant);
}
