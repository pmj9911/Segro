import 'package:flutter/material.dart';
import 'dart:ui';
import 'NearestBins.dart';
// class PinInformation {
//   String pinPath;
//   String avatarPath;
//   LatLng location;
//   String locationName;
//   Color labelColor;

//   PinInformation(
//       {this.pinPath,
//       this.avatarPath,
//       this.location,
//       this.locationName,
//       this.labelColor});
// }

class NearestBinsInfo extends StatefulWidget {
  final double pinPillPosition;
  final PinInformation currentlySelectedPin;

  NearestBinsInfo({this.pinPillPosition, this.currentlySelectedPin});

  @override
  State<StatefulWidget> createState() => NearestBinsInfoState();
}

class NearestBinsInfoState extends State<NearestBinsInfo> {
  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      bottom: widget.pinPillPosition,
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
                width: 50,
                height: 50,
                margin: EdgeInsets.only(left: 10),
                //   child: ClipOval(
                //       child: Image.asset(widget.currentlySelectedPin.avatarPath,
                //           fit: BoxFit.cover)),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(left: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(widget.currentlySelectedPin.locationName,
                          style: TextStyle(
                              color: widget.currentlySelectedPin.labelColor)),
                      Text(
                          'Latitude: ${widget.currentlySelectedPin.location.latitude.toString()}',
                          style: TextStyle(fontSize: 12, color: Colors.grey)),
                      Text(
                          'Longitude: ${widget.currentlySelectedPin.location.longitude.toString()}',
                          style: TextStyle(fontSize: 12, color: Colors.grey)),
                    ],
                  ),
                ),
              ),
              // Padding(
              //   padding: EdgeInsets.all(15),
              //   child: Image.asset(widget.currentlySelectedPin.pinPath,
              //       width: 50, height: 50),
              // )
            ],
          ),
        ),
      ),
    );
  }
}
