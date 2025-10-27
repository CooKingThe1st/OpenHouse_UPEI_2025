#include "library.h"

using namespace cv;
int value_1 = 0;
int radius = 0;
Point2f centerPt = Point2f(178.784f, 240.716f);


void sizeImage(Mat image, string name)
{
	cout << name << " : " << image.size() << endl;
}

void framePerSecond(VideoCapture video, string name)
{
	cout << name << "fps: " << video.get(CAP_PROP_FPS) << endl;
}

void denoiseImage(Mat& inputImage)
{

	//cvtColor(inputImage, inputImage, COLOR_BGR2RGB);
	//cvtColor(inputImage, inputImage, COLOR_RGB2GRAY);
	cvtColor(inputImage, inputImage, COLOR_BGR2HSV);
	inRange(inputImage, Scalar(0, 80, 95), Scalar(32, 255, 255), inputImage);
	//inRange(inputImage, Scalar(165, 0, 0), Scalar(255, 255, 255), inputImage);
	cv::imshow("image input", inputImage);
	GaussianBlur(inputImage, inputImage, Size(3, 3), 0, 0, BORDER_DEFAULT);
	//erode(inputImage, inputImage, getStructuringElement(MORPH_ELLIPSE, Size(1, 1)));
	dilate(inputImage, inputImage, getStructuringElement(MORPH_OPEN, Size(2, 2)));


	//inRange(inputImage, Scalar(165, 0, 0), Scalar(255, 255, 255), inputImage);
	//inRange(inputImage, Scalar(0, 0, 72), Scalar(93, 63, 255), inputImage);

	
}

void denoiseImage_trackbar(Mat& inputImage)
{

	cvtColor(inputImage, inputImage, COLOR_BGR2RGB);
	cvtColor(inputImage, inputImage, COLOR_RGB2GRAY);

	erode(inputImage, inputImage, getStructuringElement(MORPH_ELLIPSE, Size(int(1.5), int(1.5))));
	dilate(inputImage, inputImage, getStructuringElement(MORPH_OPEN, Size(1, 1)));

	//cout << "value 1:  " << value_1 << endl;
	inRange(inputImage, Scalar(value_1, 0, 0), Scalar(255, 255, 255), inputImage);
	GaussianBlur(inputImage, inputImage, Size(3, 3), 0, 0, BORDER_DEFAULT);

	Canny(inputImage, inputImage, 60, 100, 3);
	inputImage.convertTo(inputImage, CV_8U);
}

void fillImage_trackbar(Mat& inputImage, int imageWidth, int imageHeight)
{
	Point2f cen;
	cen.x = float(imageWidth / 2);
	cen.y = float(imageHeight / 2);
	circle(inputImage, cen, radius, Scalar(0, 0, 0), -1);
}

void trackbarName()
{
	namedWindow("Threshold", WINDOW_AUTOSIZE);
	createTrackbar("LowH", "Control", &value_1, 179);
	namedWindow("Radius", WINDOW_AUTOSIZE);
	createTrackbar("Radius", "Table", &radius, 179);
}

void fillImage(Mat& inputImage, int imageWidth, int imageHeight)
{
	circle(inputImage, Point2f(float(imageWidth / 2), float(imageHeight / 2)), 200, Scalar(0, 0, 0), -1);
}


Point2f center(vector<Point2f>mC)
{
	float x_center = 0, y_center = 0;
	int numberPt = mC.size();
	Point2f newCenter;
	for (int i = 0; i < mC.size(); i++)
	{
		x_center = x_center + mC[i].x;
		y_center = y_center + mC[i].y;
	}
	newCenter = Point2f(float(x_center / numberPt), float(y_center / numberPt));
	cout << "newCenter: " << newCenter << endl;
	return newCenter;
}

float distancePoint2Point(Point2f beginPt, Point2f endPt)
{
	return sqrtf(pow(beginPt.x - endPt.x, 2) + pow(beginPt.y - endPt.y, 2));
}

Point2f changeCoordinate(Point2f newCoordinate, Point2f pt)
{
	return Point2f(pt.x - newCoordinate.x, pt.y - newCoordinate.y);
}

Point3f descartes2PolarSystem(Point2f inputPt, Point2f centerPolar)
{
	Point2f polarPt = changeCoordinate(centerPolar, inputPt);
	Point2f newPolarCoordinate = Point2f(0, 0);
	float r = distancePoint2Point(polarPt, newPolarCoordinate);
	float phi = atan2(polarPt.y, polarPt.x);

	return Point3f(r, phi, 0);
}

Point2f descartes2PolarSystem_2f(Point2f inputPt, Point2f centerPolar)
{
	Point2f polarPt = changeCoordinate(centerPolar, inputPt);
	Point2f newPolarCoordinate = Point2f(0, 0);
	float r = distancePoint2Point(polarPt, newPolarCoordinate);
	float phi = atan2(polarPt.y, polarPt.x);

	return Point2f(r, phi);
}


