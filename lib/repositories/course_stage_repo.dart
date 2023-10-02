import 'dart:convert';

import 'package:pv_analizer/models/course_stage_list.dart';

import 'package:http/http.dart' as http;

class CourseStageRepo {
  final String url = 'https://demo1.drt.kia.prz.edu.pl/api/CourseStage/';
  Future<List<CourseStageList>> getCourseStage() async {
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    print(response);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as List;

      final result = json.map((e) {
        return CourseStageList(
          id_bus_stop: e['id_bus_stop'],
          arr_time: e['arr_time'],
          charging_time: e['charging_time'],
          dep_time: e['dep_time'],
          id_course: e['id_course'],
          id_course_stage: e['id_course_stage'],
          stage: e['stage'],
        );
      }).toList();

      return result;
    } else {
      throw '${response.statusCode}';
    }
  }
}
