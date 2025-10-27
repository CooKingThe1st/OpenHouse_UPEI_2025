
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

using namespace cv;
using namespace std;
using namespace std::chrono;


const double PI = 3.1416;

extern int value_1;
extern int radius;
extern Point2f centerPt;


void sizeImage(Mat image, string name);
void framePerSecond(VideoCapture video, string name);

void denoiseImage(Mat& inputImage);
void denoiseImage_trackbar(Mat &inputImage);

void fillImage(Mat& inputImage, int imageWidth, int imageHeight);
void fillImage_trackbar(Mat& inputImage, int imageWidth, int imageHeight);

void trackbarName();
void copy2array(vector<Point3f> sourceArray, vector<Point3f>& destinationArray);
void locateMarker(Mat& inputImage, Mat& colorImage, vector<Point3f>& mPolar_reverse_descartes);



Point2f center(vector<Point2f>mC);

float distancePoint2Point(Point2f beginPt, Point2f endPt);

Point2f changeCoordinate(Point2f newCoordinate, Point2f pt);

Point3f descartes2PolarSystem(Point2f inputPt, Point2f centerPolar);

Point2f descartes2PolarSystem_2f(Point2f inputPt, Point2f centerPolar);


void bubbleSort(vector<Point2f>&inputArray);

void polarSystem2descartes(Point3f& inputPolarPt, Point2f center);

Point3f calculateChange(Point3f savePoint, Point3f changedPoint);

void displacementArray(vector<Point3f>saveArray_descartes, vector<Point3f>changedArray_descartes, vector<Point2f>& outDisplace, bool draw_is, Mat& inputImage);

void findHighPoint(vector<Point2f> displacement, vector<int>& contactPoint);

Point2f intersection2line(Point3f v1, Point3f v2);

Point3f lineEquation(Point3f startPt, Point3f endPt);

Point2f Kpoint(Point3f bPt, Point3f dPt);

Point2f Kpoint2f(Point3f bPt, Point3f dPt);

float force2vector(Point2f v1, Point2f v2);

float forceMagnitude(Point2f vec);

void totalVector(Mat& inputImage, vector<int> contactList, vector<Point2f> displacement, vector<Point3f> savePoint, vector<Point3f> changedPoint);

Point2f vector2Point(Point3f startPt, Point3f endPt);

Point2f intersectionCircleLine(Point2f circleCenter, float cirleRadius, Point3f line, Point2f refPt);

void illustrateVec_dir_3points(Mat& inputImage, char left, char right, char middle, vector<Point3f> savePoint, vector<Point3f> changedPoint);

void illustrateVec_dir_2points(Mat& inputImage, char left, char right, char middle, vector<Point3f> savePoint, vector<Point3f> changedPoint);

Point2f illustrateVec_point_direction(Mat& inputImage, char left, char right, char middle, vector<Point3f> savePoint, vector<Point3f> changedPoint);

void checkMarker(vector<Point3f> savePoint, vector<Point3f>& changedPoint);

float estimateForce_onMarker(vector<int> &contactList, vector<float> &forceList, vector<Point3f> changedPoint, vector<Point3f> originalPoint);

Point3f point2Dto3D(Point2f input);

Point2f point3Dto2D(Point3f input);

float distanceChangeAB(Point3f changePoint, Point3f originalPoint);
