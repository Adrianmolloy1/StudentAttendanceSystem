#ifdef WIN32
#include <windows.h>
#else
#include <unistd.h>
#endif


//Pins for RFID to Rasberry Pi

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

//USING WIRINGPI PIN NUMBERS                       LCD RASPBERRY PI PINS
#define LCD_RS  25               //Register select pin  37
#define LCD_E   24               //Enable Pin           35
    
#define LCD_D4  23               //Data pin D4          33
#define LCD_D5  22               //Data pin D5          31
#define LCD_D6  21               //Data pin D6          29
#define LCD_D7  26               //Data pin D7          32


#define LedPin 0                                    //  11
#define LedPin2 4				   //   16
#define Buzzer 3                                   //   15                         
 
int lcd;
int isValid();
int notValid();

int main(void){
        

	wiringPiSetup();
	lcd = lcdInit (2, 16, 4, LCD_RS, LCD_E,LCD_D4, LCD_D5, LCD_D6, LCD_D7, 0 ,0 ,0, 0);

        lcdPuts(lcd, "Welcome") ; 
	delay(1000);
	lcdClear(lcd);
	lcdPuts(lcd, "Please Scan card..");
	printf("Program Running...\n");
	printf("Please Scan Card...\n");

	if(wiringPiSetup() == -1){
	printf("Setup wiringPi failed !");
        return 1;
}

	MFRC522 mfrc;
	pinMode(LedPin, OUTPUT);
	pinMode(LedPin2, OUTPUT);
	softToneCreate(Buzzer);
	mfrc.PCD_Init();

  while(1){
   
	digitalWrite(LedPin, HIGH);                     //Turning LEDS off
	digitalWrite(LedPin2, HIGH);
    	if(!mfrc.PICC_IsNewCardPresent())                 // Look for a card
      	continue;

    	if( !mfrc.PICC_ReadCardSerial())                 //Read Card
      	continue;

    	
    	printf("RFID CARD ADDRESS: ");                   // Print UID 
    	for(byte i = 0; i < mfrc.uid.size; ++i){
      	if(mfrc.uid.uidByte[i] < 0x10){
	printf("");
	printf("%X", mfrc.uid.uidByte[i]);
	}
      	else{
 	printf("");
	printf("%X", mfrc.uid.uidByte[i]);
      	     }
}
	lcdClear(lcd);
	if(mfrc.uid.uidByte[0] == 0x50 && mfrc.uid.uidByte[1] == 0x63
	&& mfrc.uid.uidByte[2] == 0x65 && mfrc.uid.uidByte[3] == 0xA8){           //print out which student has scanned
	lcdPuts(lcd,"Welcome Std1");
	isValid();
	}

	else if(mfrc.uid.uidByte[0] == 0xD0 && mfrc.uid.uidByte[1] == 0x7B
	&& mfrc.uid.uidByte[2] == 0xFD && mfrc.uid.uidByte[3] == 0xA7){
	lcdPuts(lcd, "Welcome Std2");
	isValid();
	
	}

	else if(mfrc.uid.uidByte[0] == 0x5E && mfrc.uid.uidByte[1] == 0x34
	&& mfrc.uid.uidByte[2] == 0x06 && mfrc.uid.uidByte[3] == 0x85){
	lcdPuts(lcd, "Welcome Std3");
	isValid();
	
	}

	else if(mfrc.uid.uidByte[0] == 0x20 && mfrc.uid.uidByte[1] == 0x57
	&& mfrc.uid.uidByte[2] == 0x65 && mfrc.uid.uidByte[3] == 0xA8){
	lcdPuts(lcd, "Welcome Std4");
	isValid();
	
	}

	else if(mfrc.uid.uidByte[0] == 0x30 && mfrc.uid.uidByte[1] == 0x06
	&& mfrc.uid.uidByte[2] == 0x56 && mfrc.uid.uidByte[3] == 0xA8){
	lcdPuts(lcd, "Welcome Std5");
	isValid();
	
	}

	else{
	lcdPuts(lcd, "Invalid Card");
	notValid();
	
	}
	
	lcdPuts(lcd, "Please Scan card..");
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


