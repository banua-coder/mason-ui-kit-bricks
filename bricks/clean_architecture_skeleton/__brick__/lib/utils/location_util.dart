import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class LocationUtil {
  const LocationUtil._();

  static const LocationUtil _instance = LocationUtil._();

  factory LocationUtil() {
    return _instance;
  }

  static Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.',
      );
    }

    return Geolocator.getCurrentPosition();
  }

  static Future<String> determineAddress({
    required double latitude,
    required double longitude,
    String? locale = 'id_ID',
  }) async {
    var placemarks = await placemarkFromCoordinates(
      latitude,
      longitude,
      localeIdentifier: locale,
    );
    var address = StringBuffer();
    var placemark = placemarks.last;
    address.writeAll(
      [
        placemark.name,
        ', ',
        placemark.subLocality,
        ', ',
        placemark.street,
        ', ',
        placemark.locality,
        ', ',
        placemark.subAdministrativeArea,
        ', ',
        placemark.administrativeArea,
        ' ',
        placemark.postalCode,
      ],
    );

    return address.toString();
  }
}
