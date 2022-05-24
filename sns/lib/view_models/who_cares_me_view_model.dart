import 'package:flutter/material.dart';
import 'package:sns/data_models/user.dart';
import 'package:sns/models/repositories/user_repository.dart';
import 'package:sns/utils/constant.dart';

class WhoCaresMeViewModel extends ChangeNotifier {
  final UserRepository userRepository;

  WhoCaresMeViewModel({required this.userRepository});

  List<User> careMeUsers = [];

  User get currentUser => UserRepository.currentUser!;
  WhoCaresMeMode whoCaresMeMode = WhoCaresMeMode.like;

  Future<void> getCaresMeUsers(String id, WhoCaresMeMode mode) async {
    whoCaresMeMode = mode;

    careMeUsers = await userRepository.getCaresMeUsers(id, mode);
    print('who cares me: $careMeUsers');
    notifyListeners();
  }

  void rebuildAfterPop(String popProfileUserId) {
    getCaresMeUsers(popProfileUserId, whoCaresMeMode);
  }
}
