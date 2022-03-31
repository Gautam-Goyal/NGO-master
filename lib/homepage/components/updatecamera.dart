import 'package:google_maps_flutter/google_maps_flutter.dart';

Future<void> updateCameraLocation(
  LatLng source,
  LatLng destination,
  GoogleMapController mapController,
) async {
  LatLngBounds bounds;
  if (source.latitude > destination.latitude &&
      source.longitude > destination.longitude) {
    bounds = LatLngBounds(southwest: destination, northeast: source);
  } else if (source.longitude > destination.longitude) {
    bounds = LatLngBounds(
        southwest: LatLng(source.latitude, destination.longitude),
        northeast: LatLng(destination.latitude, source.longitude));
  } else if (source.latitude > destination.latitude) {
    bounds = LatLngBounds(
        southwest: LatLng(destination.latitude, source.longitude),
        northeast: LatLng(source.latitude, destination.longitude));
  } else {
    bounds = LatLngBounds(southwest: source, northeast: destination);
  }

  CameraUpdate cameraUpdate = CameraUpdate.newLatLngBounds(bounds, 150);

  return checkCameraLocation(cameraUpdate, mapController);
}

Future<void> checkCameraLocation(
    CameraUpdate cameraUpdate, GoogleMapController mapController) async {
  mapController.animateCamera(cameraUpdate);
  LatLngBounds l1 = await mapController.getVisibleRegion();
  LatLngBounds l2 = await mapController.getVisibleRegion();

  if (l1.southwest.latitude == -90 || l2.southwest.latitude == -90) {
    return checkCameraLocation(cameraUpdate, mapController);
  }
}