void polarSystem2descartes(Point3f& inputPolarPt, Point2f center)
{
	float xDescartes = inputPolarPt.x * cosf(inputPolarPt.y);
	float yDescartes = inputPolarPt.x * sinf(inputPolarPt.y);
	int ith = inputPolarPt.z;
	inputPolarPt = Point3f(float(xDescartes + center.x), float(yDescartes + center.y), int(ith));
}




void copy2array(vector<Point3f> sourceArray, vector<Point3f>& destinationArray)
{
	destinationArray.resize(sourceArray.size());
	for (int i = 0; i < sourceArray.size(); i++)
	{
		destinationArray[i].x = sourceArray[i].x;
		destinationArray[i].y = sourceArray[i].y;
		destinationArray[i].z = sourceArray[i].z;
	}
	//cout << "copy2Array" << endl;
}
Point3f calculateChange(Point3f savePoint_descartes, Point3f changedPoint_descartes)
{
	// x : value in X axis
	// y : value in Y axis
	// z : the order of point
	float x = savePoint_descartes.x - changedPoint_descartes.x;
	float y = savePoint_descartes.y - changedPoint_descartes.y;
	int ith = savePoint_descartes.z;
	return Point3f(x, y, ith);
}

void displacementArray(vector<Point3f>saveArray_descartes, vector<Point3f>changedArray_descartes, vector<Point2f>& outDisplace, bool draw_is, Mat& inputImage)
{
	// if draw_is is true : arrow be draw on the image

	// cout << "size of save: " << saveArray_descartes.size() << endl;
	// cout << "size of save: " << changedArray_descartes.size() << endl;
	// this function prevent the stopping when size of < saveArray_descartes array> and <changedArray_descartes array >
	// is not equal
	float breakPoint;
	if (saveArray_descartes.size() == changedArray_descartes.size()) breakPoint = changedArray_descartes.size();
	else if (saveArray_descartes.size() > changedArray_descartes.size()) breakPoint = changedArray_descartes.size();
	else if (saveArray_descartes.size() == 0 || changedArray_descartes.size() == 0)
	{
		copy2array(saveArray_descartes, changedArray_descartes);
		breakPoint = 0;
	}
	else breakPoint = saveArray_descartes.size();
	// cout << "break: " << breakPoint;
	for (int i = 0; i < breakPoint; i++)
	{
		if (breakPoint == 0) break;
		Point2f temp;
		temp.x = sqrt(pow((saveArray_descartes[i].x - changedArray_descartes[i].x), 2) +
			pow((saveArray_descartes[i].y - changedArray_descartes[i].y), 2));

		if (temp.x < 1.5) temp.x = 0;
		temp.y = saveArray_descartes[i].z;
		outDisplace.push_back(temp);

		if (draw_is == true)
		{
			arrowedLine(inputImage, Point2f(saveArray_descartes[i].x, saveArray_descartes[i].y),
				Point2f(changedArray_descartes[i].x, changedArray_descartes[i].y), Scalar(100, 255, 255), 2, 8, 0, 0.1);
			putText(inputImage, to_string(int(changedArray_descartes[i].z)), Point2f(changedArray_descartes[i].x,
				changedArray_descartes[i].y + 5), FONT_HERSHEY_COMPLEX, 0.5, Scalar(0, 0, 255), 1, 8, false);
		}
		// cout << " pass 1 - b " << endl;
	}
	// cout << " pass 1 - c " << endl;
}

float angleOriginalChanged(Point3f changePoint, Point3f originalPoint)
{
	// This function can return the angleOAB
	// It also can return def marker AB
	float AB = sqrt(pow(changePoint.x - originalPoint.x, 2) + pow(changePoint.y - originalPoint.y, 2));
	//std::cout << "AB : " << AB << endl;
	float OB = sqrt(pow(changePoint.x - centerPt.x, 2) + pow(changePoint.y - centerPt.y, 2));
	//std::cout << "OB : " << OB << endl;
	float OA = sqrt(pow(centerPt.x - originalPoint.x, 2) + pow(centerPt.y - originalPoint.y, 2));
	//std::cout << "OA : " << OA << endl;
	std::cout << "distance point to point: " << AB << endl;
	float angleOAB = 0;
	angleOAB = acos((OB * OB - OA * OA - AB * AB) / (-2 * OA * AB));
	//return angleOAB * 180 / 3.1415;
	return AB;
}


