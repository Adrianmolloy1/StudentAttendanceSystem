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


#define LedPin 0   //wiringPi pins Raspberry Pi pin 11

#define LedPin2 4   //wiringPi pins Raspberry Pi pin 16


int main(void){ 
	printf("Please scan your card....\n");
	if(wiringPiSetup() == -1){
	printf("setup wiringPi failed !");
	return 1;
	}
  pinMode(LedPin, OUTPUT);
pinMode(LedPin2, OUTPUT);
  
  MFRC522 mfrc;
 
  mfrc.PCD_Init();
  
  while(1){
    // Look for a card
	digitalWrite(LedPin, HIGH);
    	if(!mfrc.PICC_IsNewCardPresent())
      	continue;

    	if( !mfrc.PICC_ReadCardSerial())
      	continue;
	printf("RFID CARD ADDRESS: ");
    	// Print UID
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
	if(mfrc.uid.uidByte[0] == 0x50 && mfrc.uid.uidByte[1] == 0x63             //if card scanned is equal to HEX address
	&& mfrc.uid.uidByte[2] == 0x65 && mfrc.uid.uidByte[3] == 0xA8){           //print out which student has scanned
	printf("\nWelcome Student 1\n");
	digitalWrite(LedPin, LOW);
    	delay(2000);
	digitalWrite(LedPin, HIGH);
	}
	else if(mfrc.uid.uidByte[0] == 0xD0 && mfrc.uid.uidByte[1] == 0x7B
	&& mfrc.uid.uidByte[2] == 0xFD && mfrc.uid.uidByte[3] == 0xA7){
	printf("\nWelcome Student 2 \n");
	digitalWrite(LedPin, LOW);
    	delay(2000);
	digitalWrite(LedPin, HIGH);
	}
	else if(mfrc.uid.uidByte[0] == 0x5E && mfrc.uid.uidByte[1] == 0x34
	&& mfrc.uid.uidByte[2] == 0x06 && mfrc.uid.uidByte[3] == 0x85){
	printf("\nWelcome Student 3 \n");
	digitalWrite(LedPin, LOW);
    	delay(2000);
	digitalWrite(LedPin, HIGH);
	}
	else if(mfrc.uid.uidByte[0] == 0x20 && mfrc.uid.uidByte[1] == 0x57
	&& mfrc.uid.uidByte[2] == 0x65 && mfrc.uid.uidByte[3] == 0xA8){
	printf("\nWelcome Student 4 \n");
	digitalWrite(LedPin, LOW);
    	delay(2000);
	digitalWrite(LedPin, HIGH);
	}
	else if(mfrc.uid.uidByte[0] == 0x30 && mfrc.uid.uidByte[1] == 0x06
	&& mfrc.uid.uidByte[2] == 0x56 && mfrc.uid.uidByte[3] == 0xA8){
	printf("\nWelcome Student 5\n");
	digitalWrite(LedPin, LOW);
    	delay(2000);
	digitalWrite(LedPin, HIGH);
	}
	else{
	printf("\nInvalid Card\n");
	digitalWrite(LedPin2, LOW);
    	delay(2000);
	digitalWrite(LedPin2, HIGH);
	}
	
	
	
printf("\nPlease scan your card...\n");
	
	
  }

  return 0;
}