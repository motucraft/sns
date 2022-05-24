import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sns/data_models/location.dart';
import 'package:sns/models/repositories/post_repository.dart';
import 'package:sns/models/repositories/user_repository.dart';
import 'package:sns/utils/constant.dart';

class PostViewModel extends ChangeNotifier {
  final UserRepository userRepository;

  final PostRepository postRepository;

  PostViewModel({required this.userRepository, required this.postRepository});

  File? imageFile;
  late Location location;
  String locationString = '';

  String caption = '';

  /// 処理中を表す
  bool isProcessing = false;

  /// 画像が取得できたか否か
  bool isIMagePicked = false;

  Future<void> pickImage(UploadType uploadType) async {
    isIMagePicked = false;
    isProcessing = true;
    notifyListeners();

    imageFile = await postRepository.pickImage(uploadType);
    print('pickImage: ${imageFile?.path}');

    location = await postRepository.getCurrentLocation();
    locationString = _toLocationString(location);
    print('location: $locationString');

    if (imageFile != null) isIMagePicked = true;
    isProcessing = false;
    notifyListeners();
  }

  Future<void> updateLocation(double latitude, double longitude) async {
    print('updateLocation: $latitude $longitude');
    location = await postRepository.updateLocation(latitude, longitude);
    locationString = _toLocationString(location);
    notifyListeners();
  }

  String _toLocationString(Location location) {
    return location.country + ' ' + location.state + ' ' + location.city;
  }

  Future<void> post() async {
    if (imageFile == null) return;

    isProcessing = true;
    notifyListeners();

    await postRepository.post(
      UserRepository.currentUser!,
      imageFile!,
      caption,
      location,
      locationString,
    );

    isProcessing = false;
    isIMagePicked = false;
    notifyListeners();
  }

  void cancelPost() {
    isProcessing = false;
    isIMagePicked = false;
    notifyListeners();
  }
}
