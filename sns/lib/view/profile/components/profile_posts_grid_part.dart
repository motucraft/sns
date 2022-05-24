import 'package:flutter/material.dart';
import 'package:sns/data_models/post.dart';
import 'package:sns/utils/constant.dart';
import 'package:sns/view/feed/components/sub/image_from_url.dart';
import 'package:sns/view/profile/screens/feed_screen.dart';
import 'package:sns/view_models/profile_view_model.dart';
import 'package:provider/provider.dart';

class ProfilePostsGridPart extends StatelessWidget {
  final List<Post> posts;

  const ProfilePostsGridPart({Key? key, required this.posts}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverGrid.count(
      crossAxisCount: 3,
      children: posts.isEmpty
          ? [Container()]
          : List.generate(
              posts.length,
              (int index) => InkWell(
                onTap: () => _openFeedScreen(context, index),
                child: ImageFromUrl(
                  imageUrl: posts[index].imageUrl,
                ),
              ),
            ),
    );
  }

  _openFeedScreen(BuildContext context, int index) {
    final profileViewModel = context.read<ProfileViewModel>();
    final feedUser = profileViewModel.profileUser;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FeedScreen(
          feedUser: feedUser,
          index: index,
          feedMode: FeedMode.fromProfile,
        ),
      ),
    );
  }
}
