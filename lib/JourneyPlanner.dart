import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'plannedJourney.dart';

class JourneyPlanner extends StatefulWidget {
  @override
  _JourneyPlannerState createState() => _JourneyPlannerState();
}

class _JourneyPlannerState extends State<JourneyPlanner> {
  String fromLocation = '';
  String toLocation = '';
  String selectedTransport = 'Bus';
  bool isBusSelected = false;
  bool isVanSelected = false;
  bool isButtonEnabled = false; // Track whether the button should be enabled

  // Function to check if both "From" and "To" fields are filled
  bool isBothFieldsFilled() {
    return fromLocation.isNotEmpty && toLocation.isNotEmpty;
  }

  // Update the button's enabled state
  void updateButtonState() {
    setState(() {
      isButtonEnabled = isBothFieldsFilled();
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
                      onLocationSelected: (location) {
                        setState(() {
                          fromLocation = location;
                          updateButtonState(); // Update button state when "From" changes
                        });
                      },
                    ),
                  ),
                );

                if (selectedLocation != null) {
                  setState(() {
                    fromLocation = selectedLocation;
                    updateButtonState(); // Update button state when "From" changes
                  });
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
                        fromLocation.isEmpty ? '' : fromLocation,
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
                      onLocationSelected: (location) {
                        setState(() {
                          toLocation = location;
                          updateButtonState(); // Update button state when "To" changes
                        });
                      },
                    ),
                  ),
                );

                if (selectedLocation != null) {
                  setState(() {
                    toLocation = selectedLocation;
                    updateButtonState(); // Update button state when "To" changes
                  });
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
                        toLocation.isEmpty ? '' : toLocation,
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
                  ? () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PlannedJourney(),
                        ),
                      );
                    }
                  : null, // Disable the button if fields are not filled
              child: Text('Plan my journey'),
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
  final Function(String) onLocationSelected;

  LocationSelectionPage({required this.onLocationSelected});

  @override
  _LocationSelectionPageState createState() => _LocationSelectionPageState();
}

class _LocationSelectionPageState extends State<LocationSelectionPage> {
  List<PlacesSearchResult> displayedLocations = [];
  TextEditingController searchController = TextEditingController();
  final places =
      GoogleMapsPlaces(apiKey: 'AIzaSyA4kFE1fIOPQA8IU2IpKjtPA0asWWa3ms0');

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
            onTap: () {
              widget.onLocationSelected(location.name ?? '');
              Navigator.pop(context, location.name ?? '');
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
