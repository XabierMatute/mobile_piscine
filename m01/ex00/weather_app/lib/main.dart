import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      theme: ThemeData(
        colorScheme: ColorScheme.dark(

        ),
      ),
      home: const MyHomePage(title: 'Weather App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WeatherAppBar(widget: widget),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: const Text('Texto'),
      ),
    );
  }
}

class WeatherAppBar extends AppBar {
  WeatherAppBar({
    super.key,
    required this.widget,
  }) : super(
          backgroundColor: Colors.blue,
          title: Row(
            children: [
              // Search TextField
              Expanded(
                child: Container(
                  height: 40, // Ajusta la altura según sea necesario
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search...',
                      prefixIcon: const Icon(Icons.search, color: Colors.white), // Ícono de lupa
                      // contentPadding: EdgeInsets.symmetric(vertical: 0), // Ajusta el padding interno
                      // border: OutlineInputBorder(
                      //   borderRadius: BorderRadius.circular(20),
                      // ),
                      // filled: true,
                      // fillColor: Colors.white.withOpacity(0.3),
                    ),
                  ),
                ),
              ),
              // Geolocation Button
              IconButton(
                icon: const Icon(Icons.location_on, color: Colors.white),
                onPressed: () {
                  // Handle geolocation button press
                },
              ),
            ],
          ),
        );

  final MyHomePage widget;
}
