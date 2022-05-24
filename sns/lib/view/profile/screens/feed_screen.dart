import 'package:flutter/material.dart';
import 'package:sns/data_models/user.dart';
import 'package:sns/generated/l10n.dart';
import 'package:sns/utils/constant.dart';
import 'package:sns/view/feed/pages/sub/feed_sub_page.dart';

class FeedScreen extends StatelessWidget {
  final User feedUser;
  final int index;
  final FeedMode feedMode;

  const FeedScreen(
      {Key? key,
      required this.feedUser,
      required this.index,
      required this.feedMode})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).post),
      ),
      body: FeedSubPage(
        feedMode: feedMode,
        feedUser: feedUser,
        index: index,
      ),
    );
  }
}
