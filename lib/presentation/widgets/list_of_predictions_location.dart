import 'package:flutter/material.dart';

class PredictionsListTile extends StatelessWidget {
  const PredictionsListTile(this.location, {Key? key}) : super(key: key);
  final String location;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      textColor: Colors.black,
      title: Text(
        location,
        style: const TextStyle(
          fontSize: 30,
        ),
      ),
    );
  }
}
