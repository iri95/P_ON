import 'package:dio/dio.dart';
import 'package:go_router/go_router.dart';
import 'package:p_on/common/common.dart';
import 'package:p_on/screen/main/tab/register/f_register.dart';
import 'package:flutter/material.dart';

import '../promise_room/vo_server_url.dart';

class AllFragment extends StatefulWidget {
  const AllFragment({Key? key}) : super(key: key);

  @override
  State<AllFragment> createState() => _AllFragmentState();
}

class _AllFragmentState extends State<AllFragment> {
  final Dio dio = Dio();

  void getLogIn() async {
    print('$server/oauth2/authorization/kakao');
    final response = await dio.get('$server/oauth2/authorization/kakao');
    print('==================================');
    print('==================================');
    print('==================================');
    print('==================================');
    print('==================================');
    print('==================================');
    print(response);
    print('==================================');
    print('==================================');
    print('==================================');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Flexible(
          flex: 3,
          child: Container(
            color: Colors.white,
          ),
        ),
        Flexible(
          child: Container(
            width: double.infinity,
            margin: EdgeInsets.symmetric(vertical: 25, horizontal: 50),
            decoration: BoxDecoration(
                color: Color(0xffF9E000),
                borderRadius: BorderRadius.circular(10)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  child: Image.asset('assets/image/icon/kakao.png'),
                ),
                TextButton(
                  onPressed: () {
                    final router = GoRouter.of(context);
                    // Nav.push(const RegisterFragment());
                    router.go('/chatroom/5');
                    getLogIn();
                  },
                  child: const Text('카카오로 시작하기',
                      style: TextStyle(color: Color(0xff371C1D))),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
