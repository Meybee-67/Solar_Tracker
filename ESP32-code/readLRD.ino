//Define pins
#define ldrlt A2 //LDR top left - BOTTOM LEFT
#define ldrrt A3 //LDR top rigt - BOTTOM RIGHT 
#define ldrld A0 //LDR down left - TOP LEFT
#define ldrrd  A1 //ldr down rigt - TOP RIGHT

int avg_list[4];

void setup()
{
  Serial.begin(9600);
}

void loop() 
{
  int lt = analogRead(ldrlt); // top left
  int rt = analogRead(ldrrt); // top right
  int ld = analogRead(ldrld); // down left
  int rd = analogRead(ldrrd); // down rigt
  
  

}


