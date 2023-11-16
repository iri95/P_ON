import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:p_on/common/common.dart';
import 'package:p_on/screen/main/s_main.dart';
import 'package:p_on/screen/main/tab/benefit/history_scroll_provider/history_scroll_controller_provider.dart';

class ScrollToUpHistory extends ConsumerWidget {
  const ScrollToUpHistory({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scrollController = ref.read(historyScrollControllerProvider);
    double myScreenWidth = MediaQuery.of(context).size.width / 5;

    return Transform.translate(
      offset: Offset(myScreenWidth, 0), // x축으로 myScreenWidth만큼 이동
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Tap(
              onTap: () {
                scrollController.animateTo(
                  0,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOut,
                );
              },
              child: Container(
                height: MainScreenState.bottomNavigatorHeight,
                width: myScreenWidth,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
