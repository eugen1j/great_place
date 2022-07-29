import 'package:flutter/material.dart';
import './add_place_screen.dart';
import 'package:provider/provider.dart';
import '../providers/great_places.dart';
import './place_detail_screen.dart';

class PlacesListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final places = Provider.of<GreatPlaces>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text('Your Places'),
        actions: [
          IconButton(
            onPressed: () =>
                Navigator.of(context).pushNamed(AddPlaceScreen.routeName),
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: FutureBuilder(
        future: places.fetchAndSetPlaces(),
        builder: (ctx, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? Center(child: CircularProgressIndicator())
                : Consumer<GreatPlaces>(
                    builder: (ctx, places, child) => Center(
                      child: places.items.isEmpty
                          ? child
                          : ListView.builder(
                              itemBuilder: (ctx, idx) {
                                final place = places.items[idx];
                                return ListTile(
                                  leading: CircleAvatar(
                                    backgroundImage: FileImage(place.image),
                                  ),
                                  title: Text(place.title),
                                  subtitle: Text(place.location.address),
                                  onTap: () {
                                    Navigator.of(context).pushNamed(PlaceDetailScreen.routeName, arguments: place.id);
                                    // Go detail page...
                                  },
                                );
                              },
                              itemCount: places.items.length,
                            ),
                    ),
                    child: Text('Got no places yet. Start adding some!'),
                  ),
      ),
    );
  }
}
