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
                        child: Container(
                      width: double.infinity,
                      height: 50,
                      margin: const EdgeInsets.all(24),
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: const BoxDecoration(boxShadow: [
                        BoxShadow(
                            color: Colors.black,
                            blurRadius: 2.0,
                            spreadRadius: 0,
                            offset: Offset(0, 2))
                      ], color: Colors.white),
                      child: TextField(
                          decoration: const InputDecoration(
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none),
                          onSubmitted: (text) {
                            SearchPlace(text);
                          }),
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

    showModalBottomSheet(
      context: context,
      barrierColor: Colors.transparent,
      showDragHandle: true,
      backgroundColor: AppColors.mainBlue2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SingleChildScrollView(
          // controller: scrollController,
          child: Column(
            children: items.map((item) {
              return Card(
                child: Column(
                  children: [
                    ListTile(
                        title: Text(item['title']),
                        subtitle: Text(item['description']),
                        onTap: () async {
                          Navigator.of(context).pop();
                          final x = double.parse(item['mapx']);
                          final y = double.parse(item['mapy']);

                          final endposition = NLatLng(37.5666102, 126.9783881);
                          final marker2 =
                              NMarker(id: '마커ID', position: endposition);

                          showModalBottomSheet(
                              showDragHandle: true,
                              barrierColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(20)),
                              ),
                              context: context,
                              builder: (context) {
                                return Container(
                                  height: 100,
                                  child: Column(
                                    children: [
                                      Text('약속 장소로 설정할까요?'),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          ElevatedButton(
                                            onPressed: () {
                                              ref
                                                  .read(
                                                      promiseProvider.notifier)
                                                  .setPromiseLocation(
                                                      item['title'],
                                                      NLatLng(x,
                                                          y)); // 약속 장소와 좌표 저장
                                              Navigator.pop(context); // 모달 창 닫기
                                              Navigator.pop(context,
                                                  item['title']); // 이전페이지로 돌아가기
                                            },
                                            child: Text('확인'),
                                          ),
                                          ElevatedButton(
                                            onPressed: () async {
                                              await _mapController
                                                  .deleteOverlay(
                                                      marker2.info); // 마커 삭제
                                              Navigator.pop(context); // 모달 창 닫기
                                            },
                                            child: Text('취소'),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                );
                              });

                          await _mapController.addOverlay(marker2);
                          await _mapController
                              .updateCamera(NCameraUpdate.withParams(
                            target: endposition,
                          ));
                        }),
                    ListTile(
                      title: Text('링크'),
                      subtitle: Text(item['link']),
                    ),
                    ListTile(
                      title: Text('전화번호'),
                      subtitle: Text(item['telephone']),
                    ),
                    ListTile(
                      title: Text('도로명 주소'),
                      subtitle: Text(item['roadAddress']),
                    ),
                    ListTile(
                      title: Text('x 좌표'),
                      subtitle: Text(item['mapx']),
                    ),
                    ListTile(
                      title: Text('y 좌표'),
                      subtitle: Text(item['mapy']),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
