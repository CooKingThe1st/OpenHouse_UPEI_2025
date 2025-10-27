/*
Copyright © 2012 NaturalPoint Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License. */


/*

SampleClient.cpp

This program connects to a NatNet server, receives a data stream, and writes that data stream
to an ascii file.  The purpose is to illustrate using the NatNetClient class.

Usage [optional]:

    SampleClient [ServerIP] [LocalIP] [OutputFilename]

    [ServerIP]			IP address of the server (e.g. 192.168.0.107) ( defaults to local machine)
    [OutputFilename]	Name of points file (pts) to write out.  defaults to Client-output.pts

*/

#include <inttypes.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <thread>
#include <iostream>
#include <WS2tcpip.h>
#include <sstream>
#include <thread>
#include <mutex>
#include <vector>
#include <map>
#include <cmath>
#include <math.h>
#include <utility>
#include <list>
#include <vector>
#include <fstream>
#include <atomic>
#include <chrono>
#pragma comment(lib, "ws2_32.lib")


#ifdef _WIN32
#   include <conio.h>
#else
#   include <unistd.h>
#   include <termios.h>
#endif
#ifndef M_PI
#define M_PI 3.14159265358979323846
#endif


#include <NatNetTypes.h>
#include <NatNetCAPI.h>
#include <NatNetClient.h>

#define _CRT_SECURE_NO_WARNINGS 1 
#define _USE_MATH_DEFINES
#pragma warning(disable : 4996)
using namespace std;
std::mutex mu;
#ifndef _WIN32
char getch();
#endif
void _WriteHeader(FILE* fp, sDataDescriptions* pBodyDefs);
void _WriteFrame(FILE* fp, sFrameOfMocapData* data);
void _WriteFooter(FILE* fp);
void NATNET_CALLCONV ServerDiscoveredCallback(const sNatNetDiscoveredServer* pDiscoveredServer, void* pUserContext);
void NATNET_CALLCONV DataHandler(sFrameOfMocapData* data, void* pUserData);    // receives data from the server
void NATNET_CALLCONV MessageHandler(Verbosity msgType, const char* msg);      // receives NatNet error messages
void resetClient();
int ConnectClient();
void broadcastingThread();


static const ConnectionType kDefaultConnectionType = ConnectionType_Multicast;

NatNetClient* g_pClient = NULL;
FILE* g_outputFile;

std::vector< sNatNetDiscoveredServer > g_discoveredServers;
sNatNetClientConnectParams g_connectParams;
char g_discoveredMulticastGroupAddr[kNatNetIpv4AddrStrLenMax] = NATNET_DEFAULT_MULTICAST_ADDRESS;
int g_analogSamplesPerMocapFrame = 0;
sServerDescription g_serverDescription;
int initRobotData = 0;

bool setData = FALSE;
bool sendData = FALSE;
int numberRobot = 0;
// Define the data type for controlling the robot position
struct Vector3
{
    float x;
    float y;
    float z;
};
struct PIDdata
{
    float angleRobot = NAN;
    float Xlocation = NAN;
    float Ylocation = NAN;
};
struct robotData { // This structure is named "robot data"
    int robotID = NAN;
    SOCKET sock = 0;
    float x = NAN;
    float y = NAN;
    float z = NAN;
    float xRotate = NAN;
    float yRotate = NAN;
    float zRotate = NAN;
    float heading = NAN;
    float force = NAN;
    float xDestination = NAN;
    float yDestination = NAN;
    float zDestination = NAN;
    float headingDestination = NAN;
    Vector3 marker1;
    Vector3 marker2;
    Vector3 marker3;
    Vector3 marker4;
    Vector3 marker5;
    Vector3 headingMarker;
    float kp;
    float ki;
    float kd;
    float _dt;
    float x_errorTotal;
    float y_errorTotal;
    float heading_errorTotal;
    float xPID;
    float yPID;
    float headingPID;
    bool isArrive = false;
    float remainingDistance = NAN;
};

struct rotateRobot {
    float xRotate = NAN;
    float yRotate = NAN;
    float zRotate = NAN;
};

map<int, robotData> robotList;
// Save rigid bodies in to dictionary

int connectToOptitrack();
void multiServer(SOCKET listening);
float headingDirection(Vector3 center, Vector3 headingMarker);
float distanceBetweenTwoPoint(Vector3 origin, Vector3 a);
void headingDefine(map<int, robotData>& input_robotList);
float remainingDistance(Vector3 center, Vector3 destinationPoint);
void setDestination(map<int, robotData>& input_robotList, std::vector<Vector3> destination);
string Create_multiRobotData(map<int, robotData> input_robotList);

// ============== NEW: Configuration Parameters ==============
const int DISTRIBUTING_DATA_RATE = 60; // Hz (2-60 range)
// will not be used tho
std::vector<std::string> list_receiver = {
    "192.168.0.232",  // Client 1 IP
    "192.168.0.233",  // Client 2 IP
    // Add more client IPs here
};
const int BROADCAST_PORT = 5400;

