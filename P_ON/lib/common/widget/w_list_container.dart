import 'package:fast_app_base/common/common.dart';
import 'package:flutter/material.dart';

class ListContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  final EdgeInsets? margin;
  final double radius;
  final Color? backgroundColor;
  final bool isDateClose;

  const ListContainer(
      {required this.child,
      this.isDateClose = false,
      super.key,
      this.radius = 20,
      this.backgroundColor,
      this.margin,
      this.padding = const EdgeInsets.symmetric(horizontal: 20, vertical: 15)});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      margin: margin,
      decoration: BoxDecoration(
        color: isDateClose
          ? backgroundColor ?? context.appColors.listLayoutBackground
          : backgroundColor ?? context.appColors.listLayoutBackground,
          borderRadius: BorderRadius.circular(radius)),
      child: child,
    );
  }
}
