import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:control_pad/models/gestures.dart';
import 'package:control_pad/control_pad.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_blue/gen/flutterblue.pbserver.dart';
import 'dart:convert' show utf8;

Future<void> main() async {
  await SystemChrome.setPreferredOrientations(
    [DeviceOrientation.landscapeRight, DeviceOrientation.landscapeLeft]
  );

  runApp(MainScreen());
}

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Joy Pad Controller',
      debugShowCheckedModeBanner: false,
      home: JoyPad(),
      theme: ThemeData.dark(),
    );
  }
}

class JoyPad extends StatefulWidget {
  @override
  _JoyPadState createState() => _JoyPadState();
}

class _JoyPadState extends State<JoyPad> {

  final String #define SERVICE_UUID = "";
  final String #define CHARACTERISTIC_UUID = "";
  final String TARGET_DEVICE_NAME = "esp32";

  FlutterBlue flutterBlue = FlutterBlue.instance;
  StreamSubscription<ScanResult> scanSubSubscription;

  BluetoothDevice targetDevice;
  BluetoothCharacteristic targetCharacteristic;

  String connectionText = "";

  void initState() {
    super.initState();
    startScan();
  }

  startScan() {
    setState(() {
      connectionText = "Start Scanning";
    });

    scanSubScription = flutterBlue.scan().listen((scanResult) {
      if(scanResult.device.name == TARGET_DEVICE_NAME) {
        print("device found");
        stopScan();
        setState(() {
          connectionText = "Found target device";
        });

        targetDevice = scanResult.device;
        connectToDevice();

      }
    }onDone: () => stopScan());
  }

  stopScan() {
    scanSubScription?.cancel();
    scanSubScription = null;
  }
  
  connectToDevice() async {
    if(targetDevice == null) return;

    setState(() {
      connectionText = "device connecting";
    });

    await targetDevice.connect();
    print("device connected");
    setState(() {
      connectionText = "device connected";
    });

    discoverServices();
  }

  disconnectFromDevice() {
    if(targetDevice == null) return;

    targetDevice.disconnect();

    setState(() {
      connectionText = "device disconnected";
    });
  }

  discoverServices() async {
    if(targetDevice == null) return;

    List<BluetoothService> services = await targetDevice.discoverServices();
    services.forEach((service) {
      if(service.uuid.toString() == SERVICE_UUID) {
        service.Characteristics.forEach((characteristic) {
          if(characteristic.uuid.toString() == CHARACTERISTIC_UUID) {
            targetCharacteristic = characteristic;
            writeData("Hi there esp32!!!");
            setState(() {
              connectionText = "All Ready with ${targetDevice.name}";
            });
          }
        });
      }
    });
  }

  writeData(String data) async {
    if(targetCharacteristic == null) return;

    List<int> bytes = utf8.encode(data);
    await targetCharacteristic.write(bytes);
  }

  @override
  Widget build(BuildContext context) {
    JoystickDirectionCallback onDirectionChanged(double degrees, double distance) {
        String data = "Degree: ${degrees.toStringAsFixed(2)}, distance: ${distance.toStringAsFixed(2)}";
        print(data);
        writeData(data);
    }

    PadButtonPressedCallback padButtonPressedCallback(int buttonIndex, Gestures gesture) {
      String data = "buttonIndex: ${buttonIndex}";
      print(data);
      writeData(data);
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(connectionText),
      ),
      body: Container(
        child: targetCharacteristic == null
            ? Center(
              child: Text(
                "waiting...",
                style: TextStyle(fontSize: 24, color: Colors.deepOrange),
              ),
            )
            : Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget> [
                JoystickView(onDirectionChanged: onDirectionChanged,),
                PadButtonsView(padButtonPressedCallback: padButtonPressedCallback,),
              ],
            ),
      ),
    );
  }
}