// ============== NEW: Thread-safe data access ==============
std::mutex robotListMutex;  // Renamed for clarity
std::atomic<bool> g_running(true);  // Clean shutdown flag


// ============== MODIFIED: Main Function ==============
int main(int argc, char* argv[])
{
    robotList = map<int, robotData>{};

    unsigned char ver[4];
    NatNet_GetVersion(ver);
    printf("NatNet Sample Client (NatNet ver. %d.%d.%d.%d)\n", ver[0], ver[1], ver[2], ver[3]);

    NatNet_SetLogCallback(MessageHandler);
    g_pClient = new NatNetClient();
    g_pClient->SetFrameReceivedCallback(DataHandler, g_pClient);

    // Initialize Winsock
    WSADATA wsDATA;
    WORD ver_win = MAKEWORD(2, 2);
    int wsOK = WSAStartup(ver_win, &wsDATA);
    if (wsOK != 0)
    {
        cerr << "Cannot initialize Winsock" << endl;
        return -1;
    }

    // Start threads
    std::thread t_optitrack(connectToOptitrack);
    std::thread t_broadcast(broadcastingThread);

    // Wait for user input to quit
    printf("Press 'q' to quit...\n");
    while (getch() != 'q') {
        std::this_thread::sleep_for(std::chrono::milliseconds(100));
    }

    // Clean shutdown
    g_running = false;
    t_broadcast.join();

    // OptiTrack thread cleanup (will exit on getch 'q' in connectToOptitrack)
    t_optitrack.join();

    // Cleanup
    if (g_pClient)
    {
        g_pClient->Disconnect();
        delete g_pClient;
        g_pClient = NULL;
    }

    WSACleanup();
    return ErrorCode_OK;
}


// ============== MODIFIED: Broadcasting Thread Function ==============
void broadcastingThread() {
    const int sleep_ms = 1000 / DISTRIBUTING_DATA_RATE;

    // Create listening socket
    SOCKET listening = socket(AF_INET, SOCK_STREAM, 0);
    if (listening == INVALID_SOCKET) {
        std::cerr << "Failed to create listening socket" << std::endl;
        return;
    }

    // Allow socket reuse
    int opt = 1;
    setsockopt(listening, SOL_SOCKET, SO_REUSEADDR, (char*)&opt, sizeof(opt));

    // Bind to broadcast port
    sockaddr_in hint;
    hint.sin_family = AF_INET;
    hint.sin_port = htons(BROADCAST_PORT);
    hint.sin_addr.s_addr = INADDR_ANY;  // Listen on all interfaces

    if (bind(listening, (sockaddr*)&hint, sizeof(hint)) == SOCKET_ERROR) {
        std::cerr << "Bind failed on port " << BROADCAST_PORT << std::endl;
        closesocket(listening);
        return;
    }

    // Listen for connections
    if (listen(listening, SOMAXCONN) == SOCKET_ERROR) {
        std::cerr << "Listen failed" << std::endl;
        closesocket(listening);
        return;
    }

    std::cout << "OptiTrack server listening on port " << BROADCAST_PORT << std::endl;
    std::cout << "Waiting for clients to connect..." << std::endl;

    // Vector to store connected clients
    std::vector<SOCKET> clientSockets;

    // Set listening socket to non-blocking for accept()
    u_long mode = 1;
    ioctlsocket(listening, FIONBIO, &mode);

    // Main broadcasting loop
    while (g_running) {
        auto start_time = std::chrono::high_resolution_clock::now();

        // Accept new clients (non-blocking)
        SOCKET newClient = accept(listening, nullptr, nullptr);
        if (newClient != INVALID_SOCKET) {
            std::cout << "New client connected! Total clients: " << (clientSockets.size() + 1) << std::endl;
            clientSockets.push_back(newClient);
        }

        // Thread-safe data retrieval
        std::string data;
        {
            std::lock_guard<std::mutex> lock(robotListMutex);
            if (!robotList.empty()) {
                data = Create_multiRobotData(robotList);
            }
        }

        // Broadcast to all connected clients
        if (!data.empty() && !clientSockets.empty()) {
            auto it = clientSockets.begin();
            while (it != clientSockets.end()) {
                int result = send(*it, data.c_str(), data.size() + 1, 0);
                if (result == SOCKET_ERROR) {
                    std::cout << "Client disconnected" << std::endl;
                    closesocket(*it);
                    it = clientSockets.erase(it);
                }
                else {
                    ++it;
                }
            }
        }

        // Sleep to maintain rate
        auto end_time = std::chrono::high_resolution_clock::now();
        auto elapsed = std::chrono::duration_cast<std::chrono::milliseconds>(end_time - start_time);
        int remaining_sleep = sleep_ms - elapsed.count();

        if (remaining_sleep > 0) {
            std::this_thread::sleep_for(std::chrono::milliseconds(remaining_sleep));
        }
    }

    // Cleanup
    for (auto& sock : clientSockets) {
        closesocket(sock);
    }
    closesocket(listening);
    std::cout << "Broadcasting thread stopped" << std::endl;
}


