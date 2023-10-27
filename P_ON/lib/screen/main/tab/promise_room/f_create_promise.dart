import 'package:fast_app_base/common/constant/app_colors.dart';
import 'package:fast_app_base/common/widget/w_basic_appbar.dart';
import 'package:flutter/material.dart';
import 'package:nav/nav.dart';
import 'package:velocity_x/velocity_x.dart';

class CreatePromise extends StatelessWidget {
  const CreatePromise({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: const PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: SafeArea(
            child: BasicAppBar(text: '약속 생성')
          ),
        ),
        body: Placeholder(),
        bottomSheet: Container(
          width: double.infinity,
          height: 48,
          margin: EdgeInsets.symmetric(vertical: 24, horizontal: 24),
          decoration: BoxDecoration(
              color: AppColors.mainBlue,
              borderRadius: BorderRadius.circular(10)

          ),
          child: TextButton(
            onPressed: () {},
            child: '확인'.text.semiBold.white.make(),
          ),
        ),
      ),
    );
  }
}