float estimateForce_onMarker(vector<int>& contactList, vector<float>& forceList, vector<Point3f> changedPoint, vector<Point3f> originalPoint)
{
	for (int i = 0; i < contactList.size(); i++)
	{
		if (contactList[i] == 0)
		{
			Point3f mainPoint, subsideLeft, subsideRight;
			//std::cout << " \nContact Point " << descartes2PolarSystem
			//(Point2f(changedPoint[contactList[i]].x, changedPoint[contactList[i]].y), centerPt) << endl;
			float angle_mainPoint = angleOriginalChanged(changedPoint[contactList[i]], originalPoint[contactList[i]]);
			std::cout << " Point main: " << i << endl;
			//std::cout << "angle mainPoint -----------------" << angle_mainPoint << endl;

			//std::cout << " Subside left " << descartes2PolarSystem
			//(Point2f(changedPoint[contactList[23]].x, changedPoint[contactList[23]].y), centerPt) << endl;
			//std::cout << " Point left: " << 23 << endl;
			//float angle_left = angleOriginalChanged(changedPoint[contactList[23]], originalPoint[contactList[23]]);
			//std::cout << "angle left ---------------- " << angle_left << endl;

			//std::cout << " Subside right " << descartes2PolarSystem
			//(Point2f(changedPoint[contactList[i] + 1].x, changedPoint[contactList[i] + 1].y), centerPt) << endl;
			//std::cout << " Point right: " << contactList[i] + 1 << endl;
			//float angle_right = angleOriginalChanged(changedPoint[contactList[i] + 1], originalPoint[contactList[i] + 1]);
			//std::cout << "angle right --------------------" << angle_right << endl;
		}
		else if (contactList[i] == 23)
		{
			Point3f mainPoint, subsideLeft, subsideRight;

			//std::cout << " Contact Point " << descartes2PolarSystem
			//(Point2f(changedPoint[contactList[i]].x, changedPoint[contactList[i]].y), centerPt) << endl;
			std::cout << " Point main: " << 23 << endl;
			float angle_mainPoint = angleOriginalChanged(changedPoint[contactList[i]], originalPoint[contactList[i]]);
			//std::cout << "angle mainPoint-------------------- " << angle_mainPoint << endl;

			//std::cout << " Subside left " << descartes2PolarSystem
			//(Point2f(changedPoint[contactList[i] - 1].x, changedPoint[contactList[i] - 1].y), centerPt) << endl;
			//std::cout << " Point left: " << contactList[i] - 1 << endl;
			//float angle_left = angleOriginalChanged(changedPoint[contactList[i] - 1], originalPoint[contactList[i] - 1]);
			//std::cout << "angle left-------------------- " << angle_left << endl;

			//std::cout << " Subside right " << descartes2PolarSystem
			//(Point2f(changedPoint[contactList[0]].x, changedPoint[contactList[0]].y), centerPt) << endl;
			//std::cout << " Point right: " << contactList[0] << endl;
			//float angle_right = angleOriginalChanged(changedPoint[contactList[0]], originalPoint[contactList[0]]);
			//std::cout << "angle right --------------------" << angle_right << endl;
		}
		else
		{
			Point3f mainPoint, subsideLeft, subsideRight;
			//std::cout << " Contact Point " << descartes2PolarSystem
			//(Point2f(changedPoint[contactList[i]].x, changedPoint[contactList[i]].y), centerPt) << endl;
			std::cout << " Point main: " << contactList[i] << endl;
			//float angle_main = angleOriginalChanged(changedPoint[contactList[i]], originalPoint[contactList[i]]);
			//std::cout << "angle main-------------------- " << angle_main << endl;

			//std::cout << " Subside left " << descartes2PolarSystem
			//(Point2f(changedPoint[contactList[i] - 1].x, changedPoint[contactList[i] - 1].y), centerPt) << endl;
			//std::cout << " Point left: " << contactList[i] - 1 << endl;
			//float angle_left = angleOriginalChanged(changedPoint[contactList[i] - 1], originalPoint[contactList[i] - 1]);
			//std::cout << "angle left-------------------- " << angle_left << endl;

			//std::cout << " Subside right " << descartes2PolarSystem
			//(Point2f(changedPoint[contactList[i] + 1].x, changedPoint[contactList[i] + 1].y), centerPt) << endl;
			//std::cout << " Point right: " << contactList[i] + 1 << endl;
			//float angle_right = angleOriginalChanged(changedPoint[contactList[i] + 1], originalPoint[contactList[i] + 1]);
			//std::cout << "angle right-------------------- " << angle_right << endl;
		}
	}
	return 0;
}

void bubbleSort(vector<Point3f>& inputArray)
{
	// direction 0: small to big, 1: big to small
	// x : r
	// y : phi
	for (int i = 0; i < inputArray.size(); i++)
	{
		for (int j = i + 1; j < inputArray.size(); j++)
		{
			if (inputArray[i].y < inputArray[j].y)
			{
				Point3f temp = inputArray[i];
				inputArray[i] = inputArray[j];
				inputArray[j] = temp;
			}
		}
	}

	for (int i = 0; i < inputArray.size(); i++)
	{
		inputArray[i].z = int(i);
	}
}



void drawCoordinatorCenter(Point2f center, int lenghtArrow, Mat& inputImage)
{
	Point2f stopArrowX = Point2f(center.x + lenghtArrow, center.y);
	Point2f stopArrowY = Point2f(center.x, center.y + lenghtArrow);
	putText(inputImage, "X", Point(stopArrowX.x, stopArrowX.y + 10), FONT_HERSHEY_COMPLEX, 0.5, Scalar(0, 0, 255), 1, 8, false);
	arrowedLine(inputImage, center, stopArrowX, Scalar(0, 255, 0), 1.5, 8, 0, 0.1);
	putText(inputImage, "Y", Point(stopArrowY.x - 10, stopArrowY.y), FONT_HERSHEY_COMPLEX, 0.5, Scalar(0, 0, 255), 1, 8, false);
	arrowedLine(inputImage, center, stopArrowY, Scalar(0, 255, 0), 1.5, 8, 0, 0.1);
}

