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

double force_set = 0;
float vx; float vy;
int mode = 4; // mode =1: bam  theo hop  // mode = 0: behavior bassed, mode 3 is the final one in Viart paper // mode 4: force & contact control dựa vào góc va chạm  // mode5: Lyapunov thuần // mode 6: Lyapunove modified, robot DD thẳng đến goal //mode 7: robots bám đuôi// mode 8: thẳng, đụng và xoay
int choose_box = 1; // static 1, dynamic 2
double angle; double theta; double theta_back; double omega; double norm_v = 0; float kp, ki, kd; double PID_x_value, PID_y_value, previousPID_error, previousPID_error2, PID_errorTotal2, Rotation_robot, PID_errorTotal, wL, wR;
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
double Zumo_sat = 150; // default: 13 - 25
float rotation_gain = 3;
int force_count = 0;
double sum_in_ang = 0;
double final_angle = 0;
int count_stable_angle = 0;
double speed_base = 32;
double last_angle;

double mode_connection = 0; //false
float outAngle[24];
float outForce[24];
int numContact = 0;
int flag_contact=0;
double contact_angle_RB_frame = 0;
double tmp_dsr_angle = 0;
double thr_goal = 15;
int contact_cond = 0;


int flag_once = 0;
int jo;
double u_coe;
double pp_ori_x, pp_ori_y, tangent_x, tangent_y, normal_x, normal_y, angle_normal, dsr_pos_x, dsr_pos_y;

double x_robot, y_robot, z_robot, rotation;

//
//
/////////////////////////////////////////////////////////////////////

float dataTranfer = -500;
string dataTransfer_string;
float BoxDataXY[10];
float BoxDataXY2[10];
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

