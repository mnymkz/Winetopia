import 'package:flutter/material.dart';
import 'package:winetopia/services/stripe_service.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final TextEditingController _silverTokenController =
      TextEditingController(text: '1');
  final TextEditingController _goldTokenController =
      TextEditingController(text: '1');

  @override
  void dispose() {
    _silverTokenController.dispose();
    _goldTokenController.dispose();
    super.dispose();
  }

  //price ids
  final String _silverTokenPriceId = 'price_1PpOMDIMm5TYEIRdJyM8qm2k';
  final String _goldTokenPriceId = 'price_1PwhK7IMm5TYEIRdnVROX7Ya';

  // Validate the quantity input (must be an integer >= 1)
  int _validateQuantity(String quantityText) {
    final quantity = int.tryParse(quantityText);
    if (quantity == null || quantity <= 0) {
      return 1; // default to 1 if invalid
    }
    return quantity;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Silver Token Section
            TextField(
              controller: _silverTokenController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Enter number of Silver Tokens',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            MaterialButton(
              onPressed: () async {
                // Get the quantity of silver tokens
                final silverTokenQuantity =
                    _validateQuantity(_silverTokenController.text);

                // Multiply the amount by the quantity and pass it to Stripe
                await StripeService.instance.makePayment(
                  _silverTokenPriceId,
                  quantity: silverTokenQuantity,
                );
              },
              color: Colors.green,
              child: const Text(
                "Purchase Silver Tokens",
              ),
            ),
            const SizedBox(height: 30),

            // Gold Token Section
            TextField(
              controller: _goldTokenController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Enter number of Gold Tokens',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            MaterialButton(
              onPressed: () async {
                // Get the quantity of gold tokens
                final goldTokenQuantity =
                    _validateQuantity(_goldTokenController.text);

                // Multiply the amount by the quantity and pass it to Stripe
                await StripeService.instance.makePayment(
                  _goldTokenPriceId,
                  quantity: goldTokenQuantity,
                );
              },
              color: Colors.amber,
              child: const Text(
                "Purchase Gold Tokens",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
