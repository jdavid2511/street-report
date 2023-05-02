import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class MapMarker {
  const MapMarker({
    required this.image,
    required this.title,
    required this.address,
    required this.location,
  });
  final String image;
  final String title;
  final String address;
  final LatLng location;
}

final _locations = [
  LatLng(8.226568520016519, -73.33947307248569),
  LatLng(8.227209632015773, -73.336146347663),
  LatLng(8.22769630098502, -73.343071257097),
  LatLng(8.228097044907669, -73.34011357540673),
  LatLng(8.226706267747312, -73.3395992392392),
];

const _path = 'assets/img/';

final mapMarkers = [
  MapMarker(
    image: '${_path}logo.png',
    title: 'David',
    address: 'address',
    location: _locations[0],
  ),
  MapMarker(
    image: '${_path}logo.png',
    title: 'Marco',
    address: 'address',
    location: _locations[1],
  ),
  MapMarker(
    image: '${_path}logo.png',
    title: 'Lucas',
    address: 'address',
    location: _locations[2],
  ),
  MapMarker(
    image: '${_path}logo.png',
    title: 'simon',
    address: 'address',
    location: _locations[3],
  ),
  MapMarker(
    image: '${_path}logo.png',
    title: 'Alan',
    address: 'address',
    location: _locations[4],
  ),
];
/*addToList() async {
  final query = "";
  var addresses = await Geocoder.local.findAddressesFromQuery(query);
  var first = addresses.first;
  setState(() {
    mapMarkers.add(new Marker(
      Widget: 45.0,
      height: 45.0,
      point: new LatLng(
        first.coordinates.latitude, first.coordinates.longitude),
        Builder: (context) => new Container(
          child: IconButton(icon: Icon(Icons.location_on),
          color: Colors.blue,
          iconSize: 45.0,
          onPressed: (){
            print(first.featureName);
          },),
        );
    ));
  });
}

Future addMarker() async {
  await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return new SimpleDialog(
          title: new Text(
            'add marker',
            style: new TextStyle(fontSize: 17.0),
          ),
          children: <Widget>[
            new SimpleDialogOption(
              child: new Text(
                'Add It',
                style: new TextStyle(color: Colors.blue),
              ),
              onPressed: () {
                addToList();
                Navigator.of(context).pop();
              },
            )
          ],
        );
      });
}*/
