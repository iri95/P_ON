import 'package:p_on/screen/notification/w_notification_item.dart';
import 'package:flutter/material.dart';

import 'd_notification.dart';
import 'notifications_dummy.dart';

import 'package:p_on/common/common.dart';

import 'package:p_on/screen/main/user/fn_kakao.dart';
import 'package:p_on/common/util/dio.dart';
import 'package:dio/dio.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:p_on/screen/main/user/token_state.dart';

import './vo/vo_notification.dart';

class NotificationScreen extends ConsumerStatefulWidget {
  const NotificationScreen({super.key});

  @override
  ConsumerState<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends ConsumerState<NotificationScreen> {
  // TODO: 알림 | 읽은 알림 모두 삭제
  Future<void> deleteIsRead() async {
    print('읽은거 다삭제');

    final loginState = ref.read(loginStateProvider);
    final token = loginState.serverToken;
    final id = loginState.id;

    var headers = {'Authorization': '$token', 'id': '$id'};

    if (token == null) {
      await kakaoLogin(ref);
      await fetchToken(ref);

      final newToken = ref.read(loginStateProvider).serverToken;
      final newId = ref.read(loginStateProvider).id;

      headers['Authorization'] = '$newToken';
      headers['id'] = '$newId';
    }

    final apiService = ApiService();
    try {
      await apiService.sendRequest(method: '', path: '/api/', headers: headers);
    } catch (e) {
      print(e);
    }
  }

  // TODO: 알림 | 모두 읽음 처리
  Future<void> allRead() async {
    print('모두 읽음');
    final loginState = ref.read(loginStateProvider);
    final token = loginState.serverToken;
    final id = loginState.id;

    var headers = {'Authorization': '$token', 'id': '$id'};

    if (token == null) {
      await kakaoLogin(ref);
      await fetchToken(ref);

      final newToken = ref.read(loginStateProvider).serverToken;
      final newId = ref.read(loginStateProvider).id;

      headers['Authorization'] = '$newToken';
      headers['id'] = '$newId';
    }

    final apiService = ApiService();
    try {
      await apiService.sendRequest(method: '', path: '/api/', headers: headers);
    } catch (e) {
      print(e);
    }
  }

  // TODO: 알림 | 누른거 읽음 처리
  Future<void> oneRead(pressId) async {
    print('하나 읽음');
    final loginState = ref.read(loginStateProvider);
    final token = loginState.serverToken;
    final id = loginState.id;

    var headers = {'Authorization': '$token', 'id': '$id'};

    if (token == null) {
      await kakaoLogin(ref);
      await fetchToken(ref);

      final newToken = ref.read(loginStateProvider).serverToken;
      final newId = ref.read(loginStateProvider).id;

      headers['Authorization'] = '$newToken';
      headers['id'] = '$newId';
    }

    final apiService = ApiService();
    var data = {
      // 누른 알림 아이디 전달 key 변동 할 수 있음
      id: pressId
    };
    try {
      await apiService.sendRequest(
          method: '', path: '/api/', headers: headers, data: data);
    } catch (e) {
      print(e);
    }
    // 하나 보여주는건데 일단 지움
    // NotificationDialog([notificationDummies[pressId]]).show();
  }

// TODO: 알림 | 내 알림 가져오기
  Future<List<MyNotification>> fetchNotifications(WidgetRef ref) async {
    print('ㅇㅅㅇ');
    final loginState = ref.read(loginStateProvider);
    final token = loginState.serverToken;
    final id = loginState.id;

    var headers = {'Authorization': '$token', 'id': '$id'};

    if (token == null) {
      await kakaoLogin(ref);
      await fetchToken(ref);

      final newToken = ref.read(loginStateProvider).serverToken;
      final newId = ref.read(loginStateProvider).id;

      headers['Authorization'] = '$newToken';
      headers['id'] = '$newId';
    }

    final apiService = ApiService();
    try {
      await apiService.sendRequest(method: '', path: '/api/', headers: headers);
    } catch (e) {
      print(e);
    }

    // FIXME: 이런 형태로 받아야함 아니면 json 변환
    var dummynotification = <MyNotification>[
      MyNotification('타입1', '내용1', DateTime.now().subtract(27.minutes),
          isRead: false),
      MyNotification('타입2', '내용2', DateTime.now().subtract(27.minutes),
          isRead: false),
      MyNotification('타입3', '내용3', DateTime.now().subtract(27.minutes),
          isRead: false)
    ];
    return dummynotification;
  }

  List<MyNotification> notifications = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  void _fetchData() async {
    final notifications = await fetchNotifications(ref);
    setState(() {
      this.notifications = notifications;
      isLoading = false;
    });
    print(notifications[0].description);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: Container(
            decoration: const BoxDecoration(
                border:
                    Border(bottom: BorderSide(color: Colors.grey, width: 1))),
            child: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              leading: IconButton(
                onPressed: () {
                  Nav.pop(context);
                },
                icon: Icon(Icons.arrow_back_ios, color: Colors.black),
              ),
              title: '알림'.text.black.make(),
              centerTitle: true,
            ),
          ),
        ),
        body: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(top: 10, bottom: 10, right: 10),
              decoration: const BoxDecoration(
                  border: Border(
                      bottom: BorderSide(color: Colors.grey, width: 0.3))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    style: ButtonStyle(
                      overlayColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                          if (states.contains(MaterialState.pressed)) {
                            return Colors.transparent; // 눌렀을 때 배경색 없음
                          }
                          return Colors.transparent; // 기본 배경색 없음
                        },
                      ),
                      foregroundColor:
                          MaterialStateProperty.resolveWith<Color>((states) {
                        if (states.contains(MaterialState.pressed)) {
                          return AppColors.mainBlue; // 눌렀을 때의 색상
                        }
                        return AppColors.grey500; // 기본 색상
                      }),
                      minimumSize: MaterialStateProperty.all(Size.zero),
                      padding: MaterialStateProperty.all(EdgeInsets.zero),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    onPressed: () {
                      deleteIsRead();
                    },
                    child: const Text('읽은 알림 삭제',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        )),
                  ),
                  const SizedBox(width: 10),
                  const Text('|', style: TextStyle(fontSize: 20)),
                  const SizedBox(width: 10),
                  TextButton(
                    style: ButtonStyle(
                      overlayColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                          if (states.contains(MaterialState.pressed)) {
                            return Colors.transparent; // 눌렀을 때 배경색 없음
                          }
                          return Colors.transparent; // 기본 배경색 없음
                        },
                      ),
                      foregroundColor:
                          MaterialStateProperty.resolveWith<Color>((states) {
                        if (states.contains(MaterialState.pressed)) {
                          return AppColors.mainBlue; // 눌렀을 때의 색상
                        }
                        return AppColors.grey500; // 기본 색상
                      }),
                      minimumSize: MaterialStateProperty.all(Size.zero),
                      padding: MaterialStateProperty.all(EdgeInsets.zero),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    onPressed: () {
                      allRead();
                    },
                    child: const Text('모두 읽음',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        )),
                  ),
                  const SizedBox(width: 8),
                ],
              ),
            ),
            Expanded(
                // TODO: 떙겨서 새로고침 넣어줘
                child: isLoading
                    ? Container()
                    : ListView.builder(
                        itemCount: notifications.length,
                        itemBuilder: (context, index) => NotificationItemWidget(
                          notification: notifications[index],
                          onTap: () {
                            // 하나 읽음
                            oneRead(index);
                          },
                        ),
                      ))
          ],
        ));
  }
}
