import 'package:flutter/material.dart';
import 'package:control_pad/control_pad.dart';
import 'package:flutter_blue/flutter_blue.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Scaffold(
        body: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red,
                  ),
                  child: const Text('TV'),
                  
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red,
                  ),
                  child: const Text('DIGA'),
                  
                ),
                OutlinedButton(
                  onPressed: () {},
                  child: const Text('入力切替'),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                OutlinedButton(
                  onPressed: () {},
                  child: const Text('録画視聴'),
                ),
                OutlinedButton(
                  onPressed: () {},
                  child: const Text('番組表'),
                ),
              ],
            ),
            Row(
              children:  <Widget>[
                JoystickView()
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                OutlinedButton(
                  onPressed: () {},
                  child: const Text('1'),
                ),
                OutlinedButton(
                  onPressed: () {},
                  child: const Text('2'),
                ),
                OutlinedButton(
                  onPressed: () {},
                  child: const Text('3'),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                OutlinedButton(
                  onPressed: () {},
                  child: const Text('4'),
                ),
                OutlinedButton(
                  onPressed: () {},
                  child: const Text('5'),
                ),
                OutlinedButton(
                  onPressed: () {},
                  child: const Text('6'),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                OutlinedButton(
                  onPressed: () {},
                  child: const Text('7'),
                ),
                OutlinedButton(
                  onPressed: () {},
                  child: const Text('8'),
                ),
                OutlinedButton(
                  onPressed: () {},
                  child: const Text('9'),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                OutlinedButton(
                  onPressed: () {},
                  child: const Text('<ch>'),
                ),
                OutlinedButton(
                  onPressed: () {},
                  child: const Text('+-'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