// ============== FIX: connectToOptitrack (Make Non-Blocking) ==============
int connectToOptitrack()
{
    int iResult;

    g_connectParams.connectionType = ConnectionType_Multicast;
    g_connectParams.serverCommandPort = 1510;
    g_connectParams.serverDataPort = 1511;
    g_connectParams.serverAddress = "192.168.0.100";  // UPDATED IP
    g_connectParams.localAddress = "192.168.0.100";   // UPDATED IP
    g_connectParams.multicastAddress = NULL;

    iResult = ConnectClient();
    if (iResult != ErrorCode_OK)
    {
        printf("Error initializing client. See log for details. Exiting.\n");
        return 1;
    }
    else
    {
        printf("Client initialized and ready.\n");
    }

    // Send/receive test request
    void* response;
    int nBytes;
    printf("[SampleClient] Sending Test Request\n");
    iResult = g_pClient->SendMessageAndWait("TestRequest", &response, &nBytes);
    if (iResult == ErrorCode_OK)
    {
        printf("[SampleClient] Received: %s\n", (char*)response);
    }

    // Retrieve Data Descriptions from Motive
    printf("\n\n[SampleClient] Requesting Data Descriptions...\n");
    sDataDescriptions* pDataDefs = NULL;
    iResult = g_pClient->GetDataDescriptionList(&pDataDefs);
    if (iResult != ErrorCode_OK || pDataDefs == NULL)
    {
        printf("[SampleClient] Unable to retrieve Data Descriptions.\n");
    }
    else
    {
        printf("[SampleClient] Received %d Data Descriptions\n", pDataDefs->nDataDescriptions);
        // Suppress detailed printing for cleaner output
    }

    // Create data file
    const char* szFile = "Client-output.pts";
    g_outputFile = fopen(szFile, "w");
    if (!g_outputFile)
    {
        printf("Error opening output file %s.  Exiting.\n", szFile);
        exit(1);
    }

    if (pDataDefs)
    {
        _WriteHeader(g_outputFile, pDataDefs);
        NatNet_FreeDescriptions(pDataDefs);
        pDataDefs = NULL;
    }

    // Ready to receive marker stream!
    printf("\nOptiTrack client connected and listening for data...\n");
    printf("Broadcasting server is running on port %d\n", BROADCAST_PORT);
    printf("Press 'q' in main window to quit...\n\n");

    // REMOVED: The blocking getch() loop
    // Now just wait for g_running to become false
    while (g_running) {
        std::this_thread::sleep_for(std::chrono::milliseconds(100));
    }

    // Cleanup
    if (g_outputFile)
    {
        _WriteFooter(g_outputFile);
        fclose(g_outputFile);
        g_outputFile = NULL;
    }

    return 0;
}

void NATNET_CALLCONV ServerDiscoveredCallback(const sNatNetDiscoveredServer* pDiscoveredServer, void* pUserContext)
{
    char serverHotkey = '.';
    if (g_discoveredServers.size() < 9)
    {
        serverHotkey = static_cast<char>('1' + g_discoveredServers.size());
    }

    printf("[%c] %s %d.%d at %s ",
        serverHotkey,
        pDiscoveredServer->serverDescription.szHostApp,
        pDiscoveredServer->serverDescription.HostAppVersion[0],
        pDiscoveredServer->serverDescription.HostAppVersion[1],
        pDiscoveredServer->serverAddress);

    if (pDiscoveredServer->serverDescription.bConnectionInfoValid)
    {
        printf("(%s)\n", pDiscoveredServer->serverDescription.ConnectionMulticast ? "multicast" : "unicast");
    }
    else
    {
        printf("(WARNING: Legacy server, could not autodetect settings. Auto-connect may not work reliably.)\n");
    }

    g_discoveredServers.push_back(*pDiscoveredServer);
}

// Establish a NatNet Client connection
int ConnectClient()
{
    // Release previous server
    g_pClient->Disconnect();

    // Init Client and connect to NatNet server
    int retCode = g_pClient->Connect(g_connectParams);
    if (retCode != ErrorCode_OK)
    {
        printf("Unable to connect to server.  Error code: %d. Exiting.\n", retCode);
        return ErrorCode_Internal;
    }
    else
    {
        // connection succeeded

        void* pResult;
        int nBytes = 0;
        ErrorCode ret = ErrorCode_OK;

        // print server info
        memset(&g_serverDescription, 0, sizeof(g_serverDescription));
        ret = g_pClient->GetServerDescription(&g_serverDescription);
        if (ret != ErrorCode_OK || !g_serverDescription.HostPresent)
        {
            printf("Unable to connect to server. Host not present. Exiting.\n");
            return 1;
        }
        printf("\n[SampleClient] Server application info:\n");
        printf("Application: %s (ver. %d.%d.%d.%d)\n", g_serverDescription.szHostApp, g_serverDescription.HostAppVersion[0],
            g_serverDescription.HostAppVersion[1], g_serverDescription.HostAppVersion[2], g_serverDescription.HostAppVersion[3]);
        printf("NatNet Version: %d.%d.%d.%d\n", g_serverDescription.NatNetVersion[0], g_serverDescription.NatNetVersion[1],
            g_serverDescription.NatNetVersion[2], g_serverDescription.NatNetVersion[3]);
        printf("Client IP:%s\n", g_connectParams.localAddress);
        printf("Server IP:%s\n", g_connectParams.serverAddress);
        printf("Server Name:%s\n", g_serverDescription.szHostComputerName);

        // get mocap frame rate
        ret = g_pClient->SendMessageAndWait("FrameRate", &pResult, &nBytes);
        if (ret == ErrorCode_OK)
        {
            float fRate = *((float*)pResult);
            printf("Mocap Framerate : %3.2f\n", fRate);
        }
        else
            printf("Error getting frame rate.\n");

        // get # of analog samples per mocap frame of data
        ret = g_pClient->SendMessageAndWait("AnalogSamplesPerMocapFrame", &pResult, &nBytes);
        if (ret == ErrorCode_OK)
        {
            g_analogSamplesPerMocapFrame = *((int*)pResult);
            printf("Analog Samples Per Mocap Frame : %d\n", g_analogSamplesPerMocapFrame);
        }
        else
            printf("Error getting Analog frame rate.\n");
    }

    return ErrorCode_OK;
}

