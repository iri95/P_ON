import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:p_on/common/constant/app_colors.dart';

enum VoteType {
  Date,
  Time,
  Location
}

class Vote extends StatefulWidget {
  final VoteType voteType;
  final String roomId;
  // final bool isVote;
  const Vote({super.key, required this.roomId, required this.voteType});

  @override
  State<Vote> createState() => _VoteState();
}

class _VoteState extends State<Vote> {
  final isUpdate = false;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 90,
      height: 26,
      child: FilledButton(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(AppColors.mainBlue3)),
          onPressed: () {
            final router = GoRouter.of(context);
            String voteTypeToString(VoteType voteType) {
              return voteType.toString().split('.').last;
            }
            switch (widget.voteType) {
              case VoteType.Date:
                print('date');
                print(widget.voteType);
                router.go('/create/vote/${widget.roomId}/${voteTypeToString(widget.voteType)}/$isUpdate');
                break;
              case VoteType.Time:
                print('time');
                print(widget.voteType);
                router.go('/create/vote/${widget.roomId}/${voteTypeToString(widget.voteType)}/$isUpdate');
                break;
              case VoteType.Location:
                print('location');
                print(widget.voteType);
                // router.go('/create/vote/${widget.roomId}/${voteTypeToString(widget.voteType)}/$isUpdate');
                router.go('/selecte/vote/${widget.roomId}');
                break;
            }
          },
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text('투표',
                  style: TextStyle(fontSize: 18, color: AppColors.background)),
              Icon(
                Icons.arrow_forward_ios,
                size: 18,
                color: AppColors.background,
              )
            ],
          )),
    );
  }
}

class ChatHeadText extends StatelessWidget {
  final String text;
  final Color color;

  const ChatHeadText({super.key, required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
          fontFamily: 'Pretendard',
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: color),
    );
  }
}