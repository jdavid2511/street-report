import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'map_marker.dart';

const MAPBOX_ACCESS_TOKEN =
    'pk.eyJ1IjoiZGF2aWQyNTExIiwiYSI6ImNsZ3JnMGs1eTFpa2kzZ211Z3FkYXdwdGUifQ.-zKTIZtvJkEYweXRBtHzBQ';

const MAPBOX_STYLE = 'mapbox/dart-v10';
const MAKER_COLOR = Colors.redAccent;

final _myLocation = LatLng(8.226715065736999, -73.33832311399269);

class AnimatedMarker extends StatefulWidget {
  const AnimatedMarker({super.key});

  @override
  State<AnimatedMarker> createState() => _AnimatedMarkerState();
}

class _AnimatedMarkerState extends State<AnimatedMarker> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
    );
  }
}
