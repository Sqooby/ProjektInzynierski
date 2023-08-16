part of 'google_map_cubit.dart';

@immutable
abstract class GoogleMapState {}

class GoogleMapInitial extends GoogleMapState {}

class GoogleMapLoadedState extends GoogleMapState {}

class GoogleMapDirectionsFetched extends GoogleMapState {
  final Map<String, dynamic> direction;
  final Completer<GoogleMapController> controller = Completer<GoogleMapController>();

  final Set<Marker> markers = Set<Marker>();
  final Set<Polygon> polygons = Set<Polygon>();
  final Set<Polyline> polylines = Set<Polyline>();
  final List<LatLng> polygonLatLngs = <LatLng>[];
  GoogleMapDirectionsFetched(this.direction);
}

class GoogleMapLoadingState extends GoogleMapState {}

class GoogleMapErrorState extends GoogleMapState {}
