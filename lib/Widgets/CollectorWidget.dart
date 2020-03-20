import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Result {
  List<dynamic> route;

  Result({
    this.route,
  });

  factory Result.fromJson(Map<String, dynamic> json) {
    return Result(
      route: json['result'],
    );
  }
}

Future<Result> getRoute() async {
  final response = await http.get(
    'https://00fa9c58.ngrok.io/collector/route/',
  );
  print('####### ${response.body.toString()}');
  if (response.statusCode == 200) {
    print(json.decode(response.body));
    return Result.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load post');
  }
}

class PinInformation {
  LatLng location;
  String locationName;
  Color labelColor;
  PinInformation({this.location, this.locationName, this.labelColor});
}

class CollectorWidget extends StatefulWidget {
  @override
  _CollectorWidgetState createState() => _CollectorWidgetState();
}

class _CollectorWidgetState extends State<CollectorWidget> {
  static final LatLng center = const LatLng(15.3929092, 73.8805639);
  GoogleMapController controller;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  Map<PolylineId, Polyline> polylines = <PolylineId, Polyline>{};
  int _polylineIdCounter = 1;
  PolylineId selectedPolyline;
  final Set<Polyline> _polyLines = {};
  MarkerId selectedMarker;
  int _markerIdCounter = 1;
  Position _currentPosition;
  double pinPillPosition = -100;
  PinInformation currentlySelectedPin = PinInformation(
      location: LatLng(0, 0), locationName: '', labelColor: Colors.grey);
  PinInformation sourcePinInfo;
  PinInformation destinationPinInfo;

  void _removePoints() {
    setState(() {
      if (polylines.containsKey(selectedPolyline)) {
        polylines.remove(selectedPolyline);
      }
      selectedPolyline = null;
    });
  }

  void _addPoints(List<LatLng> points, Color color) {
    final String polylineIdVal = 'polyline_id_$_polylineIdCounter';
    print(polylineIdVal);
    _polylineIdCounter++;
    final PolylineId polylineId = PolylineId(polylineIdVal);

    final Polyline polyline = Polyline(
      polylineId: polylineId,
      consumeTapEvents: true,
      color: color,
      width: 5,
      points: points,
    );
    print(points);
    setState(() {
      polylines[polylineId] = polyline;
    });
  }

  LatLng _createLatLng(double lat, double lng) {
    return LatLng(lat, lng);
  }

  void changedMap() {
    _getCurrentLocation();
    double lat, long;
    if (_currentPosition.latitude != null) {
      lat = _currentPosition.latitude;
    }
    if (_currentPosition.longitude != null) {
      long = _currentPosition.longitude;
    }
    getRoute().then((value) {
      print(value.route);
      print("%%%%%%%%%%%%%%");
      double lat;
      double long;
      int lati = 1;
      List<dynamic> res = value.route;
      final double offset = _polylineIdCounter.ceilToDouble();

      final List<LatLng> points = <LatLng>[];
      
      print(res);
      for (int i = 0; i < (res.length); i++) {
        for (var v in res[i].values) {
          if (lati == 1) {
            lat = v;
            lati = 2;
            print('lat: $lat');
            continue;
          } else {
            long = v;
            lati = 1;
            print('long: $long');
            print('index: ${(i + 1)}');
            points.add(_createLatLng(lat, long));

            _add(lat, long, index: (i + 1));
          }
        }
        print("\n");
      }
      _addPoints(<LatLng>[points[0], points[1]], Colors.orange);
      
      points.remove(points[0]);
      // points.remove(points[0]);
      // points.remove(points[9]);
      // points.remove(points[8]);
      _addPoints(points, Colors.blue);
      _addPoints(<LatLng>[points[9], points[10]], Colors.red);
    });
  }

  @override
  void initState() {
    _getCurrentLocation();
    super.initState();
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

  void _onMapCreated(GoogleMapController controller, double lat, double long) {
    this.controller = controller;
    print('in on map created');
  }

  @override
  void dispose() {
    super.dispose();
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
              ),
            ),
          );
        },
      );
    }
  }

  void _add(
    double lat,
    double long, {
    int index = 0,
    String locationName = "Starting Point",
    double distance = 0.0,
  }) {
    sourcePinInfo = PinInformation(
      locationName: locationName,
      location: LatLng(lat, long),
      labelColor: Colors.blueAccent,
    );
    print(sourcePinInfo.locationName);

    final String markerIdVal = 'marker_id_$_markerIdCounter';
    _markerIdCounter++;
    final MarkerId markerId = MarkerId(markerIdVal);

    final Marker marker = Marker(
      markerId: markerId,
      position: LatLng(
        lat,
        long,
      ),
      infoWindow: InfoWindow(title: locationName, snippet: '$index'),
      onTap: () {
        setState(() {
          currentlySelectedPin = sourcePinInfo;
          print(currentlySelectedPin.locationName);
          // pinPillPosition = 0;
        });
      },
      onDragEnd: (LatLng position) {
        _onMarkerDragEnd(markerId, position);
      },
    );

    setState(() {
      markers[markerId] = marker;
    });
  }

  @override
  Widget build(BuildContext context) {
    double lat, long;
    if (_currentPosition.latitude != null) {
      lat = _currentPosition.latitude;
    }
    if (_currentPosition.longitude != null) {
      long = _currentPosition.longitude;
    }
    _add(15.384224, 73.8883142);
    // _add(lat, long);
    return _currentPosition == null
        ? Container(
            alignment: Alignment.center,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : Stack(
            children: <Widget>[
              GoogleMap(
                myLocationEnabled: true,
                compassEnabled: true,
                tiltGesturesEnabled: false,
                markers: Set<Marker>.of(markers.values),
                mapType: MapType.normal,
                polylines: Set<Polyline>.of(polylines.values),
                initialCameraPosition: CameraPosition(
                  target: LatLng(lat, long),
                  zoom: 13.0,
                ),
                onMapCreated: (_) {
                  _onMapCreated(controller, lat, long);
                },
                onTap: (LatLng location) {
                  setState(() {
                    pinPillPosition = -100;
                    changedMap();
                  });
                },
              ),
            ],
          );
  }
}
