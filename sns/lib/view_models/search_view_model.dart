import 'package:flutter/material.dart';
import 'package:sns/data_models/user.dart';
import 'package:sns/models/repositories/user_repository.dart';

class SearchViewModel extends ChangeNotifier {
  final UserRepository userRepository;

  SearchViewModel({required this.userRepository});

  List<User> soughtUsers = [];

  Future<void> searchUsers(String query) async {
    soughtUsers = await userRepository.searchUsers(query);
    notifyListeners();
  }
}
