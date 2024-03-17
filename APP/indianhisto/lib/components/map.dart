import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart'; // For LatLng class

class MonumentMapPage extends StatelessWidget {
  final String monumentCoordinate; // Change the type to String
  final String monunsame;
  final String place;

  MonumentMapPage(
      {required this.monumentCoordinate,
      required this.monunsame,
      required this.place});

  LatLng parseCoordinates(String coordinates) {
    // Remove parentheses and split the coordinates
    List<String> parts =
        coordinates.replaceAll('(', '').replaceAll(')', '').split(',');
    double lat = double.parse(parts[0].trim());
    double lng = double.parse(parts[1].trim());
    return LatLng(lat, lng);
  }

  @override
  Widget build(BuildContext context) {
    LatLng monumentLocation = parseCoordinates(monumentCoordinate);
    return Scaffold(
      appBar: AppBar(
        title: Text(monunsame),
      ),
      body: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              initialCenter: monumentLocation,
              initialZoom: 16.9,
            ),
            children: [
              TileLayer(
                urlTemplate:
                    'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
              ),
              MarkerLayer(markers: [
                Marker(
                  point: monumentLocation,
                  child: Icon(
                    Icons.location_pin,
                    color: Colors.red,
                    size: 40.0,
                  ),
                )
              ]),
            ],
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: EdgeInsets.all(16.0),
              color: Colors.black.withOpacity(0.75),
              child: Text(
                place,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
