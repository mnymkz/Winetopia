import "package:flutter_stripe/flutter_stripe.dart";
import "package:dio/dio.dart";
import "package:flutter_dotenv/flutter_dotenv.dart";

class StripeService {
  //singleton instance of StripeService
  StripeService._();

  static final StripeService instance = StripeService._();

  ///makePayment creates a payment when the user clicks the button
  ///Takes in the price id of the gold/silver token from the Stripe dashboard and quantiy of tokens
  Future<void> makePayment(String priceId, {int quantity = 1}) async {
    try {
      //create a payment intent using the price id of the token and quantity
      String? paymentIntentClientSecret =
          await _createPaymentIntent(priceId, quantity);

      if (paymentIntentClientSecret == null) return;

      //init payment sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntentClientSecret,
          merchantDisplayName: "Winetopia",
        ),
      );

      //process payment
      await _processPayment();
    } catch (e) {
      print(e);
    }
  }

  ///creates a payment intent using the Stripe API
  ///takes in price id and quantity
  Future<String?> _createPaymentIntent(String priceId, int quantity) async {
    try {
      //dio object for HTTP requests
      final Dio dio = Dio();

      //payment data
      Map<String, dynamic> data = {
        "payment_method_types[]": "card", // Specify payment method type
        "amount": await _getProductAmount(
            priceId, quantity), // Get product amount multiplied by quantity
        "currency": "nzd", // Currency in New Zealand dollars
      };

      //send a POST request to Stripe API
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

      //if response data is not empty, return the client secret string
      if (response.data != null) {
        return response.data["client_secret"];
      }
      return null;
    } catch (e) {
      print(e);
    }
    return null;
  }

  ///gets the product amount from Stripe and multiplies it by the quantity
  Future<int> _getProductAmount(String priceId, int quantity) async {
    try {
      //send a GET request to Stripe API to retrieve the product's price
      final Dio dio = Dio();
      var response = await dio.get(
        "https://api.stripe.com/v1/prices/$priceId",
        options: Options(
          headers: {
            "Authorization": "Bearer ${dotenv.env['STRIPE_SECRET_KEY']}",
          },
        ),
      );

      //parse the price from the response and multiply by the quantity
      if (response.data != null) {
        int unitAmount = response.data["unit_amount"];
        return unitAmount * quantity; //multiply the unit amount by the quantity
      }
    } catch (e) {
      print(e);
    }

    //return 0 if there's an error
    return 0;
  }

  /// Process payment by presenting the payment sheet to the user and confirming the payment
  Future<void> _processPayment() async {
    try {
      await Stripe.instance.presentPaymentSheet();
      await Stripe.instance.confirmPaymentSheetPayment();
    } catch (e) {
      print(e);
    }
  }
}
