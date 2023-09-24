import 'package:pv_analizer/logic/models/busStop.dart';
import 'package:pv_analizer/logic/repositories/bus_stop_repo.dart';
import 'package:pv_analizer/logic/repositories/course_stage_repo.dart';

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
}
