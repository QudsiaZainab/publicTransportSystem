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

  @override
  void initState() {
    super.initState();
    _loadVanAndRouteData();
    _startLocationTracking();
  }

  Future<void> _loadVanAndRouteData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String loggedInContactNo = prefs.getString('loggedInContactNo') ?? '';

    if (loggedInContactNo.isNotEmpty) {
      String vanName =
          await MongoDatabase.getVehicleNameForPhoneNumber(loggedInContactNo);
      String routeName =
          await MongoDatabase.getRouteNameForPhoneNumber(loggedInContactNo);

      setState(() {
        vansData = [
          {"vanName": vanName, "routeName": routeName},
        ];
      });
    }
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
            for (var vanData in vansData)
              _buildVanRow(
                  vanData['vanName'] ?? '', vanData['routeName'] ?? ''),
          ],
        ),
      ),
    );
  }

  Widget _buildVanRow(String vanName, String routeName) {
    return Container(
      margin: EdgeInsets.fromLTRB(3.0, 10.0, 3.0, 10.0),
      decoration: BoxDecoration(
        color: Colors.white, // Set the background color to white
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
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Route: $routeName',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  color: Colors.grey,
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
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _numberPlateController,
                decoration: InputDecoration(labelText: 'Route Name'),
              ),
              TextFormField(
                controller: _busNameController,
                decoration: InputDecoration(labelText: 'Numberplate No'),
              ),
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
    // Use a timer to periodically fetch the location
    Timer.periodic(Duration(seconds: 60), (Timer timer) async {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Retrieve the driver's contact number from SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String driverContactNo = prefs.getString('loggedInContactNo') ?? '';

      // Update the vehicle information in MongoDB with the new location
      await MongoDatabase.updateDriverLocation(
        driverContactNo,
        position.latitude,
        position.longitude,
      );
    });
  }

  // void main() {
  //   runApp(MaterialApp(
  //     home: Vehicles(),
  //   ));
  // }
}
