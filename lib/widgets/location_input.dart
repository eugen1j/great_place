import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import '../helpers/location_helper.dart';
import '../screens/map_screen.dart';

class LocationInput extends StatefulWidget {
  final Function onSelectPlace;

  const LocationInput(this.onSelectPlace);

  @override
  State<LocationInput> createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  String? _previewImageUrl;

  Future<void> _getCurrentUserLocation() async {
    try {
      final locationData = await Location().getLocation();

      final lat = locationData.latitude;
      final lng = locationData.longitude;

      if (lat == null || lng == null) {
        return;
      }

      final imageUrl = LocationHelper.generateLocationPreviewImage(lat, lng);
      setState(() => _previewImageUrl = imageUrl);
      widget.onSelectPlace(lat, lng);
    } catch (e) {
      return;
    }

  }

  Future<void> _selectOnMap() async {
    final location = await Navigator.of(context).push<LatLng>(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (ctx) => MapScreen(isSelecting: true),
      ),
    );

    if (location == null) {
      return;
    }
    final lat = location.latitude;
    final lng = location.longitude;


    final imageUrl = LocationHelper.generateLocationPreviewImage(lat, lng);
    setState(() => _previewImageUrl = imageUrl);
    widget.onSelectPlace(lat, lng);
  }

  @override
  Widget build(BuildContext context) {
    final previewImageUrl = _previewImageUrl;

    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
          ),
          alignment: Alignment.center,
          height: 170,
          width: double.infinity,
          child: previewImageUrl == null
              ? Center(child: Text('No location chosen'))
              : Image.network(previewImageUrl),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton.icon(
              onPressed: _getCurrentUserLocation,
              icon: Icon(Icons.location_on),
              label: Text("Current location"),
            ),
            TextButton.icon(
              onPressed: _selectOnMap,
              icon: Icon(Icons.map),
              label: Text("Select on map"),
            ),
          ],
        )
      ],
    );
  }
}