Point getPointOnLine(Point P1, Point P2, double R)
{
	// Calculate the distance between P1 and P2
	double distance = sqrt((P2.x - P1.x) * (P2.x - P1.x) + (P2.y - P1.y) * (P2.y - P1.y));

	// Calculate the coordinates of the point A
	double ratio = R / distance;
	double xA = P1.x + ratio * (P2.x - P1.x);
	double yA = P1.y + ratio * (P2.y - P1.y);

	Point A = { xA, yA };
	return A;
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



void writeSth(std::ofstream& writeFile, float _outAngle[24], float _outForce[24], int numContact, double xrobot, double yrobot,double angle_rbframe)
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
			<< to_string(angle_rbframe) << ","
			<< to_string(wL) << ","
			<< to_string(wR) << ","
			<< to_string(force_set) << ","
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
	int sock;
	if (mode_connection == 1)
	{

		//Create the socket
		sock = socket(AF_INET, SOCK_STREAM, 0);
		
		if (sock == -1)
		{
			std::cout << "Sever socket error 1";
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
			std::cout << "Sever socket error 2";
			//return -1;
		}

	}


		
	// expo 
	

		std::ofstream writeData;
	//writeData.open("data.csv");	
	
	std::cout << "Time" << std::endl;
	string nameDataFile = "contactdata_"+to_string((int)kd) +".csv";
	writeData.open(nameDataFile);

	writeData << "Time" << "," << "Contact Angle" << "," << "Contact Force" << "," << "Number Contact"<< "," << "x_robot" << "," << "y_robot" << "," << "RB_frame" <<","<<" wL" "," << "wR" <<  "\n";
	writeData.flush();


	char buf[4096];
	string userInput;
	string robotInforData;
	string boxData;
	string boxData2;

	string bufferRecieve;
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

			std::cout << "0: ---";

			if (mode_connection == 1)
			{
				int sendRes = send(sock, "Initial the heading", 20, 0);
				if (sendRes == -1)
				{
					cout << "Can not send to the server";
					continue;
				}


				int bytesReceived = recv(sock, buf, 4096, 0);
				
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
			std::cout << "1: ---";
			

		}
		else
		{
			std::cout << "2: ---";

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

			//
			//userInput = std::to_string(dataTransfer);
			//userInput = dataTransfer_string;
			std::cout << "dataTransfer_string : " << dataTransfer_string << endl;

			////userInput = std::to_string(dataTranfer);
			////Send to server
			

			if (mode_connection == 1)
			{
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

					if (!isnan(RobotDataXYZ[0])) {
						vx = (RobotDataXYZ[0] - x_robot) / elapsedTime;
						vy = (RobotDataXYZ[1] - y_robot) / elapsedTime;
						x_robot = RobotDataXYZ[0];
						y_robot = RobotDataXYZ[1];
						z_robot = RobotDataXYZ[2];
						rotation = RobotDataXYZ[3] * 3.14 / 180;
					}


					for (int i = 0; i < 4; i++)
					{
						std::cout << RobotDataXYZ[i] << " " << endl;
					}

					boxData = robotInformation(bufferRecieve, boxID);
					std::cout << "BoxData: " << boxData << endl;
					prasingBox(boxData, BoxDataXY);

					for (int i = 0; i < 10; i++)
					{
						std::cout << BoxDataXY[i] << " " << endl;
					}

					boxData2 = robotInformation(bufferRecieve, 7);
					std::cout << "BoxData2: " << boxData2 << endl;
					prasingBox(boxData2, BoxDataXY2);

					for (int i = 0; i < 10; i++)
					{
						std::cout << BoxDataXY2[i] << " " << endl;
					}

					memset(buf, 0, 4096);
				}


				//---------------------------------------Follow box------
				Polygon polygon;
				//Point vertices[] = { {BoxDataXY2[0], BoxDataXY2[1]}, {BoxDataXY2[8], BoxDataXY2[9]} ,{BoxDataXY2[4], BoxDataXY2[5]}, {BoxDataXY2[6], BoxDataXY2[7]} };  // Vi tri thung swap lai theo thu tu THUNG


				if (choose_box == 1)
				{
					Point vertices[] = { {BoxDataXY[0], BoxDataXY[1]}, {BoxDataXY[2], BoxDataXY[3]} ,{BoxDataXY[8], BoxDataXY[9]}, {BoxDataXY[6], BoxDataXY[7]} };  // Vi tri thung swap lai theo thu tu THUNG
					polygon = { vertices, 4 };
				}
				else if (choose_box == 2)
				{
					Point vertices[] = { {BoxDataXY2[0], BoxDataXY2[1]}, {BoxDataXY2[8], BoxDataXY2[9]} ,{BoxDataXY2[4], BoxDataXY2[5]}, {BoxDataXY2[6], BoxDataXY2[7]} };  // Vi tri thung swap lai theo thu tu THUNG
					polygon = { vertices, 4 };
				}

				Point point = { x_robot, y_robot };// Robot i position
				Point closestPoint;
				double minDistance;


				if (flag_once == 0)
				{
					findClosestPoint(polygon, point, &closestPoint, &minDistance, &jo, &u_coe);
					pp_ori_x = closestPoint.x;
					pp_ori_y = closestPoint.y;
					flag_once = 1;
				}
				else
				{
					Point vertex1 = polygon.vertices[jo];
					Point vertex2 = polygon.vertices[(jo + 1) % polygon.numVertices];

					pp_ori_x = vertex1.x + u_coe * (vertex2.x - vertex1.x);
					pp_ori_y = vertex1.y + u_coe * (vertex2.y - vertex1.y);


				}
				//printf("Toa do thung, 2 marker dau (%f,%f),(%f,%f),\n", polygon.vertices[0].x, polygon.vertices[0].y, polygon.vertices[1].x, polygon.vertices[1].y);

				tangent_x = pp_ori_x - polygon.vertices[jo].x;
				tangent_y = pp_ori_y - polygon.vertices[jo].y;
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
				// print the closest point and minimum distance
				printf("---------------------------------Robot Data------------------------------------------------");
				printf("The original point on the polygon (%f,%f), with j = %d, cou = %f\n", pp_ori_x, pp_ori_y, jo, u_coe);
				printf("Robot Position: (%f, %f) \n", point.x, point.y);
				printf("The desired point (%f, %f)\n", dsr_pos_x, dsr_pos_y);
				if (isnan(dsr_pos_x))
				{
					dsr_pos_x = x_robot;
				}
				if (isnan(dsr_pos_y))
				{
					dsr_pos_y = y_robot;
				}


			}
			
			
			
			//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
				//control program
				//control robot to desired position!!!

			// Behavior based control



			
			// Find desired vector

			if (mode == 1)   //----------------------------------- PID position---------------------------------------------------------------------------------------------------
			{
				if (numContact > 0)
				{
					double tmp_sin = 0; double tmp_cos = 0;
					for (int i = 0; i < numContact; i++)
					{
						tmp_sin = tmp_sin + sin(outAngle[i] * 3.14 / 180);
						tmp_cos = tmp_cos + cos(outAngle[i] * 3.14 / 180);
					}

					final_angle = atan2(tmp_sin, tmp_cos); // rad 



					if (robotID == 2)
						contact_angle_RB_frame = -final_angle + 3.14 / 2;
					else
						contact_angle_RB_frame = -final_angle + 3.14; // rad
					contact_angle_RB_frame = wrapAngle(contact_angle_RB_frame);

				}

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

				printf("PID_x, PID_y: (%f,%f)\n", PID_x_value, PID_y_value);
				// chuyen sang wL,wR-----------------------------------------------------------
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

				if (norm_v > 0)
					theta = angle - rotation;
				else
					theta = 0;

				calculateWheelVelocities(theta, norm_v, elapsedTime, rotation_gain, wL, wR);

				if (numContact > 0)
				{
					flag_contact = flag_contact + 1;
				}
				else
				{
					flag_contact = 0;
					PID_errorTotal2 = 0;
					PID_errorTotal = 0;
				}
				double offset__;
				if (choose_box ==1) offset__=60;
				if (choose_box == 2) offset__ = 90;

				if (flag_contact>2)
					
				{
					if (abs(contact_angle_RB_frame) < 3.14 / 2)
					{ 
					wL = wL + offset__;
					wR = wR + offset__;
					}
					else
					{
						wL = wL - offset__;
						wR = wR - offset__;
					}
				}
					


			}
			else if (mode == 0)  // Behavior based control----------------------------------------------------------
			{  // Calculate v_x, v_y -> sum lại
				// move to goal vector:
				// goc can di toi
				double v_net_x = 0;
				double v_net_y = 0;
				alpha_goal = atan2(dsr_pos_y - y_robot, dsr_pos_x - x_robot);

				
				if (numContact > 0)
				{
					double tmp_sin = 0; double tmp_cos = 0;
					for (int i = 0; i < numContact; i++)
					{
						tmp_sin = tmp_sin + sin(outAngle[i] * 3.14 / 180);
						tmp_cos = tmp_cos + cos(outAngle[i] * 3.14 / 180);
					}

					final_angle = atan2(tmp_sin, tmp_cos); // rad 



					if (robotID == 2)
						contact_angle_RB_frame = -final_angle + 3.14 / 2;
					else
						contact_angle_RB_frame = -final_angle + 3.14; // rad
					contact_angle_RB_frame = wrapAngle(contact_angle_RB_frame);

				}
				printf("Behavior control:\n");
				// Chon state truoc -- condition
				double angle_tmp = abs(wrapAngle(alpha_goal - (contact_angle_RB_frame + rotation)));
				printf("ROBOT STATE: %f\n", rb_state);
				std::cout << "ContactAngle_RBFrame: " << contact_angle_RB_frame * 180 / 3.14 << "deg, " << contact_angle_RB_frame << endl;
				std::cout << "ContactAngle_RBFrame: " << (-outAngle[0] + 180) << endl;
				std::cout << "ContactAngle_RBFrame: " << (-outAngle[1] + 180) << endl;
				// Define mode ----------
				switch (rb_state) {
				case 0: // normal state 
					if ((numContact > 0) && (angle_tmp < 110 * 3.14 / 180))
					{
						rb_state = 1;
						if (abs(contact_angle_RB_frame) < 3.14 / 2) up_touch = 1;
						else  up_touch = 0;
					}

					break;
				case 1: // lùi
					if (numContact > 0)

					{
						avoid_count = 0;
						if (abs(contact_angle_RB_frame) < 3.14 / 2) up_touch = 1;
						else  up_touch = 0;

					}
					if (avoid_count == 5)
					{
						rb_state = 2;
						tmp_dsr_angle = wrapAngle(contact_angle_RB_frame + rotation + 3.14 / 2); // xoay ve 1 ben LEFT
						avoid_count = 0;
					}
					break;
				case 2: // xoay tai cho
					if (numContact > 0)
					{
						rb_state = 1;

						if (abs(contact_angle_RB_frame) < 3.14 / 2.0) up_touch = 1;
						else  up_touch = 0;
					}
					printf("tmp_dsr_angle: %f\n", tmp_dsr_angle);
					if (abs(tmp_dsr_angle - rotation) < 10 * 3.14 / 180) rb_state = 3;
					break;
				case 3:// đi thẳng
					if (numContact > 0)
					{
						rb_state = 1;
						if (abs(contact_angle_RB_frame) < 3.14 / 2) up_touch = 1;
						else  up_touch = 0;
					}
					if (avoid_count == 25)
					{
						rb_state = 0;
						avoid_count = 0;
					}
					break;
				}
				// Behavior ----------
				printf("up_touch flagn: %d\n", up_touch);
				switch (rb_state) {
				case 0:
				{
					v_net_x = mag_goal * cos(alpha_goal) - avoid_x;
					v_net_y = mag_goal * sin(alpha_goal) - avoid_y;
					norm_v = sqrt(v_net_x * v_net_x + v_net_y * v_net_y);

					angle = atan2(v_net_y, v_net_x);

					if (norm_v > 0)
						theta = angle - rotation;
					else
						theta = 0;

					calculateWheelVelocities(theta, norm_v, elapsedTime, rotation_gain, wL, wR);

				}
				break;
				case 1: // Lùi có chiến thuật
					if (up_touch == 1)
					{
						/*	if (contact_angle_RB_frame > 0)
							{
								wL = -20;
								wR = -100;
							}
							if (contact_angle_RB_frame < 0)
							{
								wL = -100;
								wR = -20;
							}*/
						wL = -80;
						wR = -80;
					}
					else
					{

						wL = 80;
						wR = 80;
						/*	if (contact_angle_RB_frame > 0)
							{
								wL = 20;
								wR = 100;
							}
							if (contact_angle_RB_frame < 0)
							{
								wL = 100;
								wR = 20;
							}*/
					}


					avoid_count = avoid_count + 1;
					break;
				case 2:

					if (up_touch == 1)
					{
						double error_ang = wrapAngle(tmp_dsr_angle - rotation);
						wL = -150 * error_ang;
						wR = 150 * error_ang; // -80

					}
					else
					{
						double error_ang = wrapAngle(tmp_dsr_angle - rotation);
						wL = -150 * error_ang;
						wR = 150 * error_ang;
					}
					wL = Saturation(wL, rot_fric - 10, 140);
					wR = Saturation(wR, rot_fric - 10, 140);

					break;
				case 3:
					double run__ = 0;
					if (avoid_count < 35)
						run__ = avoid_count;
					else
						run__ = 40 - avoid_count;
					if (up_touch == 1)
					{
						wL = 40 + run__ * 2;
						wR = 40 + run__ * 2;
					}
					else
					{
						wL = 40 + run__ * 2;
						wR = 40 + run__ * 2;
					}
					avoid_count = avoid_count + 1;
					break;
				}
				printf("up_touch flagn: %d\n", up_touch);

				// Stop condition
				if ((x_robot - dsr_pos_x) * (x_robot - dsr_pos_x) + (y_robot - dsr_pos_y) * (y_robot - dsr_pos_y) < 0.04)
				{
					wL = 0;
					wR = 0;
				}

			}
			else if (mode == 2)  // Neww Behavior based control----------------------------------------------------------
			{  // Calculate v_x, v_y -> sum lại
				// move to goal vector:
				// goc can di toi
				double v_net_x = 0;
				double v_net_y = 0;
				alpha_goal = atan2(dsr_pos_y - y_robot, dsr_pos_x - x_robot);

				
				if (numContact > 0)
				{
					double tmp_sin = 0; double tmp_cos = 0;
					for (int i = 0; i < numContact; i++)
					{
						tmp_sin = tmp_sin + sin(outAngle[i] * 3.14 / 180);
						tmp_cos = tmp_cos + cos(outAngle[i] * 3.14 / 180);
					}

					final_angle = atan2(tmp_sin, tmp_cos); // rad 



					if (robotID == 2)
						contact_angle_RB_frame = -final_angle + 3.14 / 2;
					else
						contact_angle_RB_frame = -final_angle + 3.14; // rad
					contact_angle_RB_frame = wrapAngle(contact_angle_RB_frame);

				}
				printf("Behavior control:\n");
				// Chon state truoc -- condition
				double angle_tmp = abs(wrapAngle(alpha_goal - (contact_angle_RB_frame + rotation)));
				printf("ROBOT STATE: %f\n", rb_state);
				std::cout << "ContactAngle_RBFrame: " << contact_angle_RB_frame * 180 / 3.14 << "deg, " << contact_angle_RB_frame << endl;
				std::cout << "ContactAngle_RBFrame: " << (-outAngle[0] + 180) << endl;
				std::cout << "ContactAngle_RBFrame: " << (-outAngle[1] + 180) << endl;
				switch (rb_state) {
				case 0: // normal state 
					if ((numContact > 0) && (angle_tmp < 110 * 3.14 / 180))
					{
						rb_state = 1;
						if (abs(contact_angle_RB_frame) < 3.14 / 2) up_touch = 1;
						else  up_touch = 0;
						tmp_dsr_angle = wrapAngle(contact_angle_RB_frame + rotation + 3.14 / 2 + 0.1); // xoay ve 1 ben LEFT
					}

					break;

				case 1: // xoay tai cho
					if (numContact > 0)
					{
						rb_state = 1;

						if (abs(contact_angle_RB_frame) < 3.14 / 2.0) up_touch = 1;
						else  up_touch = 0;
					}
					printf("tmp_dsr_angle: %f\n", tmp_dsr_angle);
					if ((abs(tmp_dsr_angle - rotation) < 10 * 3.14 / 180) || (abs(wrapAngle(tmp_dsr_angle - rotation - 3.14)) < 10 * 3.14 / 180))

						rb_state = 2;
					break;
				case 2:// đi thẳng
					if (numContact > 0)
					{
						rb_state = 1;
						if (abs(contact_angle_RB_frame) < 3.14 / 2) up_touch = 1;
						else  up_touch = 0;
					}
					if (avoid_count == 25)
					{
						rb_state = 0;
						avoid_count = 0;
					}
					break;
				}


				// Behavior
				printf("up_touch flagn: %d\n", up_touch);
				switch (rb_state) {
				case 0:
				{
					v_net_x = mag_goal * cos(alpha_goal) - avoid_x;
					v_net_y = mag_goal * sin(alpha_goal) - avoid_y;
					norm_v = sqrt(v_net_x * v_net_x + v_net_y * v_net_y);

					angle = atan2(v_net_y, v_net_x);

					if (norm_v > 0)
						theta = angle - rotation;
					else
						theta = 0;

					calculateWheelVelocities(theta, norm_v, elapsedTime, rotation_gain, wL, wR);

				}
				break;

				case 1:

					if (up_touch == 1)
					{
						double error_ang = wrapAngle(tmp_dsr_angle - rotation);
						wL = -1;
						prev_wL = -1;
						wR = -170;
						prev_wR = -150;

					}
					else
					{
						double error_ang = wrapAngle(tmp_dsr_angle - rotation);
						wL = 170;
						prev_wL = 150;
						wR = 1;
						prev_wR = 1;
					}
					//wL = Saturation(wL, rot_fric, 170);
					//wR = Saturation(wR, rot_fric, 170);

					break;
				case 2:
					double run__ = 0;
					if (avoid_count < 35)
						run__ = avoid_count;
					else
						run__ = 40 - avoid_count;
					if (up_touch == 1)
					{
						wL = 40 + run__ * 2;
						wR = 40 + run__ * 2;
					}
					else
					{
						wL = 40 + run__ * 2;
						wR = 40 + run__ * 2;
					}
					avoid_count = avoid_count + 1;
					break;
				}
			}
			else if (mode == 3)  // NEWWWWW -------------------------------------------------- Behavior based control----------------------------------------------------------
			{  // Calculate v_x, v_y -> sum lại Condinail touch + PID angle
				// move to goal vector:
				// goc can di toi

				double v_net_x = 0;
				double v_net_y = 0;
				alpha_goal = atan2(dsr_pos_y - y_robot, dsr_pos_x - x_robot);

				// Check touch condition - Conditional touch
				if (numContact > 0)
				{
					force_count = force_count + 1;
					if ((vx * vx + vy * vy) > 0.05 * 0.05)
					{
						force_count = 0;
					}

					if (force_count == 8)
					{
						contact_cond = 1;
						force_count = 0;
					}
				}
				else contact_cond = 0;

				//---
				if (contact_cond > 0)
				{
					double tmp_sin = 0; double tmp_cos = 0;
					for (int i = 0; i < numContact; i++)
					{
						tmp_sin = tmp_sin + sin(outAngle[i] * 3.14 / 180);
						tmp_cos = tmp_cos + cos(outAngle[i] * 3.14 / 180);
					}

					final_angle = atan2(tmp_sin, tmp_cos); // rad 



					if (robotID == 2)
						contact_angle_RB_frame = -final_angle + 3.14 / 2;
					else
						contact_angle_RB_frame = -final_angle + 3.14; // rad
					contact_angle_RB_frame = wrapAngle(contact_angle_RB_frame);

				}
				printf("Behavior control:\n");
				// Chon state truoc -- condition
				double angle_tmp = abs(wrapAngle(alpha_goal - (contact_angle_RB_frame + rotation)));
				printf("ROBOT STATE: %f\n", rb_state);
				std::cout << "ContactAngle_RBFrame: " << contact_angle_RB_frame * 180 / 3.14 << "deg, " << contact_angle_RB_frame << endl;
				std::cout << "ContactAngle_RBFrame: " << (-outAngle[0] + 180) << endl;
				std::cout << "ContactAngle_RBFrame: " << (-outAngle[1] + 180) << endl;
				switch (rb_state) {
				case 0: // normal state 
					if ((contact_cond > 0) && (angle_tmp < 110 * 3.14 / 180))
					{
						rb_state = 1;
						if (abs(contact_angle_RB_frame) < 3.14 / 2) up_touch = 1;
						else  up_touch = 0;
					}

					break;
				case 1: // lùi
					if (contact_cond > 0)

					{
						avoid_count = 0;
						if (abs(contact_angle_RB_frame) < 3.14 / 2) up_touch = 1;
						else  up_touch = 0;

					}
					if (avoid_count == 5)
					{
						rb_state = 2;
						tmp_dsr_angle = wrapAngle(contact_angle_RB_frame + rotation + 3.14 / 2); // xoay ve 1 ben LEFT
						avoid_count = 0;
					}
					break;
				case 2: // xoay tai cho
					if (contact_cond > 0)
					{
						rb_state = 1;

						if (abs(contact_angle_RB_frame) < 3.14 / 2.0) up_touch = 1;
						else  up_touch = 0;
					}
					
					if (     (  abs(tmp_dsr_angle - rotation) < thr_goal * 3.14 / 180  ) || ( abs(wrapAngle(tmp_dsr_angle - rotation + 3.14)) < thr_goal * 3.14 / 180)      )
					{
						count_stable_angle = count_stable_angle + 1;
						if (count_stable_angle == 20)
						{
							rb_state = 3;
							sum_in_ang = 0;
							count_stable_angle = 0;
						}
					}
					else
					{
						count_stable_angle = 0;
					}
					//  

					break;
				case 3:// đi thẳng
					if (contact_cond > 0)
					{
						rb_state = 1;
						if (abs(contact_angle_RB_frame) < 3.14 / 2) up_touch = 1;
						else  up_touch = 0;
					}
					if (avoid_count == 40)
					{
						rb_state = 0;
						avoid_count = 0;
					}
					break;
				}


				// Behavior
				printf("up_touch flagn: %d\n", up_touch);
				switch (rb_state) {
				case 0:
				{
					v_net_x = mag_goal * cos(alpha_goal) - avoid_x;
					v_net_y = mag_goal * sin(alpha_goal) - avoid_y;
					norm_v = sqrt(v_net_x * v_net_x + v_net_y * v_net_y);

					angle = atan2(v_net_y, v_net_x);

					if (norm_v > 0)
						theta = angle - rotation;
					else
						theta = 0;

					calculateWheelVelocities(theta, norm_v, elapsedTime, rotation_gain, wL, wR);

				}
				break;
				case 1: // Lùi có chiến thuật
					if (up_touch == 1)
					{
						wL = -80;
						wR = -80;
					}
					else
					{

						wL = 80;
						wR = 80;
					}


					avoid_count = avoid_count + 1;
					break;
				case 2:
				{
					double tmp_PID;
					double error_ang;

					if (abs(wrapAngle(tmp_dsr_angle - rotation)) < abs(wrapAngle(tmp_dsr_angle - rotation + 3.14)))
						error_ang = wrapAngle(tmp_dsr_angle - rotation);
					else error_ang = wrapAngle(tmp_dsr_angle - rotation+3.14);

					tmp_PID = 10 * error_ang + 1* sum_in_ang; // Ki =1;

					if (up_touch == 1)
					{
						if (contact_angle_RB_frame > 0)
						{
							wL = -tmp_PID;
							wR = tmp_PID;
						}
						else
						{
							wL = -tmp_PID;
							wR = +tmp_PID; // -80
						}

					}
					else
					{
						if (contact_angle_RB_frame > 0)
						{
							wL = -tmp_PID;
							wR = tmp_PID;
						}
						else
						{
							wL = -tmp_PID;
							wR = +tmp_PID; // -80
						}
					}
					
					if ((abs(tmp_dsr_angle - rotation) < thr_goal * 3.14 / 180) || (abs(wrapAngle(tmp_dsr_angle - rotation + 3.14)) < thr_goal * 3.14 / 180))
					{
						wL = 0;
						wR = 0;
					}
					else {
					wL = AddBase(wL, 115);
					wR = AddBase(wR, 115);
					wL = Saturation(wL, 110, 140);
					wR = Saturation(wR, 110, 140);
					sum_in_ang += error_ang*elapsedTime;
					}
					break;
				}
				case 3:
				{double run__ = 0;
				if (avoid_count < 20)
					run__ = avoid_count;
				else
					run__ = 40 - avoid_count;

				if (abs(wrapAngle(tmp_dsr_angle - rotation)) < 3.14 / 2)
				{
					wL = 40 + run__ * 2;
					wR = 40 + run__ * 2;
				}
				else
				{
					wL = -40 + run__ * 2;
					wR = -40 + run__ * 2;
				}
				avoid_count = avoid_count + 1;
				break;
				}
				}

				// Stop condition
				if ((x_robot - dsr_pos_x) * (x_robot - dsr_pos_x) + (y_robot - dsr_pos_y) * (y_robot - dsr_pos_y) < 0.04)
				{
					wL = 0;
					wR = 0;
				}

			}
			else if (mode == 4)
			{
			
			double gain_rot = 100;
			double speed_base = 60;
			 force_set = 3;

			if (numContact > 0)
			{
				double tmp_sin = 0; double tmp_cos = 0;
				for (int i = 0; i < numContact; i++)
				{
					tmp_sin = tmp_sin + sin(outAngle[i] * 3.14 / 180);
					tmp_cos = tmp_cos + cos(outAngle[i] * 3.14 / 180);
				}

				final_angle = atan2(tmp_sin, tmp_cos); // rad 



				if (robotID == 2)
					contact_angle_RB_frame = -final_angle + 3.14 / 2;
				else
					contact_angle_RB_frame = -final_angle + 3.14; // rad
				contact_angle_RB_frame = wrapAngle(contact_angle_RB_frame);

				PID_error = force_set - outForce[0];
				PID_errorTotal = PID_errorTotal + PID_error;
				speed_base = 60 + kp * PID_error + ki * PID_errorTotal;

			}
			else
			{
				contact_angle_RB_frame = 0;
				speed_base = 60;
				PID_errorTotal = 0;
			}

			// muon ve 0:
			

			
			wL = speed_base - contact_angle_RB_frame* gain_rot;
			wR= speed_base + contact_angle_RB_frame * gain_rot;


 }
			
			else if (mode == 5)
			{
			double gain_rot = 100; // default 100
			double speed_base = 60;

			 force_set = 0.6/abs(sin(contact_angle_RB_frame + rotation));

			if (numContact > 0)
			{
				double tmp_sin = 0; double tmp_cos = 0;
				for (int i = 0; i < numContact; i++)
				{
					tmp_sin = tmp_sin + sin(outAngle[i] * 3.14 / 180);
					tmp_cos = tmp_cos + cos(outAngle[i] * 3.14 / 180);
				}

				final_angle = atan2(tmp_sin, tmp_cos); // rad 

				if (robotID == 2)
					contact_angle_RB_frame = -final_angle + 3.14 / 2;
				else
					contact_angle_RB_frame = -final_angle + 3.14; // rad
				contact_angle_RB_frame = wrapAngle(contact_angle_RB_frame);

				PID_error = force_set - outForce[0];
				PID_errorTotal = PID_errorTotal + PID_error;
				speed_base = 60 + kp * PID_error + ki * PID_errorTotal;

			}
			else
			{
				contact_angle_RB_frame = 0;
				speed_base = 60;
				PID_errorTotal = 0;
			}

			// muon ve 0:



			wL = speed_base - contact_angle_RB_frame * gain_rot;
			wR = speed_base + contact_angle_RB_frame * gain_rot;


 }
			else if (mode == 6) // Lyapunov modified DD tới goal -----------------------------------------------------
			{
			double gain_rot = 70; // default 100
			double k0 =2.4;
			if ((robotID == 3) || (robotID == 4))
			{
				k0 = k0 / 2;
			}

			 force_set = k0 / abs(sin(contact_angle_RB_frame + rotation));
			 if (force_set > 5) force_set = 5;

				 
			cout << "Desired Force:" << force_set << endl;


			if (numContact > 0)
			{
				double tmp_sin = 0; double tmp_cos = 0;
				for (int i = 0; i < numContact; i++)
				{
					tmp_sin = tmp_sin + sin(outAngle[i] * 3.14 / 180);
					tmp_cos = tmp_cos + cos(outAngle[i] * 3.14 / 180);
				}

				final_angle = atan2(tmp_sin, tmp_cos); // rad 

				if (robotID == 2)
					contact_angle_RB_frame = -final_angle + 3.14 / 2;
				else
					contact_angle_RB_frame = -final_angle + 3.14; // rad
				contact_angle_RB_frame = wrapAngle(contact_angle_RB_frame);
				double tmp_force = outForce[0];
				if (tmp_force<0)
				{
					tmp_force = 10;
				}

				PID_error = force_set - tmp_force;
				speed_base = kp * PID_error + ki * PID_errorTotal;
				PID_errorTotal = PID_errorTotal + PID_error;
				last_angle = contact_angle_RB_frame;
				
			}
			else
			{
				//contact_angle_RB_frame = 0;
				if (abs(last_angle)>70*3.14/180)  speed_base = 0;
				else if (speed_base<40)		speed_base = 40;

				//PID_errorTotal = 0;
			}

			// muon ve 0:



			wL = speed_base + rotation * gain_rot;
			wR = speed_base - rotation * gain_rot;
			wL = Saturation(wL, -80, 140);
			wR = Saturation(wR, -80, 140);
 }


			else if (mode == 7)   //-----------------------------------  Bám đuôi. Snake---------------------------
			{
			if (robotID == 2.0)
			{

				if (numContact > 0)
				{
					double tmp_sin = 0; double tmp_cos = 0;
					for (int i = 0; i < numContact; i++)
					{
						tmp_sin = tmp_sin + sin(outAngle[i] * 3.14 / 180);
						tmp_cos = tmp_cos + cos(outAngle[i] * 3.14 / 180);
					}

					final_angle = atan2(tmp_sin, tmp_cos); // rad 



					if (robotID == 2)
						contact_angle_RB_frame = -final_angle + 3.14 / 2;
					else
						contact_angle_RB_frame = -final_angle + 3.14; // rad
					contact_angle_RB_frame = wrapAngle(contact_angle_RB_frame);

				}



			}
			else if (robotID > 2.0)
			{
				// Defined global variable

				float leadBotXYZ[4];
				float followBotXYZ[4];
				double R_maintain = 0.1; // meter unit

				string robotInforDataLead = robotInformation(bufferRecieve, robotID - 1);

				prasingRobotLocation(robotInforDataLead, leadBotXYZ);
				std::cout << "robotInforDataLead:" << robotID - 2 << ": " << robotInforDataLead << endl;
				string robotInforDataFollow = robotInformation(bufferRecieve, robotID);
				prasingRobotLocation(robotInforDataFollow, followBotXYZ);
				std::cout << "robotInforDataFollow:" << robotID - 1 << ": " << robotInforDataFollow << endl;

				Point leadBot = { leadBotXYZ[0],leadBotXYZ[1] };
				Point followBot = { followBotXYZ[0],followBotXYZ[1] };

				std::cout << "leadBot: " << leadBot.x << "   %   " << leadBot.y << endl;
				std::cout << "followBotXYZ: " << followBot.x << "   %   " << followBot.y << endl;
				Point desiredPoint = getPointOnLine(leadBot, followBot, R_maintain);
				dsr_pos_x = desiredPoint.x;
				dsr_pos_y = desiredPoint.y;

			}

			PID_error = dsr_pos_x - x_robot;
			cout << "test _ dsr x:" << dsr_pos_x << endl;
			cout << "test_x_robot:" << x_robot << endl;
			cout << "test:" << PID_error << endl;
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
			cout << "test:" << PID_error << endl;
			PID_errorTotal2 += PID_error;
			if (PID_errorTotal2 <= -400) PID_errorTotal2 = -400;
			if (PID_errorTotal2 >= 400) PID_errorTotal2 = 400;
			PID_p = kp * PID_error;
			PID_d = kd * ((PID_error - previousPID_error2) / elapsedTime);
			PID_i = ki * PID_errorTotal2 * elapsedTime;
			previousPID_error2 = PID_error;
			//previousTime = currentTime;
			PID_y_value = PID_p + PID_i + PID_d;

			printf("PID_x, PID_y: (%f,%f)\n", PID_x_value, PID_y_value);
			// chuyen sang wL,wR-----------------------------------------------------------
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

			if (norm_v > 0)
				theta = angle - rotation;
			else
				theta = 0;

			calculateWheelVelocities(theta, norm_v, elapsedTime, rotation_gain, wL, wR);
			}
			else if (mode == 8) // ----------------------------------------------------------------------------
			{
				if (numContact > 0)
				{
					force_count = force_count + 1;
					if ((vx * vx + vy * vy) > 0.05 * 0.05)
					{
						force_count = 0;
					}

					if (force_count == 8)
					{
						contact_cond = 1;
						force_count = 0;
					}
				}
				else contact_cond = 0;

				//---
			//	if (contact_cond > 0)


				switch (rb_state) {
				case 0: // normal state 
					if (contact_cond > 0) 
					{
						rb_state = 1;
						if (abs(contact_angle_RB_frame) < 3.14 / 2) up_touch = 1;
						else  up_touch = 0;
					}

					break;
				case 1: // lùi
					if (contact_cond > 0)

					{
						avoid_count = 0;
						if (abs(contact_angle_RB_frame) < 3.14 / 2) up_touch = 1;
						else  up_touch = 0;

					}
					if (avoid_count == 4)
					{
						rb_state = 2;
						//tmp_dsr_angle = wrapAngle(contact_angle_RB_frame + rotation + 3.14 / 2); // xoay ve 1 ben LEFT
						avoid_count = 0;
					}
					break;
				case 2: // xoay tai cho
					if (contact_cond > 0)
					{
						rb_state = 1;
						avoid_count = 0;
						if (abs(contact_angle_RB_frame) < 3.14 / 2.0) up_touch = 1;
						else  up_touch = 0;
					}
					if (avoid_count == 7)
					{
						rb_state = 0;
						//tmp_dsr_angle = wrapAngle(contact_angle_RB_frame + rotation + 3.14 / 2); // xoay ve 1 ben LEFT
						avoid_count = 0;
					}
					

					break;
	
				}


				// Behavior
				printf("up_touch flagn: %d\n", up_touch);
				switch (rb_state) {
				case 0:
				{
					wL = 80;
					wR = 80;

				}
				break;
				case 1: // Lùi có chiến thuật
					if (up_touch == 1)
					{
						wL = -80;
						wR = -80;
					}
					else
					{

						wL = 80;
						wR = 80;
					}


					avoid_count = avoid_count + 1;
					break;
				case 2:
				{
					wL = -120;
					wR = 120;
					avoid_count = avoid_count + 1;
					break;
				}
				
				}
			}



			float omega_offset = 0;
			//printf("normv, angle, theta, rotation, %f,%f,%f\n ", norm_v, angle, theta, rotation);
			float force;
			if (numContact > 0)
				force = outForce[0];
			else  force = 0;
			cout << "-------------------------Mode:" << mode << endl;
			printf("The applied FORCE %f\n", force);

			// ---------------------------------- Differential drive Input norm v, theta ----------------------------------------------------


			writeSth(writeData, outAngle, outForce, numContact, x_robot, y_robot, contact_angle_RB_frame); // Luu file
			
			if (mode_connection == 1)
			{
				printf("Data:");
				cout << dataTransfer_string.length();
				cout << dataTransfer_string << endl;
				printf(" Robot infor --------");
				printf("Heading Robot: %f (deg) \n", rotation * 180 / 3.14);
				printf("Desired direction: %f (deg) \n", angle * 180 / 3.14);
				printf("tmp_dsr_angle: %f\n", tmp_dsr_angle * 180 / 3.14);
				printf("The angular error %f (deg) \n", theta * 180 / 3.14);
				printf("Alpha goal %f (deg) \n", alpha_goal * 180 / 3.14);
				printf("The velocity (%f,%f)\n", vx, vy);
				printf("ct_angle_wFrame: %f\n", (contact_angle_RB_frame + rotation) * 180 / 3.14);

			}

			std::cout << "ContactAngle_RBFrame: " << contact_angle_RB_frame * 180 / 3.14 << "deg, " << contact_angle_RB_frame << endl;

		
			if (mode == 6) 
			printf("Desired force (%f), Last angle (%f) \n", force_set,last_angle*180/3.14);
			printf("ROBOT STATE: %d\n", rb_state);
			std::cout << "NumContact: " << numContact << endl;

			cout << "Left, right PWM: " << "g," + to_string(wL) + "," + to_string(wR) + "\n" << endl;

			wL = Zumo_saturation(prev_wL, Zumo_sat, wL);
			wR = Zumo_saturation(prev_wR, Zumo_sat, wR);
			prev_wL = wL;
			prev_wR = wR;
			//----------------------------------------------------------------------------------------------------------------------------------------------------------		
			std::string str = "g," + to_string(wL) + "," + to_string(wR) + "\n";

			if (kp == 99)  // --- test mode: kp =99;
				str = "g,400,400";

			cout << "Saturation: Left, right PWM: " << str << endl;


			char buffer[5000];
			strcpy(buffer, str.c_str());
			serialPuts(fd, buffer);
			fflush(stdout);
			dataTransfer_string = "";
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
