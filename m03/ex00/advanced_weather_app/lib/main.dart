import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:open_meteo/open_meteo.dart';


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
  String _error = '';
  String _location = '';
  String _currentWeather = '';
  String _todayWeather = '';
  String _weeklyWeather = '';

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

//   Code	Description
// 0	Clear sky
// 1, 2, 3	Mainly clear, partly cloudy, and overcast
// 45, 48	Fog and depositing rime fog
// 51, 53, 55	Drizzle: Light, moderate, and dense intensity
// 56, 57	Freezing Drizzle: Light and dense intensity
// 61, 63, 65	Rain: Slight, moderate and heavy intensity
// 66, 67	Freezing Rain: Light and heavy intensity
// 71, 73, 75	Snow fall: Slight, moderate, and heavy intensity
// 77	Snow grains
// 80, 81, 82	Rain showers: Slight, moderate, and violent
// 85, 86	Snow showers slight and heavy
// 95 *	Thunderstorm: Slight or moderate
// 96, 99 *	Thunderstorm with slight and heavy hail
  static const weatherCodes = {
    0: 'Clear sky',
    1: 'Mainly clear',
    2: 'Partly cloudy',
    3: 'Overcast',
    45: 'Fog',
    48: 'Depositing rime fog',
    51: 'Light drizzle',
    53: 'Moderate drizzle',
    55: 'Dense drizzle',
    56: 'Light freezing drizzle',
    57: 'Dense freezing drizzle',
    61: 'Slight rain',
    63: 'Moderate rain',
    65: 'Heavy rain',
    66: 'Light freezing rain',
    67: 'Heavy freezing rain',
    71: 'Slight snow fall',
    73: 'Moderate snow fall',
    75: 'Heavy snow fall',
    77: 'Snow grains',
    80: 'Slight rain showers',
    81: 'Moderate rain showers',
    82: 'Violent rain showers',
    85: 'Slight snow showers',
    86: 'Heavy snow showers',
    // Thunderstorm codes
    95: 'Slight thunderstorm',
    96: 'Thunderstorm with slight hail',
    99: 'Thunderstorm with heavy hail'
  };

  String _extractCurrentWeather(ApiResponse<WeatherApi> response) {
    final currentTemperature = response.currentData[WeatherCurrent.temperature_2m]?.value.toStringAsFixed(1)?? 'N/A';
    final currentWeatherValue = response.currentData[WeatherCurrent.weather_code]?.value ?? 'N/A';
    final currentWeatherDescription = weatherCodes[currentWeatherValue] ?? 'Unknown weather';
    final windSpeed = response.currentData[WeatherCurrent.wind_speed_10m]?.value.toStringAsFixed(1) ?? 'N/A';
    return '$currentTemperature °C\n$currentWeatherDescription\n$windSpeed km/h';
  }

  String _extractTodayWeather(ApiResponse<WeatherApi> response) {
    String todayWeather = '';
    final todayWeatherData = response.hourlyData[WeatherHourly.temperature_2m]?.values;
    final todayWeatherCode = response.hourlyData[WeatherHourly.weather_code]?.values;
    final todayWindSpeed = response.hourlyData[WeatherHourly.wind_speed_10m]?.values;
    final today = DateTime.now();
    for (int hour = 0; hour <= 24; hour++) {
      final dateTime = DateTime(today.year, today.month, today.day, hour);
      final temperature = todayWeatherData?[dateTime]?.toStringAsFixed(1) ?? 'N/A';
      final weatherCode = todayWeatherCode?[dateTime] ?? 'N/A';
      final windSpeed = todayWindSpeed?[dateTime]?.toStringAsFixed(1) ?? 'N/A';
      final weatherDescription = weatherCodes[weatherCode] ?? 'Unknown weather';
      todayWeather += '$hour:00 - $temperature °C $weatherDescription $windSpeed km/h\n';
    }
    return todayWeather;
  }

  String _extractWeeklyWeather(ApiResponse<WeatherApi> response) {
    String weeklyWeather = '';
    final weeklyTemperatureMin = response.dailyData[WeatherDaily.temperature_2m_min]?.values;
    final weeklyTemperatureMax = response.dailyData[WeatherDaily.temperature_2m_max]?.values;
    final weeklyWeatherCode = response.dailyData[WeatherDaily.weather_code]?.values;
    final today = DateTime.now();
    for (int day = 0; day < 7; day++) {
      final dateTime = DateTime(today.year, today.month, today.day + day);
      final temperatureMax = weeklyTemperatureMax?[dateTime]?.toStringAsFixed(1) ?? 'N/A';
      final temperatureMin = weeklyTemperatureMin?[dateTime]?.toStringAsFixed(1) ?? 'N/A';
      final weatherCode = weeklyWeatherCode?[dateTime] ?? 'N/A';
      final weatherDescription = weatherCodes[weatherCode] ?? 'Unknown weather';
      weeklyWeather += '${dateTime.day}/${dateTime.month} -$temperatureMin °C / $temperatureMax °C - $weatherDescription\n';
    }
    return weeklyWeather;
  }


  Future<void> _updateWeatherFromCoordinates(double latitude, double longitude) async {
      try {
        final wAPI = WeatherApi(temperatureUnit: TemperatureUnit.celsius);
        final now = DateTime.now();
        final response = await wAPI.request(
          latitude: latitude,
          longitude: longitude,
          hourly: {WeatherHourly.temperature_2m, WeatherHourly.weather_code, WeatherHourly.wind_speed_10m},
          daily: {WeatherDaily.temperature_2m_max, WeatherDaily.temperature_2m_min, WeatherDaily.weather_code},
          current: {WeatherCurrent.temperature_2m, WeatherCurrent.weather_code, WeatherCurrent.wind_speed_10m},
          startDate: DateTime(now.year, now.month, now.day, 0, 0, 0),
          endDate: now.add(const Duration(days: 7)),
        );
        setState(() {
        _error = '';
        _currentWeather = _extractCurrentWeather(response);
        _todayWeather = _extractTodayWeather(response);
        _weeklyWeather = _extractWeeklyWeather(response);
        });
      } on Exception catch (e) {
        print('Error: $e');
        _updateError("Error connecting to the weather API\nPlease check your internet connection and try again.");
        return;
      }


  }

  void _updateError(String error) {
    setState(() {
      _currentWeather = '';
      _todayWeather = '';
      _weeklyWeather = '';
      _location = '';
      _error = error;
    });
  }

  void _updateLocation(String location) {
    setState(() {
      _location = location;
    });
  }

  void _geolocate() {
    Future<Position> position = _determinePosition();
    position.then((value) => 
      setState(() {
      _updateLocation(value.toString());
      _updateWeatherFromCoordinates(value.latitude, value.longitude);
    })).catchError((error) {
      print('Error(position): $error');
      if (error is MissingPluginException) {
        _updateError("Error: Missing plugin for geolocation\nAre you sure this device supports geolocation?");
      }
      else if (error is PermissionDeniedException) {
        _updateError("Error: Permission denied\nPlease enable location permissions in your device settings.");
      }
      else if (error is LocationServiceDisabledException) {
        _updateError("Error: Location services disabled\nPlease enable location services in your device settings.");
      }
      else {
        _updateError("Error: $error");
      }
    });
  }

  void _locationSelected(Location location) {
    print('Location selected: ${location.name}');
    setState(() {
      _location = formatPlace(location.name, location.region, location.country);
      _updateWeatherFromCoordinates(location.latitude!, location.longitude!);
    });
  }

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
                      child: Autocomplete<Location>(
                        optionsBuilder: optionBuilder,
                        onSelected: (option) {
                          _locationSelected(option);
                          FocusScope.of(context).unfocus();
                        },                 
                        fieldViewBuilder: fieldViewBuilder,

                      ),
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
          Center(child: SingleChildScrollView(child: Column(children: [Text('Currently\n', textAlign: TextAlign.center), currentlyViewBuilder()],),)),
          Center(child: SingleChildScrollView(child: Column(children: [Text('Today\n', textAlign: TextAlign.center), todayViewBuilder()],),)),
          Center(child: SingleChildScrollView(child: Column(children: [Text('Weekly\n', textAlign: TextAlign.center), weeklyViewBuilder()],),)),
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

  Widget currentlyViewBuilder() {
    if (_error.isNotEmpty) {
      return errorText(_error);
    }
    return infoText("$_location\n$_currentWeather");
  }

  Widget todayViewBuilder() {
    if (_error.isNotEmpty) {
      return errorText(_error);
    }
    return infoText("$_location\n$_todayWeather");
  }

  Widget weeklyViewBuilder() {
    if (_error.isNotEmpty) {
      return errorText(_error);
    }
    return infoText("$_location\n$_weeklyWeather");
  }

  Widget fieldViewBuilder(BuildContext context, TextEditingController textEditingController, FocusNode focusNode, VoidCallback onFieldSubmitted) {
  return TextField(
    controller: textEditingController,
    focusNode: focusNode,
    decoration: const InputDecoration(
      hintText: 'Search location...',
      icon: Icon(Icons.search),
    ),
    onSubmitted: (value) async {
      onFieldSubmitted();
      FocusScope.of(context).unfocus();
      textEditingController.clear();
      try {
        final geocoding = GeocodingApi();
        final answer = await geocoding.requestJson(name: value);
        if (answer['results'] == null) {
          _updateError('No results found for "$value"');
          return;
        }
        final location = Location.json(answer['results'][0]);
        _locationSelected(location);
      } on Exception catch (e) {
        print('Error: $e');
        _updateError('Error connecting to the weather API\nPlease check your internet connection and try again.');
      }

    },
  );
}

