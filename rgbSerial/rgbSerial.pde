import processing.serial.*;

Serial myPort;  // Create object from Serial class

String rgb;
int r;
int g;
int b;

void setup() {
  size(400, 400);
  String portName = Serial.list()[1]; //change the 0 to a 1 or 2 etc. to match your port
  myPort = new Serial(this, portName, 9600);
  myPort.bufferUntil('\n');  
}


void draw() {
  rgb = myPort.readStringUntil('\n');  // Changing the background color according to received data

  if (rgb != null) {
    println(rgb);
    
    try {
      int[] c = int(split(rgb, " "));
      r = c[0];
      g = c[1];
      b = c[2];
    } catch (ArrayIndexOutOfBoundsException e) {
      r = 255;
      g = 0;
      b = 0;
    }
    
    background(r, g, b);
  }
}