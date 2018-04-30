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
#include <stdlib.h>
#include <string.h>
#include <mysql/mysql.h>

//USING WIRINGPI PIN NUMBERS                          LCD RASPBERRY PI PINS
#define LCD_RS  25             //Register select pin  37
#define LCD_E   24             //Enable Pin           35
    
#define LCD_D4  23             //Data pin D4          33
#define LCD_D5  22             //Data pin D5          31
#define LCD_D6  21             //Data pin D6          29
#define LCD_D7  26             //Data pin D7          32

#define GreenLed 0                                //  11
#define RedLed   4				 //   16
#define Buzzer   3                               //   15   
#define Button   1                      
 
int lcd;
int isValid();
int notValid();
int Attendance();
void ButtonPress();
int FullCount =0;


#define DATABASE_NAME  "StudentAttSystem"
#define DATABASE_USERNAME "root"
#define DATABASE_PASSWORD "adrian"

MYSQL *mysql1;



/***********Connect To Database*************/

void mysql_connect (void)
{
     //initialize MYSQL object for connections
     mysql1 = mysql_init(NULL);

     if(mysql1 == NULL)
     {
         fprintf(stderr, "Err : %s\n", mysql_error(mysql1));
         return;
     }

     //Connect to the database
     if(mysql_real_connect(mysql1, "localhost", DATABASE_USERNAME, DATABASE_PASSWORD, DATABASE_NAME, 0, NULL, 0) == NULL)
     {
      fprintf(stderr, "%s\n", mysql_error(mysql1));
     }
     else
     {
         printf("Database connection successful.\r\n");
     }
}

/***********Disconnect From Database*************/

void mysql_disconnect (void)
{
    mysql_close(mysql1);
    printf( "Disconnected from database.\r\n");
}


int main(void)
{
        
	unsigned long rfid;
	wiringPiSetup();
	lcd = lcdInit (2, 16, 4, LCD_RS, LCD_E,LCD_D4, LCD_D5, LCD_D6, LCD_D7, 0 ,0 ,0, 0);

    	lcdPuts(lcd, "Welcome"); 
	delay(2000);
	lcdClear(lcd);
	lcdPuts(lcd, "Please Scan Card");
	printf("Program Running...\n");
	printf("Please Scan Card...\n");

	
	if(wiringPiSetup() == -1)
	{
		printf("Setup wiringPi failed !");
        	return 1;
	}

	MFRC522 mfrc;
	pinMode(GreenLed, OUTPUT);
	pinMode(RedLed, OUTPUT);
	pinMode(Button, INPUT);
	softToneCreate(Buzzer);
	mfrc.PCD_Init();
	pullUpDnControl(Button, PUD_UP);


  while(1)
  {
   
	digitalWrite(GreenLed, HIGH);                     //Turning LEDS off
	digitalWrite(RedLed, HIGH);
	ButtonPress();
                    
    	if(!mfrc.PICC_IsNewCardPresent())                 // If a card is present
      	continue;

    	if( !mfrc.PICC_ReadCardSerial())                 //If card was read
     	 continue;

	rfid =  ((unsigned long)mfrc.uid.uidByte[0]) <<24;
	rfid += ((unsigned long)mfrc.uid.uidByte[1]) <<16;
	rfid += ((unsigned long)mfrc.uid.uidByte[2]) <<8;
	rfid+= mfrc.uid.uidByte[3];
	

     	printf("RFID CARD ADDRESS: "); 
     	printf("\n%X\n", rfid); 		// Print UID 
	
	
	lcdClear(lcd);
	

	mysql_connect();
	if (mysql1 != NULL)
		{

			char str[80];
			
			sprintf(str, "SELECT ID, Firstname, Lastname FROM students WHERE RFID ='%X'",rfid);       				 ///Select from database 
			
			 if (!mysql_query(mysql1, str))											
			   {
				MYSQL_RES *result = mysql_store_result(mysql1);
				  
				//Get the number of columns
				  int num_rows = mysql_num_rows(result);
				  int num_fields = mysql_num_fields(result);
				
				 if (result && mysql_num_rows(result)>0)
				     {
				        MYSQL_ROW row;                                            //An array of strings
				        while( (row = mysql_fetch_row(result)) )
				          {
				  		char *ID = row[0];
						char *Firstname = row[1];
						char *Lastname = row[2];
							

						printf( "Welcome %s %s\n", Firstname,Lastname);     //Print out name in database
						lcdPrintf(lcd, "Welcome %s", Firstname);
						digitalWrite(GreenLed, LOW);
						isValid();
					
						
						char str2[80];
						sprintf(str2, "INSERT INTO attendance (Students_ID, Datetime) VALUES ('%s', NOW())" ,ID); 

						   if (!mysql_query(mysql1, str2)) 
							{
							   printf("Date and Time Inserted\n");
							   FullCount++;
						        }
					
				      	  }
				           mysql_free_result(result);
				     }
				     else
				       {
				          printf("Cannot get data\n");
					  lcdPuts(lcd, "Invalid Card");
					  digitalWrite(RedLed, LOW);
					  notValid();
				       }
		          }
	             	  else
			    {
			      
			      printf("Cannot SELECT\n");
		            }
	  	
		}
		
	   mysql_disconnect();	
		
	lcdClear(lcd);
	lcdPuts(lcd, "Please Scan Card");
	
	printf("\n\nPlease Scan Card...\n");	
  }

  return 0;
}

int isValid()
{
   int lcd;
   digitalWrite(GreenLed, LOW);
   softToneWrite(Buzzer, 720);
   delay(1000);
   lcdClear(lcd);
   digitalWrite(GreenLed, HIGH);
   softToneWrite(Buzzer, 0);
}

int notValid()
{
   int lcd;
   digitalWrite(RedLed, LOW);
   softToneWrite(Buzzer, 220);
   delay(1000);
   lcdClear(lcd);
   digitalWrite(GreenLed, HIGH);
   softToneWrite(Buzzer, 0);
}

void ButtonPress()
{

   if(digitalRead(Button)==0)
	{
     	   lcdClear(lcd);
	   lcdPrintf(lcd, "Todays Count is %i",FullCount);
	   delay(1000);
	   lcdClear(lcd);
           lcdPuts(lcd, "Please Scan Card");
	}
}

























