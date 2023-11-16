import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:p_on/common/constant/app_colors.dart';

enum VoteType { DATE, TIME, LOCATION }

class Vote extends StatefulWidget {
  final VoteType voteType;
  final int roomId;
  final bool isVote;
  final String voteInfo;

  const Vote(
      {super.key,
      required this.roomId,
      required this.voteType,
      required this.isVote,
      required this.voteInfo,
      });

  @override
  State<Vote> createState() => _VoteState();
}

class _VoteState extends State<Vote> {
  final isUpdate = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.isVote ? 120 : 140,
      height: 26,
      child: FilledButton(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(widget.isVote ? AppColors.mainBlue : AppColors.mainBlue3)),
          onPressed: () {
            final router = GoRouter.of(context);
            String voteTypeToString(VoteType voteType) {
              return voteType.toString().split('.').last;
            }

            switch (widget.voteType) {
              case VoteType.DATE:
                print('date');
                print(widget.voteType);
                if (widget.isVote! == true) {
                  router.push('/selecte/vote/${widget.roomId}/${widget.voteInfo}');
                } else {
                  router.push(
                      '/create/vote/${widget.roomId}/${voteTypeToString(widget.voteType)}/$isUpdate/${widget.voteInfo}');
                }
                break;
              case VoteType.TIME:
                print('time');
                print(widget.voteType);
                if (widget.isVote! == true) {
                  router.push('/selecte/vote/${widget.roomId}/${widget.voteInfo}');
                } else {
                  router.push(
                      '/create/vote/${widget.roomId}/${voteTypeToString(widget.voteType)}/$isUpdate/${widget.voteInfo}');
                }
                break;
              case VoteType.LOCATION:
                print('location');
                print(widget.voteType);
                if (widget.isVote! == true) {
                  router.push('/selecte/vote/${widget.roomId}/${widget.voteInfo}');
                } else {
                  router.push(
                      '/create/vote/${widget.roomId}/${voteTypeToString(widget.voteType)}/$isUpdate/${widget.voteInfo}');
                }
                break;
            }
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              widget.isVote!
                  ? const Text('투표하기',
                      style:
                          TextStyle(fontSize: 18, color: AppColors.background))
                  : const Text('투표만들기',
                      style:
                          TextStyle(fontSize: 18, color: AppColors.background)),
              const Icon(
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
