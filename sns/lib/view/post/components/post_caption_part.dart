import 'package:flutter/material.dart';
import 'package:sns/data_models/post.dart';
import 'package:sns/utils/constant.dart';
import 'package:sns/view/feed/components/sub/image_from_url.dart';
import 'package:sns/view/post/components/hero_image.dart';
import 'package:sns/view/post/components/post_caption_input_text_field.dart';
import 'package:sns/view/post/screens/enlarge_image_screen.dart';
import 'package:sns/view_models/post_view_model.dart';
import 'package:provider/provider.dart';

class PostCaptionPart extends StatelessWidget {
  final PostCaptionOpenMode from;
  final Post? post;

  const PostCaptionPart({Key? key, required this.from, this.post})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final postViewModel = context.watch<PostViewModel>();
    final image = (postViewModel.imageFile != null)
        ? Image.file(
            postViewModel.imageFile!,
            fit: BoxFit.cover,
          )
        : Image.asset('assets/images/no_image.png');

    if (from == PostCaptionOpenMode.fromPost) {
      return ListTile(
        leading: HeroImage(
          image: image,
          onTap: () => _displayLargeImage(context, image),
        ),
        title: PostCaptionInputTextField(),
      );
    } else {
      return Column(
        children: [
          ImageFromUrl(
            imageUrl: post?.imageUrl,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: PostCaptionInputTextField(
              captionBeforeUpdated: post?.caption,
              from: from,
            ),
          ),
        ],
      );
    }
  }

  _displayLargeImage(BuildContext context, Image image) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EnlargeImageScreen(image: image),
      ),
    );
  }
}