void findHighPoint(vector<Point2f> displacement, vector<int>& contactPoint)
{
	int k = 0;
	//contactPoint.resize(displacement.size()/2);
	for (int i = 0; i < (displacement.size() - 2); i++)
	{
		float firstPt = displacement[i].x;
		float middlePt = displacement[i + 1].x;
		float third = displacement[i + 2].x;

		if ((middlePt > firstPt) && (middlePt > third))
		{
			contactPoint.push_back(displacement[i + 1].y);
		}
	}

	float first = displacement[displacement.size() - 2].x;
	float middle = displacement[displacement.size() - 1].x;
	float third = displacement[0].x;

	if ((middle > first) && (middle > third))
	{
		contactPoint.push_back(displacement[displacement.size() - 1].y);
	}
	first = displacement[displacement.size() - 1].x;
	middle = displacement[0].x;
	third = displacement[1].x;
	if ((middle > first) && (middle > third))
	{
		contactPoint.push_back(displacement[0].y);
	}
}

Point2f intersection2line(Point3f v1, Point3f v2)
{
	float x_center0 = -(v1.z - v2.z) / (v1.x - v2.x);
	float y_center0 = v1.x * x_center0 + v1.z;
	return Point2f(x_center0, y_center0);
}

Point3f lineEquation(Point3f startPt, Point3f endPt)
{
	// the equation: y = ax + b -> ax - y + b = 0 
	// direction vector v = (a, -1, b) 
	// v.x = a
	// v.y = -1
	// v.z = b
	float b = 0;
	float a = 0;
	a = (startPt.y - endPt.y) / (startPt.x - endPt.x);
	b = (startPt.y - a * startPt.x);
	return Point3f(a, -1, b);
}

Point2f Kpoint(Point3f bPt, Point3f dPt)
{
	float x = 0.5 * (static_cast<double>(bPt.x) + (dPt.x));
	float y = 0.5 * (static_cast<double>(bPt.y) + (dPt.y));
	return Point2f(x, y);
}

Point2f Kpoint2f(Point3f bPt, Point3f dPt)
{
	float x = 0.5 * (static_cast<double>(bPt.x) + dPt.x);
	float y = 0.5 * (bPt.y + dPt.y);
	return Point2f(x, y);
}

float forceMagnitude(Point2f vec)
{
	return sqrt(pow(vec.x, 2) + pow(vec.y, 2));
}

float force2vector(Point2f v1, Point2f v2)
{
	/*
	v1(a,b), v2(a,b) is the direction vector of force
	v1.x and v2.x is the component of vector, not the location
	v1.y and v2.y is the component of vector, not the location
	*/
	float numerator = v1.x * v2.x + v1.y * v2.y;
	float F1 = forceMagnitude(v1);
	float F2 = forceMagnitude(v2);
	float denominator = F1 * F2;
	//cout << "mag v1: " << F1 << endl;
	//cout << "mag v2: " << F2 << endl;
	if (denominator == NAN) return 0;

	float cos_v1v2 = numerator / denominator;
	//cout << "cos_v1v2: " << cos_v1v2 << endl;
	float force = sqrt(pow(F1, 2) + pow(F2, 2) + 2 * cos_v1v2 * F1 * F2);
	return force;
}
Point2f vector2Point(Point3f startPt, Point3f endPt)
{
	return Point2f(endPt.x - startPt.x, endPt.y - startPt.y);
}
Point2f intersectionCircleLine(Point2f circleCenter, float cirleRadius, Point3f line, Point2f refPt)
{
	// circleCenter(x0,y0): circleCenter.x  .y
	// line ax - y + b = 0
	// a = line.x , -1  line.y , b = line.z 
	float a = line.x;
	float b = line.z;
	float x0 = circleCenter.x;
	float y0 = circleCenter.y;
	float r = cirleRadius;
	//
	float rootX1 = (x0 - a * b + a * y0 + sqrt(a * a * r * r - a * a * x0 * x0
		- 2 * a * b * x0 + 2 * a * x0 * y0 - b * b + 2 * b * y0 + r * r - y0 * y0)) / (a * a + 1);
	float rootX2 = (x0 - a * b + a * y0 - sqrt(a * a * r * r - a * a * x0 * x0
		- 2 * a * b * x0 + 2 * a * x0 * y0 - b * b + 2 * b * y0 + r * r - y0 * y0)) / (a * a + 1);

	float rootY1 = line.x * rootX1 + line.z;
	float rootY2 = line.x * rootX2 + line.z;
	Point2f root1(rootX1, rootY1);
	Point2f root2(rootX2, rootY2);
	//cout << " Point 1 : " << root1 << endl;
	//cout << " Point 2 : " << root2 << endl;
	float distance1 = distancePoint2Point(root1, refPt);
	float distance2 = distancePoint2Point(root2, refPt);
	if (distance1 > distance2)
	{
		return root2;
	}
	else return root1;

	return Point2f(0, 0);
}


