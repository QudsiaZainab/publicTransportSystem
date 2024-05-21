import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'plannedJourney.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';

class JourneyPlanner extends StatefulWidget {
  @override
  _JourneyPlannerState createState() => _JourneyPlannerState();
}

class _JourneyPlannerState extends State<JourneyPlanner> {
  LatLng fromLocation = LatLng(0, 0);
  LatLng toLocation = LatLng(0, 0);

  String fromLocationName = '';
  String toLocationName = '';
  String selectedTransport = 'Bus';
  bool isBusSelected = false;
  bool isVanSelected = false;
  bool isButtonEnabled = false;
  String driverArrivalTime = '';

  var driverLat = 33.68825337987158;
  var driverLong = 73.0352085285546;

  var driverLat2 = 33.65751080545608;
  var driverLong2 = 73.04772569681272;

  static const String apiKey = 'AIzaSyAhF_57bZzH95SNl13TPDv9nGlH6WslzIo';
  final String apiUrl =
      'https://maps.googleapis.com/maps/api/directions/json?origin=33.68825337987158, 73.0352085285546&destination=33.64105120178869, 72.94838762128458&waypoints=via:33.678767367050085, 73.01426940636904|via:33.707517712095985, 73.03583127449788|via:33.67002876588016, 72.99619261877697|via:33.655945929558776, 72.98000094042074|via:33.65209318721671, 72.96722665093546&key=$apiKey';
  final String apiUrl2 =
      'https://maps.googleapis.com/maps/api/directions/json?origin=33.69541941928578, 73.01099917620775&destination=33.70790, 73.05048&waypoints=via:33.70929966697905, 73.03964128326247|via:33.73035633310524, 73.03722055634482|via:33.66613661613609, 73.07109517220269|via:33.655945929558776, 72.98000094042074|via:33.65722503502194, 73.05648042690798&key=$apiKey';

  List<dynamic> routes = [];
  List<Map<String, dynamic>> driverLocations = [
    {
      'lat': 33.68825337987158,
      'long': 73.0352085285546,
      'vehicle': '106',
      'route':
          'https://maps.googleapis.com/maps/api/directions/json?origin=33.68825337987158, 73.0352085285546&destination=33.64105120178869, 72.94838762128458&waypoints=via:33.678767367050085, 73.01426940636904|via:33.707517712095985, 73.03583127449788|via:33.67002876588016, 72.99619261877697|via:33.655945929558776, 72.98000094042074|via:33.65209318721671, 72.96722665093546&key=$apiKey'
    },
    {
      'lat': 33.65751080545608,
      'long': 73.04772569681272,
      'vehicle': '109',
      'route':
          'https://maps.googleapis.com/maps/api/directions/json?origin=33.69541941928578, 73.01099917620775&destination=33.70790, 73.05048&waypoints=via:33.70929966697905, 73.03964128326247|via:33.73035633310524, 73.03722055634482|via:33.66613661613609, 73.07109517220269|via:33.655945929558776, 72.98000094042074|via:33.65722503502194, 73.05648042690798&key=$apiKey'
    },
  ];

  // Function to check if both "From" and "To" fields are filled
  bool isBothFieldsFilled() {
    return fromLocation.latitude != 0 &&
        fromLocation.longitude != 0 &&
        toLocation.latitude != 0 &&
        toLocation.longitude != 0;
  }

  // Update the button's enabled state
  void updateButtonState() {
    setState(() {
      isButtonEnabled = isBothFieldsFilled();
    });
  }

  Future<void> getDirections(
      LatLng fromLocationLatLng, LatLng toLocationLatLng) async {
    bool routeFound = false;
    final now = DateTime.now();

    for (final driverLocation in driverLocations) {
      final vh = driverLocation['vehicle'];
      final apiUrl = driverLocation['route'];

      if (apiUrl != null) {
        final response = await http.get(Uri.parse(apiUrl));

        if (response.statusCode == 200) {
          final Map<String, dynamic> data = json.decode(response.body);

          if (data['status'] == 'OK') {
            final routes = data['routes'];

            for (final route in routes) {
              if (willPassThroughLocation(
                      LatLng(driverLocation['lat'], driverLocation['long']),
                      fromLocationLatLng,
                      route) &&
                  willPassThroughLocation(
                      LatLng(driverLocation['lat'], driverLocation['long']),
                      toLocationLatLng,
                      route)) {
                final durationInSeconds = calculateTimeToDestination(
                    LatLng(driverLocation['lat'], driverLocation['long']),
                    toLocationLatLng,
                    route);

                final estimatedArrivalTime =
                    now.add(Duration(seconds: durationInSeconds));
                setState(() {
                  driverArrivalTime =
                      'Vehicle $vh will arrive at $fromLocationName at ${estimatedArrivalTime.hour}:${estimatedArrivalTime.minute}';
                });
                routeFound = true;
                break;
              }
            }
          }
        }
      }

      if (routeFound) {
        break; // Exit the loop if a route is found
      }
    }

    if (!routeFound) {
      setState(() {
        driverArrivalTime = 'No vehicle';
      });
    }
  }

