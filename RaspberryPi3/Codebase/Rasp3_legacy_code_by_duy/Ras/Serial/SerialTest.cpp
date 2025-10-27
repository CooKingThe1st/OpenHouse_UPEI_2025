#include <stdio.h>
#include <string.h>
#include <errno.h>
#include <unistd.h>
#include <string>
#include <wiringSerial.h>
#include <iostream>

using namespace std;

int main()
{
	int fd;
	
	if((fd = serialOpen("/dev/serial0",115200)) < 0)
	{
		fprintf(stderr, "Unable to open serial device: %s\n", strerror(errno));
		return 1;
	}
	int a = 0;
	for(;;)
	{
		a++;
		std::string str = std::to_string(a)+"\n";
		cout << str << endl;
		char buffer[50];
		strcpy(buffer, str.c_str());
		serialPuts(fd,buffer);
		fflush(stdout);
		sleep(1);
		
	}
}
