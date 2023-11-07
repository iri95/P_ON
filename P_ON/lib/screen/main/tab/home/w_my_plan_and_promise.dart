import 'package:p_on/common/common.dart';
import 'package:p_on/common/widget/w_list_container.dart';
import 'package:p_on/screen/main/tab/home/vo/vo_bank_account.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'w_custom_text.dart';

class MyPlanAndPromise extends StatelessWidget {
  final PlanData promise;

  const MyPlanAndPromise(this.promise, {super.key});

  @override
  Widget build(BuildContext context) {
    // FIXED: 미정이 아무것도 없으면 true, 미정이 하나라도 있으면 false
    bool hasUndefinedValueInPlan(promise) {
      if (promise.Plantitle == '미정' ||
          promise.PlanDate == '미정' ||
          promise.PlanTime == '미정' ||
          promise.PlanLocation == '미정') {
        return false;
      }
      return true;
    }

    bool isClose = (hasUndefinedValueInPlan(promise));

    // DateTime? planDate;
    // if (promise.PlanDate != "미정") {
    //   planDate = DateTime.parse(promise.PlanDate);
    // }
    // final currentDate = DateTime.now();
    // bool isClose = false;

    // if (planDate != null) {
    //   final diff = currentDate.difference(planDate).inDays;
    //   if (diff.abs() < 3) {
    //     isClose = true;
    //   }
    // }

    // 화면 비율
    final Size size = MediaQuery.of(context).size;

    return Stack(
      children: [
        Center(
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 12),
            width: size.width * 0.9,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.4),
                      spreadRadius: 0,
                      blurRadius: 8,
                      offset: Offset(4, 4))
                ]),
            child: ListContainer(
              padding: const EdgeInsets.fromLTRB(24, 16, 20, 16),
              isDateClose: isClose,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 약속명
                  Container(
                    padding: EdgeInsets.only(bottom: 8),
                    child: Text(
                        promise.Plantitle.length > 11
                            ? '${promise.Plantitle.substring(0, 11)}...'
                            : promise.Plantitle,
                        style: TextStyle(
                            fontFamily: 'Pretendard',
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: isClose ? AppColors.grey50 : Colors.black)),
                  ),
                  Container(
                    padding: EdgeInsets.only(bottom: 8),
                    height: 30,
                    child: Row(children: [
                      CustomText(
                        text: '일시 | ',
                        color: isClose ? AppColors.grey300 : AppColors.grey500,
                        fontWeightValue: FontWeight.w400,
                      ),
                      promise.PlanDate == '미정'
                          ? const CreateVote()
                          : CustomText(
                              text: promise.PlanDate,
                              color: isClose
                                  ? AppColors.grey50
                                  : AppColors.grey700,
                              fontWeightValue: FontWeight.w500,
                            ),
                    ]),
                  ),
                  Container(
                    padding: EdgeInsets.only(bottom: 8),
                    height: 30,
                    child: Row(
                      children: [
                        CustomText(
                          text: '시간 | ',
                          color:
                              isClose ? AppColors.grey300 : AppColors.grey500,
                          fontWeightValue: FontWeight.w400,
                        ),
                        promise.PlanTime == '미정'
                            ? const CreateVote()
                            : CustomText(
                                text: promise.PlanTime,
                                color: isClose
                                    ? AppColors.grey50
                                    : AppColors.grey700,
                                fontWeightValue: FontWeight.w500,
                              ),
                      ],
                    ),
                  ),
                  Container(
                    height: 30,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            CustomText(
                              text: '장소 | ',
                              color: isClose
                                  ? AppColors.grey300
                                  : AppColors.grey500,
                              fontWeightValue: FontWeight.w400,
                            ),
                            promise.PlanLocation == '미정'
                                ? const CreateVote()
                                : CustomText(
                                    text: promise.PlanLocation,
                                    color: isClose
                                        ? AppColors.grey50
                                        : AppColors.grey700,
                                    fontWeightValue: FontWeight.w500,
                                  ),
                          ],
                        ),
                        // 채팅방 이동 버튼
                        Stack(
                          children: [
                            CircleAvatar(
                              radius: 15,
                              backgroundColor: const Color(0xffEFF3F9),
                              child: Transform(
                                alignment: Alignment.center,
                                transform: Matrix4.identity()..scale(-1.0, 1.0),
                                child: IconButton(
                                  icon: const Icon(Icons.chat_bubble, size: 15),
                                  onPressed: () {
                                    // TODO: 버튼 누르면 해당 채팅방으로 이동
                                    print('눌렸');
                                  },
                                  color: isClose
                                      ? Color(0xffFFBA20)
                                      : Color(0xffef8640),
                                ),
                              ),
                            ),
                            if (promise.PlanChat)
                              const Positioned(
                                  right: 5,
                                  top: 5,
                                  child: CircleAvatar(
                                    radius: 4,
                                    backgroundColor: Colors.red,
                                  ))
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // Pinky 아이콘
        Positioned(
            right: size.width * 0.08,
            child: Image(
              image: isClose
                  ? const AssetImage('assets/image/main/핑키3.png')
                  : const AssetImage('assets/image/main/핑키2.png'),
              fit: BoxFit.contain,
              width: 60,
            )),
      ],
    );
    // 받아온 데이터에 미정 포함되면 투표생성 버튼 보여주기
  }
}

class CreateVote extends StatelessWidget {
  const CreateVote({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 5),
      width: 80,
      height: 25,
      child: FilledButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.white),
          foregroundColor: MaterialStateProperty.all(const Color(0xFFFF7F27)),
        ),
        onPressed: () {},
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              '투표',
              style: TextStyle(
                  color: Color(0xFFFF7F27),
                  fontSize: 14,
                  fontWeight: FontWeight.w800),
            ),
            Icon(Icons.arrow_forward_ios, size: 14, color: Color(0xFFFF7F27))
          ],
        ),
      ),
    );
  }
}
