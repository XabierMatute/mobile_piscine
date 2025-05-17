// import 'dart:async';
// import 'dart:ffi';
// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:open_meteo/open_meteo.dart';


// Future<Position> _determinePosition() async {
//   bool serviceEnabled;
//   LocationPermission permission;

//   // Test if location services are enabled.
//   serviceEnabled = await Geolocator.isLocationServiceEnabled();
//   if (!serviceEnabled) {
//     // Location services are not enabled don't continue
//     // accessing the position and request users of the 
//     // App to enable the location services.
//     return Future.error('Location services are disabled.');
//   }

//   permission = await Geolocator.checkPermission();
//   if (permission == LocationPermission.denied) {
//     permission = await Geolocator.requestPermission();
//     if (permission == LocationPermission.denied) {
//       // Permissions are denied, next time you could try
//       // requesting permissions again (this is also where
//       // Android's shouldShowRequestPermissionRationale 
//       // returned true. According to Android guidelines
//       // your App should show an explanatory UI now.
//       return Future.error('Location permissions are denied');
//     }
//   }
  
//   if (permission == LocationPermission.deniedForever) {
//     // Permissions are denied forever, handle appropriately. 
//     return Future.error(
//       'Location permissions are permanently denied, we cannot request permissions.');
//   } 

//   // When we reach here, permissions are granted and we can
//   // continue accessing the position of the device.
//   return await Geolocator.getCurrentPosition();
// }

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Weather App',
//       theme: ThemeData(
//         colorScheme: ColorScheme.dark(
//           primary: Colors.blue,
//         ),
//       ),
//       home: const MyHomePage(title: 'Weather App'),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key, required this.title});

//   final String title;

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {
//   late TabController _tabController;
//   Location? _location;
//   Weather? _weather;

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 3, vsync: this);
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }

//   void _updateWeather() {
//     // Fetch weather data using the Open Meteo API?
//   }

//   void _updateLocation(Location location) {
//     setState(() {
//       _location = location;
//     });
//     if (_location != null) {
//       _updateWeather();
//     }
//   }

//   void _geolocate() {
//     Future<Position> position = _determinePosition();
//     position.then((value) => 
//       setState(() {
//       final wAPI = WeatherApi();

//       _updateLocation(value.toString());
//     })).catchError((error) {
//       setState(() {
//         print('Error: $error');
//         _updateLocation(error.toString());
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title),
        
