import oscP5.*;
import netP5.*;
  
OscP5 oscP5;
NetAddress myRemoteLocation;

PImage img;

int pot1;
int pot2; 
int pot3;

void setup() {
  oscP5 = new OscP5(this,8000);
  myRemoteLocation = new NetAddress("127.0.0.1", 12000);
  
  size(600,600);
  img = loadImage("Trace1.jpg");
}

void draw() {
  background(0);
  imageMode(CENTER);
  
  dimmer();
  rotateBulb();
  
  image(img, width/2, height/2);
}

void oscEvent(OscMessage theOscMessage) {
  int value = theOscMessage.get(0).intValue();
 
  if (theOscMessage.checkAddrPattern("/pot1")) {
    pot1 = value;
  } else if (theOscMessage.checkAddrPattern("/pot2")) {
    pot2 = value;
  } else if (theOscMessage.checkAddrPattern("/pot3")) {
    pot3 = value;
  }
}

void dimmer() {
  tint(pot1);
}

void rotateBulb() {
  translate(width/2, height/2);
  rotate(radians(pot3));
  translate(-img.width/2, -img.height/2);
}  

void embiggen() {
  
}