import processing.serial.*;
import cc.arduino.*;

PImage img;
PImage img2;
int i=0;
int j=0;
int w=0;
float r1=0;
float r2=0;
int time;
float timeDelay;

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
int[][] board = { //1 2 3 4 5 6 7 8 9
                   {0,0,0,0,0,0,0,0,0}, //1
                   {0,0,0,0,0,0,0,0,0}, //2
                   {0,0,0,0,0,0,0,0,0}, //3
                   {0,0,0,0,0,0,0,0,0}, //4
                   {0,0,0,0,0,0,0,0,0}, //5
                   {0,0,0,0,0,0,0,0,0}, //6
                   {0,0,0,0,0,0,0,0,0}, //7
                   {0,0,0,0,0,0,0,0,0}, //8
                   {0,0,0,0,0,0,0,0,0}  //9
                 };

int[][] mines ={  {0,0},
                  {0,0},
                  {0,0},
                  {0,0},
                  {0,0},
                  {0,0},
                  {0,0},
                  {0,0},
                  {0,0}
                };
;
void gen()
{
  r1 = random(9);
  r2 = random(9);
  board[(int)r1][(int)r2]=1;
  mines[0][0]=(int)r1;
  mines[0][1]=(int)r2;
  for(i=1;i<9;i++)
  {
    while(board[(int)r1][(int)r2]==1){
    r1 = random(9);
    r2 = random(9);
    }
    board[(int)r1][(int)r2]=1;
    mines[i][0]=(int)r1;
    mines[i][1]=(int)r2;
  }

    



}

void setup()
{
  size(576,576);
  //println(Arduino.list());
  arduino = new Arduino(this, Arduino.list()[0], 57600);
  arduino.pinMode(ledPin, Arduino.OUTPUT);
  arduino.pinMode(buzzPin, Arduino.OUTPUT);
  arduino.pinMode(xPin, Arduino.INPUT);
  arduino.pinMode(yPin, Arduino.INPUT);
  time = millis();
  timeDelay=500;
  
  background(255); //Hvid Baggrund
  for(i=0; i<width; i+=66){ // i starter på 0, så længe i er mindre end skærmen, så lav en linje og læg 66 til i
   line(i,0,i,height); // line(x1, y1, x2, y2);
 }
 for(w=0; w<height; w+=66){
   line(0,w,width,w);
 }
 img = loadImage("Anton1.png");
 img2= loadImage("Bomb.png");


 
 
 gen();
/* for (i = 0; i < 9; i++) {
  for (j = 0; j < 9; j++) {
    if(j<8){
    print(board[i][j]);
    }
    
    if(j==8)
    {
     println(board[i][j]);
    }
  }
 } */
 for(i=0;i<9;i++)
 {
   print(mines[i][0]);
   print(", ");
   println(mines[i][1]);
 }
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

void beep()
{
  float dist = 100;
  for(i=0;i<9;i++)
  {
      int tempX = mines[i][0]-location[0];
      int tempY = mines[i][1]-location[1];
      float tempD = sqrt(tempX^2+tempY^2);
      if(tempD<dist)
      {
        dist=tempD;
        
      }    
  }
  timeDelay=500/dist;
  
  if(millis() > time + timeDelay)
  {
    arduino.digitalWrite(buzzPin,Arduino.HIGH);
    time=millis();
    arduino.digitalWrite(buzzPin,Arduino.LOW);
  }
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
    beep();
    
}