void drawStraightLine(cv::Mat inputImg, cv::Point2f p1, cv::Point2f p2, cv::Scalar color)
{
	Point2f p, q;
	// Check if the line is a vertical line because vertical lines don't have slope
	if (p1.x != p2.x)
	{
		p.x = 0;
		q.x = inputImg.cols;
		// Slope equation (y1 - y2) / (x1 - x2)
		float m = (p1.y - p2.y) / (p1.x - p2.x);
		// Line equation:  y = mx + b
		float b = p1.y - (m * p1.x);
		p.y = m * p.x + b;
		q.y = m * q.x + b;
	}
	else
	{
		p.x = q.x = p2.x;
		p.y = 0;
		q.y = inputImg.rows;
	}

	cv::line(inputImg, p, q, color, 1);
}
Point3f point2Dto3D(Point2f input)
{
	return Point3f(input.x, input.y, 0);
}
Point2f point3Dto2D(Point3f input)
{
	return Point2f(input.x, input.y);
}
void illustrateVec_dir_3points(Mat& inputImage, char left, char right, char middle, vector<Point3f> savePoint, vector<Point3f> changedPoint)
{
	Point2f intersectionPt_leftRight, middlePt_leftRight;
	Point3f line_left, line_middle, line_right;
	Point3f lineComb_leftRight;
	Point2f v_left, v_right, v_middle;
	float force_leftRight;
	line_left = lineEquation(changedPoint[left], savePoint[left]);
	line_right = lineEquation(changedPoint[right], savePoint[right]);
	intersectionPt_leftRight = intersection2line(line_left, line_right);
	middlePt_leftRight = Kpoint2f(changedPoint[left], changedPoint[right]);
	lineComb_leftRight = lineEquation(Point3f(intersectionPt_leftRight.x, intersectionPt_leftRight.y, 0), Point3f(middlePt_leftRight.x, middlePt_leftRight.y, 0));

	v_left = vector2Point(changedPoint[left], savePoint[left]);
	v_right = vector2Point(changedPoint[right], savePoint[right]);

	force_leftRight = force2vector(v_left, v_right);

	//circle(inputImage, Point(intersectionPt_leftRight.x, intersectionPt_leftRight.y), 2, Scalar(255, 100, 50), 2);
	//arrowedLine(inputImage, Point(intersectionPt_leftRight.x, intersectionPt_leftRight.y), Point(middlePt_leftRight.x, middlePt_leftRight.y), Scalar(100, 100, 50), 1);

	static Point2f onCirlePt_leftRight;
	onCirlePt_leftRight = intersectionCircleLine(intersectionPt_leftRight, force_leftRight, lineComb_leftRight, centerPt);

	//circle(inputImage, onCirlePt_leftRight, 2, Scalar(50, 100, 50), 2);

	// Find the middle
	/* Input :  - intersection point of line on left and right <intersectionPt_leftRight>
	*			- intersection point : cirlce and line <onCirlePt_leftRight>
	*
	*/



	Point3f lineComb_LR_mid;
	Point2f v_onCircle;
	Point2f intersectionPt_LR_mid;
	Point2f middlePt_LR_mid;
	Point3f lineComb_intersection_mid_LR_mid;

	lineComb_LR_mid = lineEquation(Point3f(onCirlePt_leftRight.x, onCirlePt_leftRight.y, 0), Point3f(intersectionPt_leftRight.x, intersectionPt_leftRight.y, 0));
	line_middle = lineEquation(changedPoint[middle], savePoint[middle]);
	intersectionPt_LR_mid = intersection2line(lineComb_LR_mid, line_middle);

	middlePt_LR_mid = Kpoint2f(Point3f(onCirlePt_leftRight.x, onCirlePt_leftRight.y, 0), Point3f(changedPoint[middle].x, changedPoint[middle].y, 0));

	circle(inputImage, middlePt_LR_mid, 2, Scalar(0, 0, 255), 2);

	float force_LR_mid;
	v_onCircle = vector2Point(Point3f(intersectionPt_leftRight.x, intersectionPt_leftRight.y, 0), Point3f(onCirlePt_leftRight.x, onCirlePt_leftRight.y, 0));
	v_middle = vector2Point(changedPoint[middle], savePoint[middle]);
	force_LR_mid = force2vector(v_middle, v_onCircle);

	lineComb_intersection_mid_LR_mid = lineEquation(Point3f(intersectionPt_leftRight.x, intersectionPt_leftRight.y, 0), Point3f(onCirlePt_leftRight.x, onCirlePt_leftRight.y, 0));

	Point2f finalOnCircle;
	finalOnCircle = intersectionCircleLine(intersectionPt_LR_mid, force_LR_mid, lineComb_intersection_mid_LR_mid, centerPt);

	drawStraightLine(inputImage, Point2f(middlePt_LR_mid.x, middlePt_LR_mid.y), Point2f(finalOnCircle.x, finalOnCircle.y), Scalar(100, 100, 50));

	////// This part for contact location
	Point2f intersection_contact;
	if (forceMagnitude(v_left) > forceMagnitude(v_right))
	{
		intersection_contact = intersection2line(line_middle, line_left);
	}
	else
	{
		intersection_contact = intersection2line(line_middle, line_right);
	}
	Point3f lineToCenter;
	lineToCenter = lineEquation(point2Dto3D(intersection_contact), point2Dto3D(centerPt));

	Point2f pointOnCircle;
	float R = 167;
	pointOnCircle = intersectionCircleLine(centerPt, R, lineToCenter, intersection_contact);
	circle(inputImage, pointOnCircle, 2, Scalar(50, 90, 255), 2);
	float angleOfContact = 0;
	angleOfContact = descartes2PolarSystem(pointOnCircle, centerPt).y * 180 / PI;
	//cout << "Contact point possition: " << descartes2PolarSystem(pointOnCircle,centerPt) << endl;
	//cout << "Contact point angle:     " << angleOfContact << endl;
}

