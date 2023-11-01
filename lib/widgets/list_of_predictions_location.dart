import 'package:flutter/material.dart';

class PredictionsListTile extends StatefulWidget {
  PredictionsListTile(
      {required this.predictionsOriginList, required this.controllerText, required this.getPlace, Key? key})
      : super(key: key);
  List<String> predictionsOriginList;

  String controllerText;
  final Future<Map<String, dynamic>> getPlace;

  @override
  State<PredictionsListTile> createState() => _PredictionsListTileState();
}

class _PredictionsListTileState extends State<PredictionsListTile> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: widget.predictionsOriginList.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () async {
              widget.controllerText = widget.predictionsOriginList[index];

              final place = await widget.getPlace;
              final originLat = place['geometry']['location']['lat'];
              final originLng = place['geometry']['location']['lng'];
            },
            child: ListTile(
              title: Text(
                widget.predictionsOriginList[index],
              ),
            ),
          );
        },
      ),
    );
  }
}
