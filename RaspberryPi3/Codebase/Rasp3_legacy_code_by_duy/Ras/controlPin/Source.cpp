#include <iostream>		// Include all needed libraries here
#include <wiringPi.h>

using namespace std;		// No need to keep using “std”

int main()
{
	std::cout << "I am here" <<endl;
	wiringPiSetup();			// Setup the library
	pinMode(28, OUTPUT);		// Configure GPIO0 as an output
	pinMode(6, INPUT);		// Configure GPIO1 as an input
    pinMode(29, INPUT);
// Main program loop
while(1)
{
	//std::cout << "I am in loop" <<endl;
	// Button is pressed if digitalRead returns 0
	/*
	if(digitalRead(1) == 1)
	{	
		// Toggle the LED
		digitalWrite(5, !digitalRead(0));
		delay(500); 	// Delay 500ms
	}
	*/
	digitalWrite(28, 1);
	delay(500); 	
	digitalWrite(28, 0);
	delay(500); 
	
}
	return 0;
}