void illustrateVec_dir_2points(Mat& inputImage, char left, char right, char middle, vector<Point3f> savePoint, vector<Point3f> changedPoint)
{
	Point2f intersectionPt_leftRight, middlePt_leftRight;
	Point3f line_left, line_middle, line_right;
	Point3f lineComb_leftRight;
	Point2f v_left, v_right, v_middle;

	////// This part for contact location
	Point2f intersection_contact;
	v_left = vector2Point(changedPoint[left], savePoint[left]);
	v_right = vector2Point(changedPoint[right], savePoint[right]);
	line_left = lineEquation(changedPoint[left], savePoint[left]);
	line_right = lineEquation(changedPoint[right], savePoint[right]);
	line_middle = lineEquation(changedPoint[middle], savePoint[middle]);

	if (forceMagnitude(v_left) > forceMagnitude(v_right))
	{
		intersection_contact = intersection2line(line_middle, line_left);
	}
	else
	{
		intersection_contact = intersection2line(line_middle, line_right);
	}
	Point3f lineToCenter;
	lineToCenter = lineEquation(point2Dto3D(intersection_contact), point2Dto3D(centerPt));

	Point2f pointOnCircle;
	float R = 167;
	pointOnCircle = intersectionCircleLine(centerPt, R, lineToCenter, intersection_contact);
	circle(inputImage, pointOnCircle, 2, Scalar(50, 90, 255), 2);
	float angleOfContact = 0;
	angleOfContact = descartes2PolarSystem(pointOnCircle, centerPt).y * 180 / PI;
	//cout << "Contact point possition: " << descartes2PolarSystem(pointOnCircle,centerPt) << endl;
	//cout << "Contact point angle:     " << angleOfContact << endl;
}



Point2f illustrateVec_point_direction(Mat& inputImage, char left, char right, char middle, vector<Point3f> savePoint, vector<Point3f> changedPoint)
{
	Point2f intersectionPt_leftRight, middlePt_leftRight;
	Point3f line_left, line_middle, line_right;
	Point3f lineComb_leftRight;
	Point2f v_left, v_right, v_middle;

	////// This part for contact location
	Point2f intersection_contact;
	v_left = vector2Point(changedPoint[left], savePoint[left]);
	v_right = vector2Point(changedPoint[right], savePoint[right]);
	line_left = lineEquation(changedPoint[left], savePoint[left]);
	line_right = lineEquation(changedPoint[right], savePoint[right]);
	line_middle = lineEquation(changedPoint[middle], savePoint[middle]);

	if (forceMagnitude(v_left) > forceMagnitude(v_right))
	{
		intersection_contact = intersection2line(line_middle, line_left);
	}
	else
	{
		intersection_contact = intersection2line(line_middle, line_right);
	}
	Point3f lineToCenter;
	lineToCenter = lineEquation(point2Dto3D(intersection_contact), point2Dto3D(centerPt));

	Point2f pointOnCircle;
	float R = 167;
	pointOnCircle = intersectionCircleLine(centerPt, R, lineToCenter, intersection_contact);
	circle(inputImage, pointOnCircle, 2, Scalar(50, 90, 255), 2);
	float angleOfContact = 0;
	angleOfContact = descartes2PolarSystem(pointOnCircle, centerPt).y * 180 / PI;
	//cout << "Contact point possition: " << descartes2PolarSystem(pointOnCircle,centerPt) << endl;
	//cout << "Contact point angle:     " << angleOfContact << endl;
	return pointOnCircle;
}



