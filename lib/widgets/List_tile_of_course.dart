import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListTileOfCourse extends StatefulWidget {
  const ListTileOfCourse({
    Key? key,
    required this.startedTime,
  }) : super(key: key);
  final TimeOfDay? startedTime;

  @override
  State<ListTileOfCourse> createState() => _ListTileOfCourseState();
}

class _ListTileOfCourseState extends State<ListTileOfCourse> {
  @override
  Widget build(BuildContext context) {
    // Or any other loading indicator

    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.05,
      child: ListTile(
        style: ListTileStyle.drawer,
        leading: const Text('odjazd o godz:'),
        title: Text('${widget.startedTime!.hour}:${widget.startedTime!.minute}'),
      ),
    );
  }
}
