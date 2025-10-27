#include "library.h"
int value_1 = 0;
int radius = 0;
int autoCenterPt_count = 0;
cv::Point2f centerPt = cv::Point2f(178.784f, 240.716f);

/*
 * //This is for needle object
float p00 = 0.001376;
float p10 = -0.0009747;
float p01 = 0.2349;
float p20 = 4.666e-06;
float p11 = 5.739e-05;
float p02 = -0.02487;
float p30 = 1.413e-07;
float p21 = -2.168e-06;
float p12 = -3.418e-07;
float p03 = 0.001515;
float p40 = -2.418e-10;
float p31 = 8.08e-10;
float p22 = 4.683e-08;
float p13 = -2.089e-07;
float p04 = -4.631e-05;
float p50 = -4.003e-12;
float p41 = 3.14e-11;
float p32 = -3.508e-11;
float p23 = -2.382e-10;
float p14 = 7.447e-09;
float p05 = 5.603e-07;
*/
float p00 = 0.3387;
float p10 = 0.0008463;
float p01 = -0.01526;
float p20 = 4.298e-06;
float p11 = -0.0001176;
float p02 = 0.03516;
float p30 = -1.716e-08;
float p21 = -1.968e-06;
float p12 = 1.185e-05;
float p03 = -0.001097;

void sizeImage(cv::Mat image, std::string name)
{
	std::cout << name << " : " << image.size() << endl;
}

void framePerSecond(cv::VideoCapture video, std::string name)
{
	std::cout << name << "fps: " << video.get(cv::CAP_PROP_FPS) << endl;
}

void denoiseImage(cv::Mat &inputImage, int cols, int rows)
{
	
	cvtColor(inputImage, inputImage, cv::COLOR_BGR2HSV);
	inRange(inputImage, cv::Scalar(0, 90, 95), cv::Scalar(40, 255, 255), inputImage);
	//inRange(inputImage, Scalar(165, 0, 0), Scalar(255, 255, 255), inputImage);
	//cv::imshow("image input", inputImage);
	
	erode(inputImage, inputImage, cv::getStructuringElement(cv::MORPH_ELLIPSE, cv::Size(3, 3)));
	dilate(inputImage, inputImage, cv::getStructuringElement(cv::MORPH_OPEN, cv::Size(5, 5)));
        GaussianBlur(inputImage, inputImage, cv::Size(3, 3), 0, 0, cv::BORDER_DEFAULT);
        fillImage(inputImage, cols, rows);
}

void denoiseImage_trackbar(cv::Mat& inputImage)
{

	cvtColor(inputImage, inputImage, cv::COLOR_BGR2RGB);
	cvtColor(inputImage, inputImage, cv::COLOR_RGB2GRAY);
	
	erode(inputImage, inputImage, cv::getStructuringElement(cv::MORPH_ELLIPSE, cv::Size(int(1.5), int(1.5))));
	dilate(inputImage, inputImage, cv::getStructuringElement(cv::MORPH_OPEN, cv::Size(1, 1)));

	//std::cout << "value 1:  " << value_1 << endl;
	inRange(inputImage, cv::Scalar(value_1, 0, 0), cv::Scalar(255, 255, 255), inputImage);
	GaussianBlur(inputImage, inputImage, cv::Size(3, 3), 0, 0, cv::BORDER_DEFAULT);

	Canny(inputImage, inputImage, 60, 100, 3);
	inputImage.convertTo(inputImage, CV_8U);
}

void fillImage_trackbar(cv::Mat& inputImage, int imageWidth, int imageHeight)
{
	cv::Point2f cen;
	cen.x = float(imageWidth / 2);
	cen.y = float(imageHeight / 2);
	circle(inputImage,cen,radius, cv::Scalar(0,0,0),-1);
}

void trackbarName()
{
	cv::namedWindow("Threshold", cv::WINDOW_AUTOSIZE);
	cv::createTrackbar("LowH", "Control", &value_1, 179);
	cv::namedWindow("Radius", cv::WINDOW_AUTOSIZE);
	cv::createTrackbar("Radius", "Table", &radius, 179);
}

void fillImage(cv::Mat& inputImage, int imageWidth, int imageHeight)
{
	circle(inputImage, cv::Point2f(float(imageWidth / 2), float(imageHeight / 2)), 200, cv::Scalar(0, 0, 0), -1);
}


cv::Point2f center(vector<cv::Point2f>mC)
{
	float x_center = 0, y_center = 0;
	int numberPt = mC.size();
	cv::Point2f newCenter;
	for (int i = 0; i < mC.size(); i++)
	{
		x_center = x_center + mC[i].x;
		y_center = y_center + mC[i].y;
	}
	newCenter = cv::Point2f(float(x_center / numberPt), float(y_center / numberPt));
	std::cout << "newCenter: " << newCenter << endl;
	return newCenter;
}

float distancePoint2Point(cv::Point2f beginPt, cv::Point2f endPt)
{
	return sqrtf(pow(beginPt.x - endPt.x,2)+pow(beginPt.y - endPt.y,2));
}

