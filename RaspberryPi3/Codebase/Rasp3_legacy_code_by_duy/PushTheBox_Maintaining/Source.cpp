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
// Variable for control program

double PID_p = 0, PID_i = 0, PID_d = 0;
double PID_value ;
double PID_error=0;
float elapsedTime =0.05;
float rotation_gain=5;
float vx; float vy;
double angle; double theta; double theta_back; double omega; double norm_v =0; float kp,ki,kd; double PID_x_value,PID_y_value, previousPID_error,previousPID_error2,PID_errorTotal2,Rotation_robot, PID_errorTotal,wL,wR;
				double d_change = 0.05;
int flag_once=0;
				double x_robot, y_robot, z_robot, rotation;

//
//
/////////////////////////////////////////////////////////////////////

float dataTranfer= -500;
string dataTransfer_string;
float BoxDataXY[8];
float RobotDataXYZ[4];


// define struct

typedef struct {
	double x;
	double y;
} Point;

typedef struct {
	Point* vertices;
	int numVertices;
} Polygon;

double distance(Point p1, Point p2) {
	double dx = p2.x - p1.x;
	double dy = p2.y - p1.y;
	return sqrt(dx * dx + dy * dy);
}

void pointLineDistance(Point point, Point lineStart, Point lineEnd, Point* closestPoint, double* minDistance) {
	double lineLength = distance(lineStart, lineEnd);
	double u = ((point.x - lineStart.x) * (lineEnd.x - lineStart.x) + (point.y - lineStart.y) * (lineEnd.y - lineStart.y)) / (lineLength * lineLength);
	if (u < 0) {
		*minDistance = distance(point, lineStart);
		*closestPoint = lineStart;
	}
	else if (u > 1) {
		*minDistance = distance(point, lineEnd);
		*closestPoint = lineEnd;
	}
	else {
		*closestPoint = {
			lineStart.x + u * (lineEnd.x - lineStart.x),
			lineStart.y + u * (lineEnd.y - lineStart.y)
		};
		*minDistance = distance(point, *closestPoint);
	}
}

void findClosestPoint(Polygon polygon, Point point, Point* closestPoint, double* minDistance, int* j) {
	*minDistance = INFINITY;

	Point points[4];
	for (int i = 0; i < polygon.numVertices; i++) {

		Point vertex1 = polygon.vertices[i];
		Point vertex2 = polygon.vertices[(i + 1) % polygon.numVertices];
		double distance_each;
		pointLineDistance(point, vertex1, vertex2, &points[i], &distance_each);
		if (distance_each < *minDistance) {
			*minDistance = distance_each;
			*j = i;
		}
	}
	printf("The closest point (%f,%f)", points[*j].x, points[*j].y);
	Point vertex1 = polygon.vertices[*j];
	Point vertex2 = polygon.vertices[(*j + 1) % polygon.numVertices];
	//double lineLength = distance(vertex1, vertex2);
	//double u = ((point.x - vertex1.x) * (vertex2.x - vertex1.x) + (point.y - vertex1.y) * (vertex2.y - vertex1.y)) / (lineLength * lineLength);
	//closestPoint->x = vertex1.x + u * (vertex2.x - vertex1.x);
	//closestPoint->y = vertex1.y + u * (vertex2.y - vertex1.y);
	closestPoint->x = points[*j].x;
	closestPoint->y = points[*j].y;
}