//         bottom: PreferredSize(
//           preferredSize: const Size.fromHeight(42.0),
//           child: Column(
//             children: [
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Row(
//                   children: [
//                     Expanded(
//                       child: Autocomplete<Location>(
//                         optionsBuilder: optionBuilder,
//                         onSelected:(option) => _updateLocation(option),                        
//                         fieldViewBuilder: fieldViewBuilder,
//                       ),
//                     ),
//                     IconButton(
//                       icon: const Icon(Icons.location_on),
//                       onPressed: () {
//                         // Geolocation button action
//                         print('Geolocation button pressed');
//                         _geolocate();
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//       body: TabBarView(
//         controller: _tabController,
//         children: [
//           Center(child: CurrentlyText(location: _location)),
//           Center(child: TodayText(location: _location)),
//           Center(child: WeeklyText(location: _location)),
//         ],
//       ),
//       bottomNavigationBar: BottomAppBar(
//         child: TabBar(
//           controller: _tabController,
//           tabs: const [
//             Tab(icon: Icon(Icons.window), text: 'Currently'),
//             Tab(icon: Icon(Icons.today), text: 'Today'),
//             Tab(icon: Icon(Icons.calendar_view_week), text: 'Weekly'),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget fieldViewBuilder(BuildContext context, TextEditingController textEditingController, FocusNode focusNode, VoidCallback onFieldSubmitted) {
//                         return TextField(
//                           controller: textEditingController,
//                           focusNode: focusNode,
//                           decoration: const InputDecoration(
//                             hintText: 'Search...',
//                             icon: Icon(Icons.search),
//                           ),
//                           onSubmitted: (String value) {
//                             _updateLocation(value);
//                           },
//                         );
//                       }

// String formatPlace(String name, String? region, String? country) {
//     region = region == null || region.isEmpty ? '?' : ', $region';
//     country = country == null || country.isEmpty ? '?' : ', $country';
//     return '$name$region$country';
//   }

// Future<Iterable<Location>> optionBuilder(TextEditingValue textEditingValue) async {
//     if (textEditingValue.text.isEmpty) {
//       return const Iterable<Location>.empty();
//     }

//     final geocoding = GeocodingApi();
//     final answer = await geocoding.requestJson(name: textEditingValue.text);
//     if (answer['results'] == null) {
//       return const Iterable<Location>.empty();
//     }
    
//     final variable = answer['results'];
//     final List<Location> options = [];
//     for (var i = 0; i < variable.length; i++) {
//       options.add(Location.json(variable[i]));
//     }
//     return options;
//     // final List<String> options = [];
//     // for (var i = 0; i < variable.length; i++) {
//     //   options.add(formatPlace(variable[i]['name'], variable[i]['admin1'], variable[i]['country']));
//     // }
//     // return options;
//   }
// }

// class WeeklyText extends StatelessWidget {
//   const WeeklyText({
//     super.key,
//     required Location? location,
//   }) : _location = location;

//   final Location? _location;

//   @override
//   Widget build(BuildContext context) {
//     return Text('Weekly\n$_location', textAlign: TextAlign.center);
//   }
// }

// class TodayText extends StatelessWidget {
//   const TodayText({
//     super.key,
//     required Location? location,
//   }) : _location = location;

//   final Location? _location;

//   @override
//   Widget build(BuildContext context) {
//     return Text('Today\n$_location', textAlign: TextAlign.center);
//   }
// }

// class CurrentlyText extends StatelessWidget {
//   const CurrentlyText({
//     super.key,
//     required Location? location,
//   }) : _location = location;

//   final Location? _location;

//   @override
//   Widget build(BuildContext context) {
//     return Text('Currently\n$_location', textAlign: TextAlign.center);
//   }
// }

// // Parameter	Format	Description
// // id	Integer	Unique ID for this location
// // name	String	Location name. Localized following the &language= parameter, if possible
// // latitude, longitude	Floating point	Geographical WGS84 coordinates of this location
// // elevation	Floating point	Elevation above mean sea level of this location
// // timezone	String	Time zone using time zone database definitions
// // feature_code	String	Type of this location. Following the GeoNames feature_code definition
// // country_code	String	2-Character ISO-3166-1 alpha2 country code. E.g. DE for Germany
// // country	String	Country name. Localized following the &language= parameter, if possible
// // country_id	Integer	Unique ID for this country
// // population	Integer	Number of inhabitants
// // postcodes	String array	List of postcodes for this location
// // admin1, admin2, admin3, admin4	String	Name of hierarchical administrative areas this location resides in. Admin1 is the first administrative level. Admin2 the second administrative level. Localized following the &language= parameter, if possible
// // admin1_id, admin2_id, admin3_id, admin4_id	Integer	Unique IDs for the administrative areas

// class Location {
//   final int id;           // Unique ID for this location
//   final String name;         // Location name. Localized following the &language= parameter, if possible
//   final Float latitude;     // Geographical WGS84 coordinates of this location
//   final Float longitude;    // Geographical WGS84 coordinates of this location
//   final Float elevation;    // Elevation above mean sea level of this location
//   final String timezone;     // Time zone using time zone database definitions
//   final String feature_code; // Type of this location. Following the GeoNames feature_code definition
//   final String country_code; // 2-Character ISO-3166-1 alpha2 country code. E.g. DE for Germany
//   final String country;      // Country name. Localized following the &language= parameter, if possible
//   final int country_id;   // Unique ID for this country
//   final int population;   // Number of inhabitants
//   final List<String> postcodes;    // List of postcodes for this location
//   final String admin1;       // Name of hierarchical administrative areas this location resides in. Admin1 is the first administrative level. Admin2 the second administrative level. Localized following the &language= parameter, if possible
//   final String? admin2;       // Name of hierarchical administrative areas this location resides in. Admin1 is the first administrative level. Admin2 the second administrative level. Localized following the &language= parameter, if possible
//   final String? admin3;       // Name of hierarchical administrative areas this location resides in. Admin1 is the first administrative level. Admin2 the second administrative level. Localized following the &language= parameter, if possible
//   final String? admin4;       // Name of hierarchical administrative areas this location resides in. Admin1 is the first administrative level. Admin2 the second administrative level. Localized following the &language= parameter, if possible
//   final int admin1_id;    // Unique IDs for the administrative areas
//   final int? admin2_id;    // Unique IDs for the administrative areas
//   final int? admin3_id;    // Unique IDs for the administrative areas
//   final int? admin4_id;    // Unique IDs for the administrative areas


//   Location.json(Map<String, dynamic> json)
//       : id = json['id'],
//         name = json['name'],
//         latitude = json['latitude'],
//         longitude = json['longitude'],
//         elevation = json['elevation'],
//         timezone = json['timezone'],
//         feature_code = json['feature_code'],
//         country_code = json['country_code'],
//         country = json['country'],
//         country_id = json['country_id'],
//         population = json['population'],
//         postcodes = json['postcodes'],
//         admin1 = json['admin1'],
//         admin2 = json['admin2'],
//         admin3 = json['admin3'],
//         admin4 = json['admin4'],
//         admin1_id = json['admin1_id'],
//         admin2_id = json['admin2_id'],
//         admin3_id = json['admin3_id'],
//         admin4_id = json['admin4_id'];
  
//   String region() {
//     return '$admin1${admin2 != null ? ', $admin2' : ''}${admin3 != null ? ', $admin3' : ''}${admin4 != null ? ', $admin4' : ''}';
//     // return '$admin1, $admin2, $admin3, $admin4';
//   }

//   toText(){
//     return Text('$name\n, ${region()}, $country');
//   }
// }

// class Weather {
//   final temperature; // Temperature in Celsius
//   final wind_speed; // Wind speed in m/s
//   final wind_direction; // Wind direction in degrees
//   final humidity; // Humidity in percentage
//   final pressure; // Pressure in hPa
//   final weathercode; // Weather code
//   final is_day; // Is day or night
//   final time; // Time of the weather data

//   Weather({
//     required this.temperature,
//     required this.wind_speed,
//     required this.wind_direction,
//     required this.humidity,
//     required this.pressure,
//     required this.weathercode,
//     required this.is_day,
//     required this.time
//   });
// }