cv::Point2f changeCoordinate(cv::Point2f newCoordinate, cv::Point2f pt)
{
	return cv::Point2f(pt.x - newCoordinate.x, pt.y - newCoordinate.y);
}

cv::Point3f descartes2PolarSystem(cv::Point2f inputPt, cv::Point2f centerPolar)
{
	cv::Point2f polarPt = changeCoordinate(centerPolar, inputPt);
	cv::Point2f newPolarCoordinate = cv::Point2f(0, 0);
	float r = distancePoint2Point(polarPt, newPolarCoordinate);
	float phi = atan2(polarPt.y, polarPt.x);

	return cv::Point3f(r,phi,0);
}

void polarSystem2descartes(cv::Point3f &inputPolarPt, cv::Point2f center)
{
	float xDescartes = inputPolarPt.x * cosf(inputPolarPt.y);
	float yDescartes = inputPolarPt.x * sinf(inputPolarPt.y);
	int ith = inputPolarPt.z;
	inputPolarPt = cv::Point3f(float(xDescartes + center.x), float(yDescartes + center.y), int(ith));
}
void copy2array(vector<cv::Point3f> sourceArray, vector<cv::Point3f>& destinationArray)
{
	destinationArray.resize(sourceArray.size());
	for (int i = 0; i < sourceArray.size(); i++)
	{		
		destinationArray[i].x = sourceArray[i].x;
		destinationArray[i].y = sourceArray[i].y;
		destinationArray[i].z = sourceArray[i].z;		
	}
	//std::cout << "copy2Array" << endl;
}
cv::Point3f calculateChange(cv::Point3f savePoint_descartes, cv::Point3f changedPoint_descartes)
{
	// x : value in X axis
	// y : value in Y axis
	// z : the order of point
	float x = savePoint_descartes.x - changedPoint_descartes.x;
	float y = savePoint_descartes.y - changedPoint_descartes.y;
	int ith = savePoint_descartes.z;
	return cv::Point3f(x,y,ith);
}

void displacementArray(vector<cv::Point3f>saveArray_descartes, vector<cv::Point3f>changedArray_descartes, vector<cv::Point2f>&outDisplace, bool draw_is, cv::Mat& inputImage)
{
	// if draw_is is true : arrow be draw on the image
	
	// std::cout << "size of save: " << saveArray_descartes.size() << endl;
	// std::cout << "size of save: " << changedArray_descartes.size() << endl;
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
	// std::cout << "break: " << breakPoint;
	for (int i = 0; i < breakPoint; i++)
	{
		if (breakPoint == 0) break;
		cv::Point2f temp;
		temp.x = sqrt(pow((saveArray_descartes[i].x - changedArray_descartes[i].x), 2) +
			pow((saveArray_descartes[i].y - changedArray_descartes[i].y), 2));

		if (temp.x < 1.5) temp.x = 0;
		temp.y = saveArray_descartes[i].z;
		outDisplace.push_back(temp);
		
		if (draw_is == true)
		{
			arrowedLine(inputImage, cv::Point2f(saveArray_descartes[i].x, saveArray_descartes[i].y),
				cv::Point2f(changedArray_descartes[i].x, changedArray_descartes[i].y), cv::Scalar(100, 255, 255), 2, 8, 0, 0.1);
			putText(inputImage, to_string(int(changedArray_descartes[i].z)), cv::Point2f(changedArray_descartes[i].x,
				changedArray_descartes[i].y + 5), cv::FONT_HERSHEY_COMPLEX, 0.5, cv::Scalar(0, 0, 255), 1, 8, false);
		}
		// std::cout << " pass 1 - b " << endl;
	}
	// std::cout << " pass 1 - c " << endl;
}

float estimateForce_onMarker(vector<int>& contactList, vector<float>& forceList, vector<cv::Point3f> changedPoint)
{
	for (int i = 0; i < contactList.size(); i++)
	{
		cv::Point3f contactPoint;
		std::cout <<"Contact: " << contactList[i] << endl;
		std::cout << "Change Point: " << changedPoint[contactList[i]] << endl;
		contactPoint = descartes2PolarSystem(cv::Point2f(changedPoint[contactList[i]].x, changedPoint[contactList[i]].y), centerPt);
		std::cout << "Decaster to polar system: " << endl;
		std::cout << "R : " << contactPoint.x;
		std::cout << " -- theta : " << contactPoint.y <<endl;
		

	}
	return 0;
}

void bubbleSort(vector<cv::Point3f> &inputArray)
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
				cv::Point3f temp = inputArray[i];
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



