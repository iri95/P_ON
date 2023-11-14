import 'package:after_layout/after_layout.dart';
import 'package:day_night_time_picker/day_night_time_picker.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:p_on/common/util/dio.dart';
import 'package:p_on/screen/main/tab/promise_room/dto_promise.dart';
import 'package:p_on/screen/main/tab/promise_room/f_search_naver.dart';
import 'package:p_on/screen/main/tab/promise_room/vo_naver_headers.dart';
import 'package:p_on/screen/main/tab/promise_room/vo_server_url.dart';
import 'package:p_on/screen/main/user/fn_kakao.dart';
import 'package:p_on/screen/main/user/token_state.dart';
import '../../../../common/common.dart';
import '../../../../common/util/app_keyboard_util.dart';
import './dto_schedule.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateSchedule extends ConsumerStatefulWidget {
  const CreateSchedule({super.key});

  @override
  ConsumerState<CreateSchedule> createState() => _CreateScheduleState();
}

class _CreateScheduleState extends ConsumerState<CreateSchedule>
    with AfterLayoutMixin {
  late ScrollController _scrollController; // 스크롤 컨트롤러 추가

  final FocusNode titleNode = FocusNode();
  final FocusNode contentNode = FocusNode();
  final FocusNode startDateNode = FocusNode();
  final FocusNode endDateNode = FocusNode();
  final FocusNode startTimeNode = FocusNode();
  final FocusNode endTimeNode = FocusNode();
  final FocusNode placeNode = FocusNode();

  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();
  final TextEditingController startTimeController = TextEditingController();
  final TextEditingController endTimeController = TextEditingController();
  final TextEditingController placeController = TextEditingController();

  Future<void> _selectDate(label) async {
    FocusScope.of(context).requestFocus(FocusNode());
    DateTime? picked = await showDatePicker(
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.light(
                primary: AppColors.mainBlue2,
                onPrimary: Colors.white,
                onSurface: Colors.black,
              ),
              textButtonTheme: TextButtonThemeData(
                style:
                    TextButton.styleFrom(foregroundColor: AppColors.mainBlue),
              )),
          child: child!,
        );
      },
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    /// TODO : 시작일이 종료일보다 늦으면 종료일도 시작일로, 똑같이 종료일이 시작일보다 빠르면 바꿈 로직
    if (picked != null) {
      if (label == '시작') {
        // 종료일이 시작일보다 이전인 경우, 종료일도 시작일로 설정합니다.
        DateTime? endDate = ref.read(scheduleProvider).schedule_end_date;
        if (endDate != null && picked.isAfter(endDate)) {
          endDateController.text = DateFormat('MM월 dd일 (E)', 'ko_kr').format(picked);
          ref.read(scheduleProvider.notifier).setScheduleEndDate(picked);
        }
        startDateController.text = DateFormat('MM월 dd일 (E)', 'ko_kr').format(picked);
        ref.read(scheduleProvider.notifier).setScheduleStartDate(picked);
      } else if (label == '종료') {
        // 시작일이 종료일보다 이후인 경우, 시작일도 종료일로 설정합니다.
        DateTime? startDate = ref.read(scheduleProvider).schedule_start_date;
        if (startDate != null && picked.isBefore(startDate)) {
          startDateController.text = DateFormat('MM월 dd일 (E)', 'ko_kr').format(picked);
          ref.read(scheduleProvider.notifier).setScheduleStartDate(picked);
        }
        endDateController.text = DateFormat('MM월 dd일 (E)', 'ko_kr').format(picked);
        ref.read(scheduleProvider.notifier).setScheduleEndDate(picked);
      }
    }
  }

  /// TODO: 시간도 날짜랑 똑같은 로직 적용해야함
  Future<void> _selectTime(label) async {
    TimeOfDay t = TimeOfDay.now();
    Navigator.of(context).push(showPicker(
        context: context,
        value: Time(hour: t.hour, minute: t.minute),
        onChange: (TimeOfDay selectedTime) {
          final period = selectedTime.period == DayPeriod.am ? '오전' : '오후';
          final formattedTime = '${selectedTime.hour.toString().padLeft(2, '0')}:${selectedTime.minute.toString().padLeft(2, '0')}';
          final formattedDisplayTime = '$period ${selectedTime.hourOfPeriod.toString().padLeft(2, '0')}:${selectedTime.minute.toString().padLeft(2, '0')}';

          // 공통 로직을 처리하는 함수
          void updateTime(String timeLabel, TextEditingController controller, String time) {
            controller.text = formattedDisplayTime;
            if (timeLabel == '시작') {
              ref.read(scheduleProvider.notifier).setScheduleStartTime(time);
            } else {
              ref.read(scheduleProvider.notifier).setScheduleEndTime(time);
            }
          }

          DateTime? startDate = ref.read(scheduleProvider).schedule_start_date;
          DateTime? endDate = ref.read(scheduleProvider).schedule_end_date;
          String? startTime = ref.read(scheduleProvider).schedule_start_time;
          String? endTime = ref.read(scheduleProvider).schedule_end_time;

          // 날짜가 같은 경우에만 시간을 비교
          if (startDate?.isAtSameMomentAs(endDate!) ?? false) {
            if (label == '시작' && compareTime(formattedTime, endTime)) {
              updateTime('종료', endTimeController, formattedTime);
            } else if (label == '종료' && compareTime(startTime, formattedTime)) {
              updateTime('시작', startTimeController, formattedTime);
            }
          }

          // 선택한 시간을 업데이트
          updateTime(label, label == '시작' ? startTimeController : endTimeController, formattedTime);
        },
        minuteInterval: TimePickerInterval.FIVE,
        iosStylePicker: true,
        okText: '확인',
        okStyle: const TextStyle(color: AppColors.mainBlue2),
        cancelText: '취소',
        cancelStyle: const TextStyle(color: AppColors.mainBlue2),
        hourLabel: '시',
        minuteLabel: '분',
        accentColor: AppColors.mainBlue2));
  }

  void _searchPlace() async {
    final result = await Nav.push(const SearchNaver());
    if (result != null) {
      placeController.text = result
          .replaceAll(RegExp(r'<[^>]*>'), '')
          .replaceAll('&amp;', '&')
          .replaceAll('&lt;', '<')
          .replaceAll('&gt;', '>')
          .replaceAll('&quot;', '"')
          .replaceAll('&#39;', "'");
    }
  }

  // 시간을 비교하는 함수
  bool compareTime(String? time1, String? time2) {
    if (time1 == null || time2 == null) return false;
    return int.parse(time1.replaceAll(':', '')) > int.parse(time2.replaceAll(':', ''));
  }

  bool get isFilled =>
      startDateController.text.isNotEmpty &&
      startTimeController.text.isNotEmpty &&
      placeController.text.isNotEmpty;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController(); // 초기화

    titleController.addListener((){
      ref.read(scheduleProvider.notifier).setScheduleTitle(titleController.text);
    });
    contentController.addListener(() {
      ref.read(scheduleProvider.notifier).setScheduleContent(contentController.text);
    });
    startDateController.addListener(updateState);
    endDateController.addListener(updateState);
    startTimeController.addListener(updateState);
    endTimeController.addListener(updateState);
    titleNode.addListener(updateState);
    contentNode.addListener(updateState);
    startDateNode.addListener(updateState);
    endDateNode.addListener(updateState);
    startTimeNode.addListener(updateState);
    endTimeNode.addListener(updateState);
    placeController.addListener(updateState);
    placeNode.addListener(updateState);

    TimeOfDay t = TimeOfDay.now();
    String formattedTime = '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // ref를 사용하여 데이터를 설정
      ref.read(scheduleProvider.notifier).setScheduleStartTime(formattedTime);
      ref.read(scheduleProvider.notifier).setScheduleEndTime(formattedTime);
    });


  }

  void updateState() {
    if (contentNode.hasFocus) {
      // 300ms의 딜레이를 추가하여 키보드가 완전히 나타난 후 스크롤을 시작
      Future.delayed(Duration(milliseconds: 500), () {
        _scrollController.animateTo(
          200.0, // 필요한 경우 이 값을 조정하세요
          duration: Duration(milliseconds: 50),
          curve: Curves.easeOut,
        );
      });
    }
    setState(() {});
  }

  @override
  void dispose() {
    titleController.removeListener(() {
      ref.read(scheduleProvider.notifier).setScheduleTitle(titleController.text);
    });
    contentController.removeListener(() {
      ref.read(scheduleProvider.notifier).setScheduleContent(contentController.text);
    });
    startDateController.removeListener(updateState);
    endDateController.removeListener(updateState);
    startTimeController.removeListener(updateState);
    endTimeController.removeListener(updateState);
    titleNode.removeListener(updateState);
    contentNode.removeListener(updateState);
    startDateNode.removeListener(updateState);
    endDateNode.removeListener(updateState);
    startTimeNode.removeListener(updateState);
    endTimeNode.removeListener(updateState);
    placeController.removeListener(updateState);
    placeNode.removeListener(updateState);

    titleController.dispose();
    contentController.dispose();
    startDateController.dispose();
    endDateController.dispose();
    startTimeController.dispose();
    endTimeController.dispose();
    titleNode.dispose();
    contentNode.dispose();
    startDateNode.dispose();
    endDateNode.dispose();
    startTimeNode.dispose();
    endTimeNode.dispose();
    placeController.dispose();
    placeNode.dispose();

    _scrollController.dispose(); // 스크롤 컨트롤러 해제

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final schedule = ref.watch(scheduleProvider);

    return Scaffold(
      resizeToAvoidBottomInset: true, // 키보드가 나타날 때 크기 조절 활성화
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Nav.pop(context);
            ref.read(scheduleProvider.notifier).reset();
          },
        ),
        title: '새 일정'.text.bold.black.make(),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Padding(
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Column(
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
                      color: titleController.text.isEmpty && !titleNode.hasFocus
                          ? Colors.grey
                          : AppColors.mainBlue2,
                    )),
                child: TextField(
                  focusNode: titleNode,
                  controller: titleController,
                  decoration: const InputDecoration(
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                alignment: Alignment.topLeft,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('날짜',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w600)),
                      Row(
                        children: [
                          Text('하루 종일'),
                          Switch(
                            value: schedule.schedule_all_time ?? false,
                            onChanged: (bool value) {
                              print("토글 상태: $value"); // 현재 토글 상태를 출력합니다.
                              ref.read(scheduleProvider.notifier).setScheduleAllTime(value);
                            },
                          ),
                        ],
                      ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        _buildDateField('시작', startDateController, startDateNode, startTimeNode),
                        AnimatedCrossFade(
                          duration: const Duration(milliseconds: 300),
                          firstChild: Container(), // 첫 번째 자식 (표시할 것이 없을 때)
                          secondChild: _buildTimeField('시작', startTimeController, startTimeNode, endDateNode), // 두 번째 자식
                          crossFadeState: (schedule.schedule_all_time ?? false) ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                        ),
                      ],
                    ),
                    const Icon(Icons.arrow_forward, size: 24.0, color: Colors.grey),
                    Column(
                      children: [
                        _buildDateField('종료', endDateController, endDateNode, endTimeNode),
                        AnimatedCrossFade(
                          duration: const Duration(milliseconds: 300),
                          firstChild: Container(), // 첫 번째 자식 (표시할 것이 없을 때)
                          secondChild: _buildTimeField('종료', endTimeController, endTimeNode, placeNode), // 두 번째 자식
                          crossFadeState: (schedule.schedule_all_time ?? false) ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              _buildTextField('장소', placeController, placeNode, contentNode),
              _buildTextField('메모', contentController, contentNode, null),
              // 스크롤 안 올라가는 문제 해결 혹시 안되면 밑의 주석 해제해서, 강제로 스크롤 가능하게
              // Container(height: 400, color: Colors.transparent),
            ],
          ),
        ),
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
                  minimumSize: const Size(double.infinity, 48), // 버튼의 최소 크기 설정
                ),
                onPressed: () {
                  // 현재 화면 닫기
                  Navigator.pop(context);
                  ref.read(scheduleProvider.notifier).reset();
                },
                child: const Text('취소'),
              ),
            ),
            const SizedBox(width: 16), // 버튼 사이 간격
            Expanded(
              child: FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: titleController.text.isEmpty
                      ? Colors.grey
                      : AppColors.mainBlue,
                  minimumSize: const Size(double.infinity, 48), // 버튼의 최소 크기 설정
                ),
                onPressed: () async {
                  ref
                      .watch(scheduleProvider.notifier)
                      .setScheduleTitle(titleController.text);
                  await PostCreateSchedule(schedule);
                },
                child: const Text('저장'),
              ),
            ),
          ],
        ),
      ),
    );
    // ),
    // );
  }

  Widget _buildDateField(
      String label,
      TextEditingController controller,
      FocusNode node,
      FocusNode? nextNode,
      ){
    double screenAppThirdWidth = MediaQuery.of(context).size.width / 3;

    DateTime? date = (label == '시작')
        ? ref.read(scheduleProvider).schedule_start_date
        : (label == '종료')
        ? ref.read(scheduleProvider).schedule_end_date
        : null;

    // 날짜가 있으면 controller에 설정합니다. 없으면 오늘 날짜
    if (date != null) {
      controller.text = DateFormat('MM월 dd일 (E)', 'ko_kr').format(date);
    } else {
      controller.text = DateFormat('MM월 dd일 (E)', 'ko_kr').format(DateTime.now());
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      width: screenAppThirdWidth,
      child: TextField(
        focusNode: node,
        controller: controller,
        decoration: const InputDecoration(
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
        ),
        onTap: () async {
          await _selectDate(label);
        },
      ),
    );
  }

  Widget _buildTimeField(
      String label,
      TextEditingController controller,
      FocusNode node,
      FocusNode? nextNode,
      ){
    double screenAppThirdWidth = MediaQuery.of(context).size.width / 3;

    String? time = (label == '시작')
        ? ref.read(scheduleProvider).schedule_start_time
        : (label == '종료')
        ? ref.read(scheduleProvider).schedule_end_time
        : null;

    String formatTime(String timeString) {
      // 'HH:mm' 형식의 문자열을 TimeOfDay로 변환
      List<String> parts = timeString.split(':');
      int hour = int.parse(parts[0]);
      int minute = int.parse(parts[1]);

      TimeOfDay timeOfDay = TimeOfDay(hour: hour, minute: minute);

      // 오전/오후와 시간을 계산
      String period = timeOfDay.period == DayPeriod.am ? '오전' : '오후';
      int hourOfPeriod = timeOfDay.hourOfPeriod;

      // 결과 문자열을 반환
      return '$period ${hourOfPeriod.toString().padLeft(2, '0')}:${timeOfDay.minute.toString().padLeft(2, '0')}';
    }

    // 시간이 있으면 controller에 설정합니다. 없으면 지금 시간
    if (time != null) {
      controller.text = formatTime(time);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      width: screenAppThirdWidth,
      child: TextField(
        textAlign: TextAlign.center,
        focusNode: node,
        controller: controller,
        decoration: const InputDecoration(
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
        ),
        onTap: () async {
          await _selectTime(label);
        },
      ),
    );
  }


  Widget _buildTextField(
    String label,
    TextEditingController controller,
    FocusNode node,
    FocusNode? nextNode, {
    bool? isAllDay,
    Function(bool)? onToggle,
  }) {
    double screenAppWidth = MediaQuery.of(context).size.width;

    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
          alignment: Alignment.topLeft,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label,
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w600)),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 24),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          width: screenAppWidth,
          height: label == '메모' ? 150 : 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: controller.text.isEmpty && !node.hasFocus
                  ? Colors.grey
                  : AppColors.mainBlue2,
            ),
          ),
          child: TextField(
            showCursor: label == '장소',
            focusNode: node,
            controller: controller,
            keyboardType: label == '메모' ? TextInputType.multiline : TextInputType.text,
            maxLines: label == '메모' ? null : 1, // '메모'일 때 여러 줄 입력 가능
            decoration: const InputDecoration(
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none),
            onTap: () async {
              if (label == '장소') _searchPlace();
            },
          ),
        ),
      ],
    );
  }

  void SearchPlace(String text) async {
    final dio = Dio();
    final response = await dio.get(
      'https://openapi.naver.com/v1/search/local.json?',
      queryParameters: {
        'query': text,
      },
      options: Options(
        headers: {
          'X-Naver-Client-Id': Client_ID,
          'X-Naver-Client-Secret': Client_Secret,
        },
      ),
    );
    print(text);
    print("=======================");
    print("=======================");
    print("=======================");
    print("=======================");
    print(response);
    print("=======================");
    print("=======================");
    print("=======================");
    print("=======================");
  }

  Future<void> PostCreateSchedule(Schedule schedule) async {
    // 현재 저장된 서버 토큰을 가져옵니다.
    final loginState = ref.read(loginStateProvider);
    final token = loginState.serverToken;
    final id = loginState.id;
    var headers = {'Authorization': '$token', 'id': '$id'};
    final apiService = ApiService();

    // 서버 토큰이 없으면
    if (token == null) {
      await kakaoLogin(ref);
      await fetchToken(ref);

      // 토큰을 다시 읽습니다.
      final newToken = ref.read(loginStateProvider).serverToken;
      final newId = ref.read(loginStateProvider).id;

      headers['Authorization'] = '$newToken';
      headers['id'] = '$newId';
    }

    var data = {
      "title": schedule.schedule_title ?? "내 일정",
      "content": schedule.schedule_content ?? "미정",
      "startDate": schedule.schedule_start_date != null
          ? DateFormat('yyyy-MM-dd').format(schedule.schedule_start_date!) +
          (schedule.schedule_all_time == true ? ' 00:00:00' : ' ${schedule.schedule_start_time ?? ''}:00')
          : "1995-10-11 00:00:00",
      "endDate": schedule.schedule_end_date != null
          ? DateFormat('yyyy-MM-dd').format(schedule.schedule_end_date!) +
          (schedule.schedule_all_time == true ? ' 23:59:59' : ' ${schedule.schedule_end_time ?? ''}:00')
          : "1997-01-29 23:59:59",
      "place": schedule.schedule_location ?? "미정"
    };
    print('===========');
    print('===========');
    print('===========');
    print(data);
    print('===========');
    print('===========');
    try {
      // method: '대문자', path: 'end-point', headers:headers고정, data: {POST data 있을 때 key:valure}'
      Response response = await apiService.sendRequest(
          method: 'POST',
          path: '$server/api/calendar/schedule',
          headers: headers,
          data: data);

      print(response);


      ref.read(scheduleProvider.notifier).reset();
      ref.read(promiseProvider.notifier).reset();
      Nav.pop(context);
    } catch (e) {
      print(e);
    }
  }

  @override
  FutureOr<void> afterFirstLayout(BuildContext context) {
    AppKeyboardUtil.show(context, titleNode);
  }
}
