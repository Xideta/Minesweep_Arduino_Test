import processing.serial.*;
import cc.arduino.*;

Arduino arduino;
int ledPin = 13; // led pin til debugging
int bombPin = 2; // bombevender knap
int flagPin = 3; // plant flag knap
int buzzPin = 4; // pin hvor musik skal spilles
int location[][] = 

void setup()
{
  size(594,594);
  //println(Arduino.list());
  arduino = new Arduino(this, Arduino.list()[0], 57600);
  arduino.pinMode(ledPin, Arduino.OUTPUT);
  background(255); //Hvid Baggrund
  for(int i=0; i<width; i+=66){ // i starter på 0, så længe i er mindre end skærmen, så lav en linje og læg 66 til i
   line(i,0,i,height); // line(x1, y1, x2, y2);
 }
 for(int w=0; w<height; w+=66){
   line(0,w,width,w);
 }
}

void draw()
{
  arduino.digitalWrite(ledPin, Arduino.HIGH);
  delay(1000);
  arduino.digitalWrite(ledPin, Arduino.LOW);
  delay(1000);

}
