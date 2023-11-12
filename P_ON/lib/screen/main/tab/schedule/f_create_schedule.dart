import 'package:after_layout/after_layout.dart';
import 'package:p_on/screen/main/tab/promise_room/f_selected_friends.dart';
import 'package:flutter/material.dart';
import '../../../../common/common.dart';
import '../../../../common/util/app_keyboard_util.dart';
import './dto_schedule.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class CreateSchedule extends ConsumerStatefulWidget {
  const CreateSchedule({super.key});

  @override
  ConsumerState<CreateSchedule> createState() => _CreatePromiseState();
}

class _CreatePromiseState extends ConsumerState<CreateSchedule>
    with AfterLayoutMixin {
  final node = FocusNode();
  final TextEditingController textController = TextEditingController();
  bool _showError = false;

  @override
  void initState() {
    super.initState();
    textController.addListener(updateText);
    node.addListener(updateText);
  }

  void updateText() {
    if (textController.text.isNotEmpty) {
      setState(() {
        _showError = false;
      });
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Nav.pop(context);
            ref.read(promiseProvider.notifier).reset();
          },
        ),
        title: '새 일정'.text.bold.black.make(),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              margin: const EdgeInsets.all(24),
              alignment: Alignment.topLeft,
              child: '할 일을 입력해 주세요'.text.black.size(16).semiBold.make()),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 24),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            width: double.infinity,
            height: 50,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: _showError
                      ? Colors.red
                      : textController.text.isEmpty && !node.hasFocus
                      ? Colors.grey
                      : AppColors.mainBlue2,
                )),
            child: TextField(
              focusNode: node,
              controller: textController,
              decoration: const InputDecoration(
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none),
            ),
          ),
          if (_showError)
            Container(
                margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 24),
                child: const Text('제목을 입력해 주세요!!',
                    style: TextStyle(
                        fontFamily: 'Pretendard',
                        fontSize: 14,
                        color: Colors.red)))
        ],
      ),
      bottomSheet: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        child: Row(
          children: [
            Expanded(
              child: FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.grey, // 취소 버튼의 배경색
                  minimumSize: Size(double.infinity, 48), // 버튼의 최소 크기 설정
                ),
                onPressed: () {
                  // 현재 화면 닫기
                  Navigator.pop(context);
                },
                child: const Text('취소'),
              ),
            ),
            const SizedBox(width: 16), // 버튼 사이 간격
            Expanded(
              child: FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: textController.text.isEmpty
                      ? Colors.grey
                      : AppColors.mainBlue,
                  minimumSize: Size(double.infinity, 48), // 버튼의 최소 크기 설정
                ),
                onPressed: () {
                  if (textController.text.isEmpty) {
                    setState(() {
                      _showError = true;
                    });
                  } else {
                    ref
                        .read(promiseProvider.notifier)
                        .setPromiseTitle(textController.text);
                    Nav.push(const SelectedFriends());
                  }
                },
                child: const Text('다음'),
              ),
            ),
          ],
        ),
      ),
    );
    // ),
    // );
  }

  @override
  FutureOr<void> afterFirstLayout(BuildContext context) {
    AppKeyboardUtil.show(context, node);
  }
}
