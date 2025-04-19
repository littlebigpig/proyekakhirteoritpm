import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class MapSample extends StatefulWidget {
  @override
  _MapSampleState createState() => _MapSampleState();
}

class _MapSampleState extends State<MapSample> {
  GoogleMapController? mapController;
  LatLng _currentPosition = const LatLng(-6.200000, 106.816666); // Jakarta
  String _positionText = "Latitude: N/A\nLongitude: N/A";

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    LocationPermission permission = await Geolocator.requestPermission();
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    if (!mounted) return; // <--- Cegah setState kalau widget udah dispose

    setState(() {
      _currentPosition = LatLng(position.latitude, position.longitude);
      _positionText =
          "Latitude: ${position.latitude}\nLongitude: ${position.longitude}";
    });

    mapController?.animateCamera(CameraUpdate.newLatLng(_currentPosition));
  }

  void _showLocationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Omah',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          content: Text(_positionText),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Jos',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tracking Lokasi',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        backgroundColor: Colors.lightBlue,
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: (GoogleMapController controller) {
              mapController = controller;
            },
            initialCameraPosition: CameraPosition(
              target: _currentPosition,
              zoom: 15,
            ),
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false, // disembunyiin tombol default
          ),

          // posisi
          Positioned(
            top: 10,
            right: 10,
            child: Material(
              color: Colors.transparent,
              child: Ink(
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: _showLocationDialog,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 14,
                    ),
                    child: Text(
                      "Posisi",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // loc
          Positioned(
            bottom: 130,
            right: 10,
            child: Material(
              color: Colors.transparent,
              child: Ink(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: Colors.lightBlue,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: _getCurrentLocation,
                  child: Center(
                    child: Icon(Icons.my_location, color: Colors.white),
                  ),
                ),
              ),
            ),
          ),

          // zoom in/out
          Positioned(
            bottom: 10,
            right: 10,
            child: Material(
              color: Colors.lightBlue,
              elevation: 4,
              borderRadius: BorderRadius.circular(8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                    onTap:
                        () =>
                            mapController?.animateCamera(CameraUpdate.zoomIn()),
                    child: Container(
                      width: 56,
                      height: 56,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(8),
                        ),
                        border: Border(bottom: BorderSide(color: Colors.white)),
                      ),
                      child: Icon(Icons.add, size: 24, color: Colors.white),
                    ),
                  ),
                  InkWell(
                    onTap:
                        () => mapController?.animateCamera(
                          CameraUpdate.zoomOut(),
                        ),
                    child: Container(
                      width: 56,
                      height: 56,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.vertical(
                          bottom: Radius.circular(8),
                        ),
                      ),
                      child: Icon(Icons.remove, size: 24, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
