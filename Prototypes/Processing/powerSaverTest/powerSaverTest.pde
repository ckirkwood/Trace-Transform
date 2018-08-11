int count = 0;

void setup() {
  fullScreen();
}

void draw() { 
  count += 1;
  delay(1000);

  if (count == 2) {
    launch("/Users/callumkirkwood/Documents/Projects/Github/Trace-Transform/Prototypes/Automation/powerSaver.app");
  }
  if (count == 10) {
    launch("/Users/callumkirkwood/Documents/Projects/Github/Trace-Transform/Prototypes/Automation/stopPowerSaver.app");
  }
}
