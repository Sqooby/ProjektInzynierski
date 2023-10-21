import 'package:flutter/material.dart';

class ListTileOfCourse extends StatelessWidget {
  const ListTileOfCourse({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.11,
      child: const ListTile(
        style: ListTileStyle.drawer,
        title: Row(children: [
          Icon(Icons.bus_alert_rounded),
          Card(
            margin: EdgeInsets.all(5),
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("Number"),
            ),
          )
        ]),
        leading: Padding(
          padding: EdgeInsets.only(right: 10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [Text('odjazd za:'), Text("czas")],
          ),
        ),
        subtitle: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Row(
            children: [
              Icon(Icons.nordic_walking),
              Text('8 min'),
            ],
          ),
          Card(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('8:20'),
            ),
          ),
          Text('8 min'),
          Card(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('8:40'),
            ),
          ),
        ]),
        trailing: Text("14 min"),
      ),
    );
  }
}
