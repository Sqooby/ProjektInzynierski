part of 'bus_stop_cubit.dart';

@immutable
abstract class BusStopState {}

class BusStopInitial extends BusStopState {}

class BusStopLoadedState extends BusStopState {
  final List<BusStop> busStop;
  void NearestBustStop;
  BusStopLoadedState(this.busStop);
}

class BusStopLoadingState extends BusStopState {}

class BusStopErrorState extends BusStopState {
  final String error;
  BusStopErrorState(this.error);
}
