import 'package:dio/dio.dart';
import 'dart:io';

// 파일 확장자 추출
String getExt(String filePath) {
  return filePath.split('.').last;
}

Future<Result<String>> s3upload(
  String signedUrl,
  File file,
) async {
  String ext = getExt(file.path);
  print('확장자 : ' + ext);
  print('파일크기 : ' +
      (file.lengthSync() / 1024.0 / 1024.0).toStringAsFixed(2) +
      'MB');

  final Dio dio = Dio();

  final Response response = await dio.putUri(Uri.parse(signedUrl),
      data: file.openRead(),
      options: Options(contentType: 'image/' + ext, headers: <String, dynamic>{
        // HttpHeaders.contentTypeHeader: ContentType('image', ext), //추가하면 에러
        HttpHeaders.contentLengthHeader: file.lengthSync()
      }));
}
