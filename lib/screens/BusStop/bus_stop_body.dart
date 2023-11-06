import 'package:flutter/material.dart';

import 'package:pv_analizer/screens/Map/map_body.dart';

class BusStopBody extends StatefulWidget {
  @override
  State<BusStopBody> createState() => _BusStopBodyState();
}

class _BusStopBodyState extends State<BusStopBody> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Padding(
                padding: EdgeInsets.only(right: 300, top: 8, bottom: 8, left: 8),
                child: Text(
                  'Origin',
                  style: TextStyle(fontSize: 24),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Destiantions',
                  style: TextStyle(fontSize: 24),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Center(
        child: ListView.builder(
          padding: const EdgeInsets.all(10),
          itemCount: 12,
          itemBuilder: ((context, index) {
            return Card(child: listTileCourse(context));
          }),
        ),
      ),
    );
  }

  Widget listTileCourse(BuildContext context) {
    return ListTile(
      onTap: () {
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => const MapBody()),
        // );
      },
      style: ListTileStyle.drawer,
      title: const Row(children: [
        Icon(Icons.bus_alert_rounded),
        Card(
          margin: EdgeInsets.all(5),
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Text("Number"),
          ),
        )
      ]),
      leading: const Padding(
        padding: EdgeInsets.only(right: 10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [Text('odjazd za:'), Text("czas")],
        ),
      ),
      subtitle: const Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
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
      trailing: const Text("14 min"),
    );
  }
}