// DataHandler receives data from the server
// This function is called by NatNet when a frame of mocap data is available


// ============== MODIFIED: DataHandler (Reduce Console Spam) ==============
void NATNET_CALLCONV DataHandler(sFrameOfMocapData* data, void* pUserData)
{
    // Thread-safe lock for robotList access
    std::lock_guard<std::mutex> lock(robotListMutex);

    NatNetClient* pClient = (NatNetClient*)pUserData;

    // Print every 60 frames (1 second at 60 Hz) with detailed info
    static int frame_counter = 0;
    frame_counter++;

    if (frame_counter % 60 == 0) {
        printf("\n--- Frame %d | Rigid Bodies: %d | robotList size: %d ---\n", 
               data->iFrame, data->nRigidBodies, (int)robotList.size());
        
        // Print what's being sent
        std::string currentData = Create_multiRobotData(robotList);
        printf("📡 Sending: %s\n", currentData.c_str());
        
        // Check for missing IDs
        printf("🔍 RigidBodies IDs in frame: ");
        for (int i = 0; i < data->nRigidBodies; i++) {
            printf("%d ", data->RigidBodies[i].ID);
        }
        printf("\n");
        
        printf("🗂️  robotList IDs: ");
        for (const auto& pair : robotList) {
            printf("%d ", pair.first);
        }
        printf("\n");
        
        // Warning if mismatch
        if (robotList.size() != data->nRigidBodies) {
            printf("⚠️  WARNING: robotList size (%d) != nRigidBodies (%d)\n", 
                   (int)robotList.size(), data->nRigidBodies);
        }
    }
    
    for (int i = 0; i < data->nRigidBodies; i++)
    {
        bool bTrackingValid = data->RigidBodies[i].params & 0x01;

        robotData robotData1;
        rotateRobot robot1;

        // Calculate rotation
        float sinr_cosp = 2 * ((float)data->RigidBodies[i].qw * data->RigidBodies[i].qx +
            data->RigidBodies[i].qy * data->RigidBodies[i].qz);
        float cosr_cosp = 1 - 2 * ((float)data->RigidBodies[i].qx * data->RigidBodies[i].qx +
            data->RigidBodies[i].qy * data->RigidBodies[i].qy);
        robot1.xRotate = std::atan2(sinr_cosp, cosr_cosp) * 360.f / (2.f * (float)M_PI);

        float sinp = 2 * ((float)data->RigidBodies[i].qw * (float)data->RigidBodies[i].qy -
            (float)data->RigidBodies[i].qz * (float)data->RigidBodies[i].qx);
        if (std::abs(sinp) >= 1)
            robot1.yRotate = std::copysign(M_PI / 2, sinp) * 360.f / (2.f * (float)M_PI);
        else
            robot1.yRotate = std::asin(sinp) * 360.f / (2.f * M_PI);

        float siny_cosp = 2 * ((float)data->RigidBodies[i].qw * data->RigidBodies[i].qz +
            data->RigidBodies[i].qx * data->RigidBodies[i].qy);
        float cosy_cosp = 1 - 2 * ((float)data->RigidBodies[i].qy * data->RigidBodies[i].qy +
            data->RigidBodies[i].qz * data->RigidBodies[i].qz);
        robot1.zRotate = std::atan2(siny_cosp, cosy_cosp) * 360.f / (2.f * (float)M_PI);

        // Update robotList
        robotData1.x = data->RigidBodies[i].x;
        robotData1.y = data->RigidBodies[i].y;
        robotData1.z = data->RigidBodies[i].z;
        robotData1.robotID = data->RigidBodies[i].ID;
        robotData1.xRotate = robot1.xRotate;
        robotData1.yRotate = robot1.yRotate;
        robotData1.zRotate = robot1.zRotate;

        if (robotList.count(robotData1.robotID) > 0)
        {
            robotList[robotData1.robotID].x = robotData1.x;
            robotList[robotData1.robotID].y = robotData1.y;
            robotList[robotData1.robotID].z = robotData1.z;
            robotList[robotData1.robotID].xRotate = robotData1.xRotate;
            robotList[robotData1.robotID].yRotate = robotData1.yRotate;
            robotList[robotData1.robotID].zRotate = robotData1.zRotate;
        }
        else
        {
            robotList.insert(std::pair<int, robotData>((int)robotData1.robotID, robotData1));
        }
    }

    // Process markers
    int countMarkerIndex = 1;
    for (int i = 0; i < data->nLabeledMarkers; i++)
    {
        sMarker marker = data->LabeledMarkers[i];
        int modelID, markerID;
        NatNet_DecodeID(marker.ID, &modelID, &markerID);

        if (countMarkerIndex == 1)
        {
            robotList[modelID].marker1.x = marker.x;
            robotList[modelID].marker1.y = marker.y;
            robotList[modelID].marker1.z = marker.z;
            countMarkerIndex++;
        }
        else if (countMarkerIndex == 2)
        {
            robotList[modelID].marker2.x = marker.x;
            robotList[modelID].marker2.y = marker.y;
            robotList[modelID].marker2.z = marker.z;
            countMarkerIndex++;
        }
        else if (countMarkerIndex == 3)
        {
            robotList[modelID].marker3.x = marker.x;
            robotList[modelID].marker3.y = marker.y;
            robotList[modelID].marker3.z = marker.z;
            countMarkerIndex++;
        }
        else if (countMarkerIndex == 4)
        {
            robotList[modelID].marker4.x = marker.x;
            robotList[modelID].marker4.y = marker.y;
            robotList[modelID].marker4.z = marker.z;
            countMarkerIndex++;
        }
        else if (countMarkerIndex == 5)
        {
            robotList[modelID].marker5.x = marker.x;
            robotList[modelID].marker5.y = marker.y;
            robotList[modelID].marker5.z = marker.z;
            countMarkerIndex = 1;
        }
    }

    // Calculate heading and destinations
    Vector3 robot1Des, robot2Des, robot3Des;
    robot1Des.x = robot2Des.x = robot3Des.x = 0;
    robot1Des.y = robot2Des.y = robot3Des.y = 0;
    robot1Des.z = robot2Des.z = robot3Des.z = 0;
    vector<Vector3> destination = { robot1Des, robot2Des, robot3Des };
    setDestination(robotList, destination);
    headingDefine(robotList);
}


