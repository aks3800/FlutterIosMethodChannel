import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
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
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const platform = const MethodChannel('method_channel.flutter.dev/appIconBadge');

  // Get battery level.
  String _badgeCount = 'Unknown badge count';

  Future<void> _getBadgeCount() async {
    String badgeCount;
    try {
      final int result = await platform.invokeMethod('getBadgeCount');
      badgeCount = 'Badge count: $result';
    } on PlatformException catch (e) {
      badgeCount = "Failed to get badge count: '${e.message}'.";
    }

    setState(() {
      _badgeCount = badgeCount;
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
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              child: Text('Get Badge Count'),
              onPressed: _getBadgeCount,
            ),
            Text(_badgeCount),
          ],
        ),
      ), //
    );
  }
}
