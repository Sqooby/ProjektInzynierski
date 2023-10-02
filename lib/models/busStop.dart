class BusStop {
  int idBusStop;
  String codeStop;
  String city;
  String name;
  String gpsN;
  String gpsE;
  String loop;
  String waitTime;
  String chargerKw;

  BusStop({
    required this.idBusStop,
    required this.codeStop,
    required this.city,
    required this.name,
    required this.gpsN,
    required this.gpsE,
    required this.loop,
    required this.waitTime,
    required this.chargerKw,
  });

  factory BusStop.fromJson(Map<String, dynamic> json) => BusStop(
        idBusStop: json["id_bus_stop"],
        codeStop: json["code_stop"],
        city: json["city"],
        name: json["name"],
        gpsN: json["gps_n"],
        gpsE: json["gps_e"],
        loop: json["loop"],
        waitTime: json["wait_time"],
        chargerKw: json["charger_kw"],
      );

  Map<String, dynamic> toJson() => {
        // "id_bus_stop": idBusStop,
        "code_stop": codeStop,
        "city": city,
        "name": name,
        "gps_n": gpsN,
        "gps_e": gpsE,
        "loop": loop,
        "wait_time": waitTime,
        "charger_kw": chargerKw,
      };
}
