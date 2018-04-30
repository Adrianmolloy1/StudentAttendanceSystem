#ifdef WIN32
#include <windows.h>
#else
#include <unistd.h>
#endif

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


#define LedPin 0

int main(void){
	 printf ("Raspberry Pi RFID Test\n") ; 
	printf("Please scan your card....\n");
	if(wiringPiSetup() == -1){
	printf("setup wiringPi failed !");
	return 1;
	}
  pinMode(LedPin, OUTPUT);

  MFRC522 mfrc;
 
  mfrc.PCD_Init();
  
  while(1){
    // Look for a card
	
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
      	else{
 	printf("");
	//printf("%X", mfrc.uid.uidByte[i]);
      	     }
     
    	}
	printf("LED ON\n");
	digitalWrite(LedPin, LOW);
	printf("Card Scanned\n");
    	delay(2000);
	printf("LED Off\n");
	 printf("Please scan your card...\n");
	digitalWrite(LedPin, HIGH);
	
	
  }

  return 0;
}
