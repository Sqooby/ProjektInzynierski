// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class CourseStageList {
  int id_course_stage;
  String stage;
  String arr_time;
  String dep_time;
  String charging_time;
  int id_bus_stop;
  int id_course;
  CourseStageList({
    required this.id_course_stage,
    required this.stage,
    required this.arr_time,
    required this.dep_time,
    required this.charging_time,
    required this.id_bus_stop,
    required this.id_course,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id_course_stage': id_course_stage,
      'stage': stage,
      'arr_time': arr_time,
      'dep_time': dep_time,
      'charging_time': charging_time,
      'id_bus_stop': id_bus_stop,
      'id_course': id_course,
    };
  }

  factory CourseStageList.fromMap(Map<String, dynamic> map) {
    return CourseStageList(
      id_course_stage: map['id_course_stage'] as int,
      stage: map['stage'] as String,
      arr_time: map['arr_time'] as String,
      dep_time: map['dep_time'] as String,
      charging_time: map['charging_time'] as String,
      id_bus_stop: map['id_bus_stop'] as int,
      id_course: map['id_course'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory CourseStageList.fromJson(String source) =>
      CourseStageList.fromMap(json.decode(source) as Map<String, dynamic>);
}
