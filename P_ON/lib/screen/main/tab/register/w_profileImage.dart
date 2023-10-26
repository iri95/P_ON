import 'dart:io';

import 'package:fast_app_base/common/common.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileImage extends StatefulWidget {
  const ProfileImage({super.key});

  @override
  State<ProfileImage> createState() => _ProfileImageState();
}

class _ProfileImageState extends State<ProfileImage> {
  final ImagePicker _picker = ImagePicker();
  XFile? selectedImage;
  File? profileImage;

  void getImage() async {
    selectedImage = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      profileImage = File(selectedImage!.path);
    });
  }

  void showImage() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Image.file(profileImage!),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: showImage,
          child: CircleAvatar(
            radius: 40,
            backgroundImage: profileImage != null
                ? FileImage(profileImage!) as ImageProvider<Object>?
                : AssetImage('assets/image/main/핑키1.png')
                    as ImageProvider<Object>?,
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: CircleAvatar(
            radius: 15,
            backgroundColor: AppColors.mainBlue,
            child: IconButton(
              onPressed: getImage,
              icon: const Icon(
                Icons.edit,
                color: Colors.white,
                size: 14,
              ),
            ),
          ),
        )
      ],
    );
  }
}