void headingDefine(map<int, robotData>& input_robotList)
{
    // Compare to the Ox axis
    // y = 0
    int itemRobot = 1;

    for (int i = 0; i < input_robotList.size(); i++)
    {
        //input_robotList.
        float headingRobot;
        float vectorDirection[2];
        float marker12;
        float marker23;
        float marker31;
        Vector3 centerRobot;
        Vector3 headingMarkerRobot;
        Vector3 destinationPoint;
        marker12 = distanceBetweenTwoPoint(input_robotList[itemRobot].marker1, input_robotList[itemRobot].marker2);
        marker23 = distanceBetweenTwoPoint(input_robotList[itemRobot].marker2, input_robotList[itemRobot].marker3);
        marker31 = distanceBetweenTwoPoint(input_robotList[itemRobot].marker3, input_robotList[itemRobot].marker1);
        /*std::cout << "Marker 1 - x"<< input_robotList[itemRobot].marker1.x << endl;
        std::cout << "Marker 1 - y" << input_robotList[itemRobot].marker1.y << endl;
        std::cout << "Marker 1 - z" << input_robotList[itemRobot].marker1.z << endl;

        std::cout << "Marker 2 - x" << input_robotList[itemRobot].marker2.x << endl;
        std::cout << "Marker 2 - y" << input_robotList[itemRobot].marker2.y << endl;
        std::cout << "Marker 2 - z" << input_robotList[itemRobot].marker2.z << endl;

        std::cout << "Marker 3 - x" << input_robotList[itemRobot].marker3.x << endl;
        std::cout << "Marker 3 - y" << input_robotList[itemRobot].marker3.y << endl;
        std::cout << "Marker 3 - z" << input_robotList[itemRobot].marker3.z << endl;*/
        if ((marker12 > marker23) && (marker31 > marker23))
        {
            input_robotList[itemRobot].headingMarker = input_robotList[itemRobot].marker1;
        }
        if ((marker12 > marker31) && (marker23 > marker31))
        {
            input_robotList[itemRobot].headingMarker = input_robotList[itemRobot].marker2;
        }
        if ((marker31 > marker12) && (marker23 > marker12))
        {
            input_robotList[itemRobot].headingMarker = input_robotList[itemRobot].marker3;
        }
        centerRobot.x = input_robotList[itemRobot].x;
        centerRobot.y = input_robotList[itemRobot].y;
        centerRobot.z = input_robotList[itemRobot].z;
        /*std::cout << " centerRobot.x : " << centerRobot.x;
        std::cout << " centerRobot.y : " << centerRobot.y;
        std::cout << " centerRobot.z : " << centerRobot.z;*/
        headingMarkerRobot = input_robotList[itemRobot].headingMarker;

        destinationPoint.x = input_robotList[itemRobot].xDestination;
        destinationPoint.y = input_robotList[itemRobot].yDestination;
        destinationPoint.z = input_robotList[itemRobot].zDestination;
        input_robotList[itemRobot].heading = headingDirection(centerRobot, headingMarkerRobot);
        input_robotList[itemRobot].remainingDistance = remainingDistance(centerRobot, destinationPoint);

        itemRobot++;
    }

}