  int calculateTimeToDestination(
      LatLng driverLocation, LatLng destination, dynamic route) {
    // Get the duration in seconds from the route object
    final durationInSeconds = route['legs'][0]['duration']['value'];

    // Calculate the distance between the driver's location and the destination
    final distance = calculateDistance(driverLocation, destination);

    // Assuming a constant speed of, for example, 50 km/h
    // You need to replace this with your actual logic based on the real-time traffic conditions and the driver's speed
    final averageSpeed = 50; // in km/h
    final timeToDestinationInSeconds =
        (distance / averageSpeed) * 3600; // Convert hours to seconds

    return timeToDestinationInSeconds.round();
  }

  bool willPassThroughLocation(
      LatLng driverLocation, LatLng targetLocation, dynamic route) {
    // Extract the list of steps from the route object
    final steps = route['legs'][0]['steps'];

    // Check each step to see if it passes through the 'targetLocation'
    for (final step in steps) {
      final polyline = step['polyline']['points'];
      final decodedPolyline = decodePolyline(polyline);

      // Check each point of the polyline to see if it's close to the target location
      for (final point in decodedPolyline) {
        final stepLocation = LatLng(point.latitude, point.longitude);
        final distance = calculateDistance(stepLocation, targetLocation);

        // Assuming a threshold distance of 100 meters to consider as passing through the target location
        if (distance < 0.5) {
          // Adjust this threshold distance based on your requirements
          return true;
        }
      }
    }

    return false;
  }

// Helper function to decode Google Maps Polyline
  List<LatLng> decodePolyline(String encoded) {
    List<LatLng> points = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      points.add(LatLng(lat / 1E5, lng / 1E5));
    }

    return points;
  }

