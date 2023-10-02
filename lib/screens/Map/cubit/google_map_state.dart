part of 'google_map_cubit.dart';

@immutable
abstract class GoogleMapState {}

class GoogleMapInitial extends GoogleMapState {}

class GoogleMapLoadedState extends GoogleMapState {}

class GoogleMapDirectionsFetched extends GoogleMapState {
  final Map<String, dynamic> direction;
  final Completer<GoogleMapController> controller = Completer<GoogleMapController>();

  GoogleMapDirectionsFetched(this.direction);
}

class GoogleMapLoadingState extends GoogleMapState {}

class GoogleMapErrorState extends GoogleMapState {}
