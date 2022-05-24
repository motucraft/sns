import 'package:flutter/material.dart';
import 'package:sns/utils/constant.dart';
import 'package:sns/view/profile/components/sub/profile_bio.dart';
import 'package:sns/view/profile/components/sub/profile_image.dart';
import 'package:sns/view/profile/components/sub/profile_records.dart';

class ProfileDetailPart extends StatelessWidget {
  final ProfileMode mode;

  const ProfileDetailPart({Key? key, required this.mode}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                flex: 1,
                child: ProfileImage(),
              ),
              Expanded(
                flex: 3,
                child: ProfileRecords(),
              ),
            ],
          ),
          SizedBox(
            height: 8.0,
          ),
          ProfileBio(
            mode: mode,
          ),
        ],
      ),
    );
  }
}
