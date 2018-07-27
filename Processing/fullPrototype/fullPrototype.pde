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
int buttonCount = 0;
int ldrLastValue = 0;
int leftPotLastValue = 0;
float rightPotLastValue = -127.5;
int redLastValue = 0;
int greenLastValue = 0;
int blueLastValue = 0;
int leftDistanceLastValue = 0;
int rightDistanceLastValue = 0;
int motionLastValue = 0;

int leftStreamStartX = int(random(width));
int rightStreamStartY = int(random(height));

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
  for(int i=0; i<bulb.length; i++){
    bulb[i]=loadImage(str(i) + ".jpg");
    }
 
 // set image starting position and dimensions
  x = width/2;
  y = height/2;
  w = 670;
  h = 670;
  
  
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
  
  // display incoming data for debugging
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
  
  
  columns = w / cellsize;  // Calculate # of columns
  rows = h / cellsize;  // Calculate # of rows
  
  
  // pre-display transformations
  rotateBulb(); // left distance
  explode(); // pot1
  glitch(); //pot 2
  
  // load an image
  imageSelect(); // buttons 1 + 2
  
  // post-display transformations
  bulbBrightness(); // ldr
  colour(); // colour sensor
  scaleBulb(); // right distance
  //upDown(); // slider 1
  //leftRight(); // slider 2
  //leftStream(); // pot 4
  //rightStream(); // pot 5
}


// move through a bank of images using 2 buttons
void imageSelect() {
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
  if (buttonCount < -1) {
    buttonCount = -1;
  }
  if (buttonCount > 7) {
    buttonCount = 7;
  }
  
  if (buttonCount == -1) {
    background(0);
  } else if (buttonCount == 0) {
      imageMode(CENTER);
      image(bulb[0], x, y, w, h);
  } else if (buttonCount == 1) {
      imageMode(CENTER);
      image(bulb[1], x, y, w, h);
  } else if (buttonCount == 2) {
      imageMode(CENTER);
      image(bulb[2], x, y, w, h);
  } else if (buttonCount == 3) {
      imageMode(CENTER);
      image(bulb[3], x, y, w, h);
  } else if (buttonCount == 4) {
      imageMode(CENTER);
      image(bulb[4], x, y, w, h);
  } else if (buttonCount == 5) {
      imageMode(CENTER);
      image(bulb[5], x, y, w, h);
  } else if (buttonCount == 6) {
      imageMode(CENTER);
      image(bulb[6], x, y, w, h);
  } else if (buttonCount == 7) {
      singleRow();
  }    
}


// display all images on a single row
void singleRow() { 
  if (buttonCount == 7) {
    for(int i=0;i<7;i++){
      imageMode(CENTER);
      image(bulb[i], (x/5)+(200*i), y, 200, 200);
    }    
  }
  
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
  if (leftButton == 1 && rightButton == 1) {
    tint(red, green, blue); 
  }
}


void upDown() {
  float xyPot = map(rightPot, 0, 255, 0, height);
  y = xyPot;
}  

void leftRight() {
  float xyPot = map(leftPot, 0, 255, 0, width);
  x = xyPot;
}  


void leftStream() {
 int lp = int(map(leftPot, 0, 255, 0, 20));
  
  if (leftPot != leftPotLastValue);
    for(int i=0; i<lp; i++){
        image(bulb[0], leftStreamStartX, i*50, 50, 50);
        leftPotLastValue = leftPot;
  }
  
  if (lp == 0) {
    if (leftStreamStartX < 100) {
    leftStreamStartX += int(random(200));
  } else if (leftStreamStartX > (width-100)) {
      leftStreamStartX -= int(random(200));
  } else {
      leftStreamStartX += int(random(-200, 200));
    }  
  }
  
  if (leftStreamStartX < 0 || leftStreamStartX > width) {
    leftStreamStartX = width/4;
  }
  
}


void rightStream() {
  int rp = int(map(rightPot, 0, 255, 0, 30));
  
  if (rightPot != rightPotLastValue);
    for(int i=0; i<rp; i++){
        image(bulb[5], i*50, rightStreamStartY, 50, 50);
        rightPotLastValue = rightPot;
  }
  
  if (rp == 0) {
    if (rightStreamStartY < 100) {
    rightStreamStartY += int(random(200));
  } else if (rightStreamStartY > (height-100)) {
      rightStreamStartY -= int(random(200));
  } else {
      rightStreamStartY += int(random(-200, 200));
    }  
  }
  
  if (rightStreamStartY < 0 || rightStreamStartY > height) {
    rightStreamStartY = height/4;
  }
}


void scaleBulb() {
  //int rp = int(map(rightPot, 0, 255, 0, 670)); // scale by rp to change input to a pot
  
  float rd = map(rightDistance, 255, 0, 255, 0);
  if (rd > 20) {
    rd = 20;
  }
  float scale = (rd*33.5);
  println(int(scale));
  w = int(scale);
  h = int(scale);
}


void rotateBulb() {
  //int lp = int(map(leftPot, 0, 255, 0, 360)); // rotate by lp to change input to a pot
  
  float ld = map(leftDistance, 255, 0, 255, 0);
  if (ld > 20) {
    ld = 20;
  }
  float angle = (ld*18);
  translate(width/2, height/2);
  rotate(radians(angle));
  translate(-width/2, -height/2);
}


// TODO: enable choice of all images
void explode() {
  int rp = int(map(rightPot, 0, 255, 0, width));
  
  // Begin loop for columns
  for ( int i = 0; i < columns; i++) {
    // Begin loop for rows
    for ( int j = 0; j < rows; j++) {
      float x = i*cellsize + cellsize/2;  // x position
      float y = j*cellsize + cellsize/2;  // y position
      int loc = int(x + y*w);  // Pixel array location
      color c = bulb[0].pixels[loc];  // Grab the color
      // Calculate a z position as a function of mouseX and pixel brightness
      float z = (rp / float(width)) * brightness(bulb[0].pixels[loc]) + 20.0;
      // Translate to the location, set fill and stroke, and draw the rect
      pushMatrix();
      translate(x + 380, y + 110, z);
      fill(c, 255);
      if (leftButton == 1 && rightButton == 1) {
        fill(red, green, blue); 
      }
      if (rp > 150) {
        tint(0); // remove the original image while explosion is live
      }
      noStroke();
      rectMode(CENTER);
      rect(0, 0, cellsize, cellsize);
      popMatrix();
    }
    }
}


// NOT READY //

  
// rewrite manually to take input from the same pot
void glitch() {
  scaleBulb();
  explode();
}

// slows down the rest of the sketch by far too much
void blur() {
  filter(BLUR, (leftPot/25.5));
}

 




/*----------------------------------------------------------------*/
// ARCHIVE - NO LONGER NEEDED //

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
