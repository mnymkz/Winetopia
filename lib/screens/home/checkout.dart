import 'package:flutter/material.dart';
import 'package:winetopia/services/stripe_service.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final TextEditingController _tokenAmountController1 =
      TextEditingController(text: '1');
  final TextEditingController _tokenAmountController2 =
      TextEditingController(text: '1');

  @override
  void dispose() {
    _tokenAmountController1.dispose();
    _tokenAmountController2.dispose();
    super.dispose();
  }

  //price ids
  final String _silverTokenPriceId = 'price_1PpOMDIMm5TYEIRdJyM8qm2k';
  final String _goldTokenPriceId = 'price_1PwhK7IMm5TYEIRdnVROX7Ya';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
      ),
      body: SizedBox.expand(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Silver token purchase button
            MaterialButton(
              onPressed: () async {
                //make payment using silver token ID
                await StripeService.instance.makePayment(_silverTokenPriceId);
              },
              color: Colors.green,
              child: const Text(
                "Purchase Silver Token",
              ),
            ),
            const SizedBox(height: 20),
            // Gold token purchase button
            MaterialButton(
              onPressed: () async {
                //make payment using gold token id
                await StripeService.instance.makePayment(_goldTokenPriceId);
              },
              color: Colors.amber,
              child: const Text(
                "Purchase Gold Token",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
