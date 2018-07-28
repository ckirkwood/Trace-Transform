PImage[] bulb;
int files = 8;

int x, y, w, h;

void setup() {
 fullScreen();
 bulb = new PImage[files];
 for(int i=0; i<bulb.length; i++){
   bulb[i]=loadImage(str(i) + ".jpg");
 
  x = 200;
  y = height/2;
  w = 150;
  h = 150;
}
}

void draw(){
  background(0);
  
  for(int i=0;i<bulb.length;i++){
    imageMode(CENTER);
    image(bulb[i], x+(w*i), y, w, h);
    tint(255, 127);
  }
  
}