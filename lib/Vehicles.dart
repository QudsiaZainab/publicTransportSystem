import 'package:flutter/material.dart';
import 'mongodb.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';

class Vehicles extends StatefulWidget {
  @override
  _VehiclesState createState() => _VehiclesState();
}

class _VehiclesState extends State<Vehicles> {
  TextEditingController _busNameController = TextEditingController();
  TextEditingController _numberPlateController = TextEditingController();
  List<Map<String, String>> vansData = [];
  List<String> routeNames = [];
  String? _selectedRoute;

  @override
  void initState() {
    super.initState();
    _loadVanAndRouteData();
    _loadRoutes();
    _startLocationTracking();
  }

  Future<void> _loadVanAndRouteData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String loggedInContactNo = prefs.getString('loggedInContactNo') ?? '';

    if (loggedInContactNo.isNotEmpty) {
      List<String> vanNames =
          await MongoDatabase.getVanNamesForPhoneNumber(loggedInContactNo);
      List<String> routeNames =
          await MongoDatabase.getRouteNamesForPhoneNumber(loggedInContactNo);

      List<Map<String, String>> vanRoutePairs = [];

      // Ensure the length of vanNames and routeNames are the same
      if (vanNames.length == routeNames.length) {
        for (int i = 0; i < vanNames.length; i++) {
          vanRoutePairs
              .add({"vanName": vanNames[i], "routeName": routeNames[i]});
        }
      }

      setState(() {
        vansData = vanRoutePairs;
      });
    }
  }

  Future<void> _loadRoutes() async {
    List<Map<String, dynamic>> fetchedRoutes = await MongoDatabase.getRoutes();
    Set<String> uniqueRouteNames = fetchedRoutes
        .map((route) => route['route_name'].toString())
        .toSet(); // Convert to a Set to remove duplicates

    setState(() {
      this.routeNames = uniqueRouteNames.toList(); // Convert back to List
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vehicles'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Vehicles that you drive',
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
                    _showAddVehicleDialog(context);
                  },
                  child: Icon(Icons.add),
                ),
              ],
            ),
            SizedBox(height: 30),
            Expanded(
              // Use Expanded to allow the list to take remaining space and be scrollable
              child: SingleChildScrollView(
                child: Column(
                  children: vansData
                      .map((vanData) => _buildVanRow(
                          vanData['vanName'] ?? '', vanData['routeName'] ?? ''))
                      .toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVanRows(String vanName, String routeName) {
    List<Widget> vanRows = [];

    // Create multiple van rows if there are multiple vans associated with a driver
    for (var i = 0; i < vansData.length; i++) {
      vanRows.add(_buildVanRow(vanName, routeName));
    }

    return Column(
      children: vanRows,
    );
  }

  Widget _buildVanRow(String vanName, String routeName) {
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
      child: Row(children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Van Name: $vanName',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                overflow:
                    TextOverflow.ellipsis, // Handle overflow with ellipsis
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
              child: Container(
                width: MediaQuery.of(context).size.width -
                    70, // Adjust width as needed
                child: Text(
                  'Route: $routeName',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    color: Colors.grey,
                  ),
                  softWrap:
                      true, // Wrap text onto the next line if it overflows
                ),
              ),
            ),
          ],
        ),
      ]),
    );
  }

  void _showAddVehicleDialog(BuildContext context) async {
    // Fetch the current location
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Vehicle'),
          content: ConstrainedBox(
            constraints:
                BoxConstraints(maxWidth: 500), // Adjust maxWidth as needed
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 250, // Adjust width as needed
                            child: DropdownButtonFormField<String>(
                              value: _selectedRoute,
                              items: routeNames.map((String route) {
                                return DropdownMenuItem<String>(
                                  value: route,
                                  child: Container(
                                    width: 200, // Adjust width as needed
                                    child: Text(
                                      route,
                                      overflow: TextOverflow
                                          .ellipsis, // Handle overflow if text is too long
                                    ),
                                  ),
                                );
                              }).toList(),
                              onChanged: (newValue) {
                                setState(() {
                                  _selectedRoute = newValue;
                                });
                              },
                              decoration:
                                  InputDecoration(labelText: 'Select Route'),
                            ),
                          ),
                          SizedBox(height: 16),
                          TextFormField(
                            controller: _busNameController,
                            decoration:
                                InputDecoration(labelText: 'Number Plate'),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                // Handle adding the vehicle here
                // You can access the entered values using _busNameController.text and _numberPlateController.text
                String vehicleName = _busNameController.text;

                // Retrieve the driver's contact number from SharedPreferences
                SharedPreferences prefs = await SharedPreferences.getInstance();
                String driverContactNo =
                    prefs.getString('loggedInContactNo') ?? '';

                // Add the vehicle information to MongoDB
                await MongoDatabase.addVehicle(
                  vehicleName,
                  driverContactNo,
                  position.latitude,
                  position.longitude,
                  _selectedRoute!, // Pass the selected route
                );

                Navigator.of(context).pop();
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _startLocationTracking() {
    Timer.periodic(Duration(seconds: 60), (Timer timer) async {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String driverContactNo = prefs.getString('loggedInContactNo') ?? '';

      await MongoDatabase.updateDriverLocation(
        driverContactNo,
        position.latitude,
        position.longitude,
      );
    });
  }
}
