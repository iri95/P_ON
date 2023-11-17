/**
 * TODO: S3를 클라이언트에서만 시도하면, 보안상의 문제가 매우 취약함
 * 왜냐하면 아무리 config 같은 걸로 숨긴다고 해도, 
 * 결국 앱 빌드할 때 시크릿 키 그냥 다 올려짐
 * 안올리면 동작 안됨
 * 
 * 이거 숨기려면 presignedUrl 써야하는데
 * 이거 쓰려면 백엔드에서 url 만들어주는 로직을 짜고
 * 그 url을 요청 받아서 뭐시기 해야함
 * 
 * 지금 그럴 시간 없음 S3 일단 미룸
 **/ 

// import 'package:dio/dio.dart';
// import 'dart:io';
// import 'package:flutter_aws_s3_client/flutter_aws_s3_client.dart';

// // AWS S3 클라이언트를 초기화합니다.
// var s3client = AwsS3Client(
//   accessKey: 'YOUR_ACCESS_KEY',
//   secretKey: 'YOUR_SECRET_KEY',
//   bucket: 'YOUR_BUCKET_NAME',
//   region: 'YOUR_BUCKET_REGION',
// );

// // 파일을 업로드하기 위한 파일 객체를 생성합니다.
// File file = File('path_to_your_file');

// // 파일을 S3에 업로드합니다.
// try {
//   String uploadedImageUrl = await s3client.uploadFile(
//     file.path,
//     'your-desired-s3-key-for-file', // 예: 'uploads/myfile.png'
//   );
//   print('Uploaded image URL: $uploadedImageUrl');
// } catch (e) {
//   print('Error uploading file: $e');
// }
