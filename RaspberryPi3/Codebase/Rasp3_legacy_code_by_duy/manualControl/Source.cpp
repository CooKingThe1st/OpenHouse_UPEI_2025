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

#include <fstream>
#include <chrono>
#include <ctime>
#include <sstream>
#include <iomanip>
/////////////////////////////////////////////////////////////////////
//
//Change here for new robot- the 1st robot will be numbered at 1
//
//The box will be numbered at 1 , robot will be numbered 2
//
int boxID = 1;
int robotID = 5; /// not use this anymore
// Variable for control program

double PID_p = 0, PID_i = 0, PID_d = 0;
double PID_value;
double PID_error = 0;
float elapsedTime = 0.05;

float vx; float vy;

int mode = 3; // mode =1: bam  theo hop  // mode = 0: behavior bassed
double angle; double theta; double theta_back; double omega; double norm_v = 0; float kp, ki, kd; double PID_x_value, PID_y_value, previousPID_error, previousPID_error2, PID_errorTotal2, Rotation_robot, PID_errorTotal;
int wL, wR;
string activationKey ="";
int flag_manual=0;
int pre_flag_manual = 0;
int flag_sent =0;
int speed = 100;
double prev_wL = 0; double prev_wR = 0;
double alpha_goal = 0;
double avoid_x = 0;
double avoid_y = 0;
double d_change = 0.01;
int avoid_count = 0;
int avoi_flag = 0;
int rb_state = 0; // 0: normal, 1: only tranlation, 2: only rotation 
int up_touch = 0;
double max_vel = 60;
double rot_fric = 120;
double mag_goal = max_vel / 50;
double mag_avoid = 2.5;
double Zumo_sat = 13;
float rotation_gain = 3;
int force_count = 0;
double sum_in_ang = 0;

int count_stable_angle = 0;

float outAngle[24];
float outForce[24];
int numContact = 0;
double contact_angle_RB_frame = 0;
double tmp_dsr_angle = 0;
double thr_goal = 15;
int contact_cond = 0;


int flag_once = 0;
int jo;
double u_coe;

double x_robot, y_robot, z_robot, rotation;

//
//
/////////////////////////////////////////////////////////////////////

float dataTranfer = -500;
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

void pointLineDistance(Point point, Point lineStart, Point lineEnd, Point* closestPoint, double* minDistance, double* u_co) {
	double lineLength = distance(lineStart, lineEnd);
	double u = ((point.x - lineStart.x) * (lineEnd.x - lineStart.x) + (point.y - lineStart.y) * (lineEnd.y - lineStart.y)) / (lineLength * lineLength);
	if (u < 0) {
		*minDistance = distance(point, lineStart);
		*closestPoint = lineStart;
		*u_co = 0;

	}
	else if (u > 1) {
		*minDistance = distance(point, lineEnd);
		*closestPoint = lineEnd;
		*u_co = 1;

	}
	else {
		*closestPoint = {
			lineStart.x + u * (lineEnd.x - lineStart.x),
			lineStart.y + u * (lineEnd.y - lineStart.y)
		};
		*minDistance = distance(point, *closestPoint);
		*u_co = u;

	}
}

void findClosestPoint(Polygon polygon, Point point, Point* closestPoint, double* minDistance, int* j, double* u_co) {
	*minDistance = INFINITY;

	Point points[4];
	for (int i = 0; i < polygon.numVertices; i++) {

		Point vertex1 = polygon.vertices[i];
		Point vertex2 = polygon.vertices[(i + 1) % polygon.numVertices];
		double distance_each;
		double u_co_tmp;
		pointLineDistance(point, vertex1, vertex2, &points[i], &distance_each, &u_co_tmp);

		if (distance_each < *minDistance) {
			*minDistance = distance_each;
			*j = i;
			*u_co = u_co_tmp;
		}
	}
	printf("The closest point (%f,%f)", points[*j].x, points[*j].y);
	//Point vertex1 = polygon.vertices[*j];
	//Point vertex2 = polygon.vertices[(*j + 1) % polygon.numVertices];
	//double lineLength = distance(vertex1, vertex2);
	//double u = ((point.x - vertex1.x) * (vertex2.x - vertex1.x) + (point.y - vertex1.y) * (vertex2.y - vertex1.y)) / (lineLength * lineLength);
	//closestPoint->x = vertex1.x + u * (vertex2.x - vertex1.x);
	//closestPoint->y = vertex1.y + u * (vertex2.y - vertex1.y);
	closestPoint->x = points[*j].x;
	closestPoint->y = points[*j].y;
}

