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

  @override
  void initState() {
    super.initState();
    _loadStopsData();
  }

  Future<void> _loadStopsData() async {
    List<Map<String, dynamic>> stopsList = await MongoDatabase.getStopsData();

    setState(() {
      stopsData = stopsList;
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
                child: Text(
                  stopName,
                  overflow: TextOverflow.ellipsis, // Use ellipsis for overflow
                  maxLines:
                      2, // Adjust the number of lines based on your design
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    color: Colors.grey,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Latitude: $latitude, Longitude: $longitude',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    color: Colors.grey,
                  ),
                ),
              ),
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
        return AlertDialog(
          title: Text('Add Stop'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _numberPlateController,
                decoration: InputDecoration(labelText: 'Stop Name'),
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
                await MongoDatabase.addNewStop(
                  _numberPlateController.text,
                  position.latitude,
                  position.longitude,
                );
                Navigator.of(context).pop();
                _loadStopsData();
              },
              child: Text('Add Stop'),
            ),
          ],
        );
      },
    );
  }
}
