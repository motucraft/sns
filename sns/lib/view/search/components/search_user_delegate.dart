import 'package:flutter/material.dart';
import 'package:sns/data_models/user.dart';
import 'package:sns/view/common/components/user_card.dart';
import 'package:sns/view_models/search_view_model.dart';
import 'package:provider/provider.dart';

class SearchUserDelegate extends SearchDelegate<User?> {
  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        print('no result.');
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.clear),
      )
    ];
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final searchViewModel = context.read<SearchViewModel>();
    searchViewModel.searchUsers(query);
    return _buildResult(context);
  }

  @override
  Widget buildResults(BuildContext context) {
    final searchViewModel = context.read<SearchViewModel>();
    searchViewModel.searchUsers(query);
    return _buildResult(context);
  }

  Widget _buildResult(BuildContext context) {
    return Consumer<SearchViewModel>(
      builder: (context, model, child) => ListView.builder(
        itemCount: model.soughtUsers.length,
        itemBuilder: (context, int index) {
          final user = model.soughtUsers[index];
          return UserCard(
            photoUrl: user.photoUrl,
            title: user.inAppUserName,
            subTitle: user.bio,
            onTap: () {
              close(context, user);
            },
          );
        },
      ),
    );
  }
}
