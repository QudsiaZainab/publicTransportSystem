import 'package:flutter/material.dart';

class PlannedJourney extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Journey Planner'),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(
            16.0, 16.0, 0.0, 0.0), // Adjust the values as needed
        child: Container(
          alignment: Alignment.topLeft,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'Vehicle Name: 105',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Text(
                'Timing: 00:00:00',
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
