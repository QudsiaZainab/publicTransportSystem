import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapWithDirections extends StatefulWidget {
  @override
  _MapWithDirectionsState createState() => _MapWithDirectionsState();
}

class _MapWithDirectionsState extends State<MapWithDirections> {
  GoogleMapController? _controller;
  Set<Polyline> _polylines = {};
  final String apiKey = 'AIzaSyAhF_57bZzH95SNl13TPDv9nGlH6WslzIo';
  final LatLng origin = LatLng(37.43296265331129, -122.08832357078792);
  final LatLng destination = LatLng(37.43006265331129, -122.09032357078792);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        polylines: _polylines,
        initialCameraPosition: CameraPosition(
          target: LatLng(37.43296265331129, -122.08832357078792),
          zoom: 14,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _getDirections,
        child: Icon(Icons.directions),
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller = controller;
  }

  void _getDirections() async {
    final String url = 'https://maps.googleapis.com/maps/api/directions/json?'
        'origin=${origin.latitude},${origin.longitude}&'
        'destination=${destination.latitude},${destination.longitude}&'
        'key=$apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final decodedResponse = json.decode(response.body);
      final List<LatLng> route = _decodePoly(
          encodedString: decodedResponse['routes'][0]['overview_polyline']
              ['points']);

      setState(() {
        _polylines.add(Polyline(
          polylineId: PolylineId('route1'),
          points: route,
          color: Colors.blue,
          width: 5,
        ));
      });

      _controller?.animateCamera(CameraUpdate.newLatLngBounds(
        LatLngBounds(
          southwest: origin,
          northeast: destination,
        ),
        50,
      ));
    } else {
      throw Exception('Failed to load directions');
    }
  }

  List<LatLng> _decodePoly({required String encodedString}) {
    List<LatLng> poly = [];
    int index = 0, len = encodedString.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encodedString.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encodedString.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      LatLng position = LatLng(lat / 1E5, lng / 1E5);
      poly.add(position);
    }
    return poly;
  }
}

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MapWithDirections(),
  ));
}
