//Define pins
#define ldrlt A2 //LDR top left - BOTTOM LEFT
#define ldrrt A3 //LDR top rigt - BOTTOM RIGHT 
#define ldrld A0 //LDR down left - TOP LEFT
#define ldrrd  A1 //ldr down rigt - TOP RIGHT

int avg_list[4];

void setup()
{
  Serial.begin(9600);
  delay(1000); // Petit délai pour laisser le port série s'initialiser
  Serial.println("Lecture des photorésistances...");
}

String readBrightness(int list){
  int min_list = list[0];
  for (byte i = 0; i < sizeof(list); i+=1){
    if(min_list<list[i]){
      min_list = list[i];
      }
    }
    float Vout = min_list*(3.3/4095.0);
    int RLDR = 10000.0 * (Vout / (3.3- Vout));
    int brightness = exp(11.72)*pow(RLDR,-0.79);
    return(String(brightness));

void loop() 
{
  int lt = analogRead(ldrlt); // top left
  int rt = analogRead(ldrrt); // top right
  int ld = analogRead(ldrld); // down left
  int rd = analogRead(ldrrd); // down rigt
  avg_list[0]=lt;
  avg_list[1]=rt;
  avg_list[2]=ld;
  avg_list[3]=rd;

  Serial.print("Luminosité:");
  Serial.print(" : ");
  Serial.println(readBrightness(avg_list));
}