void checkMarker(vector<Point3f> savePoint, vector<Point3f>& changedPoint)
{
	char Up = 18;
	char Right = 12;
	char Down = 5;
	int min = 39;
	int max = 43;

	float distanceUp = distancePoint2Point(point3Dto2D(changedPoint[Up]), point3Dto2D(savePoint[Up]));
	float distanceRight = distancePoint2Point(point3Dto2D(changedPoint[Right]), point3Dto2D(savePoint[Right]));
	float distanceDown = distancePoint2Point(point3Dto2D(changedPoint[Down]), point3Dto2D(savePoint[Down]));
	//if ((changeUp > min && changeRight > min) and (changeUp > min && localDown > min) and (changeRight > min && localDown > min))
	if ((distanceUp > min) && (distanceRight > min) && (distanceDown > min))
	{
		//cout << "Change position: " << endl;
		if (savePoint[Up].x > changedPoint[Up].x)
		{
			//cout << " 0 -> 23 " << endl;		
			Point3f temp;
			temp = changedPoint[changedPoint.size() - 1];
			temp.z = 0;
			// cout << " Pass here " << endl;
			changedPoint.erase(changedPoint.begin() + (changedPoint.size() - 1));
			// cout << " Pass here erase -- - - - " << endl;

			for (int i = 1; i < changedPoint.size() + 1; i++)
			{
				changedPoint[i - 1].z = i;
				//cout << i << endl;
			}
			//cout << "change " << changedPoint << endl;
			reverse(changedPoint.begin(), changedPoint.end());
			changedPoint.push_back(temp);
			reverse(changedPoint.begin(), changedPoint.end());
		}
		else if (savePoint[Up].x < changedPoint[Up].x)
		{
			cout << " n -> 0 " << endl;
			Point3f temp;
			temp = changedPoint[0];
			temp.z = changedPoint.size() - 1;
			changedPoint.erase(changedPoint.begin());
			for (int i = 0; i < changedPoint.size(); i++)
			{
				changedPoint[i].z = i;
			}
			changedPoint.push_back(temp);
		}
	}
}

float delta_degree(Point2f contactPt_descar, Point2f nearest_marker)
{
	Point2f contact = descartes2PolarSystem_2f(contactPt_descar, centerPt);
	Point2f nearest = descartes2PolarSystem_2f(nearest_marker, centerPt);
	float degree = (abs(contact.y - nearest.y)) * 180 / PI;
	return degree;
}

float distanceChangeAB(Point3f changePoint, Point3f originalPoint)
{
	// This function can return the angleOAB
	// It also can return def marker AB
	float AB = sqrt(pow(changePoint.x - originalPoint.x, 2) + pow(changePoint.y - originalPoint.y, 2));
	//std::cout << "AB : " << AB << endl;
	float OB = sqrt(pow(changePoint.x - centerPt.x, 2) + pow(changePoint.y - centerPt.y, 2));
	//std::cout << "OB : " << OB << endl;
	float OA = sqrt(pow(centerPt.x - originalPoint.x, 2) + pow(centerPt.y - originalPoint.y, 2));
	//std::cout << "OA : " << OA << endl;
	//std::cout << "distance point to point: " << AB << endl;
	float angleOAB = 0;
	angleOAB = acos((OB * OB - OA * OA - AB * AB) / (-2 * OA * AB));
	return AB;
}
void illustrate_force(Mat& inputImage, Point2f contact, Point2f center, float force)
{
	Point3f lineToCenter;
	lineToCenter = lineEquation(point2Dto3D(contact), point2Dto3D(centerPt));

	Point2f pointOnCircle;
	float R = 167 - force * 25;
	pointOnCircle = intersectionCircleLine(centerPt, R, lineToCenter, contact);
	arrowedLine(inputImage, contact, pointOnCircle, Scalar(0, 255, 0), 2, 8, 0);
	putText(inputImage, std::to_string(force), Point2f(centerPt.x, centerPt.y - 50), FONT_HERSHEY_DUPLEX, 0.5, Scalar(0, 0, 255), 1, 8);
}
void totalVector(Mat& inputImage, vector<int> contactList, vector<Point2f> displacement, vector<Point3f> savePoint, vector<Point3f> changedPoint)
{
	size_t left, middle, right;
	Point2f circlePoint_descar;
	float _degree = 0;
	float _deflection = 0;
	float _def = 0;
	float _F = 0;
	for (char i = 0; i < contactList.size(); i++)
	{
		if (displacement[contactList[i]].x != 0)
		{
			if (contactList[i] == (displacement.size() - 1))
			{
				left = displacement.size() - 2;
				middle = displacement.size() - 1;
				right = 0;
				circlePoint_descar = illustrateVec_point_direction(inputImage, left, right, middle, savePoint, changedPoint);
				illustrateVec_dir_3points(inputImage, left, right, middle, savePoint, changedPoint);
				_degree = delta_degree(circlePoint_descar, point3Dto2D(savePoint[contactList[i]]));
				_deflection = distanceChangeAB(changedPoint[contactList[i]], savePoint[contactList[i]]);
				_def = 1.2026 * _deflection + 0.3093 * _degree - 1.8857;
				_F = (-1.265 * exp(-0.2108 * _def) + 1.265) + 0.45;
				illustrate_force(inputImage, circlePoint_descar, centerPt, _F);
				cout << " Contact location: " << circlePoint_descar.x << " - " << circlePoint_descar.y << endl;
				cout << " Polar contact   : " << (descartes2PolarSystem(circlePoint_descar, centerPt).y) * 180 / PI << endl;
				cout << " Deflection      : " << _deflection << endl;
				cout << " _def            : " << _def << endl;
				cout << " _Force          : " << _F << endl;
			}
			else if (contactList[i] == 0)
			{
				left = displacement.size() - 1;
				middle = 0;
				right = 1;
				circlePoint_descar = illustrateVec_point_direction(inputImage, left, right, middle, savePoint, changedPoint);
				illustrateVec_dir_3points(inputImage, left, right, middle, savePoint, changedPoint);
				_degree = delta_degree(circlePoint_descar, point3Dto2D(savePoint[contactList[i]]));
				_deflection = distanceChangeAB(changedPoint[contactList[i]], savePoint[contactList[i]]);
				_def = 1.2026 * _deflection + 0.3093 * _degree - 1.8857;
				_F = (-1.265 * exp(-0.2108 * _def) + 1.265) + 0.45;
				illustrate_force(inputImage, circlePoint_descar, centerPt, _F);
				cout << " Contact location: " << circlePoint_descar.x << " - " << circlePoint_descar.y << endl;
				cout << " Polar contact   : " << (descartes2PolarSystem(circlePoint_descar, centerPt).y) * 180 / PI << endl;
				cout << " Deflection      : " << _deflection << endl;
				cout << " _def            : " << _def << endl;
				cout << " _Force          : " << _F << endl;
			}
			else
			{
				left = contactList[i] - 1;
				middle = contactList[i];
				right = contactList[i] + 1;
				circlePoint_descar = illustrateVec_point_direction(inputImage, left, right, middle, savePoint, changedPoint);
				illustrateVec_dir_3points(inputImage, left, right, middle, savePoint, changedPoint);
				_degree = delta_degree(circlePoint_descar, point3Dto2D(savePoint[contactList[i]]));
				_deflection = distanceChangeAB(changedPoint[contactList[i]], savePoint[contactList[i]]);
				_def = 1.2026 * _deflection + 0.3093 * _degree - 1.8857;
				_F = (-1.265 * exp(-0.2108 * _def) + 1.265) + 0.45;
				illustrate_force(inputImage, circlePoint_descar, centerPt, _F);
				cout << " Contact location: " << circlePoint_descar.x << " - " << circlePoint_descar.y << endl;
				cout << " Polar contact   : " << (descartes2PolarSystem(circlePoint_descar, centerPt).y) * 180 / PI << endl;
				cout << " Deflection      : " << _deflection << endl;
				cout << " _def            : " << _def << endl;
				cout << " _Force          : " << _F << endl;
			}
		}
	}
}

