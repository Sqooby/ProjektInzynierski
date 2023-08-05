import 'package:bloc/bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

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

  Future<bool> handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return false;
    }
    return true;
  }

  Future<void> getCurrentPosition() async {
    final hasPermission = await handleLocationPermission();
    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high).then((Position position) {
      currentPosition = position;
      getAddressFromLatLng(currentPosition!);
    }).catchError((e) {
      print(e);
    });
  }

  Future<void> getAddressFromLatLng(Position position) async {
    await placemarkFromCoordinates(currentPosition!.latitude, currentPosition!.longitude)
        .then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];

      currentAddress = '${place.street}, ${place.subLocality}, ${place.subAdministrativeArea}, ${place.postalCode}';
    }).catchError((e) {
      print(e);
    });
  }
}