String formatPlace(String name, String? region, String? country) {
    region = region == null || region.isEmpty ? '' : '\n$region';
    country = country == null || country.isEmpty ? '' : '\n$country';
    return '$name$region$country';
  }

Future<Iterable<Location>> optionBuilder(TextEditingValue textEditingValue) async {
    if (textEditingValue.text.isEmpty) {
      return const Iterable<Location>.empty();
    }

    final geocoding = GeocodingApi();
    final answer = await geocoding.requestJson(name: textEditingValue.text);
    if (answer['results'] == null) {
      return const Iterable<Location>.empty();
    } 
    final variable = answer['results'];
    final List<Location> options = [];
    for (var i = 0; i < variable.length && i < 5; i++) {
      final location = Location.json(variable[i]);
      options.add(location);
    }
    return options;
  }


}

class Location {
  final int id;
  final String name;
  final String? region;
  final String? country;
  final double? latitude;
  final double? longitude;

  Location(this.id, this.name, this.region, this.country, this.latitude, this.longitude);

  Location.json(Map<String, dynamic> json)
    : id = json['id'],
      name = json['name'],
      region = json['admin1'],
      latitude = json['latitude'],
      longitude = json['longitude'],
      country = json['country'];

  @override
  String toString() {
    String name = this.name;
    if (region != null && region!.isNotEmpty) {
      name += ', $region';
    }
    if (country != null && country!.isNotEmpty) {
      name += ', $country';
    }
    return name;
  }
}

Widget errorText(String error) {
  return Text(
    error,
    style: const TextStyle(color: Colors.red),
    textAlign: TextAlign.center,
  );
}

Widget infoText(String info) {
  return Text(
    info,
    style: const TextStyle(color: Colors.white),
    textAlign: TextAlign.center,
  );
}