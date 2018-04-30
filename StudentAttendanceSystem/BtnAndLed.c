#include <stdio.h>
#include <wiringPi.h>

#define LedPin    0
#define ButtonPin 1

int main(void)
{
	if(wiringPiSetup() == -1){
	printf("setup wiringPi failed !");
	return 1;
	}

	pinMode(LedPin, OUTPUT);
	pinMode(ButtonPin, INPUT);

	while(1){
		digitalWrite(LedPin, HIGH);
		if(digitalRead(ButtonPin)==0){
			digitalWrite(LedPin, LOW);
		}
		
	}
	return 0;
}