void locateMarker(Mat& inputImage, Mat& colorImage, vector<Point3f>& mPolar_reverse_descartes)
{

	vector<vector<Point>>contour;
	vector<Moments>mu;
	vector<Point2f>mC;
	vector<Point3f>mPolar;

	findContours(inputImage, contour, RETR_EXTERNAL, CHAIN_APPROX_SIMPLE);
	Mat show;
	show = inputImage.clone();

	mu.resize(contour.size());
	mC.resize(contour.size());
	mPolar.resize(contour.size());
	mPolar_reverse_descartes.resize(contour.size());


	//cout << "size contour: " << contour.size() << endl;
	//cout << "size moments: " << mu.size() << endl;
	//cout << "size mC     : " << mC.size() << endl;

	for (char i = 0; i < contour.size(); i++)
	{

		mu[i] = moments(contour[i], true);
		mC[i] = Point2f(static_cast<float>(mu[i].m10 / mu[i].m00), static_cast<float>(mu[i].m01 / mu[i].m00));
		//circle(colorImage, Point(mC[i].x, mC[i].y),1, Scalar(255, 0, 0), 1);
		//putText(colorImage, to_string(i), Point(mC[i].x - 10 , mC[i].y - 5 ), FONT_HERSHEY_COMPLEX, 0.5, Scalar(0, 0, 255), 1, 8,false);

		mPolar[i] = descartes2PolarSystem(mC[i], centerPt);
	}
	//cout << " mC: \n " << mC << endl;
	//cout << " un-sort mPolar\n: " << mPolar << endl;
	bubbleSort(mPolar);
	//cout << " sort mPolar\n: " << mPolar << endl;
	copy2array(mPolar, mPolar_reverse_descartes);
	for (char i = 0; i < contour.size(); i++)
	{
		polarSystem2descartes(mPolar_reverse_descartes[i], centerPt);
	}

	//cout << " reverse\n: " << mPolar_reverse_descartes << endl;

	for (char i = 0; i < mPolar_reverse_descartes.size(); i++)
	{
		for (char j = 0; j < mPolar_reverse_descartes.size(); j++)
		{
			if (i == mPolar_reverse_descartes[j].z)
			{
				// cout <<"ith: "<< mPolar_reverse[i].z << endl;
				circle(colorImage, Point2f(mPolar_reverse_descartes[i].x, mPolar_reverse_descartes[i].y), 1, Scalar(255, 0, 0), 1);
				//putText(colorImage, to_string(int(mPolar_reverse_descartes[i].z)), Point2f(mPolar_reverse_descartes[i].x, 
					//mPolar_reverse_descartes[i].y + 5), FONT_HERSHEY_COMPLEX, 0.5, Scalar(0, 0, 255), 1, 8, false);
			}
		}
	}
	drawCoordinatorCenter(centerPt, 50, colorImage);
	//cout << "located marker ---" << endl;
}


