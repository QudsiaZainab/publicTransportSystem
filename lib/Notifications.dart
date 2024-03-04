import 'package:flutter/material.dart';
import 'mongodb.dart';

class Notifications extends StatefulWidget {
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  List<String> breakdownIssues = []; // Store breakdown issues here
  String vehicleName = '';

  @override
  void initState() {
    super.initState();
    fetchIssues();
  }

  Future<void> fetchIssues() async {
    try {
      // Replace 'your_vehicle_name' with the actual vehicle name
      vehicleName = '105';

      final issues = await MongoDatabase.getIssuesForVehicle(vehicleName);

      setState(() {
        breakdownIssues = issues;
      });
    } catch (e) {
      print('Error fetching breakdown issues: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Vehicle Name: ${vehicleName.toUpperCase()}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0, // Adjust the font size as needed
              ),
            ),
            SizedBox(height: 8.0), // Add some space
            Text(
              'Breakdown Issues:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0, // Adjust the font size as needed
              ),
            ),
            SizedBox(height: 8.0), // Add some space
            Column(
              children: breakdownIssues.map((issue) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Issue for $vehicleName:',
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        issue,
                        style: TextStyle(
                            fontSize: 16.0), // Adjust the font size as needed
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
