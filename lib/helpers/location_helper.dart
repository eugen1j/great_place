import 'dart:convert';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import '../models/place.dart';

const GOOGLE_API_KEY = "GOOGLE_API_KEY";

class LocationHelper {
  static String generateLocationPreviewImage(double lat, double lng) {
    return "https://maps.googleapis.com/maps/api/staticmap"
        "?zoom=14&size=600x250&scale=2&maptype=roadmap"
        "&markers=${lat},${lng}&key=${GOOGLE_API_KEY}";
  }

  static Future<String> getPlaceAddress(double lat, double lng) async {
    final uri = Uri.parse('https://maps.googleapis.com/maps/api/geocode/json'
        '?latlng=${lat},${lng}&key=${GOOGLE_API_KEY}');
    final response = await http.get(uri);
    final data = jsonDecode(response.body);
    return data['results'][0]['formatted_address'];
  }
}
