import 'package:fast_app_base/common/common.dart';
import 'package:fast_app_base/common/widget/w_list_container.dart';
import 'package:fast_app_base/common/widget/w_rounded_container.dart';
import 'package:fast_app_base/screen/dialog/d_message.dart';
import 'package:fast_app_base/screen/main/tab/home/w_bank_account.dart';
import 'package:fast_app_base/screen/main/tab/home/w_p_on_app_bar.dart';
import 'package:flutter/material.dart';

import '../../../../common/widget/w_big_button.dart';
import '../../../dialog/d_color_bottom.dart';
import '../../../dialog/d_confirm.dart';
import '../../s_main.dart';
import 'bank_accounts_dummy.dart';
import 'package:dio/dio.dart';

class HomeFragment extends StatelessWidget {
  const HomeFragment({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Stack(
        children: [
          RefreshIndicator(
            color: Color(0xff3F48CC),
            backgroundColor: Color(0xffFFBA20),
            edgeOffset: PONAppBar.appBarHeight,
            onRefresh: () async {
              await sleepAsync(500.ms);
            },
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(
                top: PONAppBar.appBarHeight + 10,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RoundedContainer(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      '수완님'.text.semiBold.size(24).color(Colors.black).make(),
                      '다가오는 약속이 있어요!'
                          .text
                          .semiBold
                          .size(24)
                          .color(Colors.black)
                          .make(),
                    ], // 로그인한 유저 이름으로 변경하기
                  )),
                  RoundedContainer(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ...bankAccounts.map((e) => BankAccountWidget(e)).toList()
                    ],
                  )),
                  height70
                ],
              ),
            ),
          ),
          const PONAppBar(),
          Positioned(
              bottom: 40,
              right: 10,
              child: FloatingActionButton(
                backgroundColor: Colors.white,
                elevation: 4,
                onPressed: fetchData,
                child: Icon(
                  Icons.add,
                  color: context.appColors.navButton,
                ),
              ))
        ],
      ),
    );
  }

  void showSnackbar(BuildContext context) {
    context.showSnackbar('snackbar 입니다.',
        extraButton: Tap(
          onTap: () {
            context.showErrorSnackbar('error');
          },
          child: '에러 보여주기 버튼'
              .text
              .white
              .size(13)
              .make()
              .centered()
              .pSymmetric(h: 10, v: 5),
        ));
  }

  Future<void> showConfirmDialog(BuildContext context) async {
    final confirmDialogResult = await ConfirmDialog(
      '오늘 기분이 좋나요?',
      buttonText: "네",
      cancelButtonText: "아니오",
    ).show();
    debugPrint(confirmDialogResult?.isSuccess.toString());

    confirmDialogResult?.runIfSuccess((data) {
      ColorBottomSheet(
        '❤️',
        context: context,
        backgroundColor: Colors.yellow.shade200,
      ).show();
    });

    confirmDialogResult?.runIfFailure((data) {
      ColorBottomSheet(
        '❤️힘내여',
        backgroundColor: Colors.yellow.shade300,
        textColor: Colors.redAccent,
      ).show();
    });
  }

  Future<void> showMessageDialog() async {
    final result = await MessageDialog("안녕하세요").show();
    debugPrint(result.toString());
  }

  void openDrawer(BuildContext context) {
    Scaffold.of(context).openDrawer();
  }

  Future<void> fetchData() async {
    Dio dio = Dio();

    try {
      final response = await dio.get('http://k9e102.p.ssafy.io/api/promise/test');
      print('Response Data: ${response}');
    } catch (error) {
      print(error);
    }
  }
}
