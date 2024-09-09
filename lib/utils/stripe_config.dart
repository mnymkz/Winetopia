import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> setupStripe() async {
  // final publishableKey = dotenv.env['STRIPE_PUBLISHABLE_KEY']!;
  Stripe.publishableKey =
      'pk_test_51PpNEkIMm5TYEIRdgj0CZHknQEqYTgyTau05XJNNaDeA2DkdSTsCJQqSFliKGM2ObTqdHX837HXlosFGTyVArbS8009pjBOB7G';
}