int main(int argc, char *argv[])
{
	std::cout<<"Printed" <<std::endl;
	kp = std::atof(std::string(argv[1]).c_str());
	ki = std::atof(std::string(argv[2]).c_str());
	kd = std::atof(std::string(argv[3]).c_str());
	std::cout << "P parameter: " << kp << endl;
	std::cout << "I parameter: " << ki<< endl;
	std::cout << "D parameter: " << kd << endl;
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
			int sendRes = send(sock, userInput.c_str(), userInput.size() + 1, 0);
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
				cout << "SERVER>" << string(buf, bytesReceived) << "\r\n" << endl;
				robotInforData = robotInformation(bufferRecieve, robotID);
				std::cout << "RobotData " << robotID - 1 << ": " << robotInforData << endl;
				prasingRobotLocation(robotInforData, RobotDataXYZ);
				for (int i = 0; i < 4; i++)
				{
					std::cout << RobotDataXYZ[i] << " " << endl;
				}

				boxData = robotInformation(bufferRecieve, boxID);
				std::cout << "BoxData: " << boxData << endl;
				prasingBox(boxData, BoxDataXY);
				for (int i = 0; i < 8; i++)
				{
					std::cout << BoxDataXY[i] << " " << endl;
				}
				memset(buf, 0, 4096);
			}
			//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
				//control program
				//control robot to desired position!!!


			if (!isnan(RobotDataXYZ[0])) {

				vx = (RobotDataXYZ[0] - x_robot) / elapsedTime;
				vy = (RobotDataXYZ[1] - y_robot) / elapsedTime;
				x_robot = RobotDataXYZ[0];
				y_robot = RobotDataXYZ[1];
				z_robot = RobotDataXYZ[2];
				rotation = RobotDataXYZ[3] * 3.14 / 180;
			}
			Point vertices[] = { {BoxDataXY[0], BoxDataXY[1]}, {BoxDataXY[2], BoxDataXY[3]}, {BoxDataXY[4], BoxDataXY[5]}, {BoxDataXY[6], BoxDataXY[7]} };  // Vi tri thung
			Polygon polygon = { vertices, 4 };

			Point point = { x_robot, y_robot };// Robot i position
			Point closestPoint;
			double minDistance;
			int j;
			findClosestPoint(polygon, point, &closestPoint, &minDistance, &j);
			// print the closest point and minimum distance
			printf("The closest point on the polygon to the point (%f, %f) is (%f, %f), with a distance of %f\n",
				point.x, point.y, closestPoint.x, closestPoint.y, minDistance);
			double pp_ori_x, pp_ori_y, tangent_x, tangent_y, normal_x, normal_y, angle_normal, dsr_pos_x, dsr_pos_y;

			pp_ori_x = closestPoint.x;
			pp_ori_y = closestPoint.y;

			tangent_x = pp_ori_x - polygon.vertices[j].x;
			tangent_y = pp_ori_y - polygon.vertices[j].y;
			normal_x = -tangent_y;
			normal_y = tangent_x;

			if (((closestPoint.x - x_robot) * normal_x + (closestPoint.y - y_robot) * normal_y) > 0)
			{
				normal_x = tangent_y;
				normal_y = -tangent_x;
			}
			angle_normal = atan2(normal_y, normal_x);

			//d_change(id): determine by lyapunov policy ~0.06
			dsr_pos_x = pp_ori_x + d_change * cos(angle_normal);
			dsr_pos_y = pp_ori_y + d_change * sin(angle_normal);
			printf("The desired point (%f, %f)\n", dsr_pos_x, dsr_pos_y);
			if (isnan(dsr_pos_x))
			{
				dsr_pos_x = x_robot;
			}
			if (isnan(dsr_pos_y))
			{
				dsr_pos_y = y_robot;
			}
			//----------------------------------- PID position
			PID_error = dsr_pos_x - x_robot;
			PID_errorTotal += PID_error;
			if (PID_errorTotal <= -400) PID_errorTotal = -400;
			if (PID_errorTotal >= 400) PID_errorTotal = 400;
			PID_p = kp * PID_error;
			PID_d = kd * ((PID_error - previousPID_error) / elapsedTime);
			PID_i = ki * PID_errorTotal * elapsedTime;
			previousPID_error = PID_error;
			//previousTime = currentTime;
			PID_x_value = PID_p + PID_i + PID_d;


			// calculate vy
			PID_error = dsr_pos_y - y_robot;

			PID_errorTotal2 += PID_error;
			if (PID_errorTotal2 <= -400) PID_errorTotal2 = -400;
			if (PID_errorTotal2 >= 400) PID_errorTotal2 = 400;
			PID_p = kp * PID_error;
			PID_d = kd * ((PID_error - previousPID_error2) / elapsedTime);
			PID_i = ki * PID_errorTotal2 * elapsedTime;
			previousPID_error2 = PID_error;
			//previousTime = currentTime;
			PID_y_value = PID_p + PID_i + PID_d;

			printf("-- PID_x,PiD_error x, x robot, PID_y: %f,%f,%f,%f:", PID_x_value, PID_error, x_robot, PID_y_value);
			// chuyen sang wL,wR
			//rw=0.02 
			norm_v = sqrt(PID_x_value * PID_x_value + PID_y_value * PID_y_value);
			if (isnan(norm_v))
			{
				norm_v = 0;
			}

			if (norm_v > 0)
				angle = atan2(PID_y_value, PID_x_value);
			else
				angle = rotation;
			theta = angle - rotation;

			while (theta > 3.14)
				theta = theta - 2 * 3.14;
			while (theta < -3.14)
				theta = theta + 2 * 3.14;
			printf("normv, angle, theta, rotation, %f,%f,%f\n ", norm_v, angle, theta, rotation);
			if (abs(theta) > 0.6 * 3.14)
			{
				theta_back = theta + 3.14;
				while (theta_back > 3.14) theta_back -= 2 * 3.14;
				while (theta_back < -3.14) theta_back += 2 * 3.14;
				// if (abs(theta_back)>3.14/3)   theta_back=(theta_back/abs(theta_back))*3.14/3;
				if (abs(theta_back) < (8 * 3.14 / 180))  omega = 0;  // Allowable angle error = 10 deg
				else omega = theta_back / elapsedTime; // van toc goc
				wL = -(norm_v + omega * 0.1 * rotation_gain / 2.0) / 0.02;
				wR = -(norm_v - omega * 0.1 * rotation_gain / 2.0) / 0.02;
			}
			else
			{
				// if (abs(theta)>3.14/4)   theta=(theta/abs(theta))*3.14/4;
				if (abs(theta) < (8 * 3.14 / 180))  omega = 0;  // Allowable angle error = 10 deg
				else omega = theta / elapsedTime; // van toc goc

				wL = (norm_v - omega * 0.1 * rotation_gain / 2.0) / 0.02;
				wR = (norm_v + omega * 0.1 * rotation_gain / 2.0) / 0.02;
			}
			printf("Data:");
			cout << dataTransfer_string.length();
			cout<<dataTransfer_string;
			if (dataTransfer_string.length()>1)
			{
				float force = std::stof(dataTransfer_string);
				printf("The applied force %f", force);
			}


//----------------------------------------------------------------------------------------------------------------------------------------------------------		
			std::string str = "g,"+to_string(wL)+"," + to_string(wR) +"\n";
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
