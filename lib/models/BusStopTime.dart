import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class BusStopTime {
  int idBusStopTime;
  int idBusStopStart;
  int idBusStopEnd;
  String hour;
  String time;

  BusStopTime(this.idBusStopTime, this.idBusStopStart, this.idBusStopEnd, this.hour, this.time);

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'idBusStopTime': idBusStopTime,
      'idBusStopStart': idBusStopStart,
      'idBusStopEnd': idBusStopEnd,
      'hour': hour,
      'time': time,
    };
  }

  factory BusStopTime.fromMap(Map<String, dynamic> map) {
    return BusStopTime(
      map['id_bus_stop_time'] as int,
      map['id_bus_stop_start'] as int,
      map['id_bus_stop_end'] as int,
      map['hour'] as String,
      map['time'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory BusStopTime.fromJson(String source) => BusStopTime.fromMap(json.decode(source) as Map<String, dynamic>);
}
