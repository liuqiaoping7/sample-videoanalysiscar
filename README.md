EN|[CN](README_cn.md)

Developers can deploy the application on the Atlas 200 DK AI acceleration cloud server to decode the local MP4 file or RTSP video streams, detect vehicles in video frames, predict their attributes, generate structured information, and send the structured information to the server for storage and display.

## Prerequisites<a name="en-us_topic_0167343881_section412314183119"></a>

Before using an open source application, ensure that:

-   MindSpore Studio has been installed.
-   The Atlas 200 DK developer board has been connected to MindSpore Studio, the cross compiler has been installed, the SD card has been prepared, and basic information has been configured. 

## Software Preparation<a name="en-us_topic_0167343881_section431629175317"></a>

Before running the application, obtain the source code package and configure the environment as follows.

1.  Obtain the source code package.

    Download all the code in the sample-videoanalysiscar repository at  [https://github.com/Ascend/sample-videoanalysiscar](https://github.com/Ascend/sample-videoanalysiscar)  to any directory on Ubuntu Server where MindSpore Studio is located as the MindSpore Studio installation user, for example,  _/home/ascend/sample-videoanalysiscar_.

2.  Log in to Ubuntu Server where MindSpore Studio is located as the MindSpore Studio installation user and set the environment variable  **DDK\_HOME**.

    **vim \~/.bashrc**

    Run the following commands to add the environment variables  **DDK\_HOME**  and  **LD\_LIBRARY\_PATH**  to the last line:

    **export DDK\_HOME=/home/XXX/tools/che/ddk/ddk**

    **export LD\_LIBRARY\_PATH=$DDK\_HOME/uihost/lib**

    >![](doc/source/img/icon-note.gif) **NOTE:**   
    >-   **XXX**  indicates the MindSpore Studio installation user, and  **/home/XXX/tools**  indicates the default installation path of the DDK.  
    >-   If the environment variables have been added, skip this step.  

    Enter  **:wq!**  to save and exit.

    Run the following command for the environment variable to take effect:

    **source \~/.bashrc**


## Deployment<a name="en-us_topic_0167343881_section254863302012"></a>

1.  Access the root directory where the vehicle detection application code is located as the MindSpore Studio installation user, for example,  _**/home/ascend/sample-videoanalysiscar**_.
2.  <a name="en-us_topic_0167343881_li08019112542"></a>Run the deployment script to prepare the project environment, including compiling and deploying the ascenddk public library, downloading the network model, and configuring Presenter Server. The Presenter Server is used to receive the data sent by the application and display the result through the browser.

    **bash deploy.sh** _host\_ip_ **internet**

    -   _host\_ip_: For the Atlas 200 DK developer board, this parameter indicates the IP address of the developer board.For the AI acceleration cloud server, this parameter indicates the IP address of the host.



    Example command:

    **bash deploy.sh 192.168.1.2 internet**

    -   When the message  **Please choose one to show the presenter in browser\(default: 127.0.0.1\):**  is displayed, enter the IP address used for accessing the Presenter Server service in the browser. Generally, the IP address is the IP address for accessing the MindSpore Studio service.
    -   When the message  **Please input a absolute path to storage video analysis data:**  is displayed, enter the absolute path for storing video analysis data in MindSpore Studio. The MindSpore Studio user must have the read and write permissions. If the path does not exit, the script is automatically created.

    Select the IP address used by the browser to access the Presenter Server service in  **Current environment valid ip list**  and enter the path for storing video analysis data, as shown in  [Figure 1](#en-us_topic_0167343881_fig184321447181017).

    **Figure  1**  Project deployment<a name="en-us_topic_0167343881_fig184321447181017"></a>  
    ![](doc/source/img/project-deployment.png "project-deployment")

3.  <a name="en-us_topic_0167343881_li499911453439"></a>Start Presenter Server.

    Run the following command to start the Presenter Server program of the video analysis application in the background:

    **python3 presenterserver/presenter\_server.py --app video\_analysis\_car &**

    >![](doc/source/img/icon-note.gif) **NOTE:**   
    >**presenter\_server.py**  is located in the  **presenterserver**  directory. You can run the  **python3 presenter\_server.py -h**  or  **python3 presenter\_server.py --help**  command in this directory to view the usage method of  **presenter\_server.py**.  

    [Figure 2](#en-us_topic_0167343881_fig69531305324)  shows that the presenter\_server service is started successfully.

    **Figure  2**  Starting the Presenter Server process<a name="en-us_topic_0167343881_fig69531305324"></a>  
    ![](doc/source/img/starting-the-presenter-server-process.png "starting-the-presenter-server-process")

    Use the URL shown in the preceding figure to log in to Presenter Server \(only the Chrome browser is supported\). The IP address is that entered in  [2](#en-us_topic_0167343881_li08019112542)  and the default port number is  **7005**. The following figure indicates that Presenter Server is started successfully.

    **Figure  3**  Home page<a name="en-us_topic_0167343881_fig64391558352"></a>  
    ![](doc/source/img/home-page.png "home-page")

    **Figure 4** Example IP Address <a name="en-us_topic_0167333823_fig64391558353"></a>  
    ![](doc/source/img/connect.png "Example IP Address")

    Among them:
    - The IP address of the  Atlas 200 DK developer board is 192.168.1.2 (connected in USB mode).
    - The IP address used by the Presenter Server to communicate with the Atlas 200 DK is in the same network segment as the IP address of the Atlas 200 DK on the UI Host server. For example: 192.168.1.223.
    - The following is an example of accessing the IP address of the Presenter Server using a browser: 10.10.0.1, because the Presenter Server and MindSpore Studio are deployed on the same server, the IP address is also the IP address for accessing the MindSpre Studio through the browser.


4.  The video structured application can parse local videos and RTSP video streams.
    -   To parse a local video, upload the video file to the Host.

        For example, upload the video file  **car.mp4**  to the  **/home/HwHiAiUser/sample**  directory on the host.

        >![](doc/source/img/icon-note.gif) **NOTE:**   
        >H.264 and H.265 MP4 files are supported. If an MP4 file needs to be edited, you are advised to use FFmpeg. If a video file is edited by other tools, FFmpeg may fail to parse the file.  

    -   If only RTSP video streams need to be parsed, skip this step.


## Running<a name="en-us_topic_0167343881_section2044213563203"></a>

1.  Run the video analysis application.

    Run the following command in the  **/home/ascend/sample-videoanalysiscar**  directory to start the video analysis application:

    **bash run\_videoanalysiscarapp.sh** _host\_ip_ _presenter\_view\_appname_ _channel1_ _\[channel2\]_  &

    -   _host\_ip_: For the Atlas 200 DK developer board, this parameter indicates the IP address of the developer board.For the AI acceleration cloud server, this parameter indicates the IP address of the host.
    -   _presenter\_view\_app\_name_: Indicates  **View Name**  displayed on the Presenter Server page, which is user-defined. The value of this parameter must be unique on the Presenter Server page.
    -   _channel1_: absolute path of a video file on the host
    -   _channel2_: URL of an RTSP video stream

    Example command:

    **bash run\_videoanalysiscarapp.sh 192.168.1.2 video /home/HwHiAiUser/sample/car.mp4 &**

2.  Use the URL that is displayed when you start the Presenter Server service to log in to the Presenter Server website \(only the Chrome browser is supported\). For details, see  [3](#en-us_topic_0167343881_li499911453439).

    >![](doc/source/img/icon-note.gif) **NOTE:**   
    >The Presenter Server of the video analysis application supports the display of a maximum of two  _presenter\_view\_app\_name_  at the same time.  

    The navigation tree on the left displays the app name and channel name of the video. The large image of the extracted video frame and the detected target small image are displayed in the middle. After you click the small image, the detailed inference result and score are displayed on the right.

    Vehicle attribute detection supports the identification of vehicle brands, vehicle colors, and license plates.

    >![](doc/source/img/icon-note.gif) **NOTE:**   
    >In the network model of license plate recognition, the license plate images automatically generated by the program are trained as the training set, instead of using real license plate images. Therefore, this model has low accuracy in identifying real license plate numbers. If a high-accuracy model is required, collect real license plate images as the training set and train them.  


## Follow-up Operations<a name="en-us_topic_0167343881_section1092612277429"></a>

-   **Stopping the Video Structured Analysis Application**

    To stop the video analysis application, perform the following operations:

    Run the following command in the  **sample-videoanalysiscar**  directory as the MindSpore Studio installation user:

    **bash stop\_videoanalysiscarapp.sh** _host\_ip_

    _host\_ip_: For the Atlas 200 DK developer board, this parameter indicates the IP address of the developer board.For the AI acceleration cloud server, this parameter indicates the IP address of the host.

    Example command:

    **bash stop\_videoanalysiscarapp.sh** _192.168.1.2_

-   **Stopping the Presenter Server Service**

    The Presenter Server service is always in the running state after being started. To stop the Presenter Server service of the video structured analysis application, perform the following operations:

    Run the following command to check the process of the Presenter Server service corresponding to the video structured analysis application as the MindSpore Studio installation user:

    **ps -ef | grep presenter | grep video\_analysis\_car**

    ```
    ascend@ascend-HP-ProDesk-600-G4-PCI-MT:~/sample-videoanalysiscar$ ps -ef | grep presenter | grep video_analysis_car
    ascend 3655 20313 0 15:10 pts/24?? 00:00:00 python3 presenterserver/presenter_server.py --app video_analysis_car
    ```

    In the preceding information,  _3655_  indicates the process ID of the Presenter Server service corresponding to the facial recognition application.

    To stop the service, run the following command:

    **kill -9** _3655_