double wrapAngle(double angle_wrap) {
	while (angle_wrap > 3.14)
		angle_wrap = angle_wrap - 2 * 3.14;
	while (angle_wrap < -3.14)
		angle_wrap = angle_wrap + 2 * 3.14;
	return angle_wrap;
}
// if wL
double AddBase(double w_,double base) {
	if (w_ > 0) return w_ + base;
	else  return w_ - base;
}
double Saturation(double value, double min, double max) {
	if (value > 0)
	{
		if (value > max)
			value = max;
		if (value < min)
			value = min;
	};

	if (value < 0)
	{
		if (value < -1 * max)
			value = -1 * max;
		if (value > -1 * min)
			value = -1 * min;
	};


	return value;
}




void calculateWheelVelocities(double theta_, double norm_vv, double elapsedTime, double rotation_gain, double& wL_, double& wR_) {
	theta_ = wrapAngle(theta_);
	double rot = omega * 0.1 * rotation_gain / 2.0;
	if (abs(theta_) > 0.55 * 3.14) // đi lùi
	{
		theta_back = wrapAngle(theta_ + 3.14);
		// if (abs(theta_back)>3.14/3)   theta_back=(theta_back/abs(theta_back))*3.14/3;
		if (abs(theta_back) < (8 * 3.14 / 180))  omega = 0;  // Allowable angle error = 10 deg
		else omega = theta_back / elapsedTime; // van toc goc
		rot = Saturation(rot, 0.5, 3);
		norm_vv = Saturation(norm_vv, 0.8, 4);

		wL_ = (double)(-(norm_vv + rot) / 0.02);
		wR_ = (double)(-(norm_vv - rot) / 0.02);
	}
	else
	{
		// if (abs(theta)>3.14/4)   theta=(theta/abs(theta))*3.14/4;
		if (abs(theta_) < (8 * 3.14 / 180))  omega = 0;  // Allowable angle error = 10 deg
		else if (theta_ > 0)
			omega = theta_ / elapsedTime; // van toc goc
		else if (theta_ < 0)
			omega = theta_ / elapsedTime;

		rot = Saturation(rot, 0.5, 3);
		norm_vv = Saturation(norm_vv, 0.8, 4);

		wL_ = (double)((norm_vv - rot) / 0.02);
		wR_ = (double)((norm_vv + rot) / 0.02);
	}
}



double Zumo_saturation(double old_wL, double tmp, double wL_) {
	if (wL_ - old_wL > tmp) return (old_wL + tmp);
	else if (wL_ - old_wL < -tmp) return (wL_ = old_wL - tmp);
	else return wL_;
}



void writeSth(std::ofstream& writeFile, float _outAngle[24], float _outForce[24], int numContact, double xrobot, double yrobot)
{
	using namespace std::chrono;
	using namespace std;
	auto now = std::chrono::system_clock::now();
	auto ms = std::chrono::duration_cast<milliseconds>(now.time_since_epoch()) % 1000;
	auto timer = system_clock::to_time_t(now);
	std::tm bt = *std::localtime(&timer);

	std::ostringstream oss;
	oss << std::put_time(&bt, "%H:%M:%S"); // HH:MM:SS
	oss << '.' << std::setfill('0') << std::setw(3) << ms.count();
	std::cout << "Time" << " " + oss.str() << std::endl;

	for (int i = 0; i < numContact; i++)
	{
		writeFile << oss.str() << ","
			<< to_string(_outAngle[i]) << ","
			<< to_string(_outForce[i]) << ","
			<< to_string(numContact) << ","
			<< to_string(xrobot) << ","
			<< to_string(yrobot) << ","
			<< "\n";
	}
	writeFile.flush();
}

