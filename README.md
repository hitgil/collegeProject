# Flutter Arduino Bluetooth Control App

This Flutter app provides a user interface to connect to an Arduino device over Bluetooth and send commands to control it. The app also displays responses from the Arduino in real-time.

## Features

- Connect to an Arduino device via Bluetooth.
- Send custom commands to control your Arduino.
- Receive and display responses from the Arduino on the app.
- Simple and user-friendly interface.

## Prerequisites

Before you start using this app, ensure that you have the following:

- Flutter development environment set up on your computer.
- An Arduino device with Bluetooth capabilities (e.g., HC-05 or HC-06 module).
- The Arduino code modified to accept and respond to specific commands over Bluetooth.

## Getting Started

1. Clone this repository
1. Navigate to the project directory:
    ```
    cd flutter-arduino-bluetooth-app
    ```
1. Open the Flutter app in your preferred development environment.

1. Connect your mobile device (Android or iOS) to your computer or use an emulator.

1. Build and run the Flutter app on your device
1. The app will start scanning for nearby Bluetooth devices. Select your Arduino device from the list to establish a connection.
1. Once connected, you can use the app's interface to send custom commands to the Arduino.

## Usage

- Use the text field to enter a command and press the send button to send it to the Arduino.
- The app will display the responses received from the Arduino in real-time.