// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:provider/provider.dart';
// import 'package:winetopia/services/auth.dart';

// class Attendee extends StatefulWidget {
//   const Attendee({super.key});
//   @override
//   State<Attendee> createState() => _AttendeeState();
// }

// class _AttendeeState extends State<Attendee> {
//   late AuthService auth;
//   late dynamic uid;

//   @override
//   void initState() {
//     super.initState();
//     auth = AuthService();
//     auth.setUserId();
//     uid = auth.userID;
//   }
//   @override
//   Widget build(BuildContext context) {
//     final attendee = Provider.of<QuerySnapshot?>(context);
//     if(attendee!=null){
//       for(var doc in attendee.docs){
//         print(doc.data());
//       }
//     }
//     return Container(
//       child: Center(
//         child: attendee != null
//             ? ListView.builder(
//                 itemCount: attendee.docs.length,
//                 itemBuilder: (context, index) {
//                   var doc = attendee.docs[index];
//                   var data = doc.data() as Map<String, dynamic>;
//                   return ListTile(
//                     title: Text(data['fname'] ?? 'No name'),
//                     subtitle: Text(data['email'] ?? 'No email'),
//                   );
//                 },
//               )
//             : CircularProgressIndicator(),
//     ));
//   }
// }