PImage img;

void setup() {
  size(600,600);
  // Make a new instance of a PImage by loading an image file
  img = loadImage("Trace1.jpg");
}

void draw() {
  background(0);
  // Draw the image to the screen at coordinate (0,0)
  imageMode(CENTER);
  
  
  dimmer();
  rotateBulb();
  
  image(img, width/2, height/2);
}

void dimmer() {
  tint(mouseX/2.5);
}

void rotateBulb() {
  rotate(radians(0));
}  

void embiggen() {
  
}