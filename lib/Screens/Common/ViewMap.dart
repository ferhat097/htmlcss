import 'package:flutter/material.dart';

class ViewMap extends StatefulWidget {
  final String restaurantId;
  const ViewMap({Key? key, required this.restaurantId}) : super(key: key);

  @override
  _ViewMapState createState() => _ViewMapState();
}

class _ViewMapState extends State<ViewMap> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(),
    );
  }
}
