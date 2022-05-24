import 'package:flutter/material.dart';
import 'package:sns/generated/l10n.dart';
import 'package:sns/models/repositories/user_repository.dart';
import 'package:sns/style.dart';
import 'package:sns/utils/constant.dart';
import 'package:sns/view/profile/screens/profile_screen.dart';
import 'package:sns/view/search/components/search_user_delegate.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.search),
        title: InkWell(
          splashColor: Colors.white30,
          onTap: () => _searchUser(context),
          child: Text(
            S.of(context).search,
            style: searchPageAppBarTitleTextStyle,
          ),
        ),
      ),
      body: Center(
        child: Text('SearchPage'),
      ),
    );
  }

  // TODO
  _searchUser(BuildContext context) async {
    final selectedUser = await showSearch(
      context: context,
      delegate: SearchUserDelegate(),
    );

    if (selectedUser != null) {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ProfileScreen(
            profileMode: ProfileMode.other,
            selectedUser: selectedUser,
            popProfileUserId: UserRepository.currentUser!.userId,
          ),
        ),
      );
    }
  }
}
