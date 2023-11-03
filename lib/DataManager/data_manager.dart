import 'package:pv_analizer/models/busStop.dart';
import 'package:pv_analizer/models/course_stage_list.dart';
import 'package:pv_analizer/repositories/bus_stop_repo.dart';
import 'package:pv_analizer/repositories/course_stage_repo.dart';

class DataManager {
  final _busStopRepo = BusStopRepo();
  final _courseStageRepo = CourseStageRepo();

  Future<List<Iterable<BusStop>>> busStopByIdCourseStage(int idCourseStage) async {
    final busStop = await _busStopRepo.getBusStop();

    final courseStage = await _courseStageRepo.getCourseStage();
    final busStopByCourse = courseStage.where((course) => course.id_course == idCourseStage).map((course) {
      final idBusStop = course.id_bus_stop;
      final busStopName = busStop.where((busStop) => busStop.idBusStop == idBusStop);
      return busStopName;
    }).toList();

    return busStopByCourse;
  }

  Future<List<CourseStageList>> courseStageByidCourse(int idCourseStage) async {
    final busStop = await _busStopRepo.getBusStop();

    final courseStage = await _courseStageRepo.getCourseStage();
    final courseStageByIdCourse = courseStage.where((e) => e.id_course == idCourseStage).map((course) {
      return course;
    }).toList();
    return courseStageByIdCourse;
  }
}
