import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:udemy_great_place/models/place.dart';
import 'package:udemy_great_place/providers/great_places.dart';
import 'package:udemy_great_place/screens/map_screen.dart';

class PlaceDetailScreen extends StatelessWidget {
  static const routeName = '/place-detail';

  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context)?.settings.arguments as String;
    final placesProvider = Provider.of<GreatPlaces>(context, listen: false);
    final place = placesProvider.findById(id) as Place;

    return Scaffold(
      appBar: AppBar(
        title: Text(place.title),
      ),
      body: Column(
        children: [
          Container(
            height: 250,
            width: double.infinity,
            child: Image.file(
              place.image,
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          ),
          SizedBox(height: 10),
          Text(
            place.location.address,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              color: Colors.grey,
            ),
          ),
          SizedBox(height: 10),
          TextButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                fullscreenDialog: true,
                builder: (ctx) => MapScreen(
                  lat: place.location.latitude,
                  lng: place.location.longitude,
                ),
              ));
            },
            child: Text("Show on map"),
          ),
        ],
      ),
    );
  }
}
