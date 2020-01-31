import 'dart:async';
import 'dart:convert';
import 'InfoBins.dart';
import 'data/error.dart';
import 'data/place_response.dart';
import 'data/result.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SimulateBins extends StatefulWidget {
  @override
  _SimulateBinsState createState() => _SimulateBinsState();
}

class _SimulateBinsState extends State<SimulateBins> {
  static const String _API_KEY = 'AIzaSyCVVe3n7f-dgPxwUg6PQspksqFtmx5SOYQ';

  static double latitude = 40.7484405;
  static double longitude = -73.9878531;
  static const String baseUrl =
      "https://maps.googleapis.com/maps/api/place/nearbysearch/json";

  Error error;
  List<Result> places;
  bool searching = true;
  String keyword;
  Completer<GoogleMapController> _controller = Completer();
// 2
  static final CameraPosition _myLocation = CameraPosition(
    target: LatLng(15.391698, 73.880387),
    zoom: 10.0,
  );

  @override
  Widget build(BuildContext context) {
    MarkerId markerId1 = MarkerId("1");

    Marker marker1 = Marker(
      markerId: markerId1,
      position: LatLng(17.385044, 78.486671),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan),
    );
    Map markers = {};

    markers[markerId1] = marker1;
    return Scaffold(
      // 1
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(10),
            child: new GoogleMapWidget(
                myLocation: _myLocation, controller: _controller),
            height: 300,
          ),
          Container(
            child: InfoBins(),
            height: 280,
          ),
        ],
      ),
    );
  }

  void _handleResponse(data) {
    // bad api key or otherwise
    if (data['status'] == "REQUEST_DENIED") {
      setState(() {
        error = Error.fromJson(data);
      });
      // success
    } else if (data['status'] == "OK") {
    } else {
      print(data);
    }
  }
}

class GoogleMapWidget extends StatelessWidget {
  const GoogleMapWidget({
    Key key,
    @required CameraPosition myLocation,
    @required Completer<GoogleMapController> controller,
  })  : _myLocation = myLocation,
        _controller = controller,
        super(key: key);

  final CameraPosition _myLocation;
  final Completer<GoogleMapController> _controller;

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      // 2
      initialCameraPosition: _myLocation,
      // 3
      mapType: MapType.normal,
      // markers: Set.of(markers.values),
      // 4
      onMapCreated: (GoogleMapController controller) {
        _controller.complete(controller);
      },
    );
  }
}
