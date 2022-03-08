import 'package:flutter/material.dart';
import 'package:tflite_example/mymodel.dart';
import 'package:tflite_example/othermodel.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text('TFLite'),
            bottom: TabBar(
              isScrollable: true,
              tabs: [
                Tab(
                  icon: Icon(Icons.home_filled),
                  text: "Other MOdel",
                ),
                Tab(
                  icon: Icon(Icons.account_box_outlined),
                  text: "Your Model",
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              Center(
                child: OtherModel(),
              ),
              Center(
                child: myModel(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
