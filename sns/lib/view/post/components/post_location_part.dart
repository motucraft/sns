import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sns/data_models/location.dart';
import 'package:sns/generated/l10n.dart';
import 'package:sns/style.dart';
import 'package:sns/view/post/screens/map_screen.dart';
import 'package:sns/view_models/post_view_model.dart';
import 'package:provider/provider.dart';

class PostLocationPart extends StatelessWidget {
  const PostLocationPart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final postViewModel = context.read<PostViewModel>();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        title: Text(
          postViewModel.locationString,
          style: postLocationTextStyle,
        ),
        subtitle: _latLngPart(postViewModel.location, context),
        trailing: IconButton(
          icon: const FaIcon(FontAwesomeIcons.locationDot),
          onPressed: () => _openMapScreen(context, postViewModel.location),
        ),
      ),
    );
  }

  _latLngPart(Location location, BuildContext context) {
    const sizedBox = SizedBox(width: 8.0);

    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Chip(
          label: Text(S.of(context).latitude),
        ),
        sizedBox,
        Text(location.latitude.toStringAsFixed(2)),
        sizedBox,
        Chip(
          label: Text(S.of(context).longitude),
        ),
        sizedBox,
        Text(location.longitude.toStringAsFixed(2)),
      ],
    );
  }

  _openMapScreen(BuildContext context, Location location) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MapScreen(location: location),
      ),
    );
  }
}
