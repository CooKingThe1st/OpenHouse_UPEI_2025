/*
* Stable version 4.0
* Date : 10/02/2022
* Run on Rasberry
* Detect multi contact point
* Show the magnetude of force
* Connect and control motor
* Run on raspberry pi 4
*/
#include "library.h"

#include <thread>

// #include "Serialport.h"

//std::mutex mu;
float dataTranfer= -500;
string dataTransfer_string;

int main()
{
	
	//OpenSerial
	int fd;
	
	if((fd = serialOpen("/dev/serial0",115200)) < 0)
	{
		fprintf(stderr, "Unable to open serial device: %s\n", strerror(errno));
		return 1;
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

	char count = 0;
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


	while (true)
	{
		//mu.lock();
		vector<cv::Point3f> changedPoint;
		vector<cv::Point2f> displacement;
		vector<int> contactList;
		vector<float> forceList;

		auto start = high_resolution_clock::now();

		camera1 >> cam_img1;

		//sizeImage(cam_img1, "camera 1");
		//framePerSecond(camera1, "camera 1");

		cam_img1 = cam_img1(cv::Rect(80, 0, 490, 480));
		colorImage = cam_img1.clone();

		//fillImage(cam_img1, static_cast<float>(cam_img1.cols), static_cast<float>(cam_img1.rows));
        
		denoiseImage(cam_img1, static_cast<int>(cam_img1.cols), static_cast<int>(cam_img1.rows));
		//// bitwise_not(cam_img1, invertImg);
		//imshow("filled", cam_img1);
		if (count < samplingDataTimes)
		{
			locateMarker(cam_img1, colorImage, savePoint);
			//std::cout << "Save data done" << endl;
			
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
					
			//std::string str = "s," +to_string((float)bufferRecieve)+ ",1"+"\n";
			std::string str = bufferRecieve;
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
			userInput = dataTransfer_string;
			std::cout << "userInput: " << userInput << endl;



			
	
			
			//userInput = std::to_string(dataTranfer);
			//Send to server
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
				memset(buf, 0,4096);
			}
					
			//std::string str = "g,"+to_string(bufferRecieve)+",1" + "\n";
			std::string str = bufferRecieve;
			cout << str << endl;
			char buffer[50];
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

		//std::cout << " Time process: " << duration.count() * 0.000001 << " second" << endl;
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
