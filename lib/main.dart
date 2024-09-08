import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:winetopia/models/nfc_state.dart';
import 'package:winetopia/models/winetopia_user.dart';
import 'package:winetopia/services/auth.dart';
import 'screens/wrapper.dart';
import 'utils/stripe_config.dart';
import 'utils/firebase_config.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await dotenv.load();
  await setupStripe(); //setup stripe
  await setupFirebase(); //setup firebase

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
