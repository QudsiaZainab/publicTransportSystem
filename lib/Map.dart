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
  bool _isDisposed = false;

  late Polyline _route;
  late Polyline _route2;
  late Polyline _route3;
  late Polyline _route4;
  late Polyline _route5;

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
      color: Colors.red,
      width: 5, // Assign route coordinates to the polyline
    );
    _route2 = Polyline(
      polylineId: PolylineId('route2'),
      color: Colors.green,
      width: 5, // Assign route coordinates to the polyline
    );
    _route3 = Polyline(
      polylineId: PolylineId('route3'),
      color: Colors.blue,
      width: 5, // Assign route coordinates to the polyline
    );
    _route4 = Polyline(
      polylineId: PolylineId('route4'),
      color: Colors.yellow,
      width: 5, // Assign route coordinates to the polyline
    );
    _route5 = Polyline(
      polylineId: PolylineId('route5'),
      color: Colors.purple,
      width: 5, // Assign route coordinates to the polyline
    );
  }

  void dispose() {
    _isDisposed = true; // Set the flag to true when disposed
    super.dispose();
  }

  late BitmapDescriptor pickupMarker;
  late BitmapDescriptor driverMarker;

  var driverLat = 33.68825337987158;
  var driverLong = 73.0352085285546;

  dothis() async {
    BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(),
      'assets/driverMarker.png',
    ).then((icon) {
      if (!_isDisposed) {
        // Check if the state is disposed before proceeding
        driverMarker = icon!;
        markers.add(
          Marker(
            markerId: MarkerId("0"),
            position: LatLng(driverLat, driverLong),
            icon: driverMarker,
          ),
        );
        driverDemo(icon);
      }
    });

    BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(),
      'assets/pickupMarker.png',
    ).then((icon) {
      if (!_isDisposed) {
        // Check if the state is disposed before proceeding
        pickupMarker = icon!;
        markers.add(
          Marker(
            markerId: MarkerId("1"),
            position: LatLng(33.68825337987158, 73.0352085285546),
            icon: pickupMarker,
          ),
        );
      }
    });
  }

  driverDemo(BitmapDescriptor x) async {
    while (!_isDisposed) {
      // Check the flag before continuing the loop
      await Future.delayed(Duration(seconds: 1));
      if (!_isDisposed) {
        // Check if the state is disposed before proceeding
        driverLat += 0.001;
        driverLong += 0.001;
        markers[0] = Marker(
          markerId: MarkerId("0"),
          position: LatLng(driverLat, driverLong),
          icon: x,
        );
        if (!_isDisposed) {
          // Check if the state is disposed before calling setState
          setState(() {});
        }
      }
    }
  }

  Future<void> getDirections() async {
    final String apiUrl =
        'https://maps.googleapis.com/maps/api/directions/json?origin=33.68825337987158, 73.0352085285546&destination=33.64105120178869, 72.94838762128458&waypoints=via:33.678767367050085, 73.01426940636904|via:33.707517712095985, 73.03583127449788|via:33.67002876588016, 72.99619261877697|via:33.655945929558776, 72.98000094042074|via:33.65209318721671, 72.96722665093546&key=$apiKey';

    final http.Response response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final decodedResponse = json.decode(response.body);
      List<LatLng> routeCoordinates = _parseRoute(decodedResponse);
      // print(routeCoordinates[1].latitude);
      List<LatLng> routeCoordinates2 = [
        LatLng(33.69541941928578, 73.01099917620775),
        LatLng(33.70790, 73.05048),
      ];
      List<LatLng> routeCoordinates3 = [
        LatLng(33.707517712095985, 73.03583127449788),
        LatLng(33.64860457126754, 73.03910394431162),
      ];
      List<LatLng> routeCoordinates4 = [
        LatLng(33.597010985197635, 73.05272123805612),
        LatLng(33.65998, 73.08433),
      ];
      List<LatLng> routeCoordinates5 = [
        LatLng(33.5972790582383, 73.0654040328685),
        LatLng(33.688160188926574, 73.06541933643074),
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
        _route3 = Polyline(
          polylineId: PolylineId('route3'),
          color: Colors.blue,
          width: 5,
          points: routeCoordinates3, // Assign route coordinates to the polyline
        );
        _route4 = Polyline(
          polylineId: PolylineId('route4'),
          color: Colors.yellow,
          width: 5,
          points: routeCoordinates4, // Assign route coordinates to the polyline
        );
        _route5 = Polyline(
          polylineId: PolylineId('route5'),
          color: Colors.purple,
          width: 5,
          points: routeCoordinates5, // Assign route coordinates to the polyline
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

  static late Marker _kPlexMarker;

  @override
  Widget build(BuildContext context) {
    if (_currentPosition == null) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(), // Show a loading indicator
        ),
      );
    }
    _kGooglePlex = CameraPosition(
      target: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
      zoom: 14.4746,
    );

    _kPlexMarker = Marker(
      markerId: MarkerId('_kLake'),
      infoWindow: InfoWindow(title: 'K Lake'),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      position: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
    );
    markers.add(_kPlexMarker);
    return Scaffold(
      body: GoogleMap(
        initialCameraPosition: _kGooglePlex,
        mapType: MapType.normal,
        markers: markers.toSet(),
        polylines: {
          _route, // Add the _route polyline to the polylines set
          _route2,
          _route3,
          _route4,
          _route5,
        },
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          getDirections();
        },
        child: Icon(Icons.directions),
      ),
    );
  }
}
