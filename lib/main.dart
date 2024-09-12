import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamProvider<WinetopiaUser?>.value(
        initialData: null,
        value: AuthService()
            .user, // Specifying StreamProvider will listen to the user stream
        child: const MaterialApp(
          home: Wrapper(),
        ));
  }
}
