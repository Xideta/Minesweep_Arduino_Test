import processing.serial.*;
import cc.arduino.*;

PImage img;
int i=0;
int w=0;

Arduino arduino;
int ledPin = 13; // led pin til debugging
int bombPin = 2; // bombevender knap
int plantPin = 3; // plant flag knap
int buzzPin = 4; // pin hvor musik skal spilles
int xPin = 0;
int yPin = 1;
float xVal = 0;
float yVal = 0;
float xGrid = 0;
float yGrid = 0;

int[] location = {0, 0};
int[][] board = {  {0,0,0,0,0,0,0,0,0},
                   {0,0,0,0,0,0,0,0,0},
                   {0,0,0,0,0,0,0,0,0},
                   {0,0,0,0,0,0,0,0,0},
                   {0,0,0,0,0,0,0,0,0},
                   {0,0,0,0,0,0,0,0,0},
                   {0,0,0,0,0,0,0,0,0},
                   {0,0,0,0,0,0,0,0,0},
                   {0,0,0,0,0,0,0,0,0}  
                 };

int[] mineTemp={0,0}
;
void gen()
{
  float r1 = random(10)+1;
  float r2 = random(10)+1;
  board[(int)r1][(int)r2]=1;
  for(i=0;i<10;i++)
  {
    
  }
  
}

void setup()
{
  size(576,576);
  //println(Arduino.list());
  arduino = new Arduino(this, Arduino.list()[0], 57600);
  arduino.pinMode(ledPin, Arduino.OUTPUT);
  arduino.pinMode(xPin, Arduino.INPUT);
  arduino.pinMode(yPin, Arduino.INPUT);
  
  
  
  background(255); //Hvid Baggrund
  for(i=0; i<width; i+=66){ // i starter på 0, så længe i er mindre end skærmen, så lav en linje og læg 66 til i
   line(i,0,i,height); // line(x1, y1, x2, y2);
 }
 for(w=0; w<height; w+=66){
   line(0,w,width,w);
 }
 img = loadImage("Anton1.png");


 
 
 
}

void move()
{
  xVal = map(arduino.analogRead(xPin), 0 , 1023, 22, 534);
  yVal = map(arduino.analogRead(yPin), 0 , 1023, 5, 517);

  for(i=1;i<10;i++)
  {
    if(64*(i-1) < xVal && xVal < 64*i)
    {
      location[0]=i;
    }
  }
  for(i=1;i<10;i++)
  {
    if(64*(i-1) < yVal && yVal < 64*i)
    {
      location[1]=i;
    }
  }

 // println(location[0]);
 // println(location[1]);
  image(img,xVal,yVal);
}

void plant()
{
  //location[1]
}

void flip()
{
  
}

void draw()
{
/*  arduino.digitalWrite(ledPin, Arduino.HIGH);
  delay(1000);
  arduino.digitalWrite(ledPin, Arduino.LOW);
  delay(1000);
*/
   background(255); //Hvid Baggrund
   move();
   for(i=0; i<width; i+=64){ // i starter på 0, så længe i er mindre end skærmen, så lav en linje og læg 66 til i
     line(i,0,i,height); // line(x1, y1, x2, y2);
   }
   for(w=0; w<height; w+=64){
     line(0,w,width,w);
   }
  /* if(arduino.digitalRead(plantPin))
   {
     
   } */
}
