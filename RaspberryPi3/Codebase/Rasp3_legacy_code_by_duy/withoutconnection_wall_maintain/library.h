#include <opencv2/core/types_c.h>
#include <opencv2/highgui/highgui.hpp>
#include <opencv2/core/core.hpp>
#include <opencv2/photo.hpp>
#include <opencv2/videoio.hpp>
#include <opencv2/imgcodecs.hpp> 
#include <iostream>
#include <string>
#include <vector>
#include <cmath>
#include <bitset> 
#include <math.h>
#include <stdlib.h>
#include <mutex>
#include <stdio.h>
#include <string.h>
#include <errno.h>
#include <unistd.h>
#include <string>
#include <wiringSerial.h>
#include <iostream>
#include <sys/types.h>
#include <sys/socket.h>
#include <netdb.h>
#include <arpa/inet.h>
#include <chrono>
#include <fstream>
#include <ctime>
#include <iomanip>
#include <sstream>

//using namespace cv;
using namespace std;
using namespace std::chrono;


const double PI = 3.1416;

extern int value_1;
extern int radius;
extern cv::Point2f centerPt;


void sizeImage(cv::Mat image, string name);
void framePerSecond(cv::VideoCapture video, string name);
void denoiseImage(cv::Mat &inputImage, int cols, int rows);
//void denoiseImage(cv::Mat& inputImage);
void denoiseImage_trackbar(cv::Mat &inputImage);

void fillImage(cv::Mat& inputImage, int imageWidth, int imageHeight);
void fillImage_trackbar(cv::Mat& inputImage, int imageWidth, int imageHeight);

void trackbarName();
void copy2array(vector<cv::Point3f> sourceArray, vector<cv::Point3f>& destinationArray);
void locateMarker(cv::Mat& inputImage, cv::Mat& colorImage, vector<cv::Point3f>& mPolar_reverse_descartes);



cv::Point2f center(vector<cv::Point2f>mC);

float distancePoint2Point(cv::Point2f beginPt, cv::Point2f endPt);

cv::Point2f changeCoordinate(cv::Point2f newCoordinate, cv::Point2f pt);

cv::Point3f descartes2PolarSystem(cv::Point2f inputPt, cv::Point2f centerPolar);

void bubbleSort(vector<cv::Point2f>&inputArray);

void polarSystem2descartes(cv::Point3f& inputPolarPt, cv::Point2f center);

cv::Point3f calculateChange(cv::Point3f savePoint, cv::Point3f changedPoint);

void displacementArray(vector<cv::Point3f>saveArray_descartes, vector<cv::Point3f>changedArray_descartes, vector<cv::Point2f>& outDisplace, bool draw_is, cv::Mat& inputImage);

void findHighPoint(vector<cv::Point2f> displacement, vector<int>& contactPoint);

cv::Point2f intersection2line(cv::Point3f v1, cv::Point3f v2);

cv::Point3f lineEquation(cv::Point3f startPt, cv::Point3f endPt);

cv::Point2f Kpoint(cv::Point3f bPt, cv::Point3f dPt);

cv::Point2f Kpoint2f(cv::Point3f bPt, cv::Point3f dPt);

float force2vector(cv::Point2f v1, cv::Point2f v2);

float forceMagnitude(cv::Point2f vec);

void totalVector(cv::Mat& inputImage, vector<int> contactList, vector<cv::Point2f> displacement, vector<cv::Point3f> savePoint, vector<cv::Point3f> changedPoint, float &transfer);

void totalVector(cv::Mat& inputImage, vector<int> contactList, vector<cv::Point2f> displacement, vector<cv::Point3f> savePoint, vector<cv::Point3f> changedPoint,float outAngle[24], float outForce[24], int &numContact);

cv::Point2f vector2Point(cv::Point3f startPt, cv::Point3f endPt);

cv::Point2f intersectionCircleLine(cv::Point2f circleCenter, float cirleRadius, cv::Point3f line, cv::Point2f refPt);

cv::Point2f illustrateVec_point2f(cv::Mat& inputImage, char left, char right, char middle, vector<cv::Point3f> savePoint, vector<cv::Point3f> changedPoint);

void checkMarker(vector<cv::Point3f> savePoint, vector<cv::Point3f>& changedPoint);

float estimateForce_onMarker(vector<int> &contactList, vector<float> &forceList, vector<cv::Point3f> changedPoint);

float illustrateVec_point(cv::Mat& inputImage, char left, char right, char middle, vector<cv::Point3f> savePoint, vector<cv::Point3f> changedPoint);

float estimateForce(float angle, float DisNearest);

string robotInformation(string inputData, int input_robotID);

void prasingBox(string inputString, float outXY[10]);

void prasingRobotLocation(string inputString, float outXY[4]);
