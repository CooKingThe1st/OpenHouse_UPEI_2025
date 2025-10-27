
#include "library.h"


int main()
{
	VideoCapture camera1;
	int k = 0;
	try
	{
		camera1 = VideoCapture(0);
		if (!camera1.isOpened()) throw 10;
	}
	catch (int e)
	{
		cout << "Can not connect to camera - error -  " << e << endl;
		exit(main());
	}

	Mat cam_img1, colorImage;
	vector<Point3f> savePoint;

	char count = 0;
	char samplingDataTimes = 50;
	float saveBoundary = 0;


	
	while (true)
	{
		vector<Point3f> changedPoint;
		vector<Point2f> displacement;
		vector<int> contactList;
		vector<float> forceList;

		auto start = high_resolution_clock::now();

		camera1 >> cam_img1;

		// sizeImage(cam_img1, "camera 1");
		// framePerSecond(camera1, "camera 1");

		cam_img1 = cam_img1(Rect(60, 0, 510, 480));
		//cv::circle(cam_img1, Point2d(310, 50), 10, Scalar(0, 0, 0), 80, 8, 0);
		//imshow("tesst", cam_img1);
		colorImage = cam_img1.clone();

		fillImage(cam_img1, static_cast<float>(cam_img1.cols), static_cast<float>(cam_img1.rows));
		imshow("filled", cam_img1);
		
		fillImage(colorImage, static_cast<float>(colorImage.cols), static_cast<float>(colorImage.rows));
		//cv::circle(cam_img1, Point2d(100, 10), 20, Scalar(0, 0, 0), 10, 8, 0);
		denoiseImage(cam_img1);
		//// bitwise_not(cam_img1, invertImg);

		if (count < samplingDataTimes)
		{
			locateMarker(cam_img1, colorImage, savePoint);
			cout << "Save data done" << endl;
		}
		else
		{
			locateMarker(cam_img1, colorImage, changedPoint);

			checkMarker(savePoint, changedPoint);

			displacementArray(savePoint, changedPoint, displacement, true, colorImage);

			findHighPoint(displacement, contactList);

			//estimateForce_onMarker(contactList, forceList, changedPoint, savePoint);

			totalVector(colorImage, contactList, displacement, savePoint, changedPoint);
		}
        

		imshow("color image", colorImage);
		cv::waitKey(30);

		auto stop = high_resolution_clock::now();
		auto duration = duration_cast<microseconds>(stop - start);

		cout << " Time process: " << duration.count() * 0.000001 << " second" << endl;
		//cout << " output: " << savePoint << endl;
		cout << "------------------------------------------------------------------------------" << endl;
		count++;
		if (count > samplingDataTimes) count = 50;
		//Sleep(500);
		
		
		
	}
	return -1;
}
