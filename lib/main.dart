import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:control_pad/models/gestures.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:control_pad/control_pad.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'dart:convert' show utf8;

Future<void> main() async {
  await SystemChrome.setPreferredOrientations(
    [DeviceOrientation.landscapeRight, DeviceOrientation.landscapeLeft]
  );

  runApp(const MainScreen());
}

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Joy Pad Controller',
      debugShowCheckedModeBanner: false,
      home: const JoyPad(),
      theme: ThemeData.dark(),
    );
  }
}

class JoyPad extends StatefulWidget {
  const JoyPad({Key? key}) : super(key: key);
  @override
  _JoyPadState createState() => _JoyPadState();
}

class _JoyPadState extends State<JoyPad> {

  // ignore: non_constant_identifier_names
  final String SERVICE_UUID = "4f705cb9-dd65-4fb3-a023-9c0abc499073";
  // ignore: non_constant_identifier_names
  final String CHARACTERISTIC_UUID = "7ec1bd64-ae0f-4fbc-b4fb-cb0db6f443ed";

  FlutterBlue flutterBlue = FlutterBlue.instance;
  // StreamSubscription<ScanResult> scanSubScription;
  // StreamSubscription<ScanResult>;

  late BluetoothDevice device;
  late BluetoothCharacteristic targetCharacteristic;

  String connectionText = "";

  @override
  void initState() {
    super.initState();
    startScan();
  }

  startScan() {
    setState(() {
      connectionText = "Start Scanning";
    });

    flutterBlue.startScan(timeout: const Duration(seconds: 4));
    flutterBlue.scanResults.listen((results) {
      for (ScanResult r in results) {
        debugPrint('${r.device.name} found! rssi: ${r.rssi}');
      }
      setState(() {
          connectionText = "Found device !";
        });

        connectToDevice();
    });
    flutterBlue.stopScan();
  }

  connectToDevice() async {
    setState(() {
      connectionText = "device connecting";
    });

    await device.connect();
    discoverServices();
  }

  discoverServices() async {

    List<BluetoothService> services = await device.discoverServices();
    for (var service in services) {
      if(service.uuid.toString() == SERVICE_UUID) {
        for (var characteristic in service.characteristics) {
          if(characteristic.uuid.toString() == CHARACTERISTIC_UUID) {
            targetCharacteristic = characteristic;
            writeData("Hi there esp32!!!");
            setState(() {
              connectionText = "All Ready with ${device.name}";
            });
          }
        }
      }
    }
  }

  writeData(String data) async {

    List<int> bytes = utf8.encode(data);
    await targetCharacteristic.write(bytes);
  }

  @override
  Widget build(BuildContext context) {
    // ignore: body_might_complete_normally_nullable
    JoystickDirectionCallback? onDirectionChanged(double degrees, double distance) {
        String data = "Degree: ${degrees.toStringAsFixed(2)}, distance: ${distance.toStringAsFixed(2)}";
        debugPrint(data);
        writeData(data);
        // return null;
    }

    // ignore: body_might_complete_normally_nullable
    PadButtonPressedCallback? padButtonPressedCallback(int buttonIndex, Gestures gesture) {
      String data = "buttonIndex: $buttonIndex";
      debugPrint(data);
      writeData(data);
      // return null;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(connectionText),
      ),
      body: Container(
        // ignore: unnecessary_null_comparison
        child: targetCharacteristic == null
          ? const Center(
                child: Text("waiting...",
                  style: TextStyle(fontSize: 24, color: Colors.deepOrange),
                ),
            )
            : Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget> [
                JoystickView(onDirectionChanged: onDirectionChanged),
                PadButtonsView(padButtonPressedCallback: padButtonPressedCallback),
              ],
            ),
      ),
    );
  }
}
