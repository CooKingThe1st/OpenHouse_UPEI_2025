/*
* Stable version 3.0
* Date : 25/9/2021
* Run on Rasberry
* Detect multi contact point
* Show the magnetude of force
* Connect and control motor
*/
#include "library.h"

//#include <thread>

// #include "Serialport.h"

//std::mutex mu;
float dataTranfer;


int main()
{
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
	char samplingDataTimes = 100;
	float saveBoundary = 0;
	std::ofstream writeData;
	writeData.open("data.csv");
	/*
	writeData << "Middle" << "," << "Second" << "," << "Distance Middle" << ","
			  << "Distance second point" << "," << "Time" << ","<< "contactAngle"<< "," 
			  << "Deflection" << "," << "Force" << ","<<"\n";
	*/
	
	writeData << "Middle" << "," << "Second" << "," << "Distance Middle" << ","
			  << "Distance 2ndPoint" << "," << "Time" << ","<< "contactAngle"<< "," << "Deflection" << "," << "Force" <<"\n";

	
	writeData.flush();
	while (true)
	{
		//mu.lock();
		vector<cv::Point3f> changedPoint;
		vector<cv::Point2f> displacement;
		vector<int> contactList;
		vector<float> forceList;

		auto start = high_resolution_clock::now();
      
		camera1 >> cam_img1;

		sizeImage(cam_img1, "camera 1");
		//framePerSecond(camera1, "camera 1");

		cam_img1 = cam_img1(cv::Rect(80, 0, 490, 480));
		colorImage = cam_img1.clone();

		//fillImage(cam_img1, static_cast<float>(cam_img1.cols), static_cast<float>(cam_img1.rows));
        
		denoiseImage(cam_img1, static_cast<int>(cam_img1.cols), static_cast<int>(cam_img1.rows));
						
		//// bitwise_not(cam_img1, invertImg);
		imshow("filled", cam_img1);
		if (count < samplingDataTimes)
		{
			locateMarker(cam_img1, colorImage, savePoint);
			std::cout << "Save data done" << endl;
		}
		else
		{
			locateMarker(cam_img1, colorImage, changedPoint);

			checkMarker(savePoint, changedPoint);

			displacementArray(savePoint, changedPoint, displacement, true, colorImage);

			findHighPoint(displacement, contactList);

			totalVector(colorImage, contactList, displacement, savePoint, changedPoint, dataTranfer,writeData);
			
			time_t now = time(0);
			char* dt = ctime(&now);
			std::cout << "Day time: " << dt << endl;
		}
		//mu.unlock();
		imshow("color image", colorImage);
		cv::waitKey(30);

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
vector<std::string> SelectComPort() //added function to find the present serial 
{
	wchar_t lpTargetPath[10000]; // buffer to store the path of the COMPORTS
	vector<std::string> portList;

	for (int i = 0; i < 255; i++) // checking ports from COM0 to COM255
	{
		wstring strComPort = L"COM" + to_wstring(i); // converting to COM0, COM1, COM2

		DWORD test = QueryDosDeviceW(strComPort.c_str(), lpTargetPath, 10000);

		// Test the return value and error if any
		if (test != 0) //QueryDosDevice returns zero if it didn't find an object
		{
			std::string pushString = std::string(strComPort.begin(), strComPort.end());
			portList.push_back(pushString);
		}

		if (::GetLastError() == 122L)
		{
		}
	}
	return portList;
}
void transferData()
{
	char output[MAX_DATA_LENGTH];
	//char port[10] = "COM3";
	char incoming[MAX_DATA_LENGTH];


	cout << "hello";
	vector<std::string> ComPort;
	ComPort = SelectComPort();

	char port1[10];
	strcpy_s(port1, ComPort[0].c_str());
	//port = ComPort[0];
	//std::cout << port1;
	//char port1[] = "COM8";


	SerialPort arduino(port1);
	if (arduino.isConnected())
	{
		std::cout << "connection is established" << endl;
	}
	else
	{
		std::cout << "port name error";
		system("pause");
	}
	
	while (arduino.isConnected())
	{
		mu.lock();
		string input;
		//cin >> input;
		while (dataTranfer != NULL)
		{
			input = std::to_string(dataTranfer);
			std::string command;
			command = input + "a" + '\0';
			std::cout << "check input: " << command << '\n';
			char* charArray = new char[command.size() + 1];

			charArray[command.size()] = '\0';
			copy(command.begin(), command.end(), charArray);
			std::cout << "Size array : " << strlen(charArray) << endl;
			arduino.writeSerialPort(charArray, strlen(charArray));

			//arduino.readSerialPort(output, MAX_DATA_LENGTH);		
			//memset(output, 0, sizeof(output)); // clear data ouput
			//cout << "output: " << output << endl;
			delete[] charArray;
			dataTranfer = NULL;
			
			break;
		}
		
		mu.unlock();
		Sleep(100);
		//dataTranfer = NULL;
	}
	
}
*/

