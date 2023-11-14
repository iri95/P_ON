// import 'package:flutter/material.dart';
// import 'package:p_on/common/common.dart';
//
// class Messages extends StatelessWidget {
//   final Stream<List<Map<String, dynamic>>> messagesStream;
//
//   const Messages({super.key, required this.messagesStream});
//
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder(
//         stream: messagesStream,
//         builder: (BuildContext context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
//           if (snapshot.hasData) {
//             return ListView.builder(
//               itemCount: snapshot.data!.length,
//               itemBuilder: (context, index) {
//                 return ListTile(
//                   title: Text('${snapshot.data![index]['sender']}:'),
//                   subtitle: Text(snapshot.data![index]['content']),
//                 );
//               },
//             );
//           } else {
//             return Center(child: CircularProgressIndicator());
//           }
//         }
//     );
//   }
// }
