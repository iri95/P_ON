import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'common/data/preference/app_preferences.dart';
import 'screen/main/tab/promise_room/vo_naver_headers.dart';
import 'common/theme/custom_theme_app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'package:flutter/foundation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 안드로이드 플랫폼인 경우에만 NaverMapSdk 초기화
  if (defaultTargetPlatform == TargetPlatform.android) {
    await NaverMapSdk.instance.initialize(clientId: Naver_Map_Id);
  }

  final bindings = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: bindings);
  await EasyLocalization.ensureInitialized();
  await AppPreferences.init();

  if (defaultTargetPlatform == TargetPlatform.android) {
    // 안드로이드 플랫폼인 경우 Firebase 초기화를 실행합니다.
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  timeago.setLocaleMessages('ko', timeago.KoMessages());
  runApp(EasyLocalization(
      supportedLocales: const [Locale('ko')],
      fallbackLocale: const Locale('ko'),
      path: 'assets/translations',
      useOnlyLangCode: true,
      child: const CustomThemeApp(
        child: const ProviderScope(child: App()),
      )));
}
