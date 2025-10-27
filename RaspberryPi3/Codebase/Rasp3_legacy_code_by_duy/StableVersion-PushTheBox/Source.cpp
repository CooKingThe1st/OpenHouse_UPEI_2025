/*
* Stable version 5.0
* Date : 6/02/2023
* Run on Rasberry
* Push the box task
*/
#include "library.h"
#include <typeinfo>
#include <thread>
#include <string>
#include <sstream>
#include <fstream>
/////////////////////////////////////////////////////////////////////
//
//Change here for new robot- the 1st robot will be numbered at 1
//
//The box will be numbered at 1 , robot will be numbered 2
//
int boxID =1;
int robotID = 3;
//
//
/////////////////////////////////////////////////////////////////////

float dataTranfer= -500;
string dataTransfer_string;
float dataXY[8];
int main(int argc, char *argv[])
{
	std::cout<<"Printed" <<std::endl;
	std::cout << "P parameter: " << std::string(argv[1]) << endl;
	std::cout << "I parameter: " << std::string(argv[2]) << endl;
	std::cout << "D parameter: " << std::string(argv[3]) << endl;
	std::cout << "Motor command: " << std::string(argv[4]) <<endl;
	
	
	//OpenSerial
	int fd;
		
	//Turn off motor function
	if((fd = serialOpen("/dev/serial0",115200)) < 0)
	{
		fprintf(stderr, "Unable to open serial device: %s\n", strerror(errno));
		return 1;
	}
	
	if(string(argv[4]) == "-r")
	{
		std::cout << "Run motors " <<endl;
		
	}
	else if (string(argv[4]) == "-s")
	{
		std::cout << "Stop motors" <<endl;
		std::string string_stop = "s,"+to_string(0)+"," + to_string(0)+","+to_string(0)+ "," + to_string(0)+ "," +to_string(0)+"\n";
		//std::string str = dataTransfer_string;
		char bufferStop[5000];
		strcpy(bufferStop, string_stop.c_str());
		serialPuts(fd,bufferStop);
		fflush(stdout);
		return 5;
	}
	
	
	int a = 100;
	
	
	cv::VideoCapture camera1;
	int k = 0;
	try
	{
		camera1 = cv::VideoCapture(0);
		if (!camera1.isOpened()) throw 10;
	}
	catch (int e)
	{
		std::cout << "Can not connect to camera - error -  " << e << endl;
	}

	cv::Mat cam_img1, colorImage;
	vector<cv::Point3f> savePoint;

	int count = 0;
	char samplingDataTimes = 50;
	float saveBoundary = 0;
	int startEngine = 0;
	
	//
	
	 
	//Create the socket
	int sock = socket(AF_INET, SOCK_STREAM,0);
	if(sock == -1)
	{
	return 1;
	}
	
	struct timeval timeout;
	timeout.tv_sec = 0;
	timeout.tv_usec = 1000;
	setsockopt(sock,SOL_SOCKET,SO_RCVTIMEO, &timeout, sizeof(timeout));
	
	//Create a hint structure for the server we connect
	int port = 5400;
	std::string ipAddress = "192.168.0.101";
	sockaddr_in hint;
	hint.sin_family = AF_INET;
	hint.sin_port =htons(port);
	inet_pton(AF_INET,"192.168.0.101", &hint.sin_addr);
	
	// Connect to the server on the socket
	int connectRes = connect(sock,(sockaddr*)&hint, sizeof(hint));
	if(connectRes == -1)
	{	
	   return -1;
	}

	//std::ofstream writeData;
	//writeData.open("data.csv");	
	
	
	 
	char buf[4096];
	string userInput;
	string robotInforData;
	string boxData;
	while (true)
	{
		//mu.lock();
		vector<cv::Point3f> changedPoint;
		vector<cv::Point2f> displacement;
		vector<int> contactList;
		vector<float> forceList;

		auto start = high_resolution_clock::now();

		camera1 >> cam_img1;
		//("Raw", cam_img1);
		//sizeImage(cam_img1, "camera 1");
		//framePerSecond(camera1, "camera 1");

		//cam_img1 = cam_img1(cv::Rect(80, 0, 490, 480));
		colorImage = cam_img1.clone();

		//fillImage(cam_img1, static_cast<float>(cam_img1.cols), static_cast<float>(cam_img1.rows));
        
		denoiseImage(cam_img1, static_cast<int>(cam_img1.cols), static_cast<int>(cam_img1.rows));
		
		//imshow("filled", cam_img1);
		if (count < samplingDataTimes)
		{
			locateMarker(cam_img1, colorImage, savePoint);
			std::cout << "Save data done" << endl;
			
			int sendRes = send(sock, "Initial the heading", 20,0);
			if (sendRes == -1)
			{
				cout << "Can not send to the server";
				continue;
			}
			
			
			int bytesReceived = recv(sock, buf, 4096, 0);
			string bufferRecieve; 
			if (bytesReceived == -1)
			{
				continue;
			}
			else
			{
				//bufferRecieve = atof(string(buf, bytesReceived).c_str()) ;
				bufferRecieve = string(buf, bytesReceived).c_str();
				cout << "SERVER>" << bufferRecieve<< "\r\n" <<endl;
				
				
				memset(buf, 0,4096);
			}
					
			std::string str = "s,0,0,0,0,0,0,\n";
			//std::string str = bufferRecieve;
			//std::string str = "s," +to_string((float)bufferRecieve)+ ",1"+"\n";
			//std::string str = bufferRecieve;
			cout << str << endl;
			char buffer[50];
			strcpy(buffer, str.c_str());
			serialPuts(fd,buffer);
			fflush(stdout);
			dataTranfer = -500;
					
		}
		else
		{
			locateMarker(cam_img1, colorImage, changedPoint);

			checkMarker(savePoint, changedPoint);

			displacementArray(savePoint, changedPoint, displacement, true, colorImage);

			findHighPoint(displacement, contactList);
			
			// totalVector(colorImage, contactList, displacement, savePoint, changedPoint, dataTranfer);
			totalVector(colorImage, contactList, displacement, savePoint, changedPoint, dataTransfer_string);
			//userInput = std::to_string(dataTransfer);
			//userInput = dataTransfer_string;
			std::cout << "dataTransfer_string : " << dataTransfer_string << endl;
		
			////userInput = std::to_string(dataTranfer);
			////Send to server
			int sendRes = send(sock, userInput.c_str(), userInput.size()+1,0);
			if (sendRes == -1)
			{
				cout << "Can not send to the server";
				continue;
			}
			
			
			
			
			int bytesReceived = recv(sock, buf, 4096, 0);
			//float bufferRecieve = 0; 
			string bufferRecieve; 
			if (bytesReceived == -1)
			{
				continue;
			}
			else
			{
				//bufferRecieve = stof(string(buf, bytesReceived)) ;
				bufferRecieve = string(buf, bytesReceived);
				cout << "SERVER>" << string(buf, bytesReceived) << "\r\n" <<endl;
				robotInforData = robotInformation( bufferRecieve, robotID);
				std::cout<< "RobotData " << robotID -1<< ": " << robotInforData << endl;
				boxData = robotInformation(bufferRecieve, boxID);
				std::cout<< "BoxData: " << boxData << endl;
				prasingBox(boxData, dataXY);
				for (int i =0;i<8;i++)
				{
					std::cout << dataXY[i] << " " << endl;
				}
				memset(buf, 0,4096);
			}
					
			std::string str = "g,"+dataTransfer_string+",1" +","+std::string(argv[1])+ "," + std::string(argv[2])+ "," +std::string(argv[3])+","+robotInforData+"\n";
			//std::string str = dataTransfer_string;
			//writeData <<dataTransfer_string;
			//writeData << "\n";
			//writeData.flush();
			cout << str << endl;
			char buffer[5000];
			strcpy(buffer, str.c_str());
			serialPuts(fd,buffer);
			fflush(stdout);
			dataTransfer_string = "";
		}	
		dataTransfer_string = " ";		
		//imshow("color image", colorImage);
		//cv::waitKey(30);

		auto stop = high_resolution_clock::now();
		auto duration = duration_cast<std::chrono::microseconds>(stop - start);

		std::cout << " Time process: " << duration.count() * 0.000001 << " second" << endl;
		//std::cout << " output: " << savePoint << endl;
		//std::cout << "------------------------------------------------------------------------------" << endl;
		count++;
		if (count > samplingDataTimes) count = 200;
		//Sleep(10);
		
		
		
	}		
	return 0;
}

/*
	//Create a socket
	int sock = socket(AF_INET, SOCK_STREAM,0);
	if(sock == -1)
	{
		return 1;
	}
	
	//Create a hint structure for the server we connect
	int port = 5400;
	std::string ipAddress = "192.168.11.2";
	sockaddr_in hint;
	hint.sin_family = AF_INET;
	hint.sin_port =htons(port);
	inet_pton(AF_INET,"192.168.11.2", &hint.sin_addr);
	
	// Connect to the server on the socket
	int connectRes = connect(sock,(sockaddr*)&hint, sizeof(hint));
	if(connectRes == -1)
	{
		return -1;
	}
	
	char buf[4096];
	string userInput;
	do
	{
		//Get input
		//cout << " > " ;
		//getline(cin, userInput);
		userInput = "aaaaaaa";
		//Send to server
		int sendRes = send(sock, userInput.c_str(), userInput.size()+1,0);
		if (sendRes == -1)
		{
			cout << "Can not send to the server";
			continue;
		}
		int bytesReceived = recv(sock, buf, 4096, 0);
		cout << "SERVER>" << string(buf, bytesReceived) << "\r\n" <<endl;
		memset(buf, 0,4096);


		
	}while(true);
	*/
