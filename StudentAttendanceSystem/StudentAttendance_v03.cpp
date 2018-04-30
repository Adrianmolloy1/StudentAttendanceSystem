#ifdef WIN32
#include <windows.h>
#else
#include <unistd.h>
#endif


//Pins for RFID to Rasberry Pi pins

//SDA = 24
//SCK = 23
//MOSI = 19
//MISO = 21
//IRQ = UNUSED
//GND = 6
//RST = 22
//3.3v = 1


#include "MFRC522.h"
#include <stdio.h>
#include <wiringPi.h>
#include <lcd.h>
#include <unistd.h>
#include <softTone.h>
#include <errno.h>



//USING WIRINGPI PIN NUMBERS                          LCD RASPBERRY PI PINS
#define LCD_RS  25             //Register select pin  37
#define LCD_E   24             //Enable Pin           35
    
#define LCD_D4  23             //Data pin D4          33
#define LCD_D5  22             //Data pin D5          31
#define LCD_D6  21             //Data pin D6          29
#define LCD_D7  26             //Data pin D7          32

#define LedPin  0                                 //  11
#define LedPin2 4			         //   16
#define Buzzer  3                                //   15   
#define Button  1                      
 
int lcd;
int isValid();
int notValid();
int Attendance();
void ButtonPress();
int FullCount =0;

unsigned long student_list[] = {0x506365A8,0x300656A8,0xD07BFDA7,0x5E340685,0x205765A8};



int find_id(unsigned long ID)
{
	int x;
	for(x=0;x<=4;x++)
	{
		if(ID == student_list[x])
			return x;
	}
	return -1;
}

int main(void){
        
	unsigned long id;
	
	wiringPiSetup();
	lcd = lcdInit (2, 16, 4, LCD_RS, LCD_E,LCD_D4, LCD_D5, LCD_D6, LCD_D7, 0 ,0 ,0, 0);

    	lcdPuts(lcd, "Welcome to my"); 
	delay(2000);
	lcdClear(lcd);
	lcdPuts(lcd, "5th Year Project"); 
	delay(2000);
	lcdClear(lcd);
	lcdPuts(lcd, "Adrian Molloy"); 
	delay(2000);
	lcdClear(lcd);
	lcdPuts(lcd, "Please Scan card");
	printf("Program Running...\n");
	printf("Please Scan Card...\n");

	if(wiringPiSetup() == -1){
	printf("Setup wiringPi failed !");
        return 1;
}

	MFRC522 mfrc;
	pinMode(LedPin, OUTPUT);
	pinMode(LedPin2, OUTPUT);
	pinMode(Button, INPUT);
	softToneCreate(Buzzer);
	mfrc.PCD_Init();
	pullUpDnControl(Button, PUD_UP);

while(1){
   
	digitalWrite(LedPin, HIGH);                     //Turning LEDS off
	digitalWrite(LedPin2, HIGH);
	ButtonPress();
                    
    	if(!mfrc.PICC_IsNewCardPresent())                 // If a card is present
      	continue;

    	if( !mfrc.PICC_ReadCardSerial())                 //If card was read
     	 continue;

	id =  ((unsigned long)mfrc.uid.uidByte[0]) <<24;
	id += ((unsigned long)mfrc.uid.uidByte[1]) <<16;
	id += ((unsigned long)mfrc.uid.uidByte[2]) <<8;
	id+= mfrc.uid.uidByte[3];
	
	
     	printf("RFID CARD ADDRESS: "); 
     	printf("\n0x%08X\n", id); 		// Print UID 
	
	
	lcdClear(lcd);
	
	
	if(find_id(id) == -1){
		printf("Student ID not found\n");
		lcdPuts(lcd, "ID not found");
		notValid();
		//delay(1000);
		
	}	
	else {
		printf("Welcome Student %d\n", find_id(id)+1);
		lcdPrintf(lcd, "Student %d", find_id(id)+1);
		FullCount++;
		digitalWrite(LedPin, LOW);
		softToneWrite(Buzzer, 720);
    		delay(1000);
		lcdClear(lcd);
		digitalWrite(LedPin, HIGH);
		softToneWrite(Buzzer, 0);
		//isValid();	
	    }
		
	lcdClear(lcd);
	lcdPuts(lcd, "Please Scan card");
	printf("\n\nPlease Scan Card...\n");	
  }
  return 0;
}

int isValid(){
	int lcd;
	digitalWrite(LedPin, LOW);
	softToneWrite(Buzzer, 720);
    	delay(1000);
	lcdClear(lcd);
	digitalWrite(LedPin, HIGH);
	softToneWrite(Buzzer, 0);
}

int notValid(){
	int lcd;
	digitalWrite(LedPin2, LOW);
	softToneWrite(Buzzer, 220);
	delay(1000);
	lcdClear(lcd);
	digitalWrite(LedPin, HIGH);
	softToneWrite(Buzzer, 0);
}

void ButtonPress(){
if(digitalRead(Button)==0){

	lcdClear(lcd);
	lcdPrintf(lcd, "Full count is %i", FullCount);
	delay(2000);
	lcdClear(lcd);
	
	lcdPuts(lcd, "Please Scan card");
	}
}

























