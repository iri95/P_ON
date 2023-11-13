import 'package:after_layout/after_layout.dart';
import 'package:day_night_time_picker/day_night_time_picker.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:p_on/common/util/dio.dart';
import 'package:p_on/screen/main/tab/promise_room/f_search_naver.dart';
import 'package:p_on/screen/main/tab/promise_room/vo_naver_headers.dart';
import 'package:p_on/screen/main/tab/promise_room/vo_server_url.dart';
import 'package:p_on/screen/main/user/fn_kakao.dart';
import 'package:p_on/screen/main/user/token_state.dart';
import '../../../../common/common.dart';
import '../../../../common/util/app_keyboard_util.dart';
import './dto_schedule.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateSchedule extends ConsumerStatefulWidget {
  const CreateSchedule({super.key});

  @override
  ConsumerState<CreateSchedule> createState() => _CreateScheduleState();
}

class _CreateScheduleState extends ConsumerState<CreateSchedule>
    with AfterLayoutMixin {
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

  Future<void> _selectStartDate() async {
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
    if (picked != null) {
      startDateController.text =
          DateFormat('yyyy-MM-dd (E)', 'ko_kr').format(picked);
      ref.read(scheduleProvider.notifier).setScheduleStartDate(picked);
    }
  }

  Future<void> _selectTime() async {
    TimeOfDay t = TimeOfDay.now();
    Navigator.of(context).push(showPicker(
        context: context,
        value: Time(hour: t.hour, minute: t.minute),
        onChange: (TimeOfDay time) {
          final period = time.period == DayPeriod.am ? '오전' : '오후';
          startTimeController.text =
              '$period ${time.hourOfPeriod.toString().padLeft(2, '0')}시 ${time.minute.toString().padLeft(2, '0')}분';
          ref
              .read(scheduleProvider.notifier)
              .setScheduleStartTime(startTimeController.text);
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

  bool get isFilled =>
      startDateController.text.isNotEmpty &&
      startTimeController.text.isNotEmpty &&
      placeController.text.isNotEmpty;

  @override
  void initState() {
    super.initState();
    titleController.addListener(updateState);
    contentController.addListener(updateState);
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
  }

  void updateState() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final schedule = ref.watch(scheduleProvider);

    return Scaffold(
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
                    color: Colors.grey,
                  )),
              child: TextField(
                focusNode: titleNode,
                controller: titleController,
                decoration: const InputDecoration(
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none),
              ),
            ),
            // Row(
            //   children: [
            //     Column(
            //       children: [
            //         _buildTextField('날짜', startDateController, startDateNode, startTimeNode),
            //         _buildTextField('시간', startTimeController, startTimeNode, endDateNode),
            //       ],
            //     ),
            //     Column(
            //       children: [
            //         _buildTextField('날짜', endDateController, endDateNode, endTimeNode),
            //         _buildTextField('시간', endTimeController, endTimeNode, placeNode),
            //       ],
            //     ),
            //   ],
            // ),
            _buildTextField(
              '날짜',
              startDateController,
              startDateNode,
              startTimeNode,
              isAllDay: schedule.schedule_all_time ?? false,
              onToggle: (bool value) {
                print("토글 상태: $value"); // 현재 토글 상태를 출력합니다.
                ref.read(scheduleProvider.notifier).setScheduleAllTime(value);
              },
            ),
            _buildTextField('장소', placeController, placeNode, contentNode),
            _buildTextField('메모', contentController, contentNode, null),
          ],
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
                      .read(scheduleProvider.notifier)
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

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    FocusNode node,
    FocusNode? nextNode, {
    bool? isAllDay,
    Function(bool)? onToggle,
  }) {
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
              if (label == '날짜' && isAllDay != null && onToggle != null)
                Row(
                  children: [
                    Text('하루 종일'),
                    Switch(
                      value: isAllDay,
                      onChanged: onToggle,
                    ),
                  ],
                ),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 24),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          width: double.infinity,
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
            decoration: const InputDecoration(
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none),
            onTap: () async {
              if (label == '날짜') await _selectStartDate();
              if (label == '시간') await _selectTime();
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
      "content": schedule.schedule_content ?? "",
      "startDate": schedule.schedule_start_date != null
          ? schedule.schedule_start_date.toString()
          : "미정",
      "endDate": schedule.schedule_end_date != null
          ? schedule.schedule_end_date.toString()
          : "미정",
      "place": schedule.schedule_location ?? "미정"
    };

    try {
      // method: '대문자', path: 'end-point', headers:headers고정, data: {POST data 있을 때 key:valure}'
      Response response = await apiService.sendRequest(
          method: 'POST',
          path: '$server/api/calendar/schedule',
          headers: headers,
          data: data);

      print(response);

      final router = GoRouter.of(context);
      router.go('/main/plan');

      ref.read(scheduleProvider.notifier).reset();
    } catch (e) {
      print(e);
    }
  }

  @override
  FutureOr<void> afterFirstLayout(BuildContext context) {
    AppKeyboardUtil.show(context, titleNode);
  }
}
