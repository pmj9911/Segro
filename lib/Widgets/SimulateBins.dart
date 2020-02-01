import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'InfoBins.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Bin {
  // double latitude;
  // double longitude;
  // String locationName;
  // double garbageValue;
  // String wasteType;
  // bool needsToBeCollected;
  // bool binFull;
  // bool wasteCollected;
  List result;
  Bin({
    // this.latitude,
    // this.longitude,
    // this.locationName,
    // this.garbageValue,
    // this.wasteType,
    // this.needsToBeCollected,
    // this.binFull,
    // this.wasteCollected,
    this.result,
  });

  factory Bin.fromJson(List<dynamic> json) {
    return Bin(
      // latitude: json['latitude'],
      // longitude: json['longitude'],
      // locationName: json['location_name'],
      // garbageValue: json['garbage_value'],
      // wasteType: json['waste_type'],
      // needsToBeCollected: json['needs_to_be_collected'],
      // binFull: json['bin_full'],
      // wasteCollected: json['waste_collected'],
      result: json,
    );
  }
}

Future<Bin> getBins(String target) async {
  final response = await http.get(
    'https://a9b8b479.ngrok.io/bins/${target}/',
    headers: {
      HttpHeaders.contentTypeHeader: 'application/json',
    },
  );
  // print('####### ${response.body.toString()}');
  if (response.statusCode == 200) {
    // print(json.decode(response.body));
    return Bin.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load post');
  }
}

class SimulateBins extends StatefulWidget {
  @override
  _SimulateBinsState createState() => _SimulateBinsState();
}

class _SimulateBinsState extends State<SimulateBins> {
  // static const String _API_KEY = 'AIzaSyCVVe3n7f-dgPxwUg6PQspksqFtmx5SOYQ';
  Timer _timer;
  _SimulateBinsState() {
    _timer = new Timer(const Duration(milliseconds: 1000), () {
      setState(() {
        // buttonPressed = false;
      });
    });
  }

  static final LatLng center = const LatLng(15.3929092, 73.8805639);
  GoogleMapController controller;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  MarkerId selectedMarker;
  int _markerIdCounter = 1;
  Position _currentPosition;
  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 3), (Timer t) => addValue());

    _getCurrentLocation();
  }

  _getCurrentLocation() {
    final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;

    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
        // print(_currentPosition.longitude);
      });
    }).catchError((e) {
      print(e);
    });
  }

  void addValue() {
    setState(() {
      getBins('simulation').then((value) {
        // print(value.result);
        List res = value.result;
        for (int i = 0; i < (res.length); i++) {
          // print(res[i]['latitude']);
          // print(res[i]['longitude']);
          _add(res[i]['latitude'], res[i]['longitude'],
              locationName: res[i]['location_name'],
              distance: i,
              garbageValue: res[i]['garbage_value']);
        }
        // if (value.latitude != null && value.longitude != null) {
        //   _add(value.latitude, value.longitude);
        // }
      });
      print("\n\n");
    });

  }

  void _add(double lat, double long,
      {String locationName = "Starting Point",
      int distance = 0,
      double garbageValue = 75}) {
    
    // for (int i=0; i < markers.length; i++){
    //   final MarkerId j = MarkerId('marker_id_$i');
    //   print(markers[j]);
    // }
    
// Marker{markerId: MarkerId{value: marker_id_1}, alpha: 1.0, anchor: Offset(0.5, 1.0), consumeTapEvents: false, draggable: false, flat: false, icon: Instance of 'BitmapDescriptor', infoWindow: InfoWindow{title: Estilo Patio, snippet: 0, anchor: Offset(0.5, 0.0)}, position: LatLng(15.392916, 73.87238271500001), rotation: 0.0, visible: true, zIndex: 0.5, onTap: null}

    final String markerIdVal = 'marker_id_$_markerIdCounter';

    // print(markerIdVal);
    _markerIdCounter++;
    final MarkerId markerId = MarkerId(markerIdVal);
    print('$garbageValue lala  $locationName');
    if (garbageValue == 75) {
      final Marker marker = Marker(
        markerId: markerId,
        position: LatLng(
          lat,
          long,
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan),
        zIndex: 0.5,
        infoWindow: InfoWindow(
          title: locationName,
          snippet: '$distance',
        ),
        onDragEnd: (LatLng position) {
          _onMarkerDragEnd(markerId, position);
        },
      );
      setState(() {
        markers[markerId] = marker;
      });
    } else if (garbageValue == 100) {
      final Marker marker = Marker(
        markerId: markerId,
        position: LatLng(
          lat,
          long,
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        infoWindow: InfoWindow(
          title: locationName,
          snippet: '$distance',
        ),
        zIndex: 1,
        onDragEnd: (LatLng position) {
          _onMarkerDragEnd(markerId, position);
        },
      );
      setState(() {
        markers[markerId] = marker;
      });
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    this.controller = controller;
  }

  @override
  void dispose() {
    _timer.cancel();

    super.dispose();
  }

  void _onMarkerTapped(MarkerId markerId) {
    final Marker tappedMarker = markers[markerId];
    if (tappedMarker != null) {
      setState(() {
        if (markers.containsKey(selectedMarker)) {
          final Marker resetOld = markers[selectedMarker]
              .copyWith(iconParam: BitmapDescriptor.defaultMarker);
          markers[selectedMarker] = resetOld;
        }
        selectedMarker = markerId;
        final Marker newMarker = tappedMarker.copyWith(
          iconParam: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueGreen,
          ),
        );
        markers[markerId] = newMarker;
      });
    }
  }

  void _onMarkerDragEnd(MarkerId markerId, LatLng newPosition) async {
    final Marker tappedMarker = markers[markerId];
    if (tappedMarker != null) {
      await showDialog<void>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
                actions: <Widget>[
                  FlatButton(
                    child: const Text('OK'),
                    onPressed: () => Navigator.of(context).pop(),
                  )
                ],
                content: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 66),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text('Old position: ${tappedMarker.position}'),
                        Text('New position: $newPosition'),
                      ],
                    )));
          });
    }
  }

  void _remove() {
    setState(() {
      if (markers.containsKey(selectedMarker)) {
        markers.remove(selectedMarker);
      }
    });
  }

  void _changePosition() {
    final Marker marker = markers[selectedMarker];
    final LatLng current = marker.position;
    final Offset offset = Offset(
      center.latitude - current.latitude,
      center.longitude - current.longitude,
    );
    setState(() {
      markers[selectedMarker] = marker.copyWith(
        positionParam: LatLng(
          center.latitude + offset.dy,
          center.longitude + offset.dx,
        ),
      );
    });
  }

  Future<void> _toggleVisible() async {
    final Marker marker = markers[selectedMarker];
    setState(() {
      markers[selectedMarker] = marker.copyWith(
        visibleParam: !marker.visible,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    double lat = _currentPosition.latitude;
    double long = _currentPosition.longitude;
    // _add(lat, long);

    return Scaffold(
      body: Stack(
        children: <Widget>[
          GoogleMap(
            myLocationEnabled: true,
            compassEnabled: true,
            tiltGesturesEnabled: false,
            markers: Set<Marker>.of(markers.values),
            mapType: MapType.normal,
            initialCameraPosition: CameraPosition(
              target: LatLng(lat, long),
              zoom: 13.0,
            ),
            onMapCreated: (_) {
              _onMapCreated(controller);
            },
          ),
        ],
      ),
    );
  }
}