float remainingDistance(Vector3 center, Vector3 destinationPoint)
{
    /*std::cout << "destinationPoint centerRobot.x : " << destinationPoint.x << endl;
    std::cout << "destinationPoint centerRobot.y : " << destinationPoint.y << endl;
    std::cout << "destinationPoint centerRobot.z : " << destinationPoint.z << endl;
    std::cout << "Test centerRobot.x : " << center.x << endl;
    std::cout << "Test centerRobot.y : " << center.y << endl;
    std::cout << "Test centerRobot.z : " << center.z << endl;*/
    float distance = distanceBetweenTwoPoint(center, destinationPoint);
    return distance;
}
float distanceBetweenTwoPoint(Vector3 origin, Vector3 a)
{
    return sqrt((origin.x - a.x) * (origin.x - a.x) + (origin.y - a.y) * (origin.y - a.y));
}
float headingDirection(Vector3 center, Vector3 headingMarker)
{
    float heading = 0;
    float heading_cos;
    float heading_sin;
    float lenght_canhHuyen = abs(distanceBetweenTwoPoint(center, headingMarker));
    float length_y = headingMarker.y - center.y;
    float length_x = headingMarker.x - center.x;



    heading_cos = acos(length_x / lenght_canhHuyen);
    heading_sin = asin(length_y / lenght_canhHuyen);
    if (heading_sin >= 0)
    {
        heading = (float)heading_cos;
    }
    else
    {
        heading = 2 * M_PI - (float)heading_cos;
    }
    return heading;
}

void setDestination(map<int, robotData>& input_robotList, std::vector<Vector3> destination)
{
    for (int i = 1; i < destination.size() + 1; i++)
    {
        input_robotList[i].xDestination = destination[i - 1].x;
        input_robotList[i].yDestination = destination[i - 1].y;
        input_robotList[i].zDestination = destination[i - 1].z;

        Vector3 centerRobot;
        centerRobot.x = input_robotList[i].x;
        centerRobot.y = input_robotList[i].y;
        centerRobot.z = input_robotList[i].z;
        /*std::cout << "center robot x: " << input_robotList[i].x << " - ";
        std::cout << "center robot y: " << input_robotList[i].y << " - ";
        std::cout << "center robot z: " << input_robotList[i].z << endl;*/
        input_robotList[i].headingDestination = headingDirection(centerRobot, destination[i - 1]);
    }
}

