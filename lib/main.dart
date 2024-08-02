import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:winetopia/firebase_options.dart';
import 'package:winetopia/models/winetopia_user.dart';
import 'package:winetopia/services/auth.dart';
import 'screens/wrapper.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<WinetopiaUser?>.value(
      initialData: null,
      value: AuthService().user, //specifying StreamProvider will listen to the user stream
      child: MaterialApp(
        home: Wrapper(),
      ),
    );
  }
}
