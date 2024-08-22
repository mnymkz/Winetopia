import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:winetopia/firebase_options.dart';
import 'package:winetopia/models/nfc_state.dart';
import 'package:winetopia/models/winetopia_user.dart';
import 'package:winetopia/services/auth.dart';
import 'screens/wrapper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final nfcStateStream = NfcStateStream();

  runApp(
    MultiProvider(
      providers: [
        StreamProvider<NfcState>.value(
          value: nfcStateStream.stream,
          initialData: NfcState.idle, // the default state is idle
        ),
        Provider<NfcStateStream>.value(
          value: nfcStateStream,
        ),
        StreamProvider<WinetopiaUser?>.value(
          // Specifying stream provider will listen to the user stream
          initialData: null,
          value: AuthService().user,
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Wrapper(),
    );
  }
}