void multiServer(SOCKET listening)
{
    fd_set master;
    FD_ZERO(&master);

    FD_SET(listening, &master);
    string dataMultirobot = "";

    while (true)
    {

        //std::cout << "outdata robotList[1].zRotate: " << robotList[1].zRotate << endl;
        fd_set copy = master;
        int socketCount = select(0, &copy, nullptr, nullptr, nullptr);

        for (int i = 0; i < socketCount; i++)
        {
            SOCKET sock = copy.fd_array[i];
            if (sock == listening)
            {
                //Accept a new connection
                SOCKET client = accept(listening, nullptr, nullptr);
                //Add the new connection to the list of connected client				
                FD_SET(client, &master);
                // Send a welcome message to the connected client
                //string welcomeMsg = "welcome to server!";
                string welcomeMsg = to_string(sock);
                send(client, welcomeMsg.c_str(), welcomeMsg.size() + 1, 0);
                // TODO: Broadcast we have a new connection				
            }
            else
            {

                char buf[4096];
                ZeroMemory(buf, 4096);

                int bytesIn = recv(sock, buf, 4096, 0);
                //cout << " Receive the controller: " << to_string(sock) << "   "<< buf[0] << endl;
                if (bytesIn <= 0)
                {
                    //Drop the client
                    closesocket(sock);
                    FD_CLR(sock, &master);
                }
                else
                {

                    for (int i = 0; i < master.fd_count; i++)
                    {
                        SOCKET outSock = master.fd_array[i];

                        //if (outSock != listening || outSock == sock)
                        if (outSock != listening && outSock == sock)
                            //if (outSock == sock)
                        {

                            char transferData[1000];
                            char transferDataDestination[1000];
                            char transferDataDistanceRemaining[1000];
                            ostringstream ss;
                            if (master.fd_count > 0) // wait until 1 robot connect to network then run all robot
                            {
                                /*if (robotList[i].remainingDistance > 0.1)
                                {*/
                                //ss << " <Server> " << sock << ": " << buf << "\r\n";
                                //std::sprintf(transferData, "%f", robotList[i].heading);
                                //std::sprintf(transferDataDestination, "%f", robotList[i].headingDestination);
                                //std::sprintf(transferDataDistanceRemaining, "%f", robotList[i].remainingDistance);
                                //ss << "s," << transferData << "," << transferDataDestination << "," << transferDataDistanceRemaining << ",1" << "\n";

                                int bytesIn = recv(sock, buf, 4096, 0);
                                cout << " Receive the controller: " << to_string(sock) << "   " << buf[0] << endl;
                                string outputDataMultirobot = Create_multiRobotData(robotList);

                                ss << outputDataMultirobot << "\n";
                                string strOut = ss.str();
                                std::cout << "Test" << strOut << endl;
                                send(outSock, strOut.c_str(), strOut.size() + 1, 0);
                                //}
                                //else
                                //{
                                //	std::sprintf(transferData, "%f", robotList[i].heading);
                                //	std::sprintf(transferDataDestination, "%f", robotList[i].headingDestination);
                                //	ss << "s," << transferData << "," << transferDataDestination << ",0" << "\n";
                                //	//ss << "s," << transferData << "," << transferDataDestination << "," << transferDataDistanceRemaining << ",0" << "\n";
                                //	string strOut = ss.str();
                                //	std::cout << strOut << endl;
                                //	send(outSock, dataMultirobot.c_str(), strOut.size() + 1, 0);
                                //}
                            }
                            /*else
                            {
                                std::sprintf(transferData, "%f", robotList[i].heading);
                                std::sprintf(transferDataDestination, "%f", robotList[i].headingDestination);
                                std::sprintf(transferDataDistanceRemaining, "%f", robotList[i].remainingDistance);
                                ss << "s," << transferData << "," << transferDataDestination << ",0" << "\n";
                                string strOut = ss.str();
                                std::cout << strOut << endl;
                                send(outSock, strOut.c_str(), strOut.size() + 1, 0);
                            }*/

                            std::cout << "ROBOT #" << sock << ": " << buf << endl;
                        }
                    }
                }
            }
        }
    }
}

//string Create_multiRobotData(map<int, robotData> input_robotList)
//{
//	string Output_RobotData;
//	ostringstream temp_startPosition;
//	int pos_length = 0;
//	int temp_length = 0;
//	for (int i = 1; i < input_robotList.size() + 1; i++)
//	{	
//		ostringstream temp_ss;
//		char tempX[10];
//		char tempY[10];
//		char tempZ[10];
//		char tempzRotate[10];
//		if (i == 1) {
//			sprintf(tempX, "%.4f", input_robotList[1].x);
//			sprintf(tempY, "%.4f",  input_robotList[1].y);
//		}
//		else
//		{
//			sprintf(tempX, "%.4f", input_robotList[i].x - input_robotList[1].x);
//			sprintf(tempY, "%.4f", input_robotList[i].y - input_robotList[1].y);
//		}
//
//		
//		sprintf(tempZ, "%.4f", input_robotList[i].x);  // check condition
//		sprintf(tempzRotate, "%.4f", input_robotList[i].zRotate);
//		temp_ss << tempX << "," << tempY << "," << tempZ << ","  << tempzRotate <<";";
//		temp_length = temp_length + temp_ss.str().length();
//		temp_startPosition << temp_length << ":";
//		
//		Output_RobotData = Output_RobotData + temp_ss.str();		
//	}
//	string Final_Output_RobotData = temp_startPosition.str() + Output_RobotData;
//	std::cout << "Test multi: " << Final_Output_RobotData << endl;
//
//return Final_Output_RobotData;
//}


// ============== FIX: Create_multiRobotData (Fix Buffer Overflow) ==============
string Create_multiRobotData(map<int, robotData> input_robotList)
{
    string Output_RobotData;
    ostringstream temp_startPosition;
    int pos_length = 0;
    int temp_length = 0;

    for (int i = 1; i < input_robotList.size() + 1; i++)
    {
        // Skip if robot doesn't exist
        if (input_robotList.find(i) == input_robotList.end()) {
            continue;
        }
        
        // Check if data is valid
        if (std::isnan(input_robotList[i].x) ||
            std::isnan(input_robotList[i].y) ||
            std::isnan(input_robotList[i].z) ||
            std::isnan(input_robotList[i].zRotate)) {
            continue;
        }
        
        ostringstream temp_ss;
        char tempID[20];
        char tempX[20];
        char tempY[20];
        char tempZ[20];
        char tempzRotate[20];
        
        sprintf(tempID, "%d", input_robotList[i].robotID);  // ← ADD ID
        sprintf(tempX, "%.4f", input_robotList[i].x);
        sprintf(tempY, "%.4f", input_robotList[i].y);
        sprintf(tempZ, "%.4f", input_robotList[i].z);
        sprintf(tempzRotate, "%.4f", input_robotList[i].zRotate);
        
        // NEW FORMAT: id,x,y,z,rot;
        temp_ss << tempID << "," << tempX << "," << tempY << "," << tempZ << "," << tempzRotate << ";";
        
        Output_RobotData = Output_RobotData + temp_ss.str();
    }

    string Final_Output_RobotData = temp_startPosition.str() + Output_RobotData;

    return Final_Output_RobotData;
}


