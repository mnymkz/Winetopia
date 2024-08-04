// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:provider/provider.dart';

// class Attendee extends StatefulWidget {
//   const Attendee({super.key});

//   @override
//   State<Attendee> createState() => _AttendeeState();
// }

// class _AttendeeState extends State<Attendee> {
//   @override
//   Widget build(BuildContext context) {

//     final attendee = Provider.of<QuerySnapshot>(context);
//     for(var doc in attendee.docs)
//     {
//       print(doc.data);
//     }
//     return const Placeholder();
//   }
// }