// Helper function to calculate distance between two LatLng points
  double calculateDistance(LatLng point1, LatLng point2) {
    const int radiusOfEarth = 6371; // Earth's radius in kilometers
    double lat1 = point1.latitude;
    double lon1 = point1.longitude;
    double lat2 = point2.latitude;
    double lon2 = point2.longitude;

    double dLat = _toRadians(lat2 - lat1);
    double dLon = _toRadians(lon2 - lon1);
    double a = pow(sin(dLat / 2), 2) +
        cos(_toRadians(lat1)) * cos(_toRadians(lat2)) * pow(sin(dLon / 2), 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    double distance = radiusOfEarth * c;
    return distance;
  }

// Helper function to convert degrees to radians
  double _toRadians(double degree) {
    return degree * pi / 180;
  }

  void updateLocation(String name, LatLng coordinates, bool isFromLocation) {
    setState(() {
      if (isFromLocation) {
        fromLocation = coordinates;
        fromLocationName = name;
      } else {
        toLocation = coordinates;
        toLocationName = name;
      }
      updateButtonState(); // Update button state when location changes
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Journey Planner'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            SizedBox(height: 30),
            GestureDetector(
              onTap: () async {
                final selectedLocation = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LocationSelectionPage(
                      onLocationSelected: (name, location) {
                        updateLocation(name, location, true);
                      },
                    ),
                  ),
                );

                if (selectedLocation != null) {
                  updateLocation(
                      selectedLocation.name, selectedLocation.location, true);
                }
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 8.0),
                    child: Text(
                      'From:',
                      style: TextStyle(fontSize: 18.0),
                    ),
                    width: 50,
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            width: 1.0,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      child: Text(
                        fromLocationName.isNotEmpty ? fromLocationName : '',
                        style: TextStyle(fontSize: 18.0),
                      ),
                    ),
                  ),
                  SizedBox(width: 5),
                  Container(
                    margin: EdgeInsets.only(right: 8.0),
                    child: Text(
                      '🏠',
                      style: TextStyle(fontSize: 24.0),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            GestureDetector(
              onTap: () async {
                final selectedLocation = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LocationSelectionPage(
                      onLocationSelected: (name, location) {
                        updateLocation(name, location, false);
                      },
                    ),
                  ),
                );

                if (selectedLocation != null) {
                  updateLocation(
                      selectedLocation.name, selectedLocation.location, false);
                }
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 8.0),
                    child: Text(
                      'To:',
                      style: TextStyle(fontSize: 18.0),
                    ),
                    width: 50,
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            width: 1.0,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      child: Text(
                        toLocationName.isNotEmpty ? toLocationName : '',
                        style: TextStyle(fontSize: 18.0),
                      ),
                    ),
                  ),
                  SizedBox(width: 5),
                  Container(
                    margin: EdgeInsets.only(right: 8.0),
                    child: Text(
                      '🎯',
                      style: TextStyle(fontSize: 24.0),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30.0),
            Padding(
              padding: EdgeInsets.only(
                left: 8.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Depart: now',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(width: 10),
                ],
              ),
            ),
            SizedBox(height: 20.0),
            Container(
              color: Colors.grey[400],
              child: Divider(
                height: 1,
                thickness: 1,
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: isButtonEnabled
                  ? () async {
                      await getDirections(fromLocation, toLocation);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PlannedJourney(
                            vehicleName: driverArrivalTime.contains('Vehicle')
                                ? driverArrivalTime.split(' ')[1]
                                : '',
                            timing: driverArrivalTime.contains('at')
                                ? driverArrivalTime.split(' ')[7]
                                : '',
                            fL: fromLocationName,
                            tL: toLocationName,
                          ),
                        ),
                      );
                    }
                  : null, // Disable the button if fields are not filled
              child: Text('Plan my journey'),
            ),
            SizedBox(height: 20),
            if (driverArrivalTime.isNotEmpty)
              Text(
                driverArrivalTime,
                style: TextStyle(fontSize: 16),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectableTag(IconData icon, String label, bool isSelected) {
    final backgroundColor = isSelected ? Colors.grey[400] : Colors.grey[200];

    return InkWell(
      onTap: () {
        setState(() {
          if (label == 'Bus') {
            isBusSelected = !isBusSelected;
          } else if (label == 'Van') {
            isVanSelected = !isVanSelected;
          }
        });
      },
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 24,
              color: Colors.red,
            ),
            SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: Colors.grey[900],
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check,
                color: Colors.red,
              ),
          ],
        ),
      ),
    );
  }
}

class LocationSelectionPage extends StatefulWidget {
  final Function(String, LatLng) onLocationSelected;

  LocationSelectionPage({required this.onLocationSelected});

  @override
  _LocationSelectionPageState createState() => _LocationSelectionPageState();
}

class _LocationSelectionPageState extends State<LocationSelectionPage> {
  List<PlacesSearchResult> displayedLocations = [];
  TextEditingController searchController = TextEditingController();
  final places =
      GoogleMapsPlaces(apiKey: 'AIzaSyAhF_57bZzH95SNl13TPDv9nGlH6WslzIo');

  @override
  void initState() {
    super.initState();
    searchController.addListener(() {
      filterLocations(searchController.text);
    });
  }

  Future<void> fetchLocations(String query) async {
    final response = await places.searchByText(query);
    if (response.status == 'OK') {
      setState(() {
        displayedLocations = response.results;
      });
    }
  }

  void filterLocations(String query) {
    fetchLocations(query);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: TextField(
          controller: searchController,
          cursorColor: Colors.green,
          style: TextStyle(color: Colors.white), // Set text color to white
          decoration: InputDecoration(
            hintText: 'Search Location',
            hintStyle: TextStyle(
                color: Colors.white), // Set placeholder color to white
            border: InputBorder.none,
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: displayedLocations.length,
        itemBuilder: (context, index) {
          final location = displayedLocations[index];
          return ListTile(
            title: Text(location.name ?? ''),
            onTap: () async {
              final details =
                  await places.getDetailsByPlaceId(location.placeId ?? '');
              final lat = details.result.geometry?.location.lat;
              final lng = details.result.geometry?.location.lng;
              if (lat != null && lng != null) {
                widget.onLocationSelected(
                    location.name ?? '', LatLng(lat, lng));
                Navigator.pop(context);
              }
            },
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
