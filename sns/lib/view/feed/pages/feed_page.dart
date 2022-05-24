import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sns/generated/l10n.dart';
import 'package:sns/style.dart';
import 'package:sns/utils/constant.dart';
import 'package:sns/view/feed/pages/sub/feed_sub_page.dart';
import 'package:sns/view/post/screens/post_upload_screen.dart';

class FeedPage extends StatelessWidget {
  const FeedPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: FaIcon(FontAwesomeIcons.camera),
          onPressed: () => _launchCamera(context),
        ),
        title: Text(
          S.of(context).appTitle,
          style: TextStyle(fontFamily: titleFont),
        ),
      ),
      body: FeedSubPage(
        feedMode: FeedMode.fromFeed,
        index: 0,
      ),
    );
  }

  _launchCamera(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PostUploadScreen(
          uploadType: UploadType.camera,
        ),
      ),
    );
  }
}
