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
  File? profileImageFile;

  // late File? profileImage;

// 갤러리에서 선택
  void getImage() async {
    selectedImage = await _picker.pickImage(source: ImageSource.gallery);
    print('전전 ${widget.profileImage}');
    print('전 ${profileImageFile?.path}');
    print('이건뭐지 ${selectedImage?.path}');
    if (selectedImage != null) {
      setState(() {
        // 선택된 이미지를 File 객체로 변환하여 profileImageFile에 저장
        profileImageFile = File(selectedImage!.path);
      });
      print('후 ${profileImageFile?.path}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () {},
          child: CircleAvatar(
            radius: 40,
            backgroundImage: profileImageFile != null
                ? FileImage(profileImageFile!) as ImageProvider
                : NetworkImage(widget.profileImage),
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
