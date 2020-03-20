import 'dart:convert';
import 'dart:io';
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
      route: json['results'],
    );
  }
}

String postToJson(double lat, double long) {
  final cord = {
    'latitude': lat,
    'longitude': long,
  };
  return json.encode(cord);
}

Future<Result> getNearby(double lat, double long) async {
  print("\n\n\nINSIDE GET NEARBY\n\n\n");
  final response = await http.post(
    'https://28505f93.ngrok.io/users/nearby_bin/',
    headers: {
      HttpHeaders.contentTypeHeader: 'application/json',
    },
    body: postToJson(lat, long),
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

class NearestBins extends StatefulWidget {
  @override
  _NearestBinsState createState() => _NearestBinsState();
}

class _NearestBinsState extends State<NearestBins> {
  static final LatLng center = const LatLng(15.3929092, 73.8805639);

  GoogleMapController controller;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  MarkerId selectedMarker;
  int _markerIdCounter = 1;
  Position _currentPosition;
  double pinPillPosition = -100;
  PinInformation currentlySelectedPin = PinInformation(
      location: LatLng(0, 0), locationName: '', labelColor: Colors.grey);
  PinInformation sourcePinInfo;
  PinInformation destinationPinInfo;

  void changedMap() {
    _getCurrentLocation();
    double lat, long;
    if (_currentPosition.latitude != null) {
      lat = _currentPosition.latitude;
    }
    if (_currentPosition.longitude != null) {
      long = _currentPosition.longitude;
    }
    getNearby(lat, long).then((value) {
      print(value.route);
      print("%%%%%%%%%%%%%%");
      double lat;
      double long;
      String locationName;
      double distance;
      int lati = 1;
      List<dynamic> res = value.route;
      print(res);
      for (int i = 0; i < (res.length); i++) {
        for (var v in res[i].values) {
          if (lati == 1) {
            lat = v;
            lati = 2;
            print(lat);
            continue;
          } else if (lati == 2) {
            long = v;
            lati = 3;
            print(long);
            continue;
          } else if (lati == 3) {
            distance = v;
            print(distance);
            lati = 4;
          } else {
            locationName = v;
            print(locationName);
            _add(lat, long, locationName: locationName, distance: distance);
            lati = 1;
          }
        }
        print("\n");
      }
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
    // _add(lat, long);
  }

  @override
  void dispose() {
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

  void _add(double lat, double long,
      {String locationName = "Starting Point", double distance = 0.0}) {
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
      infoWindow: InfoWindow(
          title: locationName,
          snippet: '${distance.toStringAsFixed(2)} metres'),
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
              _onMapCreated(controller, lat, long);
            },
            onTap: (LatLng location) {
              setState(() {
                pinPillPosition = -100;
                changedMap();
              });
            },
          ),
          AnimatedPositioned(
            bottom: pinPillPosition,
            right: 0,
            left: 0,
            duration: Duration(milliseconds: 200),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: EdgeInsets.all(20),
                height: 70,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          blurRadius: 20,
                          offset: Offset.zero,
                          color: Colors.grey.withOpacity(0.5))
                    ]),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(left: 10),
                      width: 50,
                      height: 50,
                    ), // first widget
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(left: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(currentlySelectedPin.locationName,
                                style: TextStyle(
                                    color: currentlySelectedPin.labelColor)),
                            Text(
                                'Latitude: ${currentlySelectedPin.location.latitude.toString()}',
                                style: TextStyle(
                                    fontSize: 12, color: Colors.grey)),
                            Text(
                                'Longitude: ${currentlySelectedPin.location.longitude.toString()}',
                                style:
                                    TextStyle(fontSize: 12, color: Colors.grey))
                          ], // end of Column Widgets
                        ), // end of Column
                      ), // end of Container
                    ),
                    Padding(
                      padding: EdgeInsets.all(15),
                    ), // third widget
                  ],
                ),
              ), // end of Container
            ), // end of Align
          ),
        ],
      ),
    );
  }
}
