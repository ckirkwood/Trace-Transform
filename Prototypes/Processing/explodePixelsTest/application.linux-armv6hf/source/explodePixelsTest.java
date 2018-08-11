import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class explodePixelsTest extends PApplet {

PImage img;       // The source image
int cellsize = 2; // Dimensions of each cell in the grid
int columns, rows;   // Number of columns and rows in our system

public void setup() {
   
  img = loadImage("0.jpg");  // Load the image
  columns = img.width / cellsize;  // Calculate # of columns
  rows = img.height / cellsize;  // Calculate # of rows
}

public void draw() {
  background(0);
  // Begin loop for columns
  for ( int i = 0; i < columns; i++) {
    // Begin loop for rows
    for ( int j = 0; j < rows; j++) {
      int x = i*cellsize + cellsize/2;  // x position
      int y = j*cellsize + cellsize/2;  // y position
      int loc = x + y*img.width;  // Pixel array location
      int c = img.pixels[loc];  // Grab the color
      // Calculate a z position as a function of mouseX and pixel brightness
      float z = (mouseX / PApplet.parseFloat(width)) * brightness(img.pixels[loc]) - 20.0f;
      // Translate to the location, set fill and stroke, and draw the rect
      pushMatrix();
      translate(x + 200, y + 100, z);
      fill(c, 204);
      noStroke();
      rectMode(CENTER);
      rect(0, 0, cellsize, cellsize);
      popMatrix();
    }
  }
}
  public void settings() {  fullScreen(P3D); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "explodePixelsTest" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
