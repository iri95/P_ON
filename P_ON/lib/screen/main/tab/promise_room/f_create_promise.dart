import 'package:after_layout/after_layout.dart';
import 'package:p_on/screen/main/tab/promise_room/f_selected_friends.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../../../common/common.dart';
import '../../../../common/constant/app_colors.dart';
import '../../../../common/util/app_keyboard_util.dart';
import './dto_promise.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class CreatePromise extends ConsumerStatefulWidget {
  const CreatePromise({super.key});

  @override
  ConsumerState<CreatePromise> createState() => _CreatePromiseState();
}

class _CreatePromiseState extends ConsumerState<CreatePromise>
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
        title: '약속 생성'.text.bold.black.make(),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LinearPercentIndicator(
            padding: EdgeInsets.zero,
            percent: 33 / 100,
            lineHeight: 3,
            backgroundColor: const Color(0xffCACFD8),
            progressColor: AppColors.mainBlue2,
            width: MediaQuery.of(context).size.width,
          ),
          Container(
              margin: const EdgeInsets.all(24),
              alignment: Alignment.topLeft,
              child: '약속명을 입력해 주세요'.text.black.size(16).semiBold.make()),
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
                child: const Text('약속명을 입력해 주세요!!',
                    style: TextStyle(
                        fontFamily: 'Pretendard',
                        fontSize: 14,
                        color: Colors.red)))
        ],
      ),
      bottomSheet: Container(
        width: double.infinity,
        height: 48,
        margin: const EdgeInsets.all(24),
        child: FilledButton(
          style: FilledButton.styleFrom(
              backgroundColor: textController.text.isEmpty
                  ? Colors.grey
                  : AppColors.mainBlue),
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
    );
    // ),
    // );
  }

  @override
  FutureOr<void> afterFirstLayout(BuildContext context) {
    AppKeyboardUtil.show(context, node);
  }
}
