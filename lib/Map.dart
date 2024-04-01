import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Google Maps',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.white,
      ),
      home: MapSample(),
    );
  }
}

class MapSample extends StatefulWidget {
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  Completer<GoogleMapController> _controller = Completer();
  Position? _currentPosition;

  final List<Marker> markers = [];

  static late CameraPosition _kGooglePlex;

  late Polyline _route;
  late Polyline _route2;

  static const String apiKey = 'AIzaSyAhF_57bZzH95SNl13TPDv9nGlH6WslzIo';

  Future<void> _getCurrentLocation() async {
    try {
      _currentPosition = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {});
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _route = Polyline(
      polylineId: PolylineId('route'),
      color: Colors.blue,
      width: 3,
    );
    _route2 = Polyline(
      polylineId: PolylineId('route'),
      color: Colors.blue,
      width: 3,
    );
  }

  var driverLat = 33.68825337987158;
  var driverLong = 73.0352085285546;

  dothis() {
    late BitmapDescriptor pickupMarker;
    late BitmapDescriptor driverMarker;
    BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(), 'assets/driverMarker.png')
        .then((icon) {
      driverMarker = icon;
      markers.add(Marker(
          markerId: MarkerId("0"),
          position: LatLng(driverLat, driverLong),
          icon: driverMarker));
      driverDemo(icon);
    });
    BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(), 'assets/pickupMarker.png')
        .then((icon) {
      pickupMarker = icon;
      markers.add(Marker(
          markerId: MarkerId("1"),
          position: LatLng(33.68825337987158, 73.0352085285546),
          icon: pickupMarker));
    });
  }

  driverDemo(BitmapDescriptor x) async {
    while (true) {
      await Future.delayed(Duration(seconds: 1));
      print("object");
      driverLat += 0.001;
      driverLong += 0.001;
      markers[0] = Marker(
          markerId: MarkerId("0"),
          position: LatLng(driverLat, driverLong),
          icon: x);
      setState(() {});
    }
  }

  Future<void> getDirections() async {
    final String apiUrl =
        'https://maps.googleapis.com/maps/api/directions/json?origin=33.68825337987158, 73.0352085285546&destination=33.64105120178869, 72.94838762128458&key=$apiKey';

    final http.Response response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final decodedResponse = json.decode(response.body);
      List<LatLng> routeCoordinates = _parseRoute(decodedResponse);
      print(routeCoordinates[1].latitude);
      List<LatLng> routeCoordinates2 = [
        LatLng(33.64105120178869, 72.94838762128458),
        LatLng(33.653559, 73.064585),
      ];
      setState(() {
        _route = Polyline(
          polylineId: PolylineId('route'),
          color: Colors.red,
          width: 5,
          points: routeCoordinates, // Assign route coordinates to the polyline
        );
        _route2 = Polyline(
          polylineId: PolylineId('route2'),
          color: Colors.green,
          width: 5,
          points: routeCoordinates2, // Assign route coordinates to the polyline
        );
      });
      dothis();
    } else {
      throw Exception('Failed to fetch directions');
    }
  }

  List<LatLng> _parseRoute(dynamic decodedResponse) {
    List<LatLng> routeCoordinates = [];

    // Check if 'routes' field is present and not empty
    if (decodedResponse.containsKey('routes')) {
      List<dynamic> routes = decodedResponse['routes'];

      if (routes.isNotEmpty) {
        // Access the first route
        Map<String, dynamic> firstRoute = routes[0];

        // Check if 'overview_polyline' field is present
        if (firstRoute.containsKey('overview_polyline')) {
          Map<String, dynamic> overviewPolyline =
              firstRoute['overview_polyline'];

          // Check if 'points' field is present and is a string
          if (overviewPolyline.containsKey('points') &&
              overviewPolyline['points'] is String) {
            String points = overviewPolyline['points'];

            // Convert points to LatLng coordinates
            routeCoordinates = _convertToLatLng(_decodePoly(points));
          }
        }
      }
    }

    return routeCoordinates;
  }

  List<LatLng> _convertToLatLng(List points) {
    List<LatLng> result = <LatLng>[];
    for (int i = 0; i < points.length; i += 2) {
      result.add(LatLng(points[i], points[i + 1]));
    }
    return result;
  }

  List _decodePoly(String poly) {
    var list = poly.codeUnits;
    var lList = [];
    int index = 0;
    int len = poly.length;
    int c = 0;
    do {
      var shift = 0;
      int result = 0;

      do {
        c = list[index] - 63;
        result |= (c & 0x1F) << (shift * 5);
        index++;
        shift++;
      } while (c >= 32);
      if (result & 1 == 1) {
        result = ~result;
      }
      var result1 = (result >> 1) * 0.00001;
      lList.add(result1);
    } while (index < len);

    for (var i = 2; i < lList.length; i++) lList[i] += lList[i - 2];

    return lList;
  }

  static final CameraPosition _kLake = CameraPosition(
    bearing: 192.8334,
    target: LatLng(37.437, -122),
    tilt: 59.44,
    zoom: 19.15,
  );

  static final Marker _kLakeMarker = Marker(
    markerId: MarkerId('_kLake'),
    infoWindow: InfoWindow(title: 'K Lake'),
    icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
    position: LatLng(37.437, -122),
  );

  @override
  Widget build(BuildContext context) {
    if (_currentPosition == null) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(), // Show a loading indicator
        ),
      );
    }
    // if (_currentPosition != null) {
    _kGooglePlex = CameraPosition(
      target: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
      zoom: 14.4746,
    );
    // }
    return Scaffold(
      body: GoogleMap(
        initialCameraPosition: _kGooglePlex,
        mapType: MapType.normal,
        markers: markers.toSet(),
        polylines: {
          _route, // Add the _route polyline to the polylines set
          _route2
        },
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
      // floatingActionButton: FloatingActionButton.extended(
      //   onPressed: getDirections, // Call getDirections when FAB is pressed
      //   label: Text('Get Directions'),
      //   icon: Icon(Icons.directions),
      // ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          getDirections();
        },
        child: Icon(Icons.directions),
      ),
    );
  }
}
