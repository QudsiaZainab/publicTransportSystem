import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'mongodb.dart';

class Nearby extends StatefulWidget {
  @override
  _NearbyState createState() => _NearbyState();
}

class _NearbyState extends State<Nearby> {
  bool locationEnabled = false;
  List<Map<String, dynamic>> stopsData = [];
  Set<String> uniqueStops = {};
  List<String> stops = [];
  Map<String, List<String>> lat = {};
  Map<String, List<String>> long = {};
  String _latitude = '';
  String _longitude = '';

  @override
  void initState() {
    super.initState();
    _checkLocationEnabled();
    _getCurrentLocation();
    fetchData();
  }

  Future<void> _getCurrentLocation() async {
    try {
      LocationPermission permission;
      permission = await Geolocator.requestPermission();
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _latitude = '${position.latitude}';
        _longitude = '${position.longitude}';
        print(_latitude);
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> _checkLocationEnabled() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    setState(() {
      locationEnabled = serviceEnabled;
    });
  }

  Future<void> _toggleLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (serviceEnabled) {
      // Location services are enabled, you can perform additional actions here
    } else {
      bool serviceRequestResult = await Geolocator.openAppSettings();
      // Handle the result of the service request if needed
    }

    setState(() {
      locationEnabled = !locationEnabled;
    });
  }

  Future<void> fetchData() async {
    try {
      // Fetch data from the backend
      var data = await MongoDatabase.getData();

      // Check if the widget is still mounted before calling setState
      if (mounted) {
        // Extract 'stop' values from the data and update the 'stops' list
        setState(() {
          uniqueStops = data.map((entry) => entry['stop'].toString()).toSet();
          stops = uniqueStops.toList(); // Convert set to list for use in the UI
        });

        // Extract 'lat' and 'long' values for each stop and update the 'lat' and 'long' maps
        for (var stop in stops) {
          lat[stop] = data
              .where((entry) => entry['stop'] == stop)
              .map((entry) => entry['lat'].toString())
              .toList();
          long[stop] = data
              .where((entry) => entry['stop'] == stop)
              .map((entry) => entry['long'].toString())
              .toList();
        }
      }
    } catch (e) {
      // Handle any errors that might occur during data fetching
      print('Error fetching data: $e');
    }
  }


  // Function to calculate the distance between two sets of coordinates
  double calculateDistance(String stopLat, String stopLon) {
    // Replace these values with the actual current location coordinates
    double currentLat = double.parse(_latitude) ; // Replace with actual latitude
    double currentLong = double.parse(_longitude) ; // Replace with actual longitude

    // Use Geolocator's distanceBetween function to calculate distance in meters
    return Geolocator.distanceBetween(
      double.parse(stopLat),
      double.parse(stopLon),
      currentLat,
      currentLong,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nearby Stops'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [

          Expanded(
            child: ListView.builder(
              itemCount: stops.length,
              itemBuilder: (context, index) {
                // Access the stop data and calculate the distance
                final stop = stops[index];
                final stopName = stop;
                final stopLat = lat[stop]!.first; // Assuming there's at least one latitude
                final stopLon = long[stop]!.first; // Assuming there's at least one longitude
                final distance = calculateDistance(stopLat, stopLon);

                return ListTile(
                  title: Text(stopName),
                  subtitle: Text('Distance: ${distance.toStringAsFixed(2)} meters'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}