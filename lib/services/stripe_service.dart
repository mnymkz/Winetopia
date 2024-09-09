import "package:flutter_stripe/flutter_stripe.dart";
import "package:dio/dio.dart";
import "package:flutter_dotenv/flutter_dotenv.dart";

class StripeService {
  //singleton instance of stripe service class
  StripeService._();

  static final StripeService instance = StripeService._();

  ///makePayment function creates a payment when the user clicks the button
  ///takes in the price id of the gold/silver token from the stripe dashboard
  Future<void> makePayment(String priceId) async {
    try {
      //create a payment intent using price id of the token
      String? paymentIntentClientSecret = await _createPaymentIntent(priceId);

      if (paymentIntentClientSecret == null) return;

      //initialise payment sheet
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
}

Future<String?> _createPaymentIntent(String priceId) async {
  try {
    //dio object
    final Dio dio = Dio();

    //payment data
    Map<String, dynamic> data = {
      "payment_method_types[]": "card", // Specify payment method type
      "amount":
          await _getProductAmount(priceId), // Get product amount from Stripe
      "currency": "nzd", //currency
    };

    //send a post request to stripe api
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

Future<int> _getProductAmount(String priceId) async {
  try {
    //send a get request to stripe api
    final Dio dio = Dio();
    var response = await dio.get(
      "https://api.stripe.com/v1/prices/$priceId",
      options: Options(
        headers: {
          "Authorization": "Bearer ${dotenv.env['STRIPE_SECRET_KEY']}",
        },
      ),
    );

    //parse the price from the response
    if (response.data != null) {
      return response.data["unit_amount"];
    }
  } catch (e) {
    print(e);
  }

  //return 0 if error
  return 0;
}

///process payment presents the payment sheet to the user and confirms the payment
///on success
Future<void> _processPayment() async {
  try {
    await Stripe.instance.presentPaymentSheet();
    await Stripe.instance.confirmPaymentSheetPayment();
  } catch (e) {
    print(e);
  }
}

// //_calculateAmount converts cents to dollars
// String _calculateAmount(int amount) {
//   final calculatedAmount = amount * 100;
//   return calculatedAmount.toString();
// }

// Future<void> makePayment() async {
//   try {
//     String? paymentIntentClientSecret = await _createPaymentIntent(
//       1,
//       "nzd",
//     );
//     if (paymentIntentClientSecret == null) return;
//     await Stripe.instance.initPaymentSheet(
//       paymentSheetParameters: SetupPaymentSheetParameters(
//         paymentIntentClientSecret: paymentIntentClientSecret,
//         merchantDisplayName: "Winetopia",
//       ),
//     );
//     await _processPayment();
//   } catch (e) {
//     print(e);
//   }
// }

///createPaymentIntent takes in an amount, and a currency
///returns a payment intent string from the response
// Future<String?> _createPaymentIntent(int amount, String currency) async {
//   try {
//     final Dio dio = Dio();
//     Map<String, dynamic> data = {
//       "amount": _calculateAmount(
//         amount,
//       ),
//       "currency": currency,
//     };
//     var response = await dio.post(
//       "https://api.stripe.com/v1/payment_intents",
//       data: data,
//       options: Options(
//         contentType: Headers.formUrlEncodedContentType,
//         headers: {
//           "Authorization": "Bearer ${dotenv.env['STRIPE_SECRET_KEY']}",
//           "Content-Type": 'application/x-www-form-urlencoded'
//         },
//       ),
//     );
//     if (response.data != null) {
//       return response.data["client_secret"];
//     }
//     return null;
//   } catch (e) {
//     print(e);
//   }
//   return null;
// }
