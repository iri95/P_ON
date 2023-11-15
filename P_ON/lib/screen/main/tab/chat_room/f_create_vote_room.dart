import 'package:day_night_time_picker/day_night_time_picker.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:location/location.dart';
import 'package:p_on/common/common.dart';
import 'package:p_on/common/util/dio.dart';
import 'package:p_on/screen/main/tab/chat_room/dto_vote.dart';
import '../promise_room/vo_naver_headers.dart';
import '../promise_room/vo_server_url.dart';
import 'w_header_text_vote.dart';
import 'package:p_on/screen/main/user/fn_kakao.dart';
import 'package:p_on/screen/main/user/token_state.dart';

class CreateVoteRoom extends ConsumerStatefulWidget {
  final String id;
  final VoteType voteType;
  final bool isUpdate;
  final String voteInfo;

  const CreateVoteRoom({
    super.key,
    required this.id,
    required this.voteType,
    required this.isUpdate,
    required this.voteInfo,
  });

  @override
  ConsumerState<CreateVoteRoom> createState() => _CreateVoteRoomState();
}

class _CreateVoteRoomState extends ConsumerState<CreateVoteRoom> {
  VoteType? selectedVoteType;
  bool isEndTimeSet = false;
  bool isMultipleChoice = false;
  bool isAnonymous = false;
  final TextEditingController _endDateController = TextEditingController();
  final TextEditingController _endTimeController = TextEditingController();
  double? _lat;
  double? _lng;
  List<NMarker> _markers = [];

  List<NMarker> get markers => _markers;
  late Future<LocationData> locationData;
  late NaverMapController _mapController;
  Future<void>? futureGetVoteDate;

  void addMarker(double lat, double lng, String id, [int? index]) {
    final marker = NMarker(id: id, position: NLatLng(lat, lng));
    final onMarkerInfoWindow = NInfoWindow.onMarker(id: id, text: id);

    if (index != null && index < _markers.length) {
      _mapController.clearOverlays();
      _markers[index] = marker;
    } else {
      _markers.add(marker);
    }

    for (var marker in _markers) {
      _mapController.addOverlay(marker);
      marker.openInfoWindow(onMarkerInfoWindow);
    }
    _mapController.updateCamera(
        NCameraUpdate.withParams(target: marker.position, zoom: 12));
  }

