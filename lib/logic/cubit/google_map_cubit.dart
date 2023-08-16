import 'dart:async';

import 'package:bloc/bloc.dart';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pv_analizer/logic/repositories/location_service_repo.dart';
import 'package:pv_analizer/logic/repositories/user_repo.dart';

part 'google_map_state.dart';

class GoogleMapCubit extends Cubit<GoogleMapState> {
  final LocationService _repo;

  GoogleMapCubit(this._repo) : super(GoogleMapInitial());

  Future<Map<String, dynamic>> fechtingDirection(String origin, String destination) async {
    emit(GoogleMapLoadingState());
    var directions = await _repo.getDirections(origin, destination);

    emit(GoogleMapDirectionsFetched(
      directions,
    ));
    return directions;
  }
}
