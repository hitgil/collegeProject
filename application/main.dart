import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BluetoothConsole(),
    );
  }
}

class BluetoothConsole extends StatefulWidget {
  @override
  _BluetoothConsoleState createState() => _BluetoothConsoleState();
}

class _BluetoothConsoleState extends State<BluetoothConsole> {
  FlutterBlue flutterBlue = FlutterBlue.instance;
  BluetoothDevice? connectedDevice;
  Stream<List<int>>? dataStream;
  bool isConnected = false;
  final TextEditingController commandController = TextEditingController();
  final List<String> consoleOutput = [];

  @override
  void initState() {
    super.initState();
    _initBluetooth();
  }

  void _initBluetooth() async {
    flutterBlue = FlutterBlue.instance;

    flutterBlue.scanResults.listen((results) {
      for (ScanResult result in results) {
        if (result.device.name == 'YourArduinoName') {
          _connectToDevice(result.device);
          break;
        }
      }
    });

    flutterBlue.startScan();
  }

  void _connectToDevice(BluetoothDevice device) async {
    try {
      await device.connect();
      setState(() {
        connectedDevice = device;
        isConnected = true;
        _startListeningToArduino();
      });
    } catch (e) {
      print('Failed to connect to device: $e');
    }
  }

  void _startListeningToArduino() {
    final Guid serviceUuid = Guid('YOUR_SERVICE_UUID');
    final Guid characteristicUuid = Guid('YOUR_CHARACTERISTIC_UUID');

    dataStream = connectedDevice!
        .monitorCharacteristic(serviceUuid, characteristicUuid)
        .map((characteristic) => characteristic.value);
  }

  void _sendCommandToArduino(String command) {
    if (connectedDevice != null &&
        connectedDevice!.state == BluetoothDeviceState.connected) {
      connectedDevice!.writeCharacteristic(
        Guid('YOUR_SERVICE_UUID'),
        Guid('YOUR_CHARACTERISTIC_UUID'),
        utf8.encode(command),
        withoutResponse: true,
      );
    }
    commandController.clear();
  }

  @override
  void dispose() {
    connectedDevice?.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Arduino Console'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            isConnected
                ? Text('Connected to Arduino')
                : Text('Searching for Arduino...'),
            SizedBox(height: 20),
            Text(
              'Received Data:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: consoleOutput.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(consoleOutput[index]),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: commandController,
                    decoration: InputDecoration(
                      hintText: 'Enter Command',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    final command = commandController.text.trim();
                    if (command.isNotEmpty) {
                      _sendCommandToArduino(command);
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
