import 'package:fast_app_base/common/common.dart';
import 'package:fast_app_base/screen/main/tab/register/f_register.dart';
import 'package:flutter/material.dart';

class AllFragment extends StatefulWidget {
  const AllFragment({Key? key}) : super(key: key);

  @override
  State<AllFragment> createState() => _AllFragmentState();
}

class _AllFragmentState extends State<AllFragment> {
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
                    Nav.push(const RegisterFragment());
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
