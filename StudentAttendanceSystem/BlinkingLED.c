
#include <stdio.h>
#include <wiringPi.h>

int ledPin = 11;

int main (void)
{
  printf ("Raspberry Pi blink\n") ; 
  if (wiringPiSetup () == -1)
    return 1 ;

  pinMode (ledPin, OUTPUT) ;         // 

  for (;;)
  {
    digitalWrite (0, 1) ;       // On
    printf("LED ON\n");
    delay (500) ;               // mS
    digitalWrite (0, 0) ;       // Off
    printf("LED OFF\n");
    delay (500) ;
  }
  return 0 ;
}
