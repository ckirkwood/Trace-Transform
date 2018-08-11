
void setup() {
  // put your setup code here, to run once:
  Serial.begin(230400);

}

void loop() {
  // put your main code here, to run repeatedly:

  int pot1 = readPot(0);
  int pot2 = readPot(1);
  int pot3 = readPot(2);
 /* int pot4 = readPot(3);
  int pot5 = readPot(4);
  int pot6 = readPot(5);
  int pot7 = readPot(6);
  int pot8 = readPot(7);
  int pot9 = readPot(8);
  int xSlider = readPot(9);
  int ySlider = readPot(10);
  int ldr = readPot(11);*/

  Serial.print(pot1); Serial.print(",");
  Serial.print(pot2); Serial.print(",");
  Serial.println(pot3);// Serial.print(",");
  /*Serial.print(pot4); Serial.print(",");
  Serial.print(pot5); Serial.print(",");
  Serial.print(pot6); Serial.print(",");
  Serial.print(pot7); Serial.print(",");
  Serial.print(pot8); Serial.print(",");
  Serial.println(pot9); */

}

int readPot(int p) {
  int i;
  int sval = 0;

  for (i = 0; i < 5; i++) {
    sval = sval + analogRead(p);    // sensor on analog pin 0
  }

  sval = sval / 5;    // average
  sval = sval / 4;    // scale to 8 bits (0 - 255)
  return sval;
}
