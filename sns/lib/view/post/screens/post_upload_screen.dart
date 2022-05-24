import 'package:flutter/material.dart';
import 'package:sns/generated/l10n.dart';
import 'package:sns/utils/constant.dart';
import 'package:sns/view/common/dialog/confirm_dialog.dart';
import 'package:sns/view/post/components/post_caption_part.dart';
import 'package:sns/view/post/components/post_location_part.dart';
import 'package:sns/view_models/post_view_model.dart';
import 'package:provider/provider.dart';

class PostUploadScreen extends StatelessWidget {
  final UploadType uploadType;

  const PostUploadScreen({Key? key, required this.uploadType})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final postViewModel = context.read<PostViewModel>();

    if (!postViewModel.isIMagePicked && !postViewModel.isProcessing) {
      // 非同期処理を逃がす
      Future(() => postViewModel.pickImage(uploadType));
    }

    return Consumer<PostViewModel>(
      builder: (context, model, child) {
        return Scaffold(
          appBar: AppBar(
            leading: model.isProcessing
                ? Container()
                : IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => _cancelPost(context),
                  ),
            title: model.isProcessing
                ? Text(S.of(context).underProcessing)
                : Text(S.of(context).post),
            actions: [
              (model.isProcessing || !model.isIMagePicked)
                  ? IconButton(
                      onPressed: () => _cancelPost(context),
                      icon: const Icon(Icons.close))
                  : IconButton(
                      onPressed: () => showConfirmDialog(
                        context: context,
                        title: S.of(context).post,
                        content: S.of(context).postConfirm,
                        onConfirmed: (isConfirmed) {
                          if (isConfirmed) {
                            _post(context);
                          }
                        },
                      ),
                      icon: const Icon(Icons.done),
                    ),
            ],
          ),
          body: model.isProcessing
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : model.isIMagePicked
                  ? Column(
                      children: [
                        Divider(),
                        PostCaptionPart(
                          from: PostCaptionOpenMode.fromPost,
                        ),
                        Divider(),
                        PostLocationPart(),
                        Divider(),
                      ],
                    )
                  : Container(),
        );
      },
    );
  }

  _cancelPost(BuildContext context) {
    final postViewModel = context.read<PostViewModel>();
    postViewModel.cancelPost();
    Navigator.pop(context);
  }

  void _post(BuildContext context) async {
    print('PostUploadScreen#_post invoked');
    final postViewModel = context.read<PostViewModel>();
    await postViewModel.post();
    Navigator.pop(context);
  }
}