int main(int argc, char* argv[])
{
	std::cout << "Printed" << std::endl;
	kp = std::atof(std::string(argv[1]).c_str());
	ki = std::atof(std::string(argv[2]).c_str());
	kd = std::atof(std::string(argv[3]).c_str());
	robotID = kd;
	std::cout << "P parameter: " << kp << endl;
	std::cout << "I parameter: " << ki << endl;
	std::cout << "D parameter: " << kd << endl;
	std::cout << "Motor command: " << std::string(argv[4]) << endl;


	//OpenSerial
	int fd;

	//Turn off motor function
	if ((fd = serialOpen("/dev/serial0", 115200)) < 0)
	{
		fprintf(stderr, "Unable to open serial device: %s\n", strerror(errno));
		return 1;
	}

	if (string(argv[4]) == "-r")
	{
		std::cout << "Run motors " << endl;

	}
	else if (string(argv[4]) == "-m") // Manual mode
	{
		std::cout << "Manual mode " << endl;
		std::string string_stop = "g," + to_string(kp) + "," + to_string(ki) + "\n";
		cout << string_stop << endl;
		char bufferStop[5000];
		strcpy(bufferStop, string_stop.c_str());
		serialPuts(fd, bufferStop);
		fflush(stdout);
		return 6;

	}

	else if (string(argv[4]) == "-s")
	{
		std::cout << "Stop motors" << endl;
		std::string string_stop = "s," + to_string(0) + "," + to_string(0) + "," + to_string(0) + "," + to_string(0) + "," + to_string(0) + "\n";
		//std::string str = dataTransfer_string;
		char bufferStop[5000];
		strcpy(bufferStop, string_stop.c_str());
		serialPuts(fd, bufferStop);
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
	int sock = socket(AF_INET, SOCK_STREAM, 0);
	if (sock == -1)
	{
		return 1;
	}

	struct timeval timeout;
	timeout.tv_sec = 0;
	timeout.tv_usec = 1000;
	setsockopt(sock, SOL_SOCKET, SO_RCVTIMEO, &timeout, sizeof(timeout));

	//Create a hint structure for the server we connect
	int port = 5400;
	std::string ipAddress = "192.168.0.101";
	sockaddr_in hint;
	hint.sin_family = AF_INET;
	hint.sin_port = htons(port);
	inet_pton(AF_INET, "192.168.0.101", &hint.sin_addr);

	// Connect to the server on the socket
	int connectRes = connect(sock, (sockaddr*)&hint, sizeof(hint));
	if (connectRes == -1)
	{
		return -1;
	}

		std::ofstream writeData;
	//writeData.open("data.csv");	
	
	std::cout << "Time" << std::endl;
	string nameDataFile = "contactdata_"+to_string(kd) +".csv";
	writeData.open(nameDataFile);
	/*
	writeData << "Middle" << "," << "Second" << "," << "Distance Middle" << ","
			  << "Distance second point" << "," << "Time" << ","<< "contactAngle"<< ","
			  << "Deflection" << "," << "Force" << ","<<"\n";
	*/

	writeData << "Time" << "," << "Contact Angle" << "," << "Contact Force" << "," << "Number Contact" << "\n";
	writeData.flush();


	char buf[4096];
	string userInput;
	string robotInforData;
	string boxData;
	while (true)
	{
		//////// Define outArray

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


		if (count < samplingDataTimes)
		{
			locateMarker(cam_img1, colorImage, savePoint);
			std::cout << "Save data done" << endl;

			int sendRes = send(sock, "Initial the heading", 20, 0);
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
				cout << "SERVER>" << bufferRecieve << "\r\n" << endl;


				memset(buf, 0, 4096);
			}

			std::string str = "s,0,0,0,0,0,0,\n";
			//std::string str = bufferRecieve;
			//std::string str = "s," +to_string((float)bufferRecieve)+ ",1"+"\n";
			//std::string str = bufferRecieve;
			cout << str << endl;
			char buffer[50];
			strcpy(buffer, str.c_str());
			serialPuts(fd, buffer);
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
			numContact = 0;
			totalVector(colorImage, contactList, displacement, savePoint, changedPoint, outAngle, outForce, numContact);
			/*if ((numContact > 0) && (outForce[0] < 0.5))
			{
				numContact = 0;
			}*/


			//Test
			std::cout << "numContact: " << numContact << endl;
			for (int i = 0; i < numContact; i++)
			{
				std::cout << outAngle[i] << " --- " << outForce[i] << endl;
			}
			writeSth(writeData, outAngle, outForce, numContact,x_robot,y_robot);
			//
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
				bufferRecieve = string(buf, bytesReceived);
				cout << "Byte num " << bufferRecieve << endl;
				cout << "SERVER>" << string(buf, bytesReceived) << "\r\n" << endl;
				
				
				if (buf[0] == 'q')  flag_manual=1;
				else if ( buf[0] == 'w')  flag_manual =2;
				else if ( buf[0] == 'e')  flag_manual =3;
				else if ( buf[0] == 'a')  flag_manual =4;
				else if ( buf[0] == 's')  flag_manual =5;
				else if ( buf[0] == 'd')  flag_manual =6;
				else if ( buf[0] == 'z')  flag_manual =7;
				else if ( buf[0] == 'x')  flag_manual =8;
				else if ( buf[0] == 'c')  flag_manual =9;	
				else if ( buf[0] == 'r')  flag_manual =10;
				else if ( buf[0] == 't')  flag_manual =11;
				
				
				if (flag_manual == 1)
				{					
					wL = speed/2;
					wR = speed;
					activationKey="g";
					std::cout << " Run - forward left" <<endl;		
					pre_flag_manual = 1;				
				}
				else if (flag_manual == 2)
				{
					wL = speed;
					wR = speed;
					activationKey="g";
					std::cout << " Run - forward" <<endl;	
					pre_flag_manual =2;			
				}
				else if (flag_manual == 3)
				{
					
					wL = speed;
					wR = speed/2;
					activationKey="g";
					std::cout << " Run - forward right" <<endl;
					pre_flag_manual =3;	
				}
				else if (flag_manual == 4)
				{	
					wL = -speed;
					wR = speed;
					activationKey="g";
					std::cout << " Run - Turn left" <<endl;
					pre_flag_manual =4;	
				}
				else if (flag_manual == 5)
				{	
					wL = speed-speed;
					wR = speed - speed;
					activationKey="s";
					std::cout << " Stop" <<endl;
					pre_flag_manual =5;	
				}
				else if (flag_manual == 6)
				{	
					wL = speed;
					wR = -speed;
					activationKey="g";
					std::cout << " Run - Turn left" <<endl;
					pre_flag_manual =6;	
				}
				else if (flag_manual == 7)
				{	
					wL = -speed/2;
					wR = -speed;
					activationKey="g";
					std::cout << " Run - Backward left" <<endl;
					pre_flag_manual =7;	
				}
				else if (flag_manual == 8)
				{	
					wL = -speed;
					wR = -speed;
					activationKey="g";
					std::cout << " Run - Backward" <<endl;
					pre_flag_manual =8;	
				}
				else if (flag_manual == 9)
				{	
					wL = -speed;
					wR = -speed/2;
					activationKey="g";
					std::cout << " Run - Backward right" <<endl;
					pre_flag_manual =9;	
				}
				
				if (flag_manual == 10)
				{	
					speed = speed +10;
					
					std::cout << "Speed up:  "<< speed <<endl;
					flag_manual = pre_flag_manual;
					
				}
				else if(flag_manual == 11)
				{	
					speed = speed -10;
					
					std::cout << "Speed down:  "<< speed <<endl;
					flag_manual = pre_flag_manual;
				}
				
				std::string str = activationKey+"," + to_string(wL) + "," + to_string(wR) + "\n";
				//std::string str = "g," + to_string(100) + "," + to_string(100) + "\n";

				std::cout << "Flag_manual: " << flag_manual << endl;
				std::cout << "Command: " << str << endl;
				char buffer[5000];
				strcpy(buffer, str.c_str());
				serialPuts(fd, buffer);
				fflush(stdout);
				dataTransfer_string = "";
				memset(buf, 0, 4096);
				
			}

			//----------------------------------------------------------------------------------------------------------------------------------------------------------		
			
		}
		dataTransfer_string = " ";
		// ------ Test Cam
		//imshow("filled", cam_img1);
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
