// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import '../Map/map_body.dart';

class BusStopBody extends StatefulWidget {
  @override
  final Map<String, List<dynamic>>? courseMap;

  const BusStopBody({
    Key? key,
    this.courseMap,
  }) : super(key: key);
  State<BusStopBody> createState() => _BusStopBodyState();
}

class _BusStopBodyState extends State<BusStopBody> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: widget.courseMap?['1'] == (1)
            ? AppBar()
            : AppBar(
                bottom: PreferredSize(
                  preferredSize: Size.fromHeight(60),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 8, bottom: 8, left: 8),
                        child: Text(
                          widget.courseMap?.values.first.first['name'],
                          style: const TextStyle(fontSize: 24),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          widget.courseMap?.values.first.last['name'],
                          style: const TextStyle(fontSize: 24),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
        body: widget.courseMap?['1'] == (1)
            ? const Center(child: Text("Nie ma takiego przejazdu"))
            : Center(
                child: ListView.builder(
                  padding: const EdgeInsets.all(10),
                  itemCount: widget.courseMap?.keys.toList().length,
                  itemBuilder: ((context, index) {
                    return Card(child: listTileCourse(context, index));
                  }),
                ),
              ));
  }

  Widget listTileCourse(BuildContext context, int index) {
    var keys = widget.courseMap?.keys.toList();
    var val = widget.courseMap?[keys?[index]];

    return ListTile(
      onTap: () {
        print(val);
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => MapBody(
                    courseStageMap: widget.courseMap?[keys?[index]],
                  )),
        );
      },
      style: ListTileStyle.drawer,
      title: Row(children: [
        const Icon(Icons.bus_alert_rounded),
        Card(
          margin: const EdgeInsets.all(5),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(val!.first['id_course'].toString()),
          ),
        )
      ]),
      leading: const Padding(
        padding: EdgeInsets.only(right: 10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [Text('odjazd :'), Text("czas")],
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
