import 'package:p_on/common/cli_common.dart';
import 'package:p_on/common/common.dart';
import 'package:p_on/screen/main/fab/w_bottom_nav_floating_button.riverpod.dart';
import 'package:p_on/screen/main/s_main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/widget/animated_width_collapse.dart';

class BottomFloatingActionButton extends ConsumerWidget {
  static const height = 100.0;
  BottomFloatingActionButton({super.key});

  final duration = 300.ms;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final floatingButtonState = ref.watch(floatingButtonStateProvider);
    final isExpanded = floatingButtonState.isExpanded;
    final isSmall = floatingButtonState.isSmall;
    final isHided = floatingButtonState.isHided;

    return Stack(
      children: [
        IgnorePointer(
          ignoring: !isExpanded,
          child: AnimatedContainer(
            duration: duration,
            color: isExpanded ? Colors.black.withOpacity(0.4) : Colors.transparent,
          ),
        ),
        IgnorePointer(
          ignoring: isHided,
          child: Align(
              alignment: Alignment.bottomRight,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  IgnorePointer(
                    ignoring: !isExpanded,
                    child: AnimatedOpacity(
                      opacity: isExpanded ? 1 : 0,
                      duration: duration,
                      child: Column(
                        children: [
                          Container(
                            width: 160,
                            padding: const EdgeInsets.all(15),
                            margin: const EdgeInsets.only(right: 15),
                            decoration: BoxDecoration(
                                color: context.appColors.floatingActionLayer,
                                borderRadius: BorderRadius.circular(10)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Tap(onTap: () {
                                  context.go('/main/history');

                                }, child: _floatItem('알바', '$basePath/fab/fab_01.png')),
                                _floatItem('과외/클래스', '$basePath/fab/fab_02.png'),
                                _floatItem('농수산물', '$basePath/fab/fab_03.png'),
                                _floatItem('부동산', '$basePath/fab/fab_04.png'),
                                _floatItem('중고차', '$basePath/fab/fab_05.png'),
                              ],
                            ),
                          ),
                          height5,
                          Tap(
                            onTap: () {
                              // extra: , 이걸통해서 데이터 계속 불러오지 않게 할 수 있다.
                              context.pushNamed('/createpromise');
                            },
                            child: Container(
                              width: 160,
                              padding: const EdgeInsets.all(15),
                              margin: const EdgeInsets.only(right: 15, bottom: 10),
                              decoration: BoxDecoration(
                                  color: context.appColors.floatingActionLayer,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _floatItem('내 물건 팔기', '$basePath/fab/fab_06.png'),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Tap(
                    onTap: () {
                      ref.read(floatingButtonStateProvider.notifier).onTapButton();
                    },
                    child: AnimatedContainer(
                      duration: duration,
                      height: 60,
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      decoration: BoxDecoration(
                          color: isExpanded
                              ? context.appColors.floatingActionLayer
                              : const Color(0xffff791f),
                          borderRadius: BorderRadius.circular(30)),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AnimatedRotation(
                              turns: isExpanded ? 0.125 : 0,
                              duration: duration,
                              child: const Icon(Icons.add)),
                          AnimatedWidthCollapse(
                            visible: !isSmall,
                            duration: duration,
                            child: '글쓰기'.text.make(),
                          )
                        ],
                      ),
                    ),
                  ).pOnly(
                      bottom:
                      MainScreenState.bottomNavigatorHeight + context.viewPaddingBottom + 10,
                      right: 20),
                ],
              )),
        )
      ],
    );
  }

  _floatItem(String title, String imagePath) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          imagePath,
          width: 30,
        ),
        const Width(8),
        title.text.make(),
      ],
    );
  }
}


// import 'package:flutter/material.dart';
//
// class BottomFloatingActionButton extends StatelessWidget {
//   const BottomFloatingActionButton({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: const BoxDecoration(
//           shape: BoxShape.circle,
//           boxShadow: [
//             BoxShadow(
//                 color: Colors.grey,
//                 offset: Offset(0, -2),
//                 blurRadius: 3
//             )
//           ]
//       ),
//       child: FloatingActionButton.large(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         onPressed: () {},
//         child: Image.asset('assets/image/main/핑키1.png', fit: BoxFit.contain, width: 85,),
//       ),
//     );
//   }
// }