void drawCoordinatorCenter(cv::Point2f center,  int lenghtArrow, cv::Mat &inputImage)
{
	cv::Point2f stopArrowX = cv::Point2f(center.x + lenghtArrow, center.y );
	cv::Point2f stopArrowY = cv::Point2f(center.x , center.y + lenghtArrow);
	putText(inputImage, "X", cv::Point(stopArrowX.x , stopArrowX.y + 10 ), cv::FONT_HERSHEY_COMPLEX, 0.5, cv::Scalar(0, 0, 255), 1, 8, false);
	arrowedLine(inputImage, center, stopArrowX, cv::Scalar(0, 255, 0),1.5, 8, 0, 0.1);
	putText(inputImage, "Y", cv::Point(stopArrowY.x - 10 , stopArrowY.y), cv::FONT_HERSHEY_COMPLEX, 0.5, cv::Scalar(0, 0, 255), 1, 8, false);
	arrowedLine(inputImage, center, stopArrowY, cv::Scalar(0, 255, 0), 1.5, 8, 0, 0.1);
}

void findHighPoint(vector<cv::Point2f> displacement, vector<int> &contactPoint)
{
	int k = 0;
	//contactPoint.resize(displacement.size()/2);
	for (int i = 0; i < (displacement.size()-2); i++)
	{
		float firstPt = displacement[i].x;
		float middlePt = displacement[i + 1].x;
		float third = displacement[i + 2].x;

		if ((middlePt > firstPt) && (middlePt > third))
		{
			contactPoint.push_back(displacement[i + 1].y);
		}
	}

	float first = displacement[displacement.size()-2].x;
	float middle = displacement[displacement.size() - 1].x;
	float third = displacement[0].x;

	if ((middle > first) && (middle > third))
	{
		contactPoint.push_back(displacement[displacement.size() - 1].y);
	}
	first = displacement[displacement.size() -1].x;
	middle = displacement[0].x;
	third = displacement[1].x;
	if ((middle > first) && (middle > third))
	{
		contactPoint.push_back(displacement[0].y);
	}
	/*
	std::cout << "contact point " << endl;
	for (int i = 0; i < contactPoint.size(); i++)
	{
		std::cout << contactPoint[i] << endl;
	}
	*/
}

cv::Point2f intersection2line(cv::Point3f v1, cv::Point3f v2)
{
	float x_center0 = -(v1.z - v2.z) / (v1.x - v2.x);
	float y_center0 = v1.x * x_center0 + v1.z;
	return cv::Point2f(x_center0, y_center0);
}

cv::Point3f lineEquation(cv::Point3f startPt, cv::Point3f endPt)
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
	return cv::Point3f(a, -1, b);
}

cv::Point2f Kpoint(cv::Point3f bPt, cv::Point3f dPt)
{
	float x = 0.5 *(static_cast<double>(bPt.x) + (dPt.x));
	float y = 0.5 * (static_cast<double>(bPt.y) + (dPt.y));
	return cv::Point2f(x,y);
}

cv::Point2f Kpoint2f(cv::Point3f bPt, cv::Point3f dPt)
{
	float x = 0.5 * (static_cast<double>(bPt.x) + dPt.x);
	float y = 0.5 * (bPt.y + dPt.y);
	return cv::Point2f(x, y);
}

float forceMagnitude(cv::Point2f vec)
{
	return sqrt(pow(vec.x, 2) + pow(vec.y, 2));
}

float force2vector(cv::Point2f v1, cv::Point2f v2)
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
	//std::cout << "mag v1: " << F1 << endl;
	//std::cout << "mag v2: " << F2 << endl;
	if (denominator == NAN) return 0;
	
	float cos_v1v2 = numerator / denominator;
	//std::cout << "cos_v1v2: " << cos_v1v2 << endl;
	float force = sqrt(pow(F1, 2) + pow(F2, 2) + 2 * cos_v1v2 * F1 * F2);
	return force;
}
cv::Point2f vector2Point(cv::Point3f startPt, cv::Point3f endPt)
{
	return cv::Point2f(endPt.x - startPt.x, endPt.y - startPt.y);
}
cv::Point2f intersectionCircleLine(cv::Point2f circleCenter, float cirleRadius, cv::Point3f line, cv::Point2f refPt)
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
	cv::Point2f root1(rootX1, rootY1);
	cv::Point2f root2(rootX2, rootY2);
	//std::cout << " Point 1 : " << root1 << endl;
	//std::cout << " Point 2 : " << root2 << endl;
	float distance1 = distancePoint2Point(root1, refPt);
	float distance2 = distancePoint2Point(root2, refPt);
	if (distance1 > distance2)
	{
		return root2;
	}
	else return root1;

	return cv::Point2f(0,0);
}


