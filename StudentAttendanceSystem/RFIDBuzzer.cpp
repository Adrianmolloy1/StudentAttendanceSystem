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
#include <softTone.h>
#include <errno.h>


#define LedPin 0
#define Buzzer 3     //wiringPi Pins

int main(void){
	 printf("Raspberry Pi RFID Test\n") ; 
	printf("Please scan your card....\n");
	if(wiringPiSetup() == -1){
	printf("setup wiringPi failed !");
	return 1;
	}
  pinMode(LedPin, OUTPUT);
  pinMode(Buzzer, OUTPUT);
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
	softToneWrite(Buzzer, 392);     //(pin, Freq)
	printf("Card Scanned\n");
    	delay(1000);
	printf("LED Off\n");
	printf("Please scan your card...\n");
	digitalWrite(LedPin, HIGH);
	softToneWrite(Buzzer,0);
	
  }


  return 0;
}