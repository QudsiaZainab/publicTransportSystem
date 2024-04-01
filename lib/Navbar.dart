import 'package:flutter/material.dart';
import 'Settings.dart';
import 'Routes.dart';
import 'DriverAccount.dart';
import 'JourneyPlanner.dart';
import 'RateApp.dart';
import 'Map.dart';
import 'DriverHome.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Navbar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(''),
            accountEmail: Text(''),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/navpic.jpeg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 5),
          Row(
            children: [
              HoverableRoutesButton(
                imagePath: 'assets/images/nearby grey.jpeg',
                label: 'Nearby',
              ),
              HoverableRoutesButton(
                imagePath: 'assets/images/routes grey.jpeg',
                label: 'Routes',
              ),
              HoverableRoutesButton(
                imagePath: 'assets/images/favourites grey.jpeg',
                label: 'Favorites',
              ),
            ],
          ),
          SizedBox(height: 10),
          SizedBox(height: 5),
          ListTile(
            leading: Image.asset(
              'assets/images/journey grey.jpeg',
              width: 30,
              height: 30,
            ),
            title: Text('Journey Planner'),
            onTap: () {
              // Navigate to a new page here
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => JourneyPlanner(),
                ),
              );
            },
          ),
          ListTile(
            leading: Container(
              width: 30, // Width set karein
              height: 30, // Height set karein
              child: Icon(Icons.map,
                  size: 30), // Icon widget ko size property ke sath set karein
            ),
            title: Text('Show Map'),
            onTap: () {
              // Navigate to a new page here
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => MyApp(),
                ),
              );
            },
          ),
          ListTile(
            leading: Image.asset(
              'assets/images/settings grey.jpeg',
              width: 30,
              height: 30,
            ),
            title: Text('Settings'),
            onTap: () {
              // Navigate to a new page here
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => Settings(),
                ),
              );
            },
          ),
          ListTile(
            leading: Image.asset(
              'assets/images/rate app grey.jpeg',
              width: 30,
              height: 30,
            ),
            title: Text('Rate this app'),
            onTap: () {
              // Handle the tap on the "Driver View" button
              // Add your functionality here
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => RateApp(),
                ),
              );
            },
          ),
          ListTile(
            leading: Image.asset(
              'assets/images/remove ad grey.jpeg',
              width: 30,
              height: 30,
            ),
            title: Text('Remove ads'),
            onTap: () => null,
          ),
          ListTile(
            leading: Image.asset(
              'assets/images/van grey.jpeg',
              width: 30,
              height: 30,
            ),
            title: Text('Transport Lists'),
            onTap: () => null,
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.drive_eta),
            title: Text(
              'Driver View',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            tileColor: Colors.red,
            onTap: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) =>
                      isLoggedIn ? DriverHome() : DriverAccount(),
                ),
              );
            },
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}

class HoverableRoutesButton extends StatefulWidget {
  final String imagePath;
  final String label;

  const HoverableRoutesButton({
    required this.imagePath,
    required this.label,
  });

  @override
  _HoverableRoutesButtonState createState() => _HoverableRoutesButtonState();
}

class _HoverableRoutesButtonState extends State<HoverableRoutesButton> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: MouseRegion(
        onEnter: (_) {
          setState(() {
            isHovered = true;
          });
        },
        onExit: (_) {
          setState(() {
            isHovered = false;
          });
        },
        child: InkWell(
          onTap: () {
            // Add your button's functionality here
            // For example, you can navigate to a new screen:
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => Routes()));
          },
          child: Container(
            color: isHovered
                ? Colors.blue
                : Colors.transparent, // Change background color on hover
            child: Column(
              children: [
                Image.asset(
                  widget.imagePath,
                  width: 20, // Set the width of the image as needed
                  height: 20, // Set the height of the image as needed
                ),
                Text(
                  widget.label,
                  style: TextStyle(
                    color: Colors.black, // Set the text color to gray
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// void main() => runApp(const Map());

// class Map extends StatelessWidget {
//   const Map({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: const Map(),
//     );
//   }
// }

// class MapScreen extends StatefulWidget {
//   const MapScreen({Key? key}) : super(key: key);

//   @override
//   State<MapScreen> createState() => _MapScreenState();
// }

// class _MapScreenState extends State<MapScreen> {
//   late GoogleMapController mapController;
//   late List<LatLng> _routeCoordinates = [];

//   LatLng _center = const LatLng(33.6844, 73.0479); // Default to Islamabad coordinates

//   void _onMapCreated(GoogleMapController controller) {
//     mapController = controller;
//   }

//   Future<void> _getCurrentLocation() async {
//     Position position = await Geolocator.getCurrentPosition();
//     setState(() {
//       _center = LatLng(position.latitude, position.longitude);
//     });
//   }

//   Future<void> _getRoute() async {
//     // Replace these coordinates with your desired start and end points
//     LatLng start = _center;
//     LatLng end = const LatLng(33.6844, 73.0479); // Islamabad coordinates

//     final apiKey = 'AIzaSyA4kFE1fIOPQA8IU2IpKjtPA0asWWa3ms0'; // Replace with your Google Maps API key

//     final response = await http.get(
//       Uri.parse(
//         'https://maps.googleapis.com/maps/api/directions/json?origin=${start.latitude},${start.longitude}&destination=${end.latitude},${end.longitude}&key=$apiKey',
//       ),
//     );

//     if (response.statusCode == 200) {
//       final data = json.decode(response.body);
//       final routes = data['routes'][0]['overview_polyline']['points'];

//       setState(() {
//         _routeCoordinates = PolylinePoints().decodePolyline(routes);
//       });

//       // Optional: Move the camera to show the entire route
//       _fitBounds();
//     } else {
//       // Handle error
//       print('Failed to fetch route: ${response.statusCode}');
//     }
//   }

//   void _fitBounds() {
//     LatLngBounds bounds = LatLngBounds();

//     for (LatLng point in _routeCoordinates) {
//       bounds = bounds.extend(point);
//     }

//     mapController.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
//   }

//   @override
//   void initState() {
//     super.initState();
//     _getCurrentLocation();
//     _getRoute();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'Google Map with Route',
//           style: TextStyle(color: Colors.white),
//         ),
//         backgroundColor: Colors.red,
//         elevation: 2,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.white),
//           onPressed: () {
//             Navigator.of(context).pop();
//           },
//         ),
//       ),
//       body: GoogleMap(
//         onMapCreated: _onMapCreated,
//         initialCameraPosition: CameraPosition(
//           target: _center,
//           zoom: 12.0,
//         ),
//         polylines: {
//           Polyline(
//             polylineId: PolylineId('route'),
//             color: Colors.blue,
//             points: _routeCoordinates,
//           ),
//         },
//       ),
//     );
//   }
// }
