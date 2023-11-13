import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:location/location.dart';
import 'package:p_on/common/common.dart';
import 'dto_promise.dart';
import 'vo_naver_headers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchNaver extends ConsumerStatefulWidget {
  const SearchNaver({super.key});

  @override
  ConsumerState<SearchNaver> createState() => _SearchNaverState();
}

class _SearchNaverState extends ConsumerState<SearchNaver> {
  double? _lat;
  double? _lng;
  TextEditingController inputText = TextEditingController();
  late NaverMapController _mapController;

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

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: FutureBuilder(
          future: _getCurrentLocation(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else {
              return Scaffold(
                body: Stack(
                  children: [
                    NaverMap(
                      options: NaverMapViewOptions(
                        mapType: NMapType.basic,
                        locationButtonEnable: true,
                        activeLayerGroups: [NLayerGroup.building],
                        initialCameraPosition: NCameraPosition(
                            target: NLatLng(
                                _lat ?? 37.5666102, _lng ?? 126.9783881),
                            zoom: 10),
                      ),
                      onMapReady: (controller) {
                        _mapController = controller;

                        if (_lat != null && _lng != null) {
                          final marker = NMarker(
                              id: '내위치', position: NLatLng(_lat!, _lng!));
                          controller.addOverlay(marker);

                          final onMarkerInfoWindow = NInfoWindow.onMarker(
                              id: marker.info.id, text: "현재위치");
                          marker.openInfoWindow(onMarkerInfoWindow);
                        }
                      },
                    ),
                    Positioned(
                        child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 50,
                            margin: const EdgeInsets.all(24),
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                                boxShadow: const [
                                  BoxShadow(
                                      color: Colors.grey,
                                      blurRadius: 0.1,
                                      spreadRadius: 0.5,
                                      offset: Offset(0, 2))
                                ],
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(5)),
                            child: TextField(
                                controller: inputText,
                                decoration: const InputDecoration(
                                    enabledBorder: InputBorder.none,
                                    focusedBorder: InputBorder.none),
                                onSubmitted: (text) {
                                  SearchPlace(text);
                                }),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            if (inputText.text.isNotEmpty) {
                              SearchPlace(inputText.text);
                            }
                          },
                          // 검색 버튼
                          child: Container(
                            width: 60,
                            height: 50,
                            margin: const EdgeInsets.only(right: 12),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: AppColors.mainBlue2),
                            child: const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.search,
                                    size: 24, color: Colors.white),
                                Text('검색',
                                    style: TextStyle(
                                        fontFamily: 'Pretendard',
                                        color: Colors.white,
                                        fontSize: 16))
                              ],
                            ),
                          ),
                        ),
                      ],
                    ))
                  ],
                ),
                floatingActionButton: FloatingActionButton(
                  backgroundColor: AppColors.grey200,
                  child: const Icon(Icons.undo_outlined,
                      color: AppColors.mainBlue2),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              );
            }
          }),
    );
  }

  void SearchPlace(String text) async {
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
      barrierColor: Colors.transparent,
      showDragHandle: true,
      backgroundColor: AppColors.grey200,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
            padding: const EdgeInsets.all(10),
            child: SingleChildScrollView(
              // controller: scrollController,
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
                              Navigator.of(context)
                                  .pop(); // 현재 모달 닫고 새로운 모달창 띄우기
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

                              final endposition = NLatLng(y, x);
                              final marker2 =
                                  NMarker(id: '마커ID', position: endposition);

                              showModalBottomSheet(
                                  showDragHandle: true,
                                  barrierColor: Colors.transparent,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(20)),
                                  ),
                                  context: context,
                                  builder: (context) {
                                    return Container(
                                      height: 150,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                              child: Text(
                                            '"${item['title'].replaceAll(RegExp(r'<[^>]*>'), '').replaceAll('&amp;', '&').replaceAll('&lt;', '<').replaceAll('&gt;', '>').replaceAll('&quot;', '"').replaceAll('&#39;', "'")}"\n약속 장소로 설정할까요?',
                                            style: const TextStyle(
                                                fontFamily: 'Pretendard',
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold),
                                          )),
                                          Expanded(child: Container()),
                                          Container(
                                            margin: EdgeInsets.only(bottom: 36),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  height: 40,
                                                  margin: const EdgeInsets.only(
                                                      right: 6),
                                                  decoration: BoxDecoration(
                                                      color:
                                                          AppColors.mainBlue3,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20)),
                                                  child: TextButton(
                                                    style: ButtonStyle(
                                                      overlayColor:
                                                          MaterialStateProperty
                                                              .resolveWith<
                                                                  Color>(
                                                        (Set<MaterialState>
                                                            states) {
                                                          if (states.contains(
                                                              MaterialState
                                                                  .pressed)) {
                                                            return Colors
                                                                .transparent;
                                                          }
                                                          return Colors
                                                              .transparent;
                                                        },
                                                      ),
                                                    ),
                                                    onPressed: () {
                                                      ref
                                                          .read(promiseProvider
                                                              .notifier)
                                                          .setPromiseLocation(
                                                              item['title'],
                                                              NLatLng(y,
                                                                  x)); // 약속 장소와 좌표 저장
                                                      Navigator.pop(
                                                          context); // 모달 창 닫기
                                                      Navigator.pop(
                                                          context,
                                                          item[
                                                              'title']); // 이전페이지로 돌아가기
                                                    },
                                                    child: const Text('확인',
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'Pretendard',
                                                            color:
                                                                Colors.white)),
                                                  ),
                                                ),
                                                Container(
                                                  height: 40,
                                                  margin: const EdgeInsets.only(
                                                      left: 6),
                                                  decoration: BoxDecoration(
                                                      color: AppColors.grey300,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20)),
                                                  child: TextButton(
                                                    style: ButtonStyle(
                                                      overlayColor:
                                                          MaterialStateProperty
                                                              .resolveWith<
                                                                  Color>(
                                                        (Set<MaterialState>
                                                            states) {
                                                          if (states.contains(
                                                              MaterialState
                                                                  .pressed)) {
                                                            return Colors
                                                                .transparent;
                                                          }
                                                          return Colors
                                                              .transparent;
                                                        },
                                                      ),
                                                    ),
                                                    onPressed: () async {
                                                      await _mapController
                                                          .deleteOverlay(marker2
                                                              .info); // 마커 삭제
                                                      Navigator.pop(
                                                          context); // 모달 창 닫기
                                                    },
                                                    child: const Text('취소',
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'Pretendard',
                                                            color:
                                                                Colors.white)),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    );
                                  });

                              await _mapController.addOverlay(marker2);
                              await _mapController.updateCamera(
                                  NCameraUpdate.withParams(
                                      target: endposition, zoom: 15));
                            }),
                        ListTile(
                          title: Text('도로명 주소'),
                          subtitle: Text(item['roadAddress']),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ));
      },
    );
  }
}
