import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final fabLocationProvider = StateProvider<CenterDockedFloatingActionButtonLocation>((ref) {
  return CenterDockedFloatingActionButtonLocation(15.0); // 초기 오프셋 값
});

class CenterDockedFloatingActionButtonLocation extends FloatingActionButtonLocation {
  final double offsetY; // Y축 오프셋 값

  const CenterDockedFloatingActionButtonLocation(this.offsetY);

  @override
  Offset getOffset(ScaffoldPrelayoutGeometry scaffoldGeometry) {
    // FloatingActionButtonLocation.centerDocked의 기본 위치를 계산
    final Offset centerDockedOffset = FloatingActionButtonLocation.centerDocked.getOffset(scaffoldGeometry);

    // Y축에 대해서만 오프셋을 적용하여 위치를 조정
    return Offset(centerDockedOffset.dx, centerDockedOffset.dy + offsetY);
  }
}
