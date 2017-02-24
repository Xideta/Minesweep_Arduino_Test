import processing.serial.*;
import cc.arduino.*;

PImage img;
PImage img2;
PImage img3;
PImage img4;
int i=0;
int j=0;
int w=0;
float r1=0;
float r2=0;
float tempD = 100;

int time;
float timeDelay;

boolean flagPlantTrue=false;
int holeCount = 0;
int holeLocation[][] = new int[9][2];
int flagLocation[][] = new int[9][2];

Arduino arduino;
int ledPin = 13; // led pin til debugging
int resetPin = 2; // bombevender knap
int plantPin = 3; // plant flag knap
int buzzPin = 4; // pin hvor musik skal spilles
int xPin = 0;
int yPin = 1;
float xVal = 0;
float yVal = 0;
float xGrid = 0;
float yGrid = 0;

int[] location = {5, 5};
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



void gen()
{
  r1 = random(9);
  r2 = random(9);
  board[(int)r1][(int)r2]=1;
  mines[0][0]=(int)r1+1;
  mines[0][1]=(int)r2+1;
  for(i=1;i<9;i++)
  {
    while(board[(int)r1][(int)r2]==1){
    r1 = random(9);
    r2 = random(9);
    }
    
    board[(int)r1][(int)r2]=1;
    mines[i][0]=(int)r1+1;
    mines[i][1]=(int)r2+1;
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
  arduino.pinMode(plantPin, Arduino.INPUT);
  arduino.pinMode(resetPin, Arduino.INPUT);
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
 img3= loadImage("Flag.png");
 img4= loadImage("Hole.png");
   
  for(i=0;i<9;i++)
  {
    flagLocation[i][0]=-1;
    flagLocation[i][1]=-1;
  }
  for(i=0;i<9;i++)
  {
    holeLocation[i][0]=-1;
    holeLocation[i][1]=-1;
  }
 gen();
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
  image(img,xVal,yVal);
}

void beep()
{
  float dist = 100;

  for(i=0;i<9;i++)
  {

            if(mines[i][0]-location[0]<0 && mines[i][1]-location[1]>0 || mines[i][0]-location[0]<0 && mines[i][1]-location[1]==0 ) // HØJRE-TOP side af minen distance calc
      {
        tempD = sqrt((location[0]-mines[i][0])^2+(mines[i][1]-location[1])^2);
      }
       else if(mines[i][0]-location[0]>0 && mines[i][1]-location[1]<0 || mines[i][0]-location[0]>0 && mines[i][1]-location[1]==0 ) // VENSTRE-NED side af minen distance calc
      {
        tempD = sqrt((mines[i][0]-location[0])^2+(location[1]-mines[i][1])^2);
      } 
       else if(mines[i][0]-location[0]>0 && mines[i][1]-location[1]>0 || mines[i][0]-location[0]==0 && mines[i][1]-location[1]>0 ) // VENSTRE-TOP side af minen distance calc
      {
        tempD = sqrt((mines[i][0]-location[0])^2+(mines[i][1]-location[1])^2);
      } 
       else if(mines[i][0]-location[0]<0 && mines[i][1]-location[1]<0 || mines[i][0]-location[0]==0 && mines[i][1]-location[1]<0 ) // HØJRE-NED side af minen distance calc
      {
        tempD = sqrt((location[0]-mines[i][0])^2+(location[1]-3)^mines[i][1]);
      } 
      else if (mines[i][0]-location[0]==0 && mines[i][1]-location[1]==0)
      {
        tempD=-0.5;
      }
      
      
      if(tempD<dist)
      {
        dist=tempD;
      
      }
  }
  timeDelay=200*(dist+1);
  //println(timeDelay);
  //println(dist);
  
  if(millis() > time + timeDelay)
  {
    arduino.digitalWrite(buzzPin,Arduino.HIGH);
    time=millis();
    arduino.digitalWrite(buzzPin,Arduino.LOW);
    
  }
}

void plant()
{
    for(i=0;i<9;i++)
    {
      if(location[0]==mines[i][0] && location[1]==mines[i][1])
      {
        flagPlantTrue=true;
        flagLocation[i][0]=(location[0]-1)*64;
        flagLocation[i][1]=(location[1]-1)*64;
        print("HIT");
        
      }
    }
    
    if(flagPlantTrue)
    {
      flagPlantTrue=false;
    }
    else {
      holeLocation[holeCount][0]=(location[0]-1)*64;
      holeLocation[holeCount][1]=(location[1]-1)*64;
      holeCount++;
    }
    
  
}

void holes()
{
  for(i=0;i<9;i++)
  {
    if(flagLocation[i][0]!=-1 && flagLocation[i][1]!=-1)
    {
    image(img3,flagLocation[i][0],flagLocation[i][1]); 
    }
  }
  
  for(i=0;i<9;i++)
  {
    if(holeLocation[i][0]!=-1 && holeLocation[i][1]!=-1)
    {
    image(img4,holeLocation[i][0],holeLocation[i][1]); 
    }
  }
  
}

void win()
{
  if(holeCount==4)
  {
    reset();
  }
  if(arduino.digitalRead(resetPin)==1)
  {
    while(arduino.digitalRead(resetPin)==1)
    {
      delay(1);
    }
    reset();
  }
}

void reset()
{
tempD = 100;


flagPlantTrue=false;
holeCount = 0;

for(i=0;i<9;i++)
{
holeLocation[i][0] = -1;
holeLocation[i][1] = -1;

flagLocation[i][0] = -1;
flagLocation[i][1] = -1;
}

location[0] = -1;
location[1] = -1;

for(i=0;i<9;i++)
{
  for(j=0;i<9;i++)
  {
board[i][j] =0;

  }
}
for(i=0;i<9;i++)
{
mines[i][0]=0;
mines[i][1]=0;
}
gen();
println("NEW GAME");
println("NEW GAME");
 for(i=0;i<9;i++)
 {
   print(mines[i][0]);
   print(", ");
   println(mines[i][1]);
 }

}
void draw()
{
    
    background(255); //Hvid Baggrund
    for(i=0; i<width; i+=64){ // i starter på 0, så længe i er mindre end skærmen, så lav en linje og læg 64 til i
      line(i,0,i,height); // line(x1, y1, x2, y2);
    }
    for(w=0; w<height; w+=64){
      line(0,w,width,w);
    }
      if(arduino.digitalRead(plantPin)==1)
      {
        while(arduino.digitalRead(plantPin)==1)
      {
        delay(1);
      }
        plant();
      }
    beep();
    holes();
    move();
    win();
    
}
