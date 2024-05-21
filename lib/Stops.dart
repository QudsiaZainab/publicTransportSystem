import 'package:flutter/material.dart';
import 'mongodb.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';

class Stops extends StatefulWidget {
  @override
  _StopsState createState() => _StopsState();
}

class _StopsState extends State<Stops> {
  TextEditingController _numberPlateController = TextEditingController();
  TextEditingController _busNameController = TextEditingController();
  List<Map<String, dynamic>> stopsData = [];
  List<String> stopNames = [];
  String? _selectedStop;
  List<String> allstopNames = [];
  List<String> routeNames = [];
  String? _selectedRoute;

  @override
  void initState() {
    super.initState();
    _loadStopsData();
    _getAllRoutes();
  }

  Future<void> _loadStopsData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String loggedInContactNo = prefs.getString('loggedInContactNo') ?? '';

    List<Map<String, dynamic>> stopsList =
        await MongoDatabase.getStopsForContact(loggedInContactNo);

    // Use a Set to store unique stop names and a list to filter out duplicates
    Set<String> uniqueStopNames = {};
    List<Map<String, dynamic>> uniqueStopsList = [];

    // Iterate through the list of stops to add unique stop names to the set and list
    for (var stop in stopsList) {
      if (uniqueStopNames.add(stop['stop_name'] as String)) {
        uniqueStopsList.add(stop);
      }
    }

    setState(() {
      stopsData = uniqueStopsList;
      stopNames = uniqueStopNames.toList(); // Convert the Set back to a List
    });
  }

  Future<List<Map<String, dynamic>>> _getStopsForRoute(String routeName) async {
    // Assuming you have a map of routes to stops
    Map<String, List<String>> routeToStops = {
      'G9-G10-G12-G13-G14': ['G-9 Markaz', 'G-10', 'G-12', 'G-13', 'G-14'],
      'Pindi-i9-i10-F8-Kacheri-FaisalMasjid': [
        'i9-Markaz',
        'i-10 Markaz',
        'Faisal Masjid',
        'F-8 Kacheri'
      ],
      'F10-F11-GolraDarbar-BariImam-G6-G8-ComplexCentaures': [
        'G6',
        'G-8',
        'F-10',
        'F-11'
      ],
      'Mandi-Darbar-PoliceLine-G9-G11-F11-H8-H8Qabristan': [
        'G-9',
        'G-11',
        'H-8',
        'F-11'
      ],
      'PindiSaddar-Kanora-Churi-DoubleRoad-Faizabad': [
        'Pindi Saddar',
        'Faizabad',
        'Churi',
        'Kanora'
      ]
      // Add more routes and stops as needed
    };

    // Check if the provided routeName exists in the map
    if (routeToStops.containsKey(routeName)) {
      // Convert the list of stop names to a list of maps
      List<Map<String, dynamic>> stopsList = routeToStops[routeName]!
          .map((stopName) => {'stop': stopName})
          .toList();

      return stopsList;
    } else {
      // Return an empty list if routeName is not found
      return [];
    }
  }

  Future<void> _getAllStops(String routeName) async {
    try {
      List<Map<String, dynamic>> stopsList = await _getStopsForRoute(routeName);

      // Ensure stopsList is not null and is a List<Map<String, dynamic>>
      if (stopsList != null) {
        // Initialize an empty list to store unique stop names
        List<String> uniqueStopNames = [];

        // Iterate through the list of stops to add unique stop names
        for (var stop in stopsList) {
          String stopName = stop['stop'] as String;
          if (!uniqueStopNames.contains(stopName)) {
            uniqueStopNames.add(stopName);
          }
        }

        setState(() {
          allstopNames = uniqueStopNames;
        });
      } else {
        print("Stops list is null");
      }
    } catch (e) {
      print("Error getting stops for route: $e");
    }
  }

  Future<void> _getAllRoutes() async {
    List<Map<String, dynamic>> routesList = await MongoDatabase.getData();

    Set<String> uniqueRouteNames = {};
    List<Map<String, dynamic>> uniqueRoutesList = [];

    for (var route in routesList) {
      if (uniqueRouteNames.add(route['route_name'] as String)) {
        uniqueRoutesList.add(route);
      }
    }

    setState(() {
      routeNames = uniqueRouteNames.toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stops'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Stops List',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _showAddStopDialog(context);
                    },
                    child: Icon(Icons.add),
                  ),
                ],
              ),
              SizedBox(height: 30),
              for (var stopData in stopsData)
                _buildStopRow(
                  stopData['stop_name'] ?? '',
                  stopData['latitude'] ?? 0.0,
                  stopData['longitude'] ?? 0.0,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStopRow(String stopName, double latitude, double longitude) {
    return Container(
      margin: EdgeInsets.fromLTRB(3.0, 10.0, 3.0, 10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Stop Name:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                  width: MediaQuery.of(context).size.width - 70,
                  child: Text(
                    stopName,
                    overflow:
                        TextOverflow.ellipsis, // Use ellipsis for overflow
                    maxLines:
                        2, // Adjust the number of lines based on your design
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 15),
            ],
          ),
        ],
      ),
    );
  }

  void _showAddStopDialog(BuildContext context) async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Add Stop'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 60,
                    child: DropdownButtonFormField<String>(
                      value: _selectedRoute,
                      items: routeNames.map((String routeName) {
                        return DropdownMenuItem<String>(
                          value: routeName,
                          child: SizedBox(
                            height: 60, // Adjust the height as needed
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.5,
                              child: Text(routeName),
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedRoute = newValue;
                          _selectedStop = null; // Reset the stop selection
                          if (newValue != null) {
                            _getAllStops(
                                newValue); // Fetch stops for the selected route
                          }
                        });
                      },
                      decoration: InputDecoration(
                        labelText: 'Select Route',
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  _selectedRoute != null
                      ? DropdownButtonFormField<String>(
                          value: _selectedStop,
                          items: allstopNames.map((String stopName) {
                            return DropdownMenuItem<String>(
                              value: stopName,
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.5,
                                child: Text(stopName),
                              ),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedStop = newValue;
                            });
                          },
                          decoration: InputDecoration(
                            labelText: 'Select Stop Name',
                          ),
                        )
                      : Container(), // Empty container if no route is selected
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: _selectedRoute != null
                      ? () async {
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          String driverContactNo =
                              prefs.getString('loggedInContactNo') ?? '';
                          await MongoDatabase.addNewStop(
                            _selectedStop!,
                            driverContactNo,
                          );
                          Navigator.of(context).pop();
                          _loadStopsData();
                          _showSuccessDialog(context); // Show success dialog
                        }
                      : null, // Disable button if no route is selected
                  child: Text('Add Stop'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Success'),
          content: Text('Stop added successfully!'),
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
}
