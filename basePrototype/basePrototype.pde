import oscP5.*;
import netP5.*;
  
OscP5 oscP5;
NetAddress myRemoteLocation;

PImage bulb;

int pot1;
int pot2; 
int pot3;

int lastRead2;
int lastRead3;

float x, y, w, h;
float rot;

void setup() {
  oscP5 = new OscP5(this,8000);
  myRemoteLocation = new NetAddress("127.0.0.1", 12000);
  
  size(600,600);
  bulb = loadImage("Trace1.jpg");
  x = 0.0;
  y = 0.0;
  w = 100;
  h = 200;
  rot = 0.0;
  
  lastRead2 = 0;
  lastRead3 = 0;
}

void draw() {
  background(0);
  
  dimmer();
  rotateBulb();
  
  imageMode(CENTER);
  image(bulb, x, y, w, h);
  
  embiggen();

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
  if (pot3 > lastRead3) {
    rot += 0.2;
    lastRead3 = pot3;
  }
  else if (pot3 < lastRead3) {
    rot -= 0.2;
    lastRead3 = pot3;
  }
  rotate(rot);
  
}  

void embiggen() {
  map(pot2, 0, 255, -127, 127);
  if (pot2 > lastRead2) {
    w += 10;
    h += 15;
    lastRead2 = pot2;
  }
  else if (pot2 < lastRead2) {
    w -= 10;
    h -= 15; 
    lastRead2 = pot2;
  }
}