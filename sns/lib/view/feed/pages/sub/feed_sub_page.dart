import 'package:flutter/material.dart';
import 'package:sns/data_models/user.dart';
import 'package:sns/utils/constant.dart';
import 'package:sns/view/feed/components/feed_post_tile.dart';
import 'package:sns/view_models/feed_view_model.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class FeedSubPage extends StatelessWidget {
  final FeedMode feedMode;
  final User? feedUser;
  final int index;

  const FeedSubPage(
      {Key? key, required this.feedMode, this.feedUser, required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final feedViewModel = context.read<FeedViewModel>();
    feedViewModel.setFeedUser(feedMode, feedUser);

    Future(() => feedViewModel.getPosts(feedMode));

    return Consumer<FeedViewModel>(
      builder: (context, model, child) {
        if (model.isProcessing) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return RefreshIndicator(
            onRefresh: () => model.getPosts(feedMode),
            child: ScrollablePositionedList.builder(
              initialScrollIndex: index,
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: model.posts.length,
              itemBuilder: (context, index) {
                return FeedPostTile(
                  feedMode: feedMode,
                  post: model.posts[index],
                );
              },
            ),
          );
        }
      },
    );
  }
}
