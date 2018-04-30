#include <wiringPi.h>
#include <lcd.h>
#include <unistd.h>

//USE WIRINGPI PIN NUMBERS
#define LCD_RS  25               //Register select pin
#define LCD_E   24               //Enable Pin
    
#define LCD_D4  23               //Data pin D4
#define LCD_D5  22               //Data pin D5
#define LCD_D6  21               //Data pin D6
#define LCD_D7  14               //Data pin D7
 
int main()
{
    int lcd;
    wiringPiSetup();
    lcd = lcdInit (2, 16, 4, LCD_RS, LCD_E,LCD_D4, LCD_D5, LCD_D6, LCD_D7, 0 ,0 ,0, 0);

   
    lcdPuts(lcd, "Hello");
    sleep(2);
    lcdClear(lcd);


    lcdPuts(lcd, "EveryBody");
    sleep(2);
    lcdClear(lcd);
}
