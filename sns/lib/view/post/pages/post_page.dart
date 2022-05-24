import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sns/generated/l10n.dart';
import 'package:sns/utils/constant.dart';
import 'package:sns/view/common/components/button_with_icon.dart';
import 'package:sns/view/post/screens/post_upload_screen.dart';

class PostPage extends StatelessWidget {
  const PostPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 90.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ButtonWithIcon(
                iconData: FontAwesomeIcons.images,
                label: S.of(context).gallery,
                onPressed: () => _openPostUploadScreen(
                  UploadType.gallery,
                  context,
                ),
              ),
              const SizedBox(
                height: 24.0,
              ),
              ButtonWithIcon(
                iconData: FontAwesomeIcons.camera,
                label: S.of(context).camera,
                onPressed: () => _openPostUploadScreen(
                  UploadType.camera,
                  context,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _openPostUploadScreen(UploadType uploadType, BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PostUploadScreen(
          uploadType: uploadType,
        ),
      ),
    );
  }
}
