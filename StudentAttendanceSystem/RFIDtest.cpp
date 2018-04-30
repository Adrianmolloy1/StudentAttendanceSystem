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


int main(){
	

  MFRC522 rfid;
 
  rfid.PCD_Init();
  
  while(1){
    	// Looking for a card
	
    	if(!rfid.PICC_IsNewCardPresent())
      	continue;

    	if( !rfid.PICC_ReadCardSerial())
      	continue;

    	// Print UID of card scanned

    	for(byte i = 0; i < rfid.uid.size; ++i){
      	if(rfid.uid.uidByte[i] < 0x10){
	printf(" ");
	printf("%X", rfid.uid.uidByte[i]);
	}
      	else{
 	printf(" ");
	printf("%X", rfid.uid.uidByte[i]);
      	     }
     
    	}
	printf("\n");
    	delay(1000);
	
  }

  return 0;
}
