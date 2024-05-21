import 'package:flutter/material.dart';
import 'mongodb.dart';
import 'package:google_maps_webservice/places.dart';
import 'dart:math';
import 'package:geolocator/geolocator.dart';

class PlaceIdToLocationNameConverter {
  final GoogleMapsPlaces _places =
      GoogleMapsPlaces(apiKey: 'AIzaSyAhF_57bZzH95SNl13TPDv9nGlH6WslzIo');

  Future<String> convertPlaceIdToLocationName(String placeId) async {
    PlacesDetailsResponse details = await _places.getDetailsByPlaceId(placeId);
    if (details.isOkay) {
      return details.result.name;
    } else {
      // Handle the error
      return 'Error retrieving location name';
    }
  }
}

class Routes extends StatefulWidget {
  @override
  _RoutesState createState() => _RoutesState();
}

class _RoutesState extends State<Routes> {
  String? selectedRoute;
  List<String> routes = [];
  Map<String, List<String>> stops = {};
  Map<String, List<String>> vehicles = {};
  Map<String, List<String>> drivers = {};
  Set<String> uniqueRoutes = {};
  final PlaceIdToLocationNameConverter converter =
      PlaceIdToLocationNameConverter();

  Future<void> fetchVehicleLocation(String vehicleName) async {
    try {
      // Use 'await' to wait for the result of the asynchronous function
      Map<String, double> location =
          await MongoDatabase.getVehicleLocation(vehicleName);

      // Now you can use the location data
      double lat = location['lat']!;
      double lng = location['lng']!;

      // Call the arrival time calculation function
      calculateArrivalTime(lat, lng);
    } catch (e) {
      // Handle any errors that might occur during data fetching
      print('Error fetching vehicle location: $e');
    }
  }

  Future<String> calculateArrivalTime(double lat, double lng) async {
    // Placeholder values for the destination location (replace with actual destination)
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    double latitude = position.latitude;
    double longitude = position.longitude;
    double destinationLat = latitude;
    double destinationLng = longitude;

    // Calculate distance using Haversine formula (simplified for illustration)
    double distance =
        calculateHaversine(lat, lng, destinationLat, destinationLng);

    // Placeholder average speed in meters per second (replace with actual speed)
    double averageSpeed = 10.0;

    // Calculate estimated travel time in seconds
    double travelTimeSeconds = distance / averageSpeed;

    // Print or use the calculated arrival time
    print('Estimated arrival time: ${formatTime(travelTimeSeconds)}');

    // Return the arrival time as a formatted string
    return formatTime(travelTimeSeconds);
  }

  // Haversine formula to calculate distance between two points on Earth
  double calculateHaversine(
      double startLat, double startLng, double endLat, double endLng) {
    const int earthRadius = 6371000; // Earth radius in meters

    double dLat = radians(endLat - startLat);
    double dLng = radians(endLng - startLng);

    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(radians(startLat)) *
            cos(radians(endLat)) *
            sin(dLng / 2) *
            sin(dLng / 2);

    double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return earthRadius * c;
  }

  // Convert degrees to radians
  double radians(double degrees) {
    return degrees * (pi / 180);
  }

  // Format time in seconds to a human-readable string (HH:MM:SS)
  String formatTime(double seconds) {
    int hours = (seconds / 3600).floor();
    int minutes = ((seconds % 3600) / 60).floor();
    int remainingSeconds = (seconds % 60).floor();

    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  void showArrivalTimeDialog(String vehicleName, String arrivalTime) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Arrival Time for $vehicleName'),
          content: Text('Estimated Arrival Time: $arrivalTime'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<String> fetchAndCalculateArrivalTime(String vehicleName) async {
    try {
      // Fetch vehicle location
      Map<String, double> location =
          await MongoDatabase.getVehicleLocation(vehicleName);

      // Use the location data
      double lat = location['latitude']!;
      double lng = location['longitude']!;
      print(lat);

      // Calculate arrival time
      String arrivalTime = await calculateArrivalTime(lat, lng);
      print(arrivalTime);

      // Show the arrival time dialog
      showArrivalTimeDialog(vehicleName, arrivalTime);
      return arrivalTime;
    } catch (e) {
      // Handle any errors that might occur during data fetching
      print('Error fetching and calculating arrival time: $e');
      return '';
    }
  }

  @override
  void initState() {
    super.initState();
    // Call fetchData function to populate the 'routes', 'stops', and 'vehicles' lists
    fetchData();
  }

  // Assuming MongoDatabase.getData() returns a Future<List<Map<String, dynamic>>>
  Future<void> fetchData() async {
    try {
      // Fetch data from the backend
      var data = await MongoDatabase.getData();

      // Extract 'route_name' values from the data and update the 'routes' list
      setState(() {
        uniqueRoutes =
            data.map((entry) => entry['route_name'].toString()).toSet();
        routes = uniqueRoutes.toList(); // Convert set to list for use in the UI
      });

      // Extract 'stop_name' values for each route and update the 'stops' map
      for (var route in routes) {
        stops[route] = data
            .where((entry) => entry['route_name'] == route)
            .map((entry) {
              return entry['stop']?.toString() ?? ''; // Ensure non-null stops
            })
            .where((stop) => stop.isNotEmpty)
            .toList(); // Filter out empty stops
      }

      for (var route in routes) {
        drivers[route] = data
            .where((entry) => entry['route_name'] == route)
            .map((entry) {
              return entry['driver']?.toString() ??
                  ''; // Ensure non-null drivers
            })
            .where((driver) => driver.isNotEmpty)
            .toList(); // Filter out empty drivers
      }

      // Extract 'vehicle_name' values for each route and update the 'vehicles' map
      for (var route in routes) {
        vehicles[route] = data
            .where((entry) => entry['route_name'] == route)
            .map((entry) {
              return entry['vehicleNo']?.toString() ??
                  ''; // Ensure non-null vehicles
            })
            .where((vehicle) => vehicle.isNotEmpty)
            .toList(); // Filter out empty vehicles
      }
    } catch (e) {
      // Handle any errors that might occur during data fetching
      print('Error fetching data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Routes'),
      ),
      body: ListView.builder(
        itemCount: routes.length,
        itemBuilder: (context, index) {
          return ExpansionTile(
            title: Text(routes[index]),
            children: [
              // Expansion tile for stops
              Padding(
                padding: const EdgeInsets.only(
                    left: 0.0), // Adjust the left padding as needed
                child: ExpansionTile(
                  title: Text('Stops'),
                  children: stops[routes[index]]?.map((stop) {
                        return Padding(
                          padding: const EdgeInsets.only(
                              left: 0.0), // Adjust the left padding as needed
                          child: ExpansionTile(
                            title: Text('Stop Name: $stop'),
                            children: [
                              // Expansion tile for vehicles
                              Padding(
                                padding: const EdgeInsets.only(
                                    left:
                                        0.0), // Adjust the left padding as needed
                                child: ExpansionTile(
                                  title: Text('Vehicles'),
                                  children: vehicles[routes[index]]
                                          ?.map((vehicle) {
                                            return Padding(
                                              padding: const EdgeInsets.only(
                                                  left:
                                                      0.0), // Adjust the left padding as needed
                                              child: ListTile(
                                                title: Text(
                                                  'Vehicle Name: $vehicle',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                onTap: () {
                                                  // Handle vehicle tap
                                                  // Fetch and calculate arrival time
                                                  fetchAndCalculateArrivalTime(
                                                      vehicle);
                                                },
                                              ),
                                            );
                                          })
                                          .toSet()
                                          .toList() ??
                                      [], // Ensure unique vehicle names
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList() ??
                      [],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
