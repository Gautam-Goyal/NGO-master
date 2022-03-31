import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ngo/apptheme.dart';

enum mode { edit, read }

class NgoProfile extends StatefulWidget {
  const NgoProfile({Key? key}) : super(key: key);

  @override
  State<NgoProfile> createState() => _NgoProfileState();
}

class _NgoProfileState extends State<NgoProfile> {
  mode _viewstate = mode.edit;
  final String bio =
      'Education & Literacy Health & Family Welfare Women\'s Development & Empowerment';
  final List<String> workin =
      "Education & Literacy,Health & Family Welfare,Women's Development & Empowerment"
          .split(',');

  File? profilePic;
  final List<File> workImages = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NGO Profile'),
        backgroundColor: AppTheme.nearlyWhite,
        foregroundColor: AppTheme.nearlyBlack,
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () => setState(
              () => _viewstate == mode.read
                  ? _viewstate = mode.edit
                  : _viewstate = mode.read,
            ),
            icon: const Icon(Icons.edit),
          ),
        ],
      ),
      body: Container(
        color: AppTheme.nearlyWhite,
        child: ListView(
          primary: true,
          padding: const EdgeInsets.all(20.0),
          children: [
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                GestureDetector(
                  onTap: _viewstate == mode.edit
                      ? () {
                          modalProfilePicker(context);
                        }
                      : null,
                  child: profilePic == null
                      ? CircleAvatar(
                          backgroundColor: AppTheme.background,
                          child: Icon(
                            _viewstate == mode.edit
                                ? Icons.add_a_photo_outlined
                                : Icons.person,
                            color: AppTheme.grey,
                            size: 40,
                          ),
                          radius: 40,
                        )
                      : _viewstate == mode.edit
                          ? Stack(
                              children: [
                                CircleAvatar(
                                  backgroundImage:
                                      Image.file(profilePic!).image,
                                  radius: 40,
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: AppTheme.nearlyBlack,
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: const Icon(
                                      Icons.add,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : CircleAvatar(
                              backgroundImage: Image.file(profilePic!).image,
                              radius: 40,
                            ),
                ),
                const SizedBox(width: 20),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Agrim Charan Foundation',
                      style: AppTheme.body1.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      'vikash.gupta@matrixclothing.in',
                      style: AppTheme.body1,
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      '7988959662',
                      style: AppTheme.body1,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text.rich(
              TextSpan(
                children: [
                  TextSpan(text: 'Address:\n', style: AppTheme.title),
                  TextSpan(
                      text: '107B, Beverly Park-I, M.G road, DLF Phae-II',
                      style: AppTheme.body2),
                ],
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Works In:',
              style: AppTheme.title,
            ),
            ...workin.map((item) => Text(item, style: AppTheme.body2)).toList(),
            const SizedBox(height: 10),
            const Text(
              'Bio:',
              style: AppTheme.title,
            ),
            TextFormField(
              readOnly: _viewstate == mode.read ? true : false,
              cursorColor: AppTheme.nearlyBlack,
              initialValue: bio,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Tell something about your NGO...'),
            ),
            const SizedBox(height: 20),
            const Text(
              'Images',
              style: AppTheme.title,
            ),
            const Divider(
              thickness: 1,
              color: AppTheme.nearlyBlack,
            ),
            GridView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 5,
                mainAxisSpacing: 5,
              ),
              children: _viewstate == mode.edit
                  ? [
                      GestureDetector(
                        onTap: () => modalImagesPicker(context),
                        child: Container(
                          color: AppTheme.background,
                          child: const Icon(
                            Icons.add,
                            size: 50,
                            color: AppTheme.grey,
                          ),
                        ),
                      ),
                      ...workImages
                          .map(
                            (image) => Image.file(
                              image,
                              fit: BoxFit.cover,
                            ),
                          )
                          .toList(),
                    ]
                  : workImages
                      .map(
                        (image) => Image.file(
                          image,
                          fit: BoxFit.cover,
                        ),
                      )
                      .toList(),
            )
          ],
        ),
      ),
      floatingActionButton: _viewstate == mode.read
          ? FloatingActionButton(
              backgroundColor: AppTheme.nearlyBlack,
              foregroundColor: AppTheme.background,
              onPressed: () {},
              child: const Icon(Icons.message_rounded),
            )
          : null,
    );
  }

  modalProfilePicker(BuildContext context) => showModalBottomSheet(
        context: context,
        builder: (_) {
          return SizedBox(
            height: 100,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  child: Row(
                    children: const [
                      Icon(
                        Icons.photo,
                        size: 40,
                      ),
                      Text(
                        'Pick from Gallery',
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                  onTap: () => pickProfileImage(ImageSource.gallery),
                ),
                InkWell(
                  child: Row(
                    children: const [
                      Icon(
                        Icons.photo_camera,
                        size: 40,
                      ),
                      Text(
                        'Capture a Photo',
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                  onTap: () => pickProfileImage(ImageSource.camera),
                ),
              ],
            ),
          );
        },
      );

  Future pickProfileImage(ImageSource imageSource) async {
    try {
      final image = await ImagePicker().pickImage(source: imageSource);
      if (image == null) return;

      setState(() {
        profilePic = File(image.path);
      });
      Navigator.pop(context);
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  modalImagesPicker(BuildContext context) => showModalBottomSheet(
        context: context,
        builder: (_) {
          return SizedBox(
            height: 100,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  child: Row(
                    children: const [
                      Icon(
                        Icons.photo,
                        size: 40,
                      ),
                      Text(
                        'Pick from Gallery',
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                  onTap: () => pickWorkImage(ImageSource.gallery),
                ),
                InkWell(
                  child: Row(
                    children: const [
                      Icon(
                        Icons.photo_camera,
                        size: 40,
                      ),
                      Text(
                        'Capture a Photo',
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                  onTap: () => pickWorkImage(ImageSource.camera),
                ),
              ],
            ),
          );
        },
      );

  Future pickWorkImage(ImageSource imageSource) async {
    try {
      final image = await ImagePicker().pickImage(source: imageSource);
      if (image == null) return;

      setState(() {
        workImages.add(File(image.path));
      });
      Navigator.pop(context);
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }
}
