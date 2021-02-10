import 'package:flutter/material.dart';
import 'package:torch_controller/torch_controller.dart';

void main() {
  TorchController().initialize();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final controller = TorchController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            children: [
              FutureBuilder(
                  future: controller.isTorchActive,
                  builder: (_, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done)
                      return Text(
                          'Is torch on? ${snapshot.data ? 'Yes!' : 'No :('}');

                    return Container();
                  }),
              MaterialButton(
                  child: Text('Toggle'),
                  onPressed: () {
                    controller.toggle(intensity: 1);
                    setState(() {});
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
