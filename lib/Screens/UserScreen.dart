import 'dart:async';
import 'dart:convert';
import '../Widgets/data/error.dart';
import '../Widgets/data/place_response.dart';
import '../Widgets/data/result.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:geolocator/geolocator.dart';

class UserScreen extends StatefulWidget {
  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
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
      body: Container(
        padding: EdgeInsets.all(10),
        child: GoogleMap(
          // 2
          initialCameraPosition: _myLocation,
          // 3
          mapType: MapType.normal,
          // markers: Set.of(markers.values),
          // 4
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
        ),
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
