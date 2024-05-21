import 'package:flutter/material.dart';

class PlannedJourney extends StatelessWidget {
  final String vehicleName;
  final String timing;
  final String fL;
  final String tL;

  // Constructor to receive the arguments
  PlannedJourney({
    required this.vehicleName,
    required this.timing,
    required this.fL,
    required this.tL,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Journey Planner'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          alignment: Alignment.topLeft,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Center(
                  child: Text(
                    '$fL to $tL',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              if (vehicleName.isNotEmpty && timing.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Text(
                    'Vehicle Name: $vehicleName',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              if (vehicleName.isNotEmpty && timing.isNotEmpty)
                Text(
                  'Van Arrival Time: $timing',
                  style: TextStyle(fontSize: 16),
                ),
              if (vehicleName.isEmpty && timing.isEmpty)
                Text(
                  'There is no van available in this route.',
                  style: TextStyle(fontSize: 16),
                ),
              // Add more widgets as needed for your journey details
            ],
          ),
        ),
      ),
    );
  }
}