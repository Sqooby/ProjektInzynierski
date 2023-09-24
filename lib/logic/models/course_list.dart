// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class CourseList {
  int id_course;
  String start_time;
  String end_time;
  String id_driver_vehicle;
  CourseList({
    required this.id_course,
    required this.start_time,
    required this.end_time,
    required this.id_driver_vehicle,
  });

  CourseList copyWith({
    int? id_course,
    String? start_time,
    String? end_time,
    String? id_driver_vehicle,
  }) {
    return CourseList(
      id_course: id_course ?? this.id_course,
      start_time: start_time ?? this.start_time,
      end_time: end_time ?? this.end_time,
      id_driver_vehicle: id_driver_vehicle ?? this.id_driver_vehicle,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id_course': id_course,
      'start_time': start_time,
      'end_time': end_time,
      'id_driver_vehicle': id_driver_vehicle,
    };
  }

  factory CourseList.fromMap(Map<String, dynamic> map) {
    return CourseList(
      id_course: map['id_course'] as int,
      start_time: map['start_time'] as String,
      end_time: map['end_time'] as String,
      id_driver_vehicle: map['id_driver_vehicle'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory CourseList.fromJson(String source) => CourseList.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CourseList(id_course: $id_course, start_time: $start_time, end_time: $end_time, id_driver_vehicle: $id_driver_vehicle)';
  }

  @override
  bool operator ==(covariant CourseList other) {
    if (identical(this, other)) return true;

    return other.id_course == id_course &&
        other.start_time == start_time &&
        other.end_time == end_time &&
        other.id_driver_vehicle == id_driver_vehicle;
  }

  @override
  int get hashCode {
    return id_course.hashCode ^ start_time.hashCode ^ end_time.hashCode ^ id_driver_vehicle.hashCode;
  }
}