void drawStraightLine(cv::Mat inputImg, cv::Point2f p1, cv::Point2f p2, cv::Scalar color)
{
	cv::Point2f p, q;
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
cv::Point3f point2Dto3D(cv::Point2f input)
{
	return cv::Point3f(input.x, input.y, 0);
}
cv::Point2f point3Dto2D(cv::Point3f input)
{
	return cv::Point2f(input.x, input.y);
}
float illustrateVec_point(cv::Mat& inputImage, char left, char right, char middle, vector<cv::Point3f> savePoint, vector<cv::Point3f> changedPoint)
{
	cv::Point2f intersectionPt_leftRight, middlePt_leftRight;
	cv::Point3f line_left, line_middle, line_right;
	cv::Point3f lineComb_leftRight;
	cv::Point2f v_left, v_right, v_middle;

	////// This part for contact location
	cv::Point2f intersection_contact;
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
	cv::Point3f lineToCenter;
	lineToCenter = lineEquation(point2Dto3D(intersection_contact), point2Dto3D(centerPt));

	cv::Point2f pointOnCircle;
	float R = 167;
	pointOnCircle = intersectionCircleLine(centerPt, R, lineToCenter, intersection_contact);
	circle(inputImage, pointOnCircle, 2, cv::Scalar(50, 90, 255), 2);
	float angleOfContact = 0;
	angleOfContact = descartes2PolarSystem(pointOnCircle, centerPt).y * 180 / PI;
	//std::cout << "Contact point possition: " << descartes2PolarSystem(pointOnCircle,centerPt) << endl;
	std::cout << "Contact point angle:     " << angleOfContact << endl;
	return angleOfContact;
}
cv::Point2f illustrateVec_point2f(cv::Mat& inputImage, char left, char right, char middle, vector<cv::Point3f> savePoint, vector<cv::Point3f> changedPoint)
{
	cv::Point2f intersectionPt_leftRight, middlePt_leftRight;
	cv::Point3f line_left, line_middle, line_right;
	cv::Point3f lineComb_leftRight;
	cv::Point2f v_left, v_right, v_middle;

	////// This part for contact location
	cv::Point2f intersection_contact;
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
	cv::Point3f lineToCenter;
	lineToCenter = lineEquation(point2Dto3D(intersection_contact), point2Dto3D(centerPt));

	cv::Point2f pointOnCircle;
	float R = 167;
	pointOnCircle = intersectionCircleLine(centerPt, R, lineToCenter, intersection_contact);
	circle(inputImage, pointOnCircle, 2, cv::Scalar(50, 90, 255), 2);
	float angleOfContact = 0;
	angleOfContact = descartes2PolarSystem(pointOnCircle, centerPt).y * 180 / PI;
	//cout << "Contact point possition: " << descartes2PolarSystem(pointOnCircle,centerPt) << endl;
	//cout << "Contact point angle:     " << angleOfContact << endl;
	return pointOnCircle;
}




void checkMarker(vector<cv::Point3f> savePoint, vector<cv::Point3f> &changedPoint)
{
	char Up = 18;
	char Right = 12;
	char Down = 5;
	int min = 39;
	int max = 43;
	
	float distanceUp = distancePoint2Point(point3Dto2D(changedPoint[Up]),point3Dto2D(savePoint[Up]));
	float distanceRight = distancePoint2Point(point3Dto2D(changedPoint[Right]), point3Dto2D(savePoint[Right]));
	float distanceDown = distancePoint2Point(point3Dto2D(changedPoint[Down]), point3Dto2D(savePoint[Down]));
	//if ((changeUp > min && changeRight > min) and (changeUp > min && localDown > min) and (changeRight > min && localDown > min))
	if ((distanceUp > min) && (distanceRight > min) && (distanceDown > min))
	{
		//std::cout << "Change position: " << endl;
		if (savePoint[Up].x > changedPoint[Up].x)
		{
			//std::cout << " 0 -> 23 " << endl;		
			cv::Point3f temp;
			temp = changedPoint[changedPoint.size() - 1];
			temp.z = 0;
			// std::cout << " Pass here " << endl;
			changedPoint.erase(changedPoint.begin() + (changedPoint.size() - 1));
			// std::cout << " Pass here erase -- - - - " << endl;
			
			for (int i = 1; i < changedPoint.size()+1; i++)
			{
				changedPoint[i-1].z = i;
				//std::cout << i << endl;
			}
			//std::cout << "change " << changedPoint << endl;
			reverse(changedPoint.begin(), changedPoint.end());
			changedPoint.push_back(temp);
			reverse(changedPoint.begin(), changedPoint.end());
		}
		else if (savePoint[Up].x < changedPoint[Up].x)
		{
			//std::cout << " n -> 0 " << endl;
			cv::Point3f temp;
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

cv::Point2f descartes2PolarSystem_2f(cv::Point2f inputPt, cv::Point2f centerPolar)
{
	cv::Point2f polarPt = changeCoordinate(centerPolar, inputPt);
	cv::Point2f newPolarCoordinate = cv::Point2f(0, 0);
	float r = distancePoint2Point(polarPt, newPolarCoordinate);
	float phi = atan2(polarPt.y, polarPt.x);

	return cv::Point2f(r, phi);
}

float delta_degree(cv::Point2f contactPt_descar, cv::Point2f nearest_marker)
{
	cv::Point2f contact = descartes2PolarSystem_2f(contactPt_descar, centerPt);
	cv::Point2f nearest = descartes2PolarSystem_2f(nearest_marker, centerPt);
	float degree = (abs(contact.y - nearest.y)) * 180 / PI;
	return degree;
}

float distanceChangeAB(cv::Point3f changePoint, cv::Point3f originalPoint)
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

void illustrate_force(cv::Mat& inputImage, cv::Point2f contact, cv::Point2f center, float force)
{
	cv::Point3f lineToCenter;
	lineToCenter = lineEquation(point2Dto3D(contact), point2Dto3D(centerPt));

	cv::Point2f pointOnCircle;
	float R = 167 - force * 25;
	pointOnCircle = intersectionCircleLine(centerPt, R, lineToCenter, contact);
	arrowedLine(inputImage, contact, pointOnCircle, cv::Scalar(0, 255, 0), 2, 8, 0);
	putText(inputImage, std::to_string(force), cv::Point2f(centerPt.x, centerPt.y - 50), cv::FONT_HERSHEY_DUPLEX, 0.5, cv::Scalar(0, 0, 255), 1, 8);
}

float estimateForce(float angle, float DisNearest)
{
	float force = 0;
	float pow_angle2 = pow(angle, 2);
	float pow_angle3 = pow_angle2 * angle;
	float pow_dis2 = pow(DisNearest, 2);
	float pow_dis3 = pow_dis2 * DisNearest;
	force = p00 + p10 * angle + p01 * DisNearest + p20 * pow_angle2 +
		p11 * angle * DisNearest + p02 * pow_dis2 + p30 * pow_angle3 +
		p21 * pow_angle2 * DisNearest + p12 * angle * pow_dis2 + p03 * pow_dis3;

	std::cout << "Result of " << to_string(angle) << " - " << to_string(DisNearest) << " : " << force << endl;

	return force;
}

void totalVector(cv::Mat& inputImage, vector<int> contactList, vector<cv::Point2f> displacement, vector<cv::Point3f> savePoint, vector<cv::Point3f> changedPoint,float &transfer)
{	
	size_t left, middle, right;
	cv::Point2f circlePoint_descar;
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
				transfer = illustrateVec_point(inputImage, left, right, middle, savePoint, changedPoint);
				
				/*
				////Force version2
				float distanceNearest = distanceChangeAB(changedPoint[contactList[middle]], savePoint[contactList[middle]]);
				
				_F = estimateForce( transfer,  distanceNearest);
				//Note: transfer is contact angle value
				circlePoint_descar = illustrateVec_point2f(inputImage, left, right, middle, savePoint, changedPoint);
				_degree = delta_degree(circlePoint_descar, point3Dto2D(savePoint[contactList[i]]));
				illustrate_force(inputImage, circlePoint_descar, centerPt, _F);
				cout << " Contact location: " << circlePoint_descar.x << " - " << circlePoint_descar.y << endl;
				cout << " Polar contact   : " << (descartes2PolarSystem(circlePoint_descar, centerPt).y) * 180 / PI << endl;
				//cout << " Deflection      : " << _deflection << endl;
				cout << " distanceNearest : " << distanceNearest<< endl;
				cout << " _Force          : " << _F << endl;
				*/
				//// Force version1
				
				circlePoint_descar = illustrateVec_point2f(inputImage, left, right, middle, savePoint, changedPoint);
				_degree = delta_degree(circlePoint_descar, point3Dto2D(savePoint[contactList[i]]));				
				_deflection = distanceChangeAB(changedPoint[contactList[i]], savePoint[contactList[i]]);
				//_def = 1.2026 * _deflection + 0.3093 * _degree - 1.8857;
				//_F = (-1.265 * exp(-0.2108 * _def) + 1.265) + 0.45;
				_F = estimateForce( transfer,  _deflection);
				illustrate_force(inputImage, circlePoint_descar, centerPt, _F);
				cout << " Contact location: " << circlePoint_descar.x << " - " << circlePoint_descar.y << endl;
				cout << " Polar contact   : " << (descartes2PolarSystem(circlePoint_descar, centerPt).y) * 180 / PI << endl;
				cout << " Deflection      : " << _deflection << endl;
				cout << " Transfer        : " << transfer << endl;
				//cout << " _def            : " << _def << endl;
				cout << " _Force          : " << _F << endl;
				
			}
			else if (contactList[i] == 0)
			{
				left = displacement.size() - 1;
				middle = 0;
				right = 1;
				transfer = illustrateVec_point(inputImage, left, right, middle, savePoint, changedPoint);


				
				/*
				////Force version2
				float distanceNearest = distanceChangeAB(changedPoint[contactList[middle]], savePoint[contactList[middle]]);
				
				_F = estimateForce( transfer,  distanceNearest);
				//Note: transfer is contact angle value
				circlePoint_descar = illustrateVec_point2f(inputImage, left, right, middle, savePoint, changedPoint);
				_degree = delta_degree(circlePoint_descar, point3Dto2D(savePoint[contactList[i]]));
				illustrate_force(inputImage, circlePoint_descar, centerPt, _F);
				cout << " Contact location: " << circlePoint_descar.x << " - " << circlePoint_descar.y << endl;
				cout << " Polar contact   : " << (descartes2PolarSystem(circlePoint_descar, centerPt).y) * 180 / PI << endl;
				//cout << " Deflection      : " << _deflection << endl;
				cout << " distanceNearest : " << distanceNearest<< endl;
				cout << " _Force          : " << _F << endl;
				*/
				
				///// Force
				circlePoint_descar = illustrateVec_point2f(inputImage, left, right, middle, savePoint, changedPoint);
				_degree = delta_degree(circlePoint_descar, point3Dto2D(savePoint[contactList[i]]));
				_deflection = distanceChangeAB(changedPoint[contactList[i]], savePoint[contactList[i]]);
				//_def = 1.2026 * _deflection + 0.3093 * _degree - 1.8857;
				//_F = (-1.265 * exp(-0.2108 * _def) + 1.265) + 0.45;
				
				_F = estimateForce( transfer ,_deflection);
				illustrate_force(inputImage, circlePoint_descar, centerPt, _F);
				cout << " Contact location: " << circlePoint_descar.x << " - " << circlePoint_descar.y << endl;
				cout << " Polar contact   : " << (descartes2PolarSystem(circlePoint_descar, centerPt).y) * 180 / PI << endl;
				cout << " Deflection      : " << _deflection << endl;
				cout << " Transfer        : " << transfer << endl;
				//cout << " _def            : " << _def << endl;
				cout << " _Force          : " << _F << endl;
				
			}
			else 
			{
				left = contactList[i] - 1;
				middle = contactList[i];
				right = contactList[i] + 1;
				transfer = illustrateVec_point(inputImage, left, right, middle, savePoint, changedPoint);
				
					/*		
				////Force version2
				float distanceNearest = distanceChangeAB(changedPoint[contactList[middle]], savePoint[contactList[middle]]);
				
				_F = estimateForce( transfer,  distanceNearest);
				//Note: transfer is contact angle value
				circlePoint_descar = illustrateVec_point2f(inputImage, left, right, middle, savePoint, changedPoint);
				_degree = delta_degree(circlePoint_descar, point3Dto2D(savePoint[contactList[i]]));
				illustrate_force(inputImage, circlePoint_descar, centerPt, _F);
				cout << " Contact location: " << circlePoint_descar.x << " - " << circlePoint_descar.y << endl;
				cout << " Polar contact   : " << (descartes2PolarSystem(circlePoint_descar, centerPt).y) * 180 / PI << endl;
				//cout << " Deflection      : " << _deflection << endl;
				cout << " distanceNearest : " << distanceNearest<< endl;
				cout << " _Force          : " << _F << endl;
				*/
				
				////Force
				circlePoint_descar = illustrateVec_point2f(inputImage, left, right, middle, savePoint, changedPoint);
				_degree = delta_degree(circlePoint_descar, point3Dto2D(savePoint[contactList[i]]));
				_deflection = distanceChangeAB(changedPoint[contactList[i]], savePoint[contactList[i]]);
				//_def = 1.2026 * _deflection + 0.3093 * _degree - 1.8857;
				//_F = (-1.265 * exp(-0.2108 * _def) + 1.265) + 0.45;
				
				_F = estimateForce( transfer ,_deflection);
				illustrate_force(inputImage, circlePoint_descar, centerPt, _F);
				cout << " Contact location: " << circlePoint_descar.x << " - " << circlePoint_descar.y << endl;
				cout << " Polar contact   : " << (descartes2PolarSystem(circlePoint_descar, centerPt).y) * 180 / PI << endl;
				cout << " Deflection      : " << _deflection << endl;
				cout << " Transfer        : " << transfer << endl;
				//cout << " _def            : " << _def << endl;
				cout << " _Force          : " << _F << endl;
				
			}
		}
	}
}

void totalVector(cv::Mat& inputImage, vector<int> contactList, vector<cv::Point2f> displacement, vector<cv::Point3f> savePoint, vector<cv::Point3f> changedPoint,string &transfer_string)
{	
	size_t left, middle, right;
	cv::Point2f circlePoint_descar;
	float _degree = 0;
	float _deflection = 0;
	float _def = 0;
	float _F = 0;
	float transfer =0;

		for (char i = 0; i < contactList.size(); i++)
		{ 
			if (displacement[contactList[i]].x != 0)
			{
				if (contactList[i] == (displacement.size() - 1))
				{
					left = displacement.size() - 2;
					middle = displacement.size() - 1;
					right = 0;
					transfer = illustrateVec_point(inputImage, left, right, middle, savePoint, changedPoint);
					
					/*
					////Force version2
					float distanceNearest = distanceChangeAB(changedPoint[contactList[middle]], savePoint[contactList[middle]]);
					
					_F = estimateForce( transfer,  distanceNearest);
					//Note: transfer is contact angle value
					circlePoint_descar = illustrateVec_point2f(inputImage, left, right, middle, savePoint, changedPoint);
					_degree = delta_degree(circlePoint_descar, point3Dto2D(savePoint[contactList[i]]));
					illustrate_force(inputImage, circlePoint_descar, centerPt, _F);
					cout << " Contact location: " << circlePoint_descar.x << " - " << circlePoint_descar.y << endl;
					cout << " Polar contact   : " << (descartes2PolarSystem(circlePoint_descar, centerPt).y) * 180 / PI << endl;
					//cout << " Deflection      : " << _deflection << endl;
					cout << " distanceNearest : " << distanceNearest<< endl;
					cout << " _Force          : " << _F << endl;
					*/
					//// Force version1
					
					circlePoint_descar = illustrateVec_point2f(inputImage, left, right, middle, savePoint, changedPoint);
					_degree = delta_degree(circlePoint_descar, point3Dto2D(savePoint[contactList[i]]));				
					_deflection = distanceChangeAB(changedPoint[contactList[i]], savePoint[contactList[i]]);
					//_def = 1.2026 * _deflection + 0.3093 * _degree - 1.8857;
					//_F = (-1.265 * exp(-0.2108 * _def) + 1.265) + 0.45;
					_F = estimateForce( transfer,  _deflection);
					illustrate_force(inputImage, circlePoint_descar, centerPt, _F);
					cout << " Contact location: " << circlePoint_descar.x << " - " << circlePoint_descar.y << endl;
					cout << " Polar contact   : " << (descartes2PolarSystem(circlePoint_descar, centerPt).y) * 180 / PI << endl;
					cout << " Deflection      : " << _deflection << endl;
					cout << " Transfer        : " << transfer << endl;
					//cout << " _def            : " << _def << endl;
					cout << " _Force          : " << _F << endl;
					
				}
				else if (contactList[i] == 0)
				{
					left = displacement.size() - 1;
					middle = 0;
					right = 1;
					transfer = illustrateVec_point(inputImage, left, right, middle, savePoint, changedPoint);


					
					/*
					////Force version2
					float distanceNearest = distanceChangeAB(changedPoint[contactList[middle]], savePoint[contactList[middle]]);
					
					_F = estimateForce( transfer,  distanceNearest);
					//Note: transfer is contact angle value
					circlePoint_descar = illustrateVec_point2f(inputImage, left, right, middle, savePoint, changedPoint);
					_degree = delta_degree(circlePoint_descar, point3Dto2D(savePoint[contactList[i]]));
					illustrate_force(inputImage, circlePoint_descar, centerPt, _F);
					cout << " Contact location: " << circlePoint_descar.x << " - " << circlePoint_descar.y << endl;
					cout << " Polar contact   : " << (descartes2PolarSystem(circlePoint_descar, centerPt).y) * 180 / PI << endl;
					//cout << " Deflection      : " << _deflection << endl;
					cout << " distanceNearest : " << distanceNearest<< endl;
					cout << " _Force          : " << _F << endl;
					*/
					
					///// Force
					circlePoint_descar = illustrateVec_point2f(inputImage, left, right, middle, savePoint, changedPoint);
					_degree = delta_degree(circlePoint_descar, point3Dto2D(savePoint[contactList[i]]));
					_deflection = distanceChangeAB(changedPoint[contactList[i]], savePoint[contactList[i]]);
					//_def = 1.2026 * _deflection + 0.3093 * _degree - 1.8857;
					//_F = (-1.265 * exp(-0.2108 * _def) + 1.265) + 0.45;
					
					_F = estimateForce( transfer ,_deflection);
					illustrate_force(inputImage, circlePoint_descar, centerPt, _F);
					cout << " Contact location: " << circlePoint_descar.x << " - " << circlePoint_descar.y << endl;
					cout << " Polar contact   : " << (descartes2PolarSystem(circlePoint_descar, centerPt).y) * 180 / PI << endl;
					cout << " Deflection      : " << _deflection << endl;
					cout << " Transfer        : " << transfer << endl;
					//cout << " _def            : " << _def << endl;
					cout << " _Force          : " << _F << endl;
					
				}
				else 
				{
					left = contactList[i] - 1;
					middle = contactList[i];
					right = contactList[i] + 1;
					transfer = illustrateVec_point(inputImage, left, right, middle, savePoint, changedPoint);
					
						/*		
					////Force version2
					float distanceNearest = distanceChangeAB(changedPoint[contactList[middle]], savePoint[contactList[middle]]);
					
					_F = estimateForce( transfer,  distanceNearest);
					//Note: transfer is contact angle value
					circlePoint_descar = illustrateVec_point2f(inputImage, left, right, middle, savePoint, changedPoint);
					_degree = delta_degree(circlePoint_descar, point3Dto2D(savePoint[contactList[i]]));
					illustrate_force(inputImage, circlePoint_descar, centerPt, _F);
					cout << " Contact location: " << circlePoint_descar.x << " - " << circlePoint_descar.y << endl;
					cout << " Polar contact   : " << (descartes2PolarSystem(circlePoint_descar, centerPt).y) * 180 / PI << endl;
					//cout << " Deflection      : " << _deflection << endl;
					cout << " distanceNearest : " << distanceNearest<< endl;
					cout << " _Force          : " << _F << endl;
					*/
					
					////Force
					circlePoint_descar = illustrateVec_point2f(inputImage, left, right, middle, savePoint, changedPoint);
					_degree = delta_degree(circlePoint_descar, point3Dto2D(savePoint[contactList[i]]));
					_deflection = distanceChangeAB(changedPoint[contactList[i]], savePoint[contactList[i]]);
					//_def = 1.2026 * _deflection + 0.3093 * _degree - 1.8857;
					//_F = (-1.265 * exp(-0.2108 * _def) + 1.265) + 0.45;
					
					_F = estimateForce( transfer ,_deflection);
					illustrate_force(inputImage, circlePoint_descar, centerPt, _F);
					cout << " Contact location: " << circlePoint_descar.x << " - " << circlePoint_descar.y << endl;
					cout << " Polar contact   : " << (descartes2PolarSystem(circlePoint_descar, centerPt).y) * 180 / PI << endl;
					cout << " Deflection      : " << _deflection << endl;
					cout << " Transfer        : " << transfer << endl;
					//cout << " _def            : " << _def << endl;
					cout << " _Force          : " << _F << endl;
					
				}
				string temp = to_string((float)transfer) + "," + to_string((float)_F);
				transfer_string = transfer_string + temp + ";";
			}
		}

}


void locateMarker(cv::Mat &inputImage, cv::Mat &colorImage, vector<cv::Point3f>&mPolar_reverse_descartes)
{

	vector<vector<cv::Point>>contour;
	vector<cv::Moments>mu;
	vector<cv::Point2f>mC;
	vector<cv::Point3f>mPolar;

	findContours(inputImage, contour, cv::RETR_EXTERNAL, cv::CHAIN_APPROX_SIMPLE);
	cv::Mat show;
	show = inputImage.clone();

	mu.resize(contour.size());
	mC.resize(contour.size());
	mPolar.resize(contour.size());
	mPolar_reverse_descartes.resize(contour.size());

	
	//std::cout << "size contour: " << contour.size() << endl;
	//std::cout << "size moments: " << mu.size() << endl;
	//std::cout << "size mC     : " << mC.size() << endl;
	
	if (autoCenterPt_count == 0)
	{
		for (char i = 0; i < contour.size(); i++)
		{
			
			mu[i] = moments(contour[i], true);
			mC[i] = cv::Point2f(static_cast<float>(mu[i].m10 / mu[i].m00), static_cast<float>(mu[i].m01 / mu[i].m00));		
			//circle(colorImage, Point(mC[i].x, mC[i].y),1, Scalar(255, 0, 0), 1);
			//putText(colorImage, to_string(i), Point(mC[i].x - 10 , mC[i].y - 5 ), FONT_HERSHEY_COMPLEX, 0.5, Scalar(0, 0, 255), 1, 8,false);
			
		}
		autoCenterPt_count = 1;
		centerPt = center(mC);
	}
	else
	{
		for (char i = 0; i < contour.size(); i++)
		{
			
			mu[i] = moments(contour[i], true);
			mC[i] = cv::Point2f(static_cast<float>(mu[i].m10 / mu[i].m00), static_cast<float>(mu[i].m01 / mu[i].m00));		
			//circle(colorImage, Point(mC[i].x, mC[i].y),1, Scalar(255, 0, 0), 1);
			//putText(colorImage, to_string(i), Point(mC[i].x - 10 , mC[i].y - 5 ), FONT_HERSHEY_COMPLEX, 0.5, Scalar(0, 0, 255), 1, 8,false);

			mPolar[i] = descartes2PolarSystem(mC[i], centerPt);
		}
	}
	//std::cout << " mC: \n " << mC << endl;
	//std::cout << " un-sort mPolar\n: " << mPolar << endl;
	bubbleSort(mPolar);
	//std::cout << " sort mPolar\n: " << mPolar << endl;
	copy2array(mPolar, mPolar_reverse_descartes);
	for (char i = 0; i < contour.size(); i++)
	{
		polarSystem2descartes(mPolar_reverse_descartes[i],centerPt);
	}

	//std::cout << " reverse\n: " << mPolar_reverse_descartes << endl;
	
	for (char i = 0; i < mPolar_reverse_descartes.size(); i++)
	{		
		for (char j = 0; j < mPolar_reverse_descartes.size(); j++)
		{
			if (i == mPolar_reverse_descartes[j].z)
			{
				// std::cout <<"ith: "<< mPolar_reverse[i].z << endl;
				circle(colorImage, cv::Point2f(mPolar_reverse_descartes[i].x, mPolar_reverse_descartes[i].y), 1, cv::Scalar(255, 0, 0), 1);
				//putText(colorImage, to_string(int(mPolar_reverse_descartes[i].z)), cv::Point2f(mPolar_reverse_descartes[i].x, 
					//mPolar_reverse_descartes[i].y + 5), FONT_HERSHEY_COMPLEX, 0.5, Scalar(0, 0, 255), 1, 8, false);
			}
		}
	}
	drawCoordinatorCenter(centerPt, 50, colorImage);
	//std::cout << "located marker ---" << endl;
}






