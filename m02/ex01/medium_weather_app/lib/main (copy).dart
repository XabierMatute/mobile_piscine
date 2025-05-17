import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:open_meteo/open_meteo.dart';


void test_open_meteo() async {
  final weather = WeatherApi(temperatureUnit: TemperatureUnit.celsius);
  final geocoding = GeocodingApi();

  final durdus = await geocoding.requestJson(name: 'Urduliz');
  final durdu = durdus["results"][0];
  // final durdu = await geocoding.request('Urduliz');
  print(durdu);
  final response = await weather.request(
    // latitude: 41.2287,
    // longitude: 1.7457,
    latitude: durdu["latitude"],
    longitude: durdu["longitude"],
    hourly: {WeatherHourly.temperature_2m},
    current: {WeatherCurrent.temperature_2m},

    // current: {WeatherCurrent.rain},
    startDate: DateTime(2025, 3, 30),
    endDate: DateTime(2025, 3, 31),
    // temperature_unit: TemperatureUnit.celsius,
  );
  final data = response.currentData[WeatherCurrent.temperature_2m]!;
  // final data = response.hourlyData[WeatherHourly.temperature_2m]!;
  // final currentTemperature = data.values;
  final currentTemperature = data.value;

  print(currentTemperature);

}

Future<Position> _determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled don't continue
    // accessing the position and request users of the 
    // App to enable the location services.
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permissions are denied, next time you could try
      // requesting permissions again (this is also where
      // Android's shouldShowRequestPermissionRationale 
      // returned true. According to Android guidelines
      // your App should show an explanatory UI now.
      return Future.error('Location permissions are denied');
    }
  }
  
  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately. 
    return Future.error(
      'Location permissions are permanently denied, we cannot request permissions.');
  } 

  // When we reach here, permissions are granted and we can
  // continue accessing the position of the device.
  return await Geolocator.getCurrentPosition();
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      theme: ThemeData(
        colorScheme: ColorScheme.dark(
          primary: Colors.blue,
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

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _location = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _updateLocation(String location) {
    setState(() {
      _location = location;
    });
  }

  void _geolocate() {
    Future<Position> position = _determinePosition();


    position.then((value) => 
      setState(() async {
        _updateLocation(value.toString());
      // _updateLocation(value.toString());
    })).catchError((error) {
      setState(() {
        print('Error: $error');
        _updateLocation(error.toString());
      });
    });
  }

  // Future<void> _summitLocation(String location) async {
  //   List<Location> locations = await locationFromAddress(location).catchError(
  //     (error) {
  //       setState(() {
  //         print('Error: $error');
  //         _updateLocation(error.toString());
  //       });
  //       return Future<List<Location>>.error([]);
  //     }
  //   );

  //   setState(() {
  //     _updateLocation(locations[0].toString());
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(42.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: AutocompleteBasicPositionExample(),
                                                                ),
                    IconButton(
                      icon: const Icon(Icons.bug_report),
                      onPressed: () async {
                        // Search button action
                        print('Debug button pressed');
                        test_open_meteo();
                        final geocoding = GeocodingApi();

                        final durdus = await geocoding.requestJson(name: 'Plent');

                        setState(() {
                          final results = durdus["results"];
                          String location = "";
                          for (var result in results) {
                            location += "${result["name"]}, ${result["country"]}\n";
                          }
                          _location = location;
                        });
                        // _summitLocation(_location);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.location_on),
                      onPressed: () {
                        // Geolocation button action
                        print('Geolocation button pressed');
                        _geolocate();
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          Center(child: Text('Currently\n$_location', textAlign: TextAlign.center)),
          Center(child: Text('Today\n$_location', textAlign: TextAlign.center)),
          Center(child: Text('Weekly\n$_location', textAlign: TextAlign.center)),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.window), text: 'Currently'),
            Tab(icon: Icon(Icons.today), text: 'Today'),
            Tab(icon: Icon(Icons.calendar_view_week), text: 'Weekly'),
          ],
        ),
      ),
    );
  }
}

class AutocompleteBasicExample extends StatelessWidget {
  const AutocompleteBasicExample({super.key});

  static const List<String> _kOptions = <String>['aardvark', 'bobcat', 'chameleon'];
  // static final List<Position> _kOptions =  <Position>[Position(latitude: 0.0, longitude: 0.0)];


  @override
  Widget build(BuildContext context) {
    return Autocomplete<String>(
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text == '') {
          return const Iterable<String>.empty();
        }
        return _kOptions.where((String option) {
          return option.contains(textEditingValue.text.toLowerCase());
        });
      },
      onSelected: (String selection) {
        debugPrint('You just selected $selection');
      },
    );
  }
}

class AutocompleteBasicPositionExample extends StatelessWidget {
  const AutocompleteBasicPositionExample({super.key});

  static final List<Position> _userOptions = <Position>[
    Position(
      longitude: -74.0060, // Nueva York
      latitude: 40.7128,
      timestamp: DateTime.now(),
      accuracy: 10.0,
      altitude: 10.0,
      altitudeAccuracy: 5.0,
      heading: 0.0,
      headingAccuracy: 0.0,
      speed: 0.0,
      speedAccuracy: 0.0,
    ),
    Position(
      longitude: -0.1276, // Londres
      latitude: 51.5074,
      timestamp: DateTime.now(),
      accuracy: 10.0,
      altitude: 35.0,
      altitudeAccuracy: 5.0,
      heading: 0.0,
      headingAccuracy: 0.0,
      speed: 0.0,
      speedAccuracy: 0.0,
    ),
    Position(
      longitude: 139.6917, // Tokio
      latitude: 35.6895,
      timestamp: DateTime.now(),
      accuracy: 10.0,
      altitude: 40.0,
      altitudeAccuracy: 5.0,
      heading: 0.0,
      headingAccuracy: 0.0,
      speed: 0.0,
      speedAccuracy: 0.0,
    ),
  ];

  static String _displayStringForOption(Position option) {
    // Muestra el nombre de la ciudad basado en las coordenadas
    if (option.latitude == 40.7128 && option.longitude == -74.0060) {
      return "Nueva York, EE.UU.";
    } else if (option.latitude == 51.5074 && option.longitude == -0.1276) {
      return "Londres, Reino Unido";
    } else if (option.latitude == 35.6895 && option.longitude == 139.6917) {
      return "Tokio, Japón";
    } else {
      return "${option.latitude}, ${option.longitude}";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Autocomplete<Position>(
      displayStringForOption: _displayStringForOption,
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text.isEmpty) {
          return const Iterable<Position>.empty();
        }
        return _userOptions.where((Position option) {
          return _displayStringForOption(option)
              .toLowerCase()
              .contains(textEditingValue.text.toLowerCase());
        });
      },
      onSelected: (Position selection) {
        debugPrint('Seleccionaste: ${_displayStringForOption(selection)}');
      },
    );
  }
} 