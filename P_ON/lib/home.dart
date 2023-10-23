import 'package:flutter/material.dart';

class homeScreen extends StatefulWidget {
  const homeScreen({super.key});

  @override
  State<homeScreen> createState() => _homeScreenState();
}

class _homeScreenState extends State<homeScreen> {
  late int index;

  @override
  void initState() {
    super.initState();
    index = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Image.asset('assets/images/핑키1.png',
                  fit: BoxFit.contain, height: 32),
            ),
            Text('P:ON',
                style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                    color: Color(0xffff7f27))),
          ],
        ),
        actions: [
          IconButton(
              onPressed: () {},
              icon: Icon(Icons.notifications_none_outlined, size: 32)),
          IconButton(
              onPressed: () {}, icon: Icon(Icons.settings_outlined, size: 32))
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1.0),
          child: Container(
            color: Colors.grey,
            height: 1.0,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('수완님',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.w500)),
                  Text('다가오는 약속이 있어요!',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.w500)),
                ],
              ),
            ),
            PlanList()
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton.large(
        onPressed: () {},
        child: TextButton(
          onPressed: () {},
          child: Image.asset('assets/images/핑키1.png', fit: BoxFit.contain),
        )

      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(onPressed: () {}, icon: Icon(Icons.home_outlined)),
                Text('홈')
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(onPressed: () {}, icon: Icon(Icons.home_outlined)),
                Text('홈')
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(onPressed: () {}, icon: Icon(Icons.home_outlined)),
                Text('홈')
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(onPressed: () {}, icon: Icon(Icons.home_outlined)),
                Text('홈')
              ],
            ),
          ],
        ),
        shape: CircularNotchedRectangle(),
        color: Colors.white,
      ),
    );
  }
}

class PlanData {
  final String planTitle;
  final String planDate;
  final String planTime;
  final String planLocation;

  PlanData(
      {required this.planTitle,
      required this.planDate,
      required this.planTime,
      required this.planLocation});
}

final PlanListData = [
  PlanData(
      planTitle: '중간 평가',
      planDate: '2023년 10월 20일(금)',
      planTime: '미정',
      planLocation: '부산 SSAFY'),
  PlanData(
      planTitle: 'UCC 촬영', planDate: '미정', planTime: '미정', planLocation: '미정'),
  PlanData(
      planTitle: '팀 회식',
      planDate: '미정',
      planTime: '미정',
      planLocation: '하단 팔각도'),
  PlanData(
      planTitle: '팀 회식',
      planDate: '미정',
      planTime: '미정',
      planLocation: '하단 팔각도'),
  PlanData(
      planTitle: '프로젝트 완성',
      planDate: '미정',
      planTime: '미정',
      planLocation: '하단 팔각도'),
];

class PlanList extends StatefulWidget {
  const PlanList({super.key});

  @override
  State<PlanList> createState() => _PlanListState();
}

class _PlanListState extends State<PlanList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: PlanListData.length,
      itemBuilder: (context, index) => PlanItem(planData: PlanListData[index]),
    );
  }
}

class PlanItem extends StatefulWidget {
  final PlanData planData;

  const PlanItem({required this.planData, super.key});

  @override
  State<PlanItem> createState() => _PlanItemState();
}

class _PlanItemState extends State<PlanItem> {
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Container(
        width: double.infinity,
        height: 150,
        margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
        decoration: BoxDecoration(
            color: Color(0xffE4E8EF), borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: (Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.planData.planTitle,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      height: 1.8)),
              Text('일시 | ${widget.planData.planDate}',
                  style: TextStyle(color: Colors.black, fontSize: 18)),
              Text('시간 | ${widget.planData.planTime}',
                  style: TextStyle(color: Colors.black, fontSize: 18)),
              Text('장소 | ${widget.planData.planLocation}',
                  style: TextStyle(color: Colors.black, fontSize: 18))
            ],
          )),
        ),
      ),
      Positioned(
          right: 40,
          child: Image(
            image: AssetImage('assets/images/핑키2.png'),
            fit: BoxFit.contain,
            width: 48,
          )),
    ]);
  }
}
