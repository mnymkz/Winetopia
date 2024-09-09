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
  String? _errorMessage;
  String? _confirmationMessage; // New variable for confirmation message

  @override
  void dispose() {
    _silverTokenController.dispose();
    _goldTokenController.dispose();
    super.dispose();
  }

  //price ids
  final String _silverTokenPriceId = 'price_1PpOMDIMm5TYEIRdJyM8qm2k';
  final String _goldTokenPriceId = 'price_1PwhK7IMm5TYEIRdnVROX7Ya';

  //validate the quantity input (must be >= 1)
  int _validateQuantity(String quantityText) {
    final quantity = int.tryParse(quantityText);
    if (quantity == null || quantity <= 0) {
      return 1; // default to 1 if invalid
    }
    return quantity;
  }

  //handle purchase error messages
  Future<void> _handlePurchase(
      String priceId, TextEditingController controller) async {
    setState(() {
      _errorMessage = null; // Clear previous error message
      _confirmationMessage = null; // Clear previous confirmation message
    });

    final quantity = _validateQuantity(controller.text);

    try {
      final success =
          await StripeService.instance.makePayment(priceId, quantity: quantity);
      print(success);
      if (success) {
        setState(() {
          _confirmationMessage =
              'Your purchase was successful!'; // Update confirmation message
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString(); // Display error message to the user
      });
    }
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
            // Silver button
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
              onPressed: () =>
                  _handlePurchase(_silverTokenPriceId, _silverTokenController),
              color: Colors.green,
              child: const Text("Purchase Silver Tokens"),
            ),
            const SizedBox(height: 30),

            // Gold token button
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
              onPressed: () =>
                  _handlePurchase(_goldTokenPriceId, _goldTokenController),
              color: Colors.amber,
              child: const Text("Purchase Gold Tokens"),
            ),
            const SizedBox(height: 20),
            // Display error message if any
            if (_errorMessage != null) ...[
              Text(
                _errorMessage!,
                style: TextStyle(color: Colors.red),
              ),
            ],
            // Display confirmation message if any
            if (_confirmationMessage != null) ...[
              Text(
                _confirmationMessage!,
                style:
                    TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
