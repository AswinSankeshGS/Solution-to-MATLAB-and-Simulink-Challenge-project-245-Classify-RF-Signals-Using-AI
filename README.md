# Solution-to-MATLAB-and-Simulink-Challenge-project-245-Classify-RF-Signals-Using-AI

## RF Signal Interference Detection

### Introduction

This project focuses on identifying RF signals that may interfere with one another, addressing the increasing RF congestion in the modern technology era. Specifically, it aims to detect and suppress interference between WiFi and Bluetooth signals.

### Project Details

The project utilizes MATLAB and Adalm Pluto to generate and transmit WiFi and Bluetooth signals in real-time, subsequently identifying their presence through a trained machine learning (ML) model. The process involves:

1. **Signal Generation and Transmission**: MATLAB and Adalm Pluto are employed to generate and transmit WiFi and Bluetooth signals. Data is collected at various distances between the transmitter and receiver, with different transmission and reception gains to ensure a diverse dataset.

2. **Data Collection**: Datasets are collected separately for WiFi and Bluetooth signals, including instances where interference is intentionally induced.

3. **Machine Learning Model Development**: A dedicated ML model is developed to classify data into three classes: WiFi, Bluetooth, and both WiFi and Bluetooth signals, based on the received baseband spectrum.

4. **Real-time Testing**: The developed ML model is tested in real-time using Adalm Pluto hardware to sense the presence of WiFi/Bluetooth signals.

### Hardware Setup
Maximum of 3 Adalm Pluto Hardware is used to transmit Wifi and Bluetooth signals simultaneously 
and then receive using a different hardware.
### Description of Files

This GitHub repository contains sub-folders with different MATLAB codes:

- **Transmitter**: MATLAB codes and functions for generating and transmitting WiFi and Bluetooth signals in real-time using Adalm Pluto. Sample spectrogram images of transmitted signals are included.

- **Receiver**: A MATLAB code depicting the receiver structure for capturing RF signals present in the environment. Data collection is facilitated using the codes in the Transmitter and Receiver folders.

- **Training**: MATLAB code for training the ML model using the collected dataset. The trained ML model file is also provided.

- **Testing**: MATLAB program for real-time testing of the developed algorithm using Adalm Pluto.

Feel free to explore the respective folders for detailed implementations and functionalities.
### How to Run

To run this MATLAB code, ensure you have the following prerequisites:

1. Maximum of 3 Adalm Pluto hardware devices configured with AD3964 chips.
2. Three PCs with MATLAB 2023b or later versions installed, with Adalm Pluto package support.

To test the program:

1. Download the `ML_model.mat` file to load the pre-trained ML network.
2. Run the program named `testingML.m` under the Testing sub-folder. This file serves as the receiver.

To transmit WiFi/Bluetooth/both signals:

1. Execute the appropriate files in the `Training` sub-folder on a different computer.

### Training the ML Model

If you wish to train the ML model:

1. Create datasets for WiFi/Bluetooth/both signals using the files in the `Transmitter` folder.
2. Train the model using MATLAB codes in the `Training` folder.
3. Follow the same procedure for testing after training.

Ensure you follow these steps carefully to effectively utilize and test the MATLAB code for RF signal interference detection.
### Demo

The following video, shows the demo of our solution

### Contributors

- Aswin Sankesh G S
- Balavadhana B
- Ganeshkumar V
- Velmurugan PGS


