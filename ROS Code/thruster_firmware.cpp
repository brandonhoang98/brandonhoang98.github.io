// Thruster Firmware
#include "ros/ros.h"
#include "std_msgs/String.h"
#include <iostream>
#include <wiringPi.h>
#include <stdio.h>
#include <unistd.h>
#include <softPwm.h>


using namespace std;

/*
	WiringPi's GPIO Mapping
	WIRING PI PIN		BCM		Pi BOARD PIN	THRUSTER
	0					17		11				Front left
	1 					18		12				Front right
	2 					27		13				Back left
	3 					22		15				Back right
	4 					23		16				Middle left
	5 					24		18				Middle right
	6					25		22				Arm
*/
int frontLeft = 0;
int frontRight = 1; 
int backLeft = 2;
int backRight = 3;
int middleLeft = 4;
int middleRight =5;
int arm = 6;
void stop(void);

void getMsg(const std_msgs::String::ConstPtr& msg)
{
	// Gets msg from topic
	string msgString = msg->data.c_str();
	
	// Outputs dirction we want to go
	ROS_INFO("Turning %s ", msg->data.c_str());

	stop();
	if(msgString == "left")
	{
		for (int i = 0; i<500; i++)
		{
		// front right thruster on
		//digitalWrite(1,1);
		softPwmWrite (1, 16);
		// back right thruster on
		//digitalWrite(3,1);	
		softPwmWrite (3, 16);
		usleep(10000);
		}
		
		// Wait 2 seconds
		//usleep(2000000);
	}
	else if(msgString == "right")
	{
		for (int i = 0; i<500; i++)
		{
		// front left thruster on
			softPwmWrite (0, 16);
			// back left thruster on
			softPwmWrite (2, 16);
		
			// This snippet is for arm test *Ryan*
			//softPwmWrite (1, 14);
			usleep(5000);
			//softPwmWrite(1,15);
			usleep(5000);
		}
		// Wait 2 seconds
		//usleep(2000000);
	}
	else if(msgString == "down")
	{
		for (int i = 0; i<500; i++)
		{
			// middle left thruster on
			softPwmWrite (4, 16);
			// middle right thruster on
			softPwmWrite (5, 16);
			usleep(10000);
		}

		// Wait 2 seconds
		//usleep(2000000);
	}
	else if(msgString== "up")
	{
		/*	Ideally we want the middle thrusters to turn off but
			for the purpose of testing on the breadboard we'll
			just have the LED's blink instead
		*/
		for(int i = 0; i < 500; i++)
		{
			// middle left thruster on
			softPwmWrite (4, 15);
			// middle right thruster on
			softPwmWrite (5, 15);
			// Wait for 0.5 seconds
			usleep(10000);
			
		}

	}
	else if(msgString == "forward")
	{
		for (int i = 0; i<500; i++)
		{
			// front left thruster on
			softPwmWrite (0, 16);
			// front right thruter on
			softPwmWrite (1, 16);
			usleep(10000);
		}
		//usleep(2000000);
	}
	else if(msgString == "backward")
	{
		for (int i = 0; i<500; i++)
		{
			// back left thruster on
			softPwmWrite (2, 16);
			// back right thruster on
			softPwmWrite (3, 16);
			usleep(10000);
		}
	}
	else if(msgString == "stop")
	{
		stop();
	}
	else
	{
		// if not instructions given, don't move
		stop();
	}
}

void stop(void)
{
	// Sets all pins to 1500us 
	cout << "stop all thrusters\n";
	
	softPwmWrite (1, 15);
	softPwmWrite (2, 15);
	softPwmWrite (3, 15);
	softPwmWrite (4, 15);
	softPwmWrite (5, 15);
	softPwmWrite (0, 15);
	
}

void pinInit(void)
{
	//Sets GPIO pins with a frequency of 400hz (2500us periods) with a 1500us pulse
	softPwmCreate (1,15,25);
	softPwmCreate (2,15,25);
	softPwmCreate (3,15,25);
	softPwmCreate (4,15,25);
	softPwmCreate (5,15,25);
	softPwmCreate (0,15,25);
	//Give thrusters time to initialize before sending throttle signals
	usleep(8000000);
	softPwmWrite (1,15);
}

int main(int argc, char **argv)
{
	ros::init(argc, argv, "thruster_firmware");

	ros::NodeHandle n;

	// wiring pi initialization & check
	if(wiringPiSetup() == -1)
	{
		cout << "Error in Wiring Pi initialization\n";
		return 1;
	}
	
	pinInit();

	ros::Subscriber sub = n.subscribe("direction", 10, getMsg);

	ros::spin();

	return 0;

}
