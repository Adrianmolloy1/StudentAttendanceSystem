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


void delay(int ms){
#ifdef WIN32
  Sleep(ms);
#else
  usleep(ms*1000);
#endif
}


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
#define LedPin 0
#define Buzzer 3

int main(void){
	int lcd;
  	wiringPiSetup();
  	lcd = lcdInit (2, 16, 4, LCD_RS, LCD_E,LCD_D4, LCD_D5, LCD_D6, LCD_D7, 0 ,0 ,0, 0);

	lcdPuts(lcd, "Welcome") ; 
	sleep(2);
	lcdClear(lcd);
	lcdPuts(lcd, "Please Scan card..");
	if(wiringPiSetup() == -1){
	printf("Setup wiringPi failed !");
	return 1;
	}
  pinMode(LedPin, OUTPUT);
  softToneCreate(Buzzer);
  MFRC522 mfrc;
 
  mfrc.PCD_Init();
  
  while(1){
    // Look for a card
	digitalWrite(LedPin, HIGH);
    	if(!mfrc.PICC_IsNewCardPresent())
      	continue;

    	if( !mfrc.PICC_ReadCardSerial())
      	continue;

    	// Print UID
    	for(byte i = 0; i < mfrc.uid.size; ++i){
      	if(mfrc.uid.uidByte[i] < 0x10){
	printf("");
	//printf("%X", mfrc.uid.uidByte[i]);
	
      	  }
     
    }
	printf("LED ON\n");
	digitalWrite(LedPin, LOW);
        softToneWrite(Buzzer, 392); //(pin, Freq)
	lcdClear(lcd);
	lcdPuts(lcd, "Card Scanned");
    	sleep(1);
	printf("LED Off\n");
	lcdClear(lcd);
	lcdPuts(lcd, "Please Scan card..");
	digitalWrite(LedPin, HIGH);
	softToneWrite(Buzzer, 0);
	
	
  }

  return 0;
}