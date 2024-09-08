import "package:flutter_stripe/flutter_stripe.dart";
import "package:dio/dio.dart";
import "package:flutter_dotenv/flutter_dotenv.dart";

class StripeService {
  StripeService._();

  static final StripeService instance = StripeService._();

  ///makePayment function creates a payment
  Future<void> makePayment() async {
    try {
      String? paymentIntentClientSecret = await _createPaymentIntent(
        1,
        "nzd",
      );
      if (paymentIntentClientSecret == null) return;
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntentClientSecret,
          merchantDisplayName: "Winetopia",
        ),
      );
      await _processPayment();
    } catch (e) {
      print(e);
    }
  }

  ///createPaymentIntent takes in an amount, and a currency
  ///returns a payment intent string from the response
  Future<String?> _createPaymentIntent(int amount, String currency) async {
    try {
      final Dio dio = Dio();
      Map<String, dynamic> data = {
        "amount": _calculateAmount(
          amount,
        ),
        "currency": currency,
      };
      var response = await dio.post(
        "https://api.stripe.com/v1/payment_intents",
        data: data,
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          headers: {
            "Authorization": "Bearer ${dotenv.env['STRIPE_SECRET_KEY']}",
            "Content-Type": 'application/x-www-form-urlencoded'
          },
        ),
      );
      if (response.data != null) {
        return response.data["client_secret"];
      }
      return null;
    } catch (e) {
      print(e);
    }
    return null;
  }

  ///
  Future<void> _processPayment() async {
    try {
      await Stripe.instance.presentPaymentSheet();
      await Stripe.instance.confirmPaymentSheetPayment();
    } catch (e) {
      print(e);
    }
  }

  String _calculateAmount(int amount) {
    final calculatedAmount = amount * 100;
    return calculatedAmount.toString();
  }
}
