import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:opale/features/add_solution/ressources/pick_image.dart';
import 'package:opale/theme/assets.dart';

class PickImage extends StatefulWidget {
  final ValueChanged<Uint8List> banner;
  final String photoUrl;
  final String photo;
  const PickImage({
    Key? key,
    required this.banner,
    required this.photoUrl,
    this.photo = Assets.bannerDefault,
  }) : super(key: key);

  @override
  State<PickImage> createState() => _PickImageState();
}

class _PickImageState extends State<PickImage> {
  Uint8List bannerSet = Uint8List.fromList([]);

  Widget buildCoverImage() => Container(
        color: Colors.transparent,
        child: bannerSet.isEmpty
            ? Image.network(
                widget.photo,
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
              )
            : Image.memory(
                bannerSet,
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
              ),
      );

  Widget buildProfileImage() => CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 52,
        backgroundImage: NetworkImage(widget.photoUrl),
      );

  Future<void> selectImage(BuildContext parentContext) async {
    return showDialog(
      context: parentContext,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Choose a cover image'),
          children: <Widget>[
            SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Take a photo'),
                onPressed: () async {
                  Navigator.pop(context);
                  Uint8List file = await pickImage(ImageSource.camera);
                  bannerSet = file;
                  widget.banner(file);
                }),
            SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Choose from Gallery'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await pickImage(ImageSource.gallery);
                  bannerSet = file;
                  widget.banner(file);
                }),
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        GestureDetector(
          onTap: () async => await selectImage(context),
          child: buildCoverImage(),
        ),
        Positioned(
          top: 148,
          child: buildProfileImage(),
        )
      ],
    );
  }
}
