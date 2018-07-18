void setup(){
  Serial.begin(9600);
}

void loop() {
  int ldr = LDR();
  int leftPot = pot1();
  int rightPot = pot2();
  
  Serial.print(ldr); Serial.print(", "); Serial.print(leftPot); Serial.print(", "); Serial.println(rightPot); 
}

int LDR(){
  int i;
  int sval = 0;

  for (i = 0; i < 5; i++){
    sval = sval + analogRead(0);    // sensor on analog pin 0
  }

  sval = sval / 5;    // average
  sval = sval / 4;    // scale to 8 bits (0 - 255)
  return sval;
}

int pot1(){
  int i;
  int sval = 0;

  for (i = 0; i < 5; i++){
    sval = sval + analogRead(1);    // sensor on analog pin 0
  }

  sval = sval / 5;    // average
  sval = sval / 4;    // scale to 8 bits (0 - 255)
  return sval;
}

int pot2(){
  int i;
  int sval = 0;

  for (i = 0; i < 5; i++){
    sval = sval + analogRead(2);    // sensor on analog pin 0
  }

  sval = sval / 5;    // average
  sval = sval / 4;    // scale to 8 bits (0 - 255)
  return sval;
}
