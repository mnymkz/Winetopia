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
            MaterialButton(
              onPressed: () {
                StripeService.instance.makePayment();
              },
              color: Colors.green,
              child: const Text(
                "Purchase",
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Placeholder function for purchasing tokens
  void _purchaseTokens(int tokenAmount) {
    // Implement the logic for purchasing tokens based on tokenAmount
    print('Purchased $tokenAmount tokens');
  }
}
