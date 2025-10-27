#include <iostream>
#include <opencv2/videoio.hpp>
#include "opencv2/opencv.hpp"
#include <opencv2/photo.hpp>
#include <opencv2/core/types_c.h>
#include <string>
#include <iostream>
using namespace cv;
using namespace std;
int main()
{
	cv::VideoCapture camera1;
	try
	{
		camera1 = VideoCapture(0);
		if (!camera1.isOpened()) throw 10;
	}
	catch (int e)
	{
		std::cout <<"Can not connect to camera " << e <<endl;
		exit(main());
	}
	
	std::cout <<"hello world"<<std::endl;
	Mat cam_img1;
	while(true)
	{
		camera1 >> cam_img1;
		imshow("Color image", cam_img1);
		cv::waitKey(30);
	}
	return 0;
}
