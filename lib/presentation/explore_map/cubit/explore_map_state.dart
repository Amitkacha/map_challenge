import '../model/marker_item_data.dart';

abstract class ExploreMapState {}

class MapInitialState extends ExploreMapState {}

class MapLoadingState extends ExploreMapState {}

class UpdateDataState extends ExploreMapState {}
class AnimateMarkerState extends ExploreMapState {}

class ShowMarkerDataState extends ExploreMapState {
  MarkerItemData markerItemData;
  ShowMarkerDataState(this.markerItemData);
}
