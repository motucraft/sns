import 'dart:async';

import 'package:geocoding/geocoding.dart' as geo_coding;
import 'package:geolocator/geolocator.dart';
import 'package:sns/data_models/location.dart';

class LocationManager {
  Future<Location> getCurrentLocation() async {
    final isLocationServiceEnabled =
        await Geolocator.isLocationServiceEnabled();
    if (!isLocationServiceEnabled) {
      return Future.error('位置情報サービスがOFFになっています。');
    }

    var locationPermission = await Geolocator.checkPermission();
    if (locationPermission == LocationPermission.denied) {
      locationPermission = await Geolocator.requestPermission();
      // 再度パーミッションリクエスト
      if (locationPermission == LocationPermission.denied) {
        return Future<Location>.error('位置情報へのアクセスをユーザに拒否されました。');
      }
    }

    if (locationPermission == LocationPermission.deniedForever) {
      return Future.error('位置情報へのアクセスが永久に拒否されました。');
    }

    final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    final placeMarks = await geo_coding.placemarkFromCoordinates(
        position.latitude, position.longitude);
    final placeMark = placeMarks.first;

    return Future.value(
        convert(placeMark, position.latitude, position.longitude));
  }

  Future<Location> updateLocation(double latitude, double longitude) async {
    final placeMarks =
        await geo_coding.placemarkFromCoordinates(latitude, longitude);
    final placeMark = placeMarks.first;

    return Future.value(convert(placeMark, latitude, longitude));
  }

  Location convert(
      geo_coding.Placemark placeMark, double latitude, double longitude) {
    return Location(
      latitude: latitude,
      longitude: longitude,
      country: placeMark.country ?? '',
      state: placeMark.administrativeArea ?? '',
      city: placeMark.locality ?? '',
    );
  }
}
