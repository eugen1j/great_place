import 'dart:io';
import 'package:flutter/material.dart';
import '../models/place.dart';
import '../helpers/db_helper.dart';
import '../helpers/location_helper.dart';

class GreatPlaces with ChangeNotifier {
  List<Place> _items = [];

  List<Place> get items {
    return [..._items];
  }

  Place? findById(String id) {
    return _items.firstWhere((i) => i.id == id);
  }

  Future<void> addPlace(String title, File image, Location location) async {

    final address = await LocationHelper.getPlaceAddress(
        location.latitude, location.longitude);

    final newPlace = Place(
      id: DateTime.now().toIso8601String(),
      image: image,
      title: title,
      location: Location(
        latitude: location.latitude,
        longitude: location.longitude,
        address: address,
      ),
    );
    _items.add(newPlace);
    notifyListeners();

    DBHelper.insert('user_places', {
      "id": newPlace.id,
      "title": newPlace.title,
      "image": newPlace.image.path,
      "loc_lat": location.latitude,
      "loc_lng": location.longitude,
      "address": address,
    });
  }

  Future<void> fetchAndSetPlaces() async {
    final dataList = await DBHelper.getData('user_places');
    _items = dataList
        .map(
          (d) => Place(
            id: d['id'],
            title: d['title'],
            location: Location(
              latitude: d['loc_lat'],
              longitude: d['loc_lng'],
              address: d['address'],
            ),
            image: File(d['image']),
          ),
        )
        .toList();
    notifyListeners();
  }
}
