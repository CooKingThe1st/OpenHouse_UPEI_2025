#include <Wire.h>
#include <ZumoShield.h>


ZumoMotors motors;
int readByte = 0;
int defaulSpeed = 0;
String orientation = "";
String initOrientationFlag = "";
double kp = 5, ki = 2, kd = 0.25;
double PID_p = 0, PID_i = 0, PID_d = 0;
double PID_value = 0;
float PID_error = 0;
float PID_errorTotal = 0;
float currentOri = 0;
float setOri = 0;
float previousPID_error = 0;
float currentTime = 0;
float previousTime = 0;
double correction = 0;
String command = "";
void setup() {
  // put your setup code here, to run once:
  Serial.begin(115200);
  Serial.flush();
  char buf[20];
  setOri = 266;

}

void loop()
{
  char buf[20] = {'\0'};
  char* pos = NULL;
  if (Serial.available() > 0)
  {
    readByte = Serial.readBytesUntil('\n', buf, 20);
    //    //Serial.println(readByte);
    //    pos = strchr(buf, '.');
    //    //Serial.println(pos - buf);
    //    int delimitersPos_command = pos - buf;
    //    initOrientationFlag = String(buf).substring(0, delimitersPos_command);
    //    //Serial.println(orientation);
    //    int delimitersPos_speed = delimitersPos_command + 1;
    //    orientation = String(buf).substring(delimitersPos_speed, readByte + 1);
    //    //Serial.println(speedMotor);


    String myString = String(buf);
    int firstDelimiter = myString.indexOf(",");

    initOrientationFlag = myString.substring(0, firstDelimiter);
    Serial.println(initOrientationFlag);
    int secondDelimiter = myString.indexOf(",", firstDelimiter + 1);
    orientation = myString.substring(firstDelimiter + 1, secondDelimiter);
    Serial.println(orientation);
    command =  myString.substring(secondDelimiter + 1, myString.length());
    Serial.println(command);
    //    if (initOrientationFlag == "s")
    //    {
    //      setOri = orientation.toFloat();
    //      motors.setLeftSpeed(0);
    //      motors.setRightSpeed(0);
    //    }
  }


  Serial.flush();
  if (initOrientationFlag == "g" )
  {

    currentOri = orientation.toFloat();
    defaulSpeed = 50;
    PID_error = setOri - currentOri;

    currentTime = millis();
    float elapsedTime = (currentTime - previousTime);
    PID_errorTotal += PID_error * elapsedTime;

    Serial.println("Thong So-------------");
    Serial.print("PID_error     ");
    //    Serial.println(PID_error);
    PID_p = kp * PID_error;


    //    Serial.print("Time");
    //    Serial.println(elapsedTime);
    //    Serial.print(" previousPID_error");
    //    Serial.println(previousPID_error);
    Serial.print(" PID_error");
    Serial.println(PID_error);
    PID_d = kd * ((PID_error - previousPID_error) / elapsedTime);
    PID_i = ki * PID_errorTotal * elapsedTime;
    //PID_value = PID_p + PID_i + PID_d;

    previousPID_error = PID_error;

    previousTime = currentTime;

    //PID_value = PID_p +  PID_d;
    PID_value = PID_p;
    //    Serial.print("   PID_p       ");
    //    Serial.println(PID_p);
    //    Serial.print("   PID_i       ");
    //    Serial.println(PID_i);
    //    Serial.print("   PID_d       ");
    //    Serial.println(PID_d);
    if (PID_value > 150)
    {
      PID_value = 150;
    }
    else if (PID_value < (-150))
    {
      PID_value = -150;
    }

    //  Serial.print("PID_value: ");
    //  Serial.println(PID_value);

    if (command == "1")
    {
      goStraight(defaulSpeed, PID_value);
    }
    else if (command == "2")
    {
      goBack(defaulSpeed, PID_value);
    }
    else if (command == "3")
    {
      rorateLeft(PID_value);
    }
    else if (command == "4")
    {
      rorateRight(PID_value);
    }
  }

}


void goStraight(int defaulSpeed, int correction)
{
  motors.setLeftSpeed(defaulSpeed + correction);
  motors.setRightSpeed(defaulSpeed - correction);
  delay(2);
}
void goBack(int defaulSpeed, int correction)
{
  motors.setLeftSpeed(-defaulSpeed + correction);
  motors.setRightSpeed(-defaulSpeed - correction);
  delay(2);
}

void rorateLeft(int correction)
{
  motors.setLeftSpeed(-correction);
  motors.setRightSpeed(correction);
  delay(2);
}

void rorateRight(int correction)
{
  motors.setLeftSpeed(correction);
  motors.setRightSpeed(-correction);
  delay(2);
}
