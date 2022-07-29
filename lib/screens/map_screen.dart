import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  final double lat;
  final double lng;
  final bool isSelecting;

  const MapScreen({
    this.lat = 37.0,
    this.lng = 50.0,
    this.isSelecting = false,
  });

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng? _pickedLocation;

  void _selectLocation(LatLng location) {
    setState(() => _pickedLocation = location);
  }

  @override
  Widget build(BuildContext context) {
    final location = _pickedLocation;

    return Scaffold(
      appBar: AppBar(
        title: Text('Your Map'),
        actions: [
          if (widget.isSelecting)
            IconButton(
              onPressed: location == null
                  ? null
                  : () => Navigator.of(context).pop(location),
              icon: Icon(Icons.check),
            )
        ],
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(widget.lat, widget.lng),
          zoom: 14,
        ),
        onTap: widget.isSelecting ? _selectLocation : null,
        markers: {
          if (location != null || !widget.isSelecting)
            Marker(
              position: location ?? LatLng(widget.lat, widget.lng),
              markerId: MarkerId('m1'),
            )
        },
      ),
    );
  }
}
