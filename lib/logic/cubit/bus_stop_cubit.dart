import 'package:bloc/bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:meta/meta.dart';
import 'package:pv_analizer/logic/models/busStop.dart';

import '../repositories/bus_stop_repo.dart';

part 'bus_stop_state.dart';

class BusStopCubit extends Cubit<BusStopState> {
  final BusStopRepo _repo;
  String? currentAddress;
  Position? currentPosition;

  BusStopCubit(this._repo) : super(BusStopInitial());

  Future<void> fetchBusStop() async {
    emit(BusStopLoadingState());
    try {
      final response = await _repo.getBusStop();

      emit(BusStopLoadedState(response));
    } catch (e) {
      emit(BusStopErrorState(e.toString()));
    }
  }

  Future<void> getNearestBusStop(double lat, double lng, Iterable<BusStop> response) async {}
}