  Future<LocationData> _getCurrentLocation() async {
    final location = Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return Future.error('Location service not enabled');
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return Future.error('Location permission not granted');
      }
    }
    _locationData = await location.getLocation();

    _lat = _locationData.latitude;
    _lng = _locationData.longitude;

    return _locationData;
  }

  Map<VoteType, List<String>> voteItems = {
    VoteType.DATE: ['', ''],
    VoteType.TIME: ['', ''],
    VoteType.LOCATION: ['', '']
  };
  Map<VoteType, List<TextEditingController>> textEditingControllers = {
    VoteType.DATE: [TextEditingController(), TextEditingController()],
    VoteType.TIME: [TextEditingController(), TextEditingController()],
    VoteType.LOCATION: [TextEditingController(), TextEditingController()]
  };

  Future<void> postVote(vote, voteInfo) async {
    // 현재 저장된 서버 토큰을 가져옵니다.
    final loginState = ref.read(loginStateProvider);
    final token = loginState.serverToken;
    final id = loginState.id;

    var headers = {'Authorization': '$token', 'id': '$id'};
    // 서버 토큰이 없으면
    if (token == null) {
      await kakaoLogin(ref);
      await fetchToken(ref);
      //
      //   // 토큰을 다시 읽습니다.
      final newToken = ref.read(loginStateProvider).serverToken;
      final newId = ref.read(loginStateProvider).id;
      //
      headers['Authorization'] = '$newToken';
      headers['id'] = '$newId';
    }

    var data = {
      'deadDate': voteInfo.dead_date,
      'deadTime': voteInfo.dead_time,
      'anonymous': voteInfo.is_anonymous,
      'multipleChoice': voteInfo.is_multiple_choice,
      'date': vote.vote_date,
      'time': vote.vote_time,
      'location': vote.vote_location
    };

    final apiService = ApiService();
    try {
      Response response = await apiService.sendRequest(
          method: 'POST',
          path: '$server/api/promise/item/${widget.id}',
          headers: headers,
          data: data);
      print('투표생성성공이다');
      print('투표생성성공이다');
      print(response);
      ref.read(voteProvider.notifier).setState(VoteDate());

      final router = GoRouter.of(context);
      router.go('/chatroom/${widget.id}');
    } catch (e) {
      print(e);
    }
  }

  Future<void> getVoteDate() async {
    // 현재 저장된 서버 토큰을 가져옵니다.
    final loginState = ref.read(loginStateProvider);
    final token = loginState.serverToken;
    final id = loginState.id;

    var headers = {'Authorization': '$token', 'id': '$id'};
    // 서버 토큰이 없으면
    if (token == null) {
      await kakaoLogin(ref);
      await fetchToken(ref);
      //
      //   // 토큰을 다시 읽습니다.
      final newToken = ref.read(loginStateProvider).serverToken;
      final newId = ref.read(loginStateProvider).id;
      //
      headers['Authorization'] = '$newToken';
      headers['id'] = '$newId';
    }

    final apiService = ApiService();
    try {
      Response response = await apiService.sendRequest(
          method: 'GET',
          path: '$server/api/promise/item/${widget.id}',
          headers: headers);
      print('투표수정화면에서 보이는 부분임');
      print('투표수정화면에서 보이는 부분임');
      print('투표수정화면에서 보이는 부분임');
      print(response);
      final date = await response.data['result'][0]['date'];
      final time = await response.data['result'][0]['time'];
      final location = await response.data['result'][0]['location'];
      final deadDate = response.data['result'][0]['deadDate'];
      final deadTime = response.data['result'][0]['deadTime'];
      final anonymous = response.data['result'][0]['anonymous'];
      final multipleChoice = response.data['result'][0]['multipleChoice'];

      if (deadDate != null && deadTime != null) {
        isEndTimeSet = true;
        _endDateController.text = deadDate;
        _endTimeController.text = deadTime;
      }
      isAnonymous = anonymous;
      isMultipleChoice = multipleChoice;

      print(date.length);
      print(voteItems[VoteType.DATE]?.length);

      // 리스트 길이가 모자라면 길이 늘려주기
      int dateDiff = date.length - (voteItems[VoteType.DATE]?.length ?? 0);
      if (dateDiff > 0) {
        for (int i = 0; i < dateDiff; i++) {
          voteItems[VoteType.DATE]?.add('');
          textEditingControllers[VoteType.DATE]?.add(TextEditingController());
        }
      }

      int timeDiff = time.length - (voteItems[VoteType.TIME]?.length ?? 0);
      if (timeDiff > 0) {
        for (int i = 0; i < timeDiff; i++) {
          voteItems[VoteType.TIME]?.add('');
          textEditingControllers[VoteType.TIME]?.add(TextEditingController());
        }
      }
      int locationDiff =
          location.length - (voteItems[VoteType.LOCATION]?.length ?? 0);
      if (locationDiff > 0) {
        for (int i = 0; i < locationDiff; i++) {
          voteItems[VoteType.LOCATION]?.add('');
          textEditingControllers[VoteType.LOCATION]
              ?.add(TextEditingController());
        }
      }
      // 해당값들 기본값으로 설정하기
      for (int j = 0; j < date.length; j++) {
        voteItems[VoteType.DATE]![j] = date[j];
        textEditingControllers[VoteType.DATE]![j].text = changeDate(date[j]);
      }
      for (int j = 0; j < time.length; j++) {
        voteItems[VoteType.TIME]![j] = time[j];
        textEditingControllers[VoteType.TIME]![j].text = time[j];
      }
      for (int j = 0; j < location.length; j++) {
        voteItems[VoteType.LOCATION]![j] = location[j]['location'];
        textEditingControllers[VoteType.LOCATION]![j].text =
            location[j]['location'];
        addMarker(double.parse(location[j]['lat']),
            double.parse(location[j]['lng']), location[j]['location']);
      }
      ref.read(voteProvider.notifier).setVoteData(date, time, location);

      print('리버팟 상태 찍기');
      print(ref.read(voteProvider).vote_date);
      print(ref.read(voteProvider).vote_time);
      print(ref.read(voteProvider).vote_location);
    } catch (e) {
      print('지금 못받아옴 왜 ');
      print('여기에러임 뭐가 문제지 $e');
    }
  }

  String changeDate(String date) {
    DateTime chatRoomDate = DateTime.parse(date);
    DateFormat formatter = DateFormat('yyyy-MM-dd (E)', 'ko_kr');
    String formatterDate = formatter.format(chatRoomDate);
    return formatterDate;
  }

  Future<void> putVote(vote, voteInfo) async {
    // 현재 저장된 서버 토큰을 가져옵니다.
    final loginState = ref.read(loginStateProvider);
    final token = loginState.serverToken;
    final id = loginState.id;

    var headers = {'Authorization': '$token', 'id': '$id'};
    // 서버 토큰이 없으면
    if (token == null) {
      await kakaoLogin(ref);
      await fetchToken(ref);
      //
      //   // 토큰을 다시 읽습니다.
      final newToken = ref.read(loginStateProvider).serverToken;
      final newId = ref.read(loginStateProvider).id;
      //
      headers['Authorization'] = '$newToken';
      headers['id'] = '$newId';
    }

    var data = {
      'deadDate': voteInfo.dead_date,
      'deadTime': voteInfo.dead_time,
      'anonymous': voteInfo.is_anonymous,
      'multipleChoice': voteInfo.is_multiple_choice,
      'date': vote.vote_date,
      'time': vote.vote_time,
      'location': vote.vote_location
    };

    final apiService = ApiService();
    try {
      Response response = await apiService.sendRequest(
          method: 'PUT',
          path: '$server/api/promise/item/${widget.id}',
          headers: headers,
          data: data);
      print('투표수정성공');
      print('투표수정성공');
      print('투표수정성공');
      print('투표수정성공');
      print(response);
      ref.read(voteProvider.notifier).setState(VoteDate());
      final router = GoRouter.of(context);
      router.go('/chatroom/${widget.id}');
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    selectedVoteType = widget.voteType;
    locationData = _getCurrentLocation();
    final voteInfo = ref.read(voteInfoProvider);
    if (voteInfo.dead_date != null && voteInfo.dead_time != null) {
      isEndTimeSet = true;
      _endDateController.text = voteInfo.dead_date!;
      _endTimeController.text = voteInfo.dead_time!;
    }
    if (voteInfo.is_anonymous != null) {
      isAnonymous = voteInfo.is_anonymous!;
    }
    if (voteInfo.is_multiple_choice != null) {
      isMultipleChoice = voteInfo.is_multiple_choice!;
    }
    if (widget.isUpdate) {
      futureGetVoteDate = getVoteDate();
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {});
      });
    }
  }

  String _formatDate(DateTime date) {
    final formatter = DateFormat('yyyy-MM-dd (E)', 'ko_KR');
    return formatter.format(date);
  }

  String _changeDate(DateTime date) {
    final change = DateFormat('yyyy-MM-dd');
    return change.format(date);
  }

  @override
  Widget build(BuildContext context) {
    final vote = ref.watch(voteProvider);
    final voteInfo = ref.watch(voteInfoProvider);
    print('--------');
    print('--------');
    print('--------');
    print(widget.voteInfo);
    print('--------');
    print('--------');
    print('--------');

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(kToolbarHeight),
              child: Container(
                decoration: const BoxDecoration(
                    border: Border(bottom: BorderSide(color: Colors.grey))),
                child: AppBar(
                  backgroundColor: Colors.white,
                  leading: IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        ref.read(voteProvider.notifier).setState(VoteDate());
                        context.go('/chatroom/${widget.id}');
                      }),
                  title: Text(widget.isUpdate ? '투표 수정' : '투표 만들기',
                      style: const TextStyle(
                          fontFamily: 'Pretendard', color: Colors.black)),
                  centerTitle: true,
                  actions: [
                    TextButton(
                        onPressed: handleVoteButton(vote, voteInfo),
                        child: Text(
                          widget.isUpdate ? '수정' : '저장',
                          style: const TextStyle(
                              color: Colors.black,
                              fontFamily: 'Pretendard',
                              fontSize: 18),
                        ))
                  ],
                  elevation: 0,
                ),
              ),
            ),
            body: widget.isUpdate
                ? FutureBuilder(
                    future: futureGetVoteDate,
                    builder:
                        (BuildContext context, AsyncSnapshot<void> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Text('404 NotFound!: ${snapshot.error}');
                      } else {
                        return ListView(
                          children: [
                            Row(
                              children: VoteType.values.map((voteType) {
                                    return Expanded(
                                      child: ListTile(
                                        title: Text(voteTypeToString(voteType)),
                                        leading: Radio<VoteType>(
                                          activeColor: AppColors.mainBlue,
                                          value: voteType,
                                          groupValue: selectedVoteType,
                                          onChanged: (VoteType? value) {
                                            setState(() {
                                              selectedVoteType = value;
                                            });
                                          },
                                        ),
                                      ),
                                    );
                                  }).toList() ??
                                  [],
                            ),
                            ...selectedVoteType == null
                                ? []
                                : voteItems[selectedVoteType]!
                                    .asMap()
                                    .entries
                                    .map((entry) {
                                    int index = entry.key;
                                    String item = entry.value;
                                    return Container(
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 6, horizontal: 24),
                                      padding: const EdgeInsets.fromLTRB(
                                          12, 4, 4, 4),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          border: Border.all(
                                              color: AppColors.mainBlue3)),
                                      child: Stack(
                                        children: [
                                          TextField(
                                            controller: textEditingControllers[
                                                selectedVoteType!]![index],
                                            readOnly: selectedVoteType ==
                                                    VoteType.LOCATION
                                                ? false
                                                : true,
                                            onTap: () async {
                                              switch (selectedVoteType) {
                                                case VoteType.DATE:
                                                  _selectedDate(context,
                                                      selectedVoteType!, index);
                                                  break;
                                                case VoteType.TIME:
                                                  _selectTime(context,
                                                      selectedVoteType!, index);
                                                  break;
                                                case VoteType.LOCATION:
                                                  break;
                                                default:
                                                  break;
                                              }
                                            },
                                            onChanged: (value) {
                                              setState(() {
                                                voteItems[selectedVoteType!]![
                                                    index] = value;
                                              });
                                            },
                                            onSubmitted: (value) {
                                              if (selectedVoteType ==
                                                  VoteType.LOCATION) {
                                                SearchPlace(value, index);
                                              }
                                            },
                                            decoration: const InputDecoration(
                                                border: InputBorder.none),
                                          ),
                                          Positioned(
                                            top: 0,
                                            right: 0,
                                            child: IconButton(
                                              icon: const Icon(Icons.close,
                                                  size: 24),
                                              color: AppColors.mainBlue2,
                                              padding: EdgeInsets.zero,
                                              onPressed: () {
                                                setState(() {
                                                  int index = voteItems[
                                                          selectedVoteType!]!
                                                      .indexOf(item);
                                                  voteItems[selectedVoteType!]
                                                      ?.removeAt(index);
                                                  textEditingControllers[
                                                          selectedVoteType!]
                                                      ?.removeAt(index);
                                                  switch (selectedVoteType) {
                                                    case VoteType.DATE:
                                                      ref
                                                          .read(voteProvider
                                                              .notifier)
                                                          .removeVoteDate(
                                                              index);
                                                      break;
                                                    case VoteType.TIME:
                                                      ref
                                                          .read(voteProvider
                                                              .notifier)
                                                          .removeVoteTime(
                                                              index);
                                                      break;
                                                    case VoteType.LOCATION:
                                                      ref
                                                          .read(voteProvider
                                                              .notifier)
                                                          .removeVoteLocation(
                                                              index);
                                                      _mapController
                                                          .clearOverlays();
                                                      _markers.removeAt(index);
                                                      break;
                                                    default:
                                                      break;
                                                  }
                                                });
                                              },
                                            ),
                                          ),
                                          if (selectedVoteType ==
                                              VoteType.LOCATION)
                                            Positioned(
                                                right: 30,
                                                child: TextButton(
                                                  onPressed: () {
                                                    String searchText =
                                                        textEditingControllers[
                                                                    selectedVoteType!]![
                                                                index]
                                                            .text;
                                                    SearchPlace(
                                                        searchText, index);
                                                  },
                                                  child: Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              6),
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
                                                          color: AppColors
                                                              .mainBlue2),
                                                      child: const Text('검색',
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'Pretendard',
                                                              color: Colors
                                                                  .white))),
                                                ))
                                        ],
                                      ),
                                    );
                                  }).toList(),
                            Align(
                              alignment: Alignment.center,
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                    vertical: 6, horizontal: 24),
                                width: double.infinity,
                                height: 60,
                                child: OutlinedButton(
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Colors.white),
                                      foregroundColor:
                                          MaterialStateProperty.all(
                                              AppColors.mainBlue3),
                                      side: MaterialStateProperty.all(
                                          BorderSide(
                                              color: AppColors.mainBlue3))),
                                  onPressed: () {
                                    setState(() {
                                      voteItems[selectedVoteType!]?.add('');
                                      textEditingControllers[selectedVoteType!]
                                          ?.add(TextEditingController());
                                    });
                                  },
                                  child: const Text('+ 항목 추가',
                                      style: TextStyle(
                                          fontFamily: 'Pretenadrd',
                                          fontWeight: FontWeight.w900,
                                          fontSize: 16)),
                                ),
                              ),
                            ),
                            if (selectedVoteType == VoteType.LOCATION)
                              FutureBuilder(
                                  future: locationData,
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return Align(
                                        alignment: Alignment.center,
                                        child: Container(
                                            width: 300,
                                            height: 300,
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color:
                                                        AppColors.mainBlue3)),
                                            child: const Center(
                                                child:
                                                    CircularProgressIndicator())),
                                      );
                                    } else if (snapshot.hasError) {
                                      return const Center(
                                          child: Text('404 Error!'));
                                    } else {
                                      _lat = snapshot.data!.latitude;
                                      _lng = snapshot.data!.longitude;
                                      return Align(
                                        alignment: Alignment.center,
                                        child: Container(
                                          width: 300,
                                          height: 300,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: AppColors.mainBlue3)),
                                          child: NaverMap(
                                            options: NaverMapViewOptions(
                                                mapType: NMapType.basic,
                                                rotationGesturesEnable: true,
                                                scrollGesturesEnable: true,
                                                tiltGesturesEnable: true,
                                                zoomGesturesEnable: true,
                                                stopGesturesEnable: true,
                                                // locationButtonEnable: true,
                                                initialCameraPosition:
                                                    NCameraPosition(
                                                        target: NLatLng(
                                                            _lat ?? 37.5666102,
                                                            _lng ??
                                                                126.9783881),
                                                        zoom: 10)),
                                            onMapReady: (controller) {
                                              _mapController = controller;

                                              final currentMarker = NMarker(
                                                  id: '내위치',
                                                  position:
                                                      NLatLng(_lat!, _lng!));
                                              controller
                                                  .addOverlay(currentMarker);
                                            },
                                            onCameraIdle: () {
                                              // 카메라 위치에 대한 좌표 얻어와서 마커 표시하고
                                              //   그 부분 검색해서 모달창으로 검색결과 띄워주고
                                            },
                                          ),
                                        ),
                                      );
                                    }
                                  }),
                            Container(
                              height: 100,
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              child: Row(
                                children: [
                                  Checkbox(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      activeColor: AppColors.mainBlue,
                                      side: isEndTimeSet
                                          ? const BorderSide(
                                              color: AppColors.mainBlue3)
                                          : const BorderSide(
                                              color: AppColors.grey300),
                                      value: isEndTimeSet,
                                      onChanged: (bool? value) {
                                        setState(() {
                                          isEndTimeSet = value!;
                                          if (isEndTimeSet == false) {
                                            ref
                                                .read(voteInfoProvider.notifier)
                                                .resetDeadDateAndTime();
                                            _endDateController.text = "";
                                            _endTimeController.text = "";
                                          }
                                        });
                                      }),
                                  Text(
                                    '종료시간',
                                    style: TextStyle(
                                        fontFamily: 'Pretendard',
                                        color: isEndTimeSet
                                            ? Colors.black
                                            : AppColors.grey300),
                                  ),
                                  Expanded(child: Container()),
                                  Container(
                                    width: 145,
                                    height: 50,
                                    padding: const EdgeInsets.only(left: 12),
                                    margin: const EdgeInsets.only(right: 6),
                                    decoration: BoxDecoration(
                                        border: isEndTimeSet
                                            ? Border.all(
                                                color: AppColors.mainBlue3)
                                            : Border.all(
                                                color: AppColors.grey300),
                                        borderRadius: BorderRadius.circular(6)),
                                    child: TextField(
                                        decoration: const InputDecoration(
                                          border: InputBorder.none,
                                        ),
                                        readOnly: true,
                                        controller: _endDateController,
                                        enabled: isEndTimeSet,
                                        onTap: () async {
                                          DateTime? date = await showDatePicker(
                                            builder: (context, child) {
                                              return Theme(
                                                data: Theme.of(context)
                                                    .copyWith(
                                                        colorScheme:
                                                            const ColorScheme
                                                                .light(
                                                          primary: AppColors
                                                              .mainBlue2,
                                                          onPrimary:
                                                              Colors.white,
                                                          onSurface:
                                                              Colors.black,
                                                        ),
                                                        textButtonTheme:
                                                            TextButtonThemeData(
                                                          style: TextButton.styleFrom(
                                                              foregroundColor:
                                                                  AppColors
                                                                      .mainBlue),
                                                        )),
                                                child: child!,
                                              );
                                            },
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime(2000),
                                            lastDate: DateTime(2100),
                                          );
                                          if (date != null) {
                                            _endDateController.text =
                                                _formatDate(date);
                                            ref
                                                .read(voteInfoProvider.notifier)
                                                .setDeadDate(_changeDate(date)
                                                    .toString());
                                          }
                                        }),
                                  ),
                                  Container(
                                    width: 120,
                                    height: 50,
                                    padding: const EdgeInsets.only(left: 6),
                                    decoration: BoxDecoration(
                                        border: isEndTimeSet
                                            ? Border.all(
                                                color: AppColors.mainBlue3)
                                            : Border.all(
                                                color: AppColors.grey300),
                                        borderRadius: BorderRadius.circular(6)),
                                    child: TextField(
                                      readOnly: true,
                                      decoration: const InputDecoration(
                                          border: InputBorder.none),
                                      controller: _endTimeController,
                                      enabled: isEndTimeSet,
                                      onTap: () {
                                        TimeOfDay initialTime = TimeOfDay.now();
                                        Navigator.of(context).push(showPicker(
                                            context: context,
                                            value: Time(
                                                hour: initialTime.hour,
                                                minute: initialTime.minute),
                                            onChange: (TimeOfDay time) {
                                              final period =
                                                  time.period == DayPeriod.am
                                                      ? '오전'
                                                      : '오후';
                                              final selectedTime =
                                                  '$period ${time.hourOfPeriod.toString().padLeft(2, '0')}시 ${time.minute.toString().padLeft(2, '0')}분';
                                              _endTimeController.text =
                                                  selectedTime;
                                              ref
                                                  .read(
                                                      voteInfoProvider.notifier)
                                                  .setDeadTime(selectedTime);
                                            },
                                            minuteInterval:
                                                TimePickerInterval.FIVE,
                                            iosStylePicker: true,
                                            okText: '확인',
                                            okStyle: const TextStyle(
                                                color: AppColors.mainBlue2),
                                            cancelText: '취소',
                                            cancelStyle: const TextStyle(
                                                color: AppColors.mainBlue2),
                                            hourLabel: '시',
                                            minuteLabel: '분',
                                            accentColor: AppColors.mainBlue2));
                                      },
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              child: Row(
                                children: [
                                  Checkbox(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      activeColor: AppColors.mainBlue,
                                      side: isMultipleChoice
                                          ? const BorderSide(
                                              color: AppColors.mainBlue3)
                                          : const BorderSide(
                                              color: AppColors.grey300),
                                      value: isMultipleChoice,
                                      onChanged: (bool? value) {
                                        setState(() {
                                          isMultipleChoice = value!;
                                        });
                                        ref
                                            .read(voteInfoProvider.notifier)
                                            .setMultiple(isMultipleChoice);
                                      }),
                                  Text('복수선택',
                                      style: TextStyle(
                                          fontFamily: 'Pretendard',
                                          color: isMultipleChoice
                                              ? Colors.black
                                              : AppColors.grey300))
                                ],
                              ),
                            ),
                            Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              child: Row(
                                children: [
                                  Checkbox(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      activeColor: AppColors.mainBlue,
                                      side: isAnonymous
                                          ? const BorderSide(
                                              color: AppColors.mainBlue3)
                                          : const BorderSide(
                                              color: AppColors.grey300),
                                      value: isAnonymous,
                                      onChanged: (bool? value) {
                                        setState(() {
                                          isAnonymous = value!;
                                        });
                                        ref
                                            .read(voteInfoProvider.notifier)
                                            .setAnonymous(isAnonymous);
                                      }),
                                  Text('익명투표',
                                      style: TextStyle(
                                          fontFamily: 'Pretendard',
                                          color: isAnonymous
                                              ? Colors.black
                                              : AppColors.grey300))
                                ],
                              ),
                            ),
                          ],
                        );
                      }
                    })
                : ListView(
                    children: [
                      Row(
                        children: VoteType.values.map((voteType) {
                              return Expanded(
                                child: ListTile(
                                  title: Text(voteTypeToString(voteType)),
                                  leading: Radio<VoteType>(
                                    activeColor: AppColors.mainBlue,
                                    value: voteType,
                                    groupValue: selectedVoteType,
                                    onChanged: widget.voteInfo != '미정'
                                        ? null
                                        : (VoteType? value) {
                                            setState(() {
                                              selectedVoteType = value;
                                            });
                                          },
                                  ),
                                ),
                              );
                            }).toList() ??
                            [],
                      ),
                      ...selectedVoteType == null
                          ? []
                          : voteItems[selectedVoteType]!
                              .asMap()
                              .entries
                              .map((entry) {
                              int index = entry.key;
                              String item = entry.value;
                              return Container(
                                margin: const EdgeInsets.symmetric(
                                    vertical: 6, horizontal: 24),
                                padding: const EdgeInsets.fromLTRB(12, 4, 4, 4),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    border:
                                        Border.all(color: AppColors.mainBlue3)),
                                child: Stack(
                                  children: [
                                    TextField(
                                      controller: textEditingControllers[
                                          selectedVoteType!]![index],
                                      readOnly:
                                          selectedVoteType == VoteType.LOCATION
                                              ? false
                                              : true,
                                      onTap: () async {
                                        switch (selectedVoteType) {
                                          case VoteType.DATE:
                                            _selectedDate(context,
                                                selectedVoteType!, index);
                                            break;
                                          case VoteType.TIME:
                                            _selectTime(context,
                                                selectedVoteType!, index);
                                            break;
                                          case VoteType.LOCATION:
                                            break;
                                          default:
                                            break;
                                        }
                                      },
                                      onChanged: (value) {
                                        setState(() {
                                          voteItems[selectedVoteType!]![index] =
                                              value;
                                        });
                                      },
                                      onSubmitted: (value) {
                                        if (selectedVoteType ==
                                            VoteType.LOCATION) {
                                          SearchPlace(value, index);
                                        }
                                      },
                                      decoration: const InputDecoration(
                                          border: InputBorder.none),
                                    ),
                                    Positioned(
                                      top: 0,
                                      right: 0,
                                      child: IconButton(
                                        icon: const Icon(Icons.close, size: 24),
                                        color: AppColors.mainBlue2,
                                        padding: EdgeInsets.zero,
                                        onPressed: () {
                                          setState(() {
                                            int index =
                                                voteItems[selectedVoteType!]!
                                                    .indexOf(item);
                                            voteItems[selectedVoteType!]
                                                ?.removeAt(index);
                                            textEditingControllers[
                                                    selectedVoteType!]
                                                ?.removeAt(index);
                                            switch (selectedVoteType) {
                                              case VoteType.DATE:
                                                ref
                                                    .read(voteProvider.notifier)
                                                    .removeVoteDate(index);
                                                break;
                                              case VoteType.TIME:
                                                ref
                                                    .read(voteProvider.notifier)
                                                    .removeVoteTime(index);
                                                break;
                                              case VoteType.LOCATION:
                                                ref
                                                    .read(voteProvider.notifier)
                                                    .removeVoteLocation(index);
                                                _mapController.clearOverlays();
                                                _markers.removeAt(index);
                                                break;
                                              default:
                                                break;
                                            }
                                          });
                                        },
                                      ),
                                    ),
                                    if (selectedVoteType == VoteType.LOCATION)
                                      Positioned(
                                          right: 30,
                                          child: TextButton(
                                            onPressed: () {
                                              String searchText =
                                                  textEditingControllers[
                                                              selectedVoteType!]![
                                                          index]
                                                      .text;
                                              SearchPlace(searchText, index);
                                            },
                                            child: Container(
                                                padding:
                                                    const EdgeInsets.all(6),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    color: AppColors.mainBlue2),
                                                child: const Text('검색',
                                                    style: TextStyle(
                                                        fontFamily:
                                                            'Pretendard',
                                                        color: Colors.white))),
                                          ))
                                  ],
                                ),
                              );
                            }).toList(),
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 6, horizontal: 24),
                          width: double.infinity,
                          height: 60,
                          child: OutlinedButton(
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.white),
                                foregroundColor: MaterialStateProperty.all(
                                    AppColors.mainBlue3),
                                side: MaterialStateProperty.all(
                                    BorderSide(color: AppColors.mainBlue3))),
                            onPressed: () {
                              setState(() {
                                voteItems[selectedVoteType!]?.add('');
                                textEditingControllers[selectedVoteType!]
                                    ?.add(TextEditingController());
                              });
                            },
                            child: const Text('+ 항목 추가',
                                style: TextStyle(
                                    fontFamily: 'Pretenadrd',
                                    fontWeight: FontWeight.w900,
                                    fontSize: 16)),
                          ),
                        ),
                      ),
                      if (selectedVoteType == VoteType.LOCATION)
                        FutureBuilder(
                            future: locationData,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Align(
                                  alignment: Alignment.center,
                                  child: Container(
                                      width: 300,
                                      height: 300,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: AppColors.mainBlue3)),
                                      child: const Center(
                                          child: CircularProgressIndicator())),
                                );
                              } else if (snapshot.hasError) {
                                return const Center(child: Text('404 Error!'));
                              } else {
                                _lat = snapshot.data!.latitude;
                                _lng = snapshot.data!.longitude;
                                return Align(
                                  alignment: Alignment.center,
                                  child: Container(
                                    width: 300,
                                    height: 300,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: AppColors.mainBlue3)),
                                    child: NaverMap(
                                      options: NaverMapViewOptions(
                                          mapType: NMapType.basic,
                                          rotationGesturesEnable: true,
                                          scrollGesturesEnable: true,
                                          tiltGesturesEnable: true,
                                          zoomGesturesEnable: true,
                                          stopGesturesEnable: true,
                                          // locationButtonEnable: true,
                                          initialCameraPosition:
                                              NCameraPosition(
                                                  target: NLatLng(
                                                      _lat ?? 37.5666102,
                                                      _lng ?? 126.9783881),
                                                  zoom: 10)),
                                      onMapReady: (controller) {
                                        _mapController = controller;

                                        final currentMarker = NMarker(
                                            id: '내위치',
                                            position: NLatLng(_lat!, _lng!));
                                        controller.addOverlay(currentMarker);
                                      },
                                      onCameraIdle: () {
                                        // 카메라 위치에 대한 좌표 얻어와서 마커 표시하고
                                        //   그 부분 검색해서 모달창으로 검색결과 띄워주고
                                      },
                                    ),
                                  ),
                                );
                              }
                            }),
                      Container(
                        height: 100,
                        margin: const EdgeInsets.symmetric(horizontal: 12),
                        child: Row(
                          children: [
                            Checkbox(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15)),
                                activeColor: AppColors.mainBlue,
                                side: isEndTimeSet
                                    ? const BorderSide(
                                        color: AppColors.mainBlue3)
                                    : const BorderSide(
                                        color: AppColors.grey300),
                                value: isEndTimeSet,
                                onChanged: (bool? value) {
                                  setState(() {
                                    isEndTimeSet = value!;
                                    if (isEndTimeSet == false) {
                                      ref
                                          .read(voteInfoProvider.notifier)
                                          .resetDeadDateAndTime();
                                      _endDateController.text = "";
                                      _endTimeController.text = "";
                                    }
                                  });
                                }),
                            Text(
                              '종료시간',
                              style: TextStyle(
                                  fontFamily: 'Pretendard',
                                  color: isEndTimeSet
                                      ? Colors.black
                                      : AppColors.grey300),
                            ),
                            Expanded(child: Container()),
                            Container(
                              width: 145,
                              height: 50,
                              padding: const EdgeInsets.only(left: 12),
                              margin: const EdgeInsets.only(right: 6),
                              decoration: BoxDecoration(
                                  border: isEndTimeSet
                                      ? Border.all(color: AppColors.mainBlue3)
                                      : Border.all(color: AppColors.grey300),
                                  borderRadius: BorderRadius.circular(6)),
                              child: TextField(
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                  ),
                                  readOnly: true,
                                  controller: _endDateController,
                                  enabled: isEndTimeSet,
                                  onTap: () async {
                                    DateTime? date = await showDatePicker(
                                      builder: (context, child) {
                                        return Theme(
                                          data: Theme.of(context).copyWith(
                                              colorScheme:
                                                  const ColorScheme.light(
                                                primary: AppColors.mainBlue2,
                                                onPrimary: Colors.white,
                                                onSurface: Colors.black,
                                              ),
                                              textButtonTheme:
                                                  TextButtonThemeData(
                                                style: TextButton.styleFrom(
                                                    foregroundColor:
                                                        AppColors.mainBlue),
                                              )),
                                          child: child!,
                                        );
                                      },
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(2000),
                                      lastDate: DateTime(2100),
                                    );
                                    if (date != null) {
                                      _endDateController.text =
                                          _formatDate(date);
                                      ref
                                          .read(voteInfoProvider.notifier)
                                          .setDeadDate(
                                              _changeDate(date).toString());
                                    }
                                  }),
                            ),
                            Container(
                              width: 120,
                              height: 50,
                              padding: const EdgeInsets.only(left: 6),
                              decoration: BoxDecoration(
                                  border: isEndTimeSet
                                      ? Border.all(color: AppColors.mainBlue3)
                                      : Border.all(color: AppColors.grey300),
                                  borderRadius: BorderRadius.circular(6)),
                              child: TextField(
                                readOnly: true,
                                decoration: const InputDecoration(
                                    border: InputBorder.none),
                                controller: _endTimeController,
                                enabled: isEndTimeSet,
                                onTap: () {
                                  TimeOfDay initialTime = TimeOfDay.now();
                                  Navigator.of(context).push(showPicker(
                                      context: context,
                                      value: Time(
                                          hour: initialTime.hour,
                                          minute: initialTime.minute),
                                      onChange: (TimeOfDay time) {
                                        final period =
                                            time.period == DayPeriod.am
                                                ? '오전'
                                                : '오후';
                                        final selectedTime =
                                            '$period ${time.hourOfPeriod.toString().padLeft(2, '0')}시 ${time.minute.toString().padLeft(2, '0')}분';
                                        _endTimeController.text = selectedTime;
                                        ref
                                            .read(voteInfoProvider.notifier)
                                            .setDeadTime(selectedTime);
                                      },
                                      minuteInterval: TimePickerInterval.FIVE,
                                      iosStylePicker: true,
                                      okText: '확인',
                                      okStyle: const TextStyle(
                                          color: AppColors.mainBlue2),
                                      cancelText: '취소',
                                      cancelStyle: const TextStyle(
                                          color: AppColors.mainBlue2),
                                      hourLabel: '시',
                                      minuteLabel: '분',
                                      accentColor: AppColors.mainBlue2));
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 12),
                        child: Row(
                          children: [
                            Checkbox(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15)),
                                activeColor: AppColors.mainBlue,
                                side: isMultipleChoice
                                    ? const BorderSide(
                                        color: AppColors.mainBlue3)
                                    : const BorderSide(
                                        color: AppColors.grey300),
                                value: isMultipleChoice,
                                onChanged: (bool? value) {
                                  setState(() {
                                    isMultipleChoice = value!;
                                  });
                                  ref
                                      .read(voteInfoProvider.notifier)
                                      .setMultiple(isMultipleChoice);
                                }),
                            Text('복수선택',
                                style: TextStyle(
                                    fontFamily: 'Pretendard',
                                    color: isMultipleChoice
                                        ? Colors.black
                                        : AppColors.grey300))
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 12),
                        child: Row(
                          children: [
                            Checkbox(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15)),
                                activeColor: AppColors.mainBlue,
                                side: isAnonymous
                                    ? const BorderSide(
                                        color: AppColors.mainBlue3)
                                    : const BorderSide(
                                        color: AppColors.grey300),
                                value: isAnonymous,
                                onChanged: (bool? value) {
                                  setState(() {
                                    isAnonymous = value!;
                                  });
                                  ref
                                      .read(voteInfoProvider.notifier)
                                      .setAnonymous(isAnonymous);
                                }),
                            Text('익명투표',
                                style: TextStyle(
                                    fontFamily: 'Pretendard',
                                    color: isAnonymous
                                        ? Colors.black
                                        : AppColors.grey300))
                          ],
                        ),
                      ),
                    ],
                  )));
  }

  String voteTypeToString(VoteType voteType) {
    switch (voteType) {
      case VoteType.DATE:
        return '일시';
      case VoteType.TIME:
        return '시간';
      case VoteType.LOCATION:
        return '장소';
      default:
        return '';
    }
  }

  Future<void> _selectedDate(
      BuildContext context, VoteType voteType, int index) async {
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
      textEditingControllers[voteType]![index].text =
          DateFormat('yyyy-MM-dd (E)', 'ko_kr').format(picked);
      if (index < (ref.read(voteProvider).vote_date?.length ?? 0)) {
        ref
            .read(voteProvider.notifier)
            .updateVoteDate(index, picked.toString());
      } else {
        ref
            .read(voteProvider.notifier)
            .addVoteDate(_changeDate(picked).toString());
      }
    }
  }

  Future<void> _selectTime(
      BuildContext context, VoteType voteType, int index) async {
    TimeOfDay initialTime = TimeOfDay.now();
    Navigator.of(context).push(showPicker(
        context: context,
        value: Time(hour: initialTime.hour, minute: initialTime.minute),
        onChange: (TimeOfDay time) {
          final period = time.period == DayPeriod.am ? '오전' : '오후';
          final selectedTime =
              '$period ${time.hourOfPeriod.toString().padLeft(2, '0')}시 ${time.minute.toString().padLeft(2, '0')}분';
          textEditingControllers[voteType]![index].text = selectedTime;
          if (index < (ref.read(voteProvider).vote_time?.length ?? 0)) {
            ref.read(voteProvider.notifier).updateVoteTime(index, selectedTime);
          } else {
            ref.read(voteProvider.notifier).addVoteTime(selectedTime);
          }
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

  void SearchPlace(String text, int index) async {
    final dio = Dio();
    final response = await dio.get(
      'https://openapi.naver.com/v1/search/local.json?',
      queryParameters: {
        'query': text,
        'display': 5,
        'sort': 'random',
      },
      options: Options(
        headers: {
          'X-Naver-Client-Id': Client_ID,
          'X-Naver-Client-Secret': Client_Secret,
        },
      ),
    );

    final List<dynamic> items = response.data['items'];
    StringBuffer buffer = StringBuffer();

    // ignore: use_build_context_synchronously
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return SingleChildScrollView(
            child: Column(
              children: items.map((item) {
                return Card(
                  child: Column(
                    children: [
                      ListTile(
                        title: Text((item['title'])
                            .replaceAll(RegExp(r'<[^>]*>'), '')
                            .replaceAll('&amp;', '&')
                            .replaceAll('&lt;', '<')
                            .replaceAll('&gt;', '>')
                            .replaceAll('&quot;', '"')
                            .replaceAll('&#39;', "'")),
                        subtitle: Text(item['description']),
                        onTap: () async {
                          Navigator.of(context).pop();
                          final xString = (item['mapx']);
                          buffer
                            ..write(xString.substring(0, 3))
                            ..write('.')
                            ..write(xString.substring(3));
                          final x = double.parse(buffer.toString());

                          buffer.clear();

                          final yString = (item['mapy']);
                          buffer
                            ..write(yString.substring(0, 2))
                            ..write('.')
                            ..write(yString.substring(2));
                          final y = double.parse(buffer.toString());
                          String title = (item['title'])
                              .replaceAll(RegExp(r'<[^>]*>'), '')
                              .replaceAll('&amp;', '&')
                              .replaceAll('&lt;', '<')
                              .replaceAll('&gt;', '>')
                              .replaceAll('&quot;', '"')
                              .replaceAll('&#39;', "'");

                          addMarker(y, x, title, index);

                          if (index <
                              (ref.read(voteProvider).vote_location?.length ??
                                  0)) {
                            // Update the existing item
                            ref.read(voteProvider.notifier).updateVoteLocation(
                                index, text, y.toString(), x.toString());
                          } else {
                            // Add a new item
                            ref.read(voteProvider.notifier).addVoteLocation(
                                text, y.toString(), x.toString());
                          }
                        },
                      )
                    ],
                  ),
                );
              }).toList(),
            ),
          );
        });
  }

  handleVoteButton(vote, voteInfo) {
    if (isEndTimeSet == true) {
      if (_endDateController.text == "" || _endTimeController.text == "") {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  contentPadding: EdgeInsets.zero,
                  content: Stack(
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            decoration: const BoxDecoration(
                              color: AppColors.mainBlue2,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    Nav.pop(context);
                                  },
                                  icon: const Icon(
                                    Icons.close,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 24, bottom: 12),
                            child: const Text(
                              '종료시간을 확인해 주세요!',
                              style: TextStyle(
                                fontFamily: 'Pretendard',
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 12),
                            child: Text(
                              _endDateController.text == ""
                                ? _endTimeController.text == ""
                              ? "날짜와 시간이 설정되지 않았어요!"
                              : "종료날짜가 제대로 설정되지 않았어요!"
                              : "종료시간이 제대로 설정되지 않았어요!",
                              style: const TextStyle(
                                  fontFamily: 'Pretendard', fontSize: 14),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 8),
                            child: Row(
                              children: [
                                Expanded(
                                    child: Container(
                                  decoration: BoxDecoration(
                                      color: AppColors.mainBlue2,
                                      borderRadius: BorderRadius.circular(4)),
                                  child: TextButton(
                                    onPressed: () {
                                      Nav.pop(context);
                                    },
                                    child: const Text(
                                      '확인',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'Pretendard'),
                                    ),
                                  ),
                                ))
                              ],
                            ),
                          )
                        ],
                      ),
                      Positioned(
                        top: 30,
                        left: 30,
                        child: Image.asset(
                          'assets/image/main/핑키4.png',
                          width: 48,
                        ),
                      )
                    ],
                  ),
                ),
        );
      } else {
        String formattedEndDate = _endDateController.text.substring(0, 10);
        int endHour = int.parse(_endTimeController.text.substring(3, 5));
        if (_endTimeController.text.startsWith("오후")) {
          endHour += 12;
        }
        DateTime endDateTime = DateTime.parse("$formattedEndDate ${endHour.toString().padLeft(2, '0')}:05:00");
        if (endDateTime.isAfter(DateTime.now())) {
          widget.isUpdate
            ? putVote(vote, voteInfo)
            : postVote(vote, voteInfo);
        } else {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              contentPadding: EdgeInsets.zero,
              content: Stack(
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        decoration: const BoxDecoration(
                          color: AppColors.mainBlue2,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              onPressed: () {
                                Nav.pop(context);
                              },
                              icon: const Icon(
                                Icons.close,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 24, bottom: 12),
                        child: const Text(
                          '종료시간을 확인해 주세요!',
                          style: TextStyle(
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 12),
                        child: const Text(
                          "종료시간을 과거로 설정할 수 는 없어요!",
                          style: TextStyle(
                              fontFamily: 'Pretendard', fontSize: 14),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 8),
                        child: Row(
                          children: [
                            Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: AppColors.mainBlue2,
                                      borderRadius: BorderRadius.circular(4)),
                                  child: TextButton(
                                    onPressed: () {
                                      Nav.pop(context);
                                    },
                                    child: const Text(
                                      '확인',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'Pretendard'),
                                    ),
                                  ),
                                ))
                          ],
                        ),
                      )
                    ],
                  ),
                  Positioned(
                    top: 30,
                    left: 30,
                    child: Image.asset(
                      'assets/image/main/핑키4.png',
                      width: 48,
                    ),
                  )
                ],
              ),
            ),
          );
        }
      }
    } else {
      widget.isUpdate
        ? putVote(vote, voteInfo)
        : postVote(vote, voteInfo);
    }
  }
}
