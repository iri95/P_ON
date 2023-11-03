import 'package:flutter/material.dart';
import 'package:nav/nav.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:p_on/common/common.dart';

import '../constant/app_colors.dart';

class BasicAppBar extends StatelessWidget {
  final String text;
  final bool isProgressBar;
  final int? percentage;

  const BasicAppBar({
    Key? key,
    required this.text,
    required this.isProgressBar,
    this.percentage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        Container(
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.grey, width: 1)),
          ),
          child: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              onPressed: () {
                // Navigator.pop(context);
                // context.pop();
                Nav.pop(context);
              },
              icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
            ),
            title: Text(
              text,
              style: const TextStyle(color: Colors.black),
            ),
            centerTitle: true,
          ),
        ),
        if (isProgressBar)
          LinearPercentIndicator(
            padding: EdgeInsets.zero,
            percent: (percentage ?? 0) / 100,
            lineHeight: 3,
            backgroundColor: const Color(0xffCACFD8),
            progressColor: AppColors.mainBlue3,
            width: MediaQuery.of(context).size.width,
          ),
      ],
    );
  }
}
