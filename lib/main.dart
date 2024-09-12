import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:winetopia/firebase_options.dart';
import 'package:winetopia/shared/nfc_state.dart';
import 'package:winetopia/models/winetopia_user.dart';
import 'package:winetopia/services/auth.dart';
import 'screens/wrapper.dart';
import 'utils/stripe_config.dart';
import 'utils/firebase_config.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await dotenv.load(fileName: ".env"); //load environment variables
  } catch (e) {
    print("error loading environment variables");
  }

  try {
    await setupStripe(); //setup stripe
  } catch (e) {
    print("error initialising stripe key");
  }

  try {
    await setupFirebase(); //setup firebase
  } catch (e) {
    print("error initialising firebase");
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<NfcState>(
          create: (context) => NfcState(),
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
    return const MaterialApp(
      home: Wrapper(),
    );
  }
}
