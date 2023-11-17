import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:p_on/common/common.dart';
import 'package:flutter/material.dart';

import 'complete_provider.dart';
import 'w_one_complete.dart';
import 'package:p_on/screen/main/s_main.dart';
import 'package:p_on/screen/main/tab/tab_item.dart';

class MyCompletePromise extends ConsumerStatefulWidget {
  const MyCompletePromise({super.key});

  @override
  ConsumerState<MyCompletePromise> createState() => _MyCompletePromiseState();
}

class _MyCompletePromiseState extends ConsumerState<MyCompletePromise> {
  bool isClose = false;
  final currentDate = DateTime.now();

  @override
  void initState() {
    print('w_promise');
    ref.read(completeProvider.notifier).getCompleteRoom();
    super.initState();
  }

  String changeDate(String date) {
    DateTime chatRoomDate = DateTime.parse(date);
    DateFormat formatter = DateFormat('yyyy-MM-dd');
    String formatterDate = formatter.format(chatRoomDate);
    return formatterDate;
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(currentTabProvider, (_, TabItem? newTabItem) async {
      if (newTabItem == TabItem.history) {
        // ref.read(completeProvider.notifier).getCompleteRoom();
        ref.read(completeProvider.notifier).getCompleteRoom();
      }
    });
    final completeData = ref.watch(completeProvider);
    final complete = completeData.complete;
    final completeCount = completeData.completeCount;

    // 화면 비율
    final Size size = MediaQuery.of(context).size;
    // if (promise.length == 0) {
    if (completeCount == 0) {
      return Container(
        width: double.infinity,
        height: 500,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/image/main/login.png',
              width: MediaQuery.of(context).size.width - 150,
            ),
            Container(
              margin: const EdgeInsets.only(top: 12),
              child: const Text('아직 저장된 추억이 없어요!',
                  style: TextStyle(
                      color: AppColors.mainBlue2,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Pretendard')),
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '핑키',
                  style: TextStyle(
                    color: AppColors.pointOrange,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Pretendard',
                  ),
                ),
                Text(
                  '와 약속을 만들어 봐요',
                  style: TextStyle(
                    color: AppColors.mainBlue2,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Pretendard',
                  ),
                ),
              ],
            )
          ],
        ),
      );
    } else {
      return ListView.builder(
        shrinkWrap: true,
        primary: false,
        itemCount: complete.length,
        itemBuilder: (BuildContext context, int index) {
          return OneCompletePromise(
            item: complete[index],
            size: size,
          );
        },
      );
    }
  }
}
