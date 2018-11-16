# RedDetectionRobot
1. The robot detects the Red Color objects. The number of objects will determine the direction.
2. The input is taken from the camera of the laptop. The MATLAB code is run and the camera starts detecting.
3. The code is counting the number of red colored blobs.
4. According to the number of blobs, the robot's direction of movement is decided.
5. For example, if the number of red blobs are '2', then through serial communication, MATLAB sends a character ('b') to the Arduino UNO, on-board the robot.
