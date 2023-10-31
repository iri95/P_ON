import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:location/location.dart';


class SearchNaver extends StatefulWidget {
  const SearchNaver({super.key});

  @override
  State<SearchNaver> createState() => _SearchNaverState();
}

/// 화면 좌표를 위경도 좌표로 변환할 수 있어요.
Future<NLatLng> screenLocationToLatLng(NPoint point);

/// 위경도 좌표를 화면 좌표로 변환할 수 있어요.
Future<NPoint> latLngToScreenLocation(NLatLng latLng);

/// 1DP (Logical Pixel와 동일)당 몇 미터인지 알 수 있어요.
/// latitude와 zoom을 지정하지 않으면 모두 현재 카메라의 값을 사용해요.
/// 현재 카메라의 좌표가 아닌, 특정 좌표에서의 값을 알아야 한다면, latitiude를 지정해주어야 하고,
/// 현재 카메라의 줌 레벨이 아닌, 특정 줌 레벨에서의 값을 알아야 한다면, zoom을 지정해주어야 해요.
Future<double> getMeterPerDp({double? latitude, double? zoom});

class _SearchNaverState extends State<SearchNaver> {

  void _getCurrentLocation() async {
    final location = Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();

    print('Latitude: ${_locationData.latitude}, Longitude: ${_locationData.longitude}');
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NaverMap(
        options: const NaverMapViewOptions(
          mapType: NMapType.basic,
          locationButtonEnable: true,
          extent: NLatLngBounds(
            southWest: NLatLng(31.43, 122.37),
            northEast: NLatLng(44.35, 132.0),
          ),
          activeLayerGroups: [

            NLayerGroup.building
          ],
        ),
        onMapReady: (controller) {

        },
      ),
    );
  }
}