// MessageHandler receives NatNet error/debug messages
void NATNET_CALLCONV MessageHandler(Verbosity msgType, const char* msg)
{
    // Optional: Filter out debug messages
    if (msgType < Verbosity_Info)
    {
        return;
    }

    printf("\n[NatNetLib]");

    switch (msgType)
    {
    case Verbosity_Debug:
        printf(" [DEBUG]");
        break;
    case Verbosity_Info:
        printf("  [INFO]");
        break;
    case Verbosity_Warning:
        printf("  [WARN]");
        break;
    case Verbosity_Error:
        printf(" [ERROR]");
        break;
    default:
        printf(" [?????]");
        break;
    }

    printf(": %s\n", msg);
}


/* File writing routines */
void _WriteHeader(FILE* fp, sDataDescriptions* pBodyDefs)
{
    int i = 0;

    if (pBodyDefs->arrDataDescriptions[0].type != Descriptor_MarkerSet)
        return;

    sMarkerSetDescription* pMS = pBodyDefs->arrDataDescriptions[0].Data.MarkerSetDescription;

    fprintf(fp, "<MarkerSet>\n\n");
    fprintf(fp, "<Name>\n%s\n</Name>\n\n", pMS->szName);

    fprintf(fp, "<Markers>\n");
    for (i = 0; i < pMS->nMarkers; i++)
    {
        fprintf(fp, "%s\n", pMS->szMarkerNames[i]);
    }
    fprintf(fp, "</Markers>\n\n");

    fprintf(fp, "<Data>\n");
    fprintf(fp, "Frame#\t");
    for (i = 0; i < pMS->nMarkers; i++)
    {
        fprintf(fp, "M%dX\tM%dY\tM%dZ\t", i, i, i);
    }
    fprintf(fp, "\n");

}


void _WriteFrame(FILE* fp, sFrameOfMocapData* data)
{
    fprintf(fp, "%d", data->iFrame);
    for (int i = 0; i < data->MocapData->nMarkers; i++)
    {
        fprintf(fp, "\t%.5f\t%.5f\t%.5f", data->MocapData->Markers[i][0], data->MocapData->Markers[i][1], data->MocapData->Markers[i][2]);
    }
    fprintf(fp, "\n");
}


void _WriteFooter(FILE* fp)
{
    fprintf(fp, "</Data>\n\n");
    fprintf(fp, "</MarkerSet>\n");
}


void resetClient()
{
    int iSuccess;

    printf("\n\nre-setting Client\n\n.");

    iSuccess = g_pClient->Disconnect();
    if (iSuccess != 0)
        printf("error un-initting Client\n");

    iSuccess = g_pClient->Connect(g_connectParams);
    if (iSuccess != 0)
        printf("error re-initting Client\n");
}

float PID(float kp, float ki, float kd, float sp, float pv, float _dt, float& errorTotal)
{
    int limitPID = 150;
    //system PV (Process Variable) the desire value SP (SetPoint) nhỏ nhất có thể (~ 0)
    float output = 0;

    float error = sp - pv;
    float p = kp * pv;
    float i = ki * errorTotal;
    float d = kd * error / _dt;
    errorTotal = errorTotal + error;

    output = p + i + d;
    if (output < -150)
    {
        output = -150;
    }
    else if (output > 150)
    {
        output = 150;
    }

    return output;
}


#ifndef _WIN32
char getch()
{
    char buf = 0;
    termios old = { 0 };

    fflush(stdout);

    if (tcgetattr(0, &old) < 0)
        perror("tcsetattr()");

    old.c_lflag &= ~ICANON;
    old.c_lflag &= ~ECHO;
    old.c_cc[VMIN] = 1;
    old.c_cc[VTIME] = 0;

    if (tcsetattr(0, TCSANOW, &old) < 0)
        perror("tcsetattr ICANON");

    if (read(0, &buf, 1) < 0)
        perror("read()");

    old.c_lflag |= ICANON;
    old.c_lflag |= ECHO;

    if (tcsetattr(0, TCSADRAIN, &old) < 0)
        perror("tcsetattr ~ICANON");

    //printf( "%c\n", buf );

    return buf;
}
#endif


// Simple client code (run on other computers)
// SOCKET sock = socket(AF_INET, SOCK_STREAM, 0);
// sockaddr_in server;
// server.sin_family = AF_INET;
// server.sin_port = htons(5400);
// inet_pton(AF_INET, "OPTITRACK_SERVER_IP", &server.sin_addr);

// bind(sock, (sockaddr*)&server, sizeof(server));
// listen(sock, 1);

// SOCKET client = accept(sock, nullptr, nullptr);

// while(true) {
//     char buf[1000];
//     int bytes = recv(client, buf, 1000, 0);
//     if(bytes > 0) {
//         // Parse data: buf contains the robot data string
//         cout << buf << endl;
//     }
// }