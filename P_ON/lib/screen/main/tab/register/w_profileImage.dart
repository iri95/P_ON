import 'dart:io';

import 'package:p_on/common/common.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileImage extends StatefulWidget {
  final String profileImage;
  ProfileImage({super.key, required this.profileImage});

  @override
  State<ProfileImage> createState() => _ProfileImageState();
}

class _ProfileImageState extends State<ProfileImage> {
  final ImagePicker _picker = ImagePicker();
  XFile? selectedImage;
  late final File? profileImage;

  @override
  void initState() {
    super.initState();
    print('init===================');
    print(widget.profileImage);
    // 여기서 widget.profileImage를 사용하여 File 객체를 초기화하거나, 다른 로직을 적용할 수 있습니다.
    if (widget.profileImage.isNotEmpty) {
      profileImage = File(widget.profileImage);
      print('$profileImage ==========');
    }
  }

  void getImage() async {
    selectedImage = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      profileImage = File(selectedImage!.path);
    });
  }

  // 클릭 시 이미지 팝업
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
                ? FileImage(profileImage!)
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
