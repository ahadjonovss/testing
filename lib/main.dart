import 'package:all_vibrate/all_vibrate.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:gaimon/gaimon.dart';
import 'package:vibration/vibration.dart';
import 'package:vibration_type/vibration_type_export.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Extended Counter App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.compact,
      ),
      home: OnboardingScreen(),
    );
  }
}

class OnboardingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final Iterable<Duration> pauses = [
            const Duration(milliseconds: 500),
            const Duration(milliseconds: 1000),
            const Duration(milliseconds: 500),
          ];
          final vibrate = AllVibrate();
          vibrate.waveForm(
            timings: [102, 303, 983, 332],
            amplitudes: [100, 150, 49, 100],
          );
        },
      ),
      appBar: AppBar(title: const Text("Welcome to the Counter App")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: ListView(
                children: [
                  TextButton(
                    onPressed: () async {
                      final String response = await rootBundle
                          .loadString('assets/haptics/rumble.ahap');
                      Gaimon.patternFromData(response);
                    },
                    child: const Text('📳 Rumble'),
                  ),
                  TextButton(
                    onPressed: () async {
                      final String response = await rootBundle
                          .loadString('assets/haptics/heartbeats.ahap');
                      Gaimon.patternFromData(response);
                    },
                    child: const Text('💗 Heartbeat'),
                  ),
                  TextButton(
                    onPressed: () async {
                      final String response = await rootBundle
                          .loadString('assets/haptics/gravel.ahap');
                      Gaimon.patternFromData(response);
                    },
                    child: const Text('🪨 Gravel'),
                  ),
                  TextButton(
                    onPressed: () async {
                      final String response = await rootBundle
                          .loadString('assets/haptics/inflate.ahap');
                      Gaimon.patternFromData(response);
                    },
                    child: const Text('😮‍💨 Inflate'),
                  ),
                ],
              ),
            ),
            const Text(
                "This app demonstrates an extended counter functionality with multiple pages."),
            ElevatedButton(
              child: const Text("Get Started"),
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => RegistrationPage())),
            )
          ],
        ),
      ),
    );
  }
}

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Registration")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Semantics(
              identifier: 'name_text_field',
              child: TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Enter your name',
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              child: const Text("Register"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        HomePage(userName: _nameController.text),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  final String userName;

  HomePage({required this.userName});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Page"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Hello, ${widget.userName}! Enter a starting number:'),
            Semantics(
              identifier: 'home_input',
              textField: true,
              child: TextField(
                controller: _controller,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Enter your username',
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CounterPage(
                      userName: widget.userName,
                      startingCount: int.tryParse(_controller.text) ?? 0,
                    ),
                  ),
                );
              },
              child: const Text('Start Counting'),
            ),
          ],
        ),
      ),
    );
  }
}

class CounterPage extends StatefulWidget {
  final String userName;
  final int startingCount;

  CounterPage({required this.userName, required this.startingCount});

  @override
  _CounterPageState createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  late int _counter;

  @override
  void initState() {
    super.initState();
    _counter = widget.startingCount;
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void _decrementCounter() {
    setState(() {
      _counter--;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Counter Page"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Welcome, ${widget.userName}!',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            Text('Counter: $_counter',
                style: Theme.of(context).textTheme.headlineSmall),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Semantics(
                  identifier: 'Decrement',
                  child: FloatingActionButton(
                    onPressed: _decrementCounter,
                    tooltip: 'Decrement',
                    child: const Icon(Icons.remove),
                  ),
                ),
                Semantics(
                  identifier: 'Increment',
                  child: FloatingActionButton(
                    onPressed: _incrementCounter,
                    tooltip: 'Increment',
                    child: const Icon(Icons.add),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
