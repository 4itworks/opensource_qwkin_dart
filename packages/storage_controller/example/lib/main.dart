import 'package:flutter/material.dart';
import 'package:storage_controller/storage_controller.dart';

void main() {
  runApp(MyApp());
}

class SharedPreferencesStorage extends StorageController {
  SharedPreferencesStorage() : super.sharedPreferences();
}

class HiveStorage extends StorageController {
  HiveStorage() : super.hive('storage');
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final hive = HiveStorage();
  final sharedPreferences = SharedPreferencesStorage();

  int _counter = 0;

  Future<int?> get counterOnHive async => await hive.read<int>(key: 'counter');
  Future<int?> get counterOnSP async =>
      await sharedPreferences.read<int>(key: 'counter');

  void _incrementCounter() {
    setState(() {
      _counter++;
      hive.write<int>(key: 'counter', value: _counter);
      sharedPreferences.write<int>(key: 'counter', value: _counter);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FutureBuilder<int?>(
                future: counterOnHive,
                builder: (_, future) {
                  if (future.connectionState == ConnectionState.done) {
                    return Text(
                      'You have pushed the button this many times on hive: ${future.data}',
                    );
                  }

                  return Container();
                }),
            FutureBuilder<int?>(
                future: counterOnSP,
                builder: (_, future) {
                  if (future.connectionState == ConnectionState.done) {
                    return Text(
                      'You have pushed the button this many times on shared prefs: ${future.data}',
                    );
                  }

                  return Container();
                }),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
