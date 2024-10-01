import 'package:flutter/material.dart';
import 'package:winetopia/services/stripe_service.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
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
      //print(success);
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
        centerTitle: true,
        title: const Text(
          'Top Up',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            letterSpacing: 2.0,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF292663),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0.0,
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
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFD3D3D3), width: 2.0),
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF00DEC3), width: 2.0),
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            MaterialButton(
              onPressed: () =>
                  _handlePurchase(_silverTokenPriceId, _silverTokenController),
              color: const Color(0xFF00DEC3),
              padding:
                  const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0)),
              child: const Text("Purchase Silver Tokens",
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 100),

            // Gold token button
            TextField(
              controller: _goldTokenController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Enter number of Gold Tokens',
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFD3D3D3), width: 2.0),
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.amber, width: 2.0),
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            MaterialButton(
              onPressed: () =>
                  _handlePurchase(_goldTokenPriceId, _goldTokenController),
              color: Colors.amber,
              padding:
                  const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0)),
              child: const Text("Purchase Gold Tokens",
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 20),
            // Display error message if any
            if (_errorMessage != null) ...[
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10.0),
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: Colors.red[50], // Light red background for the box
                  borderRadius: BorderRadius.circular(8.0), // Rounded corners
                  border: Border.all(
                      color: Colors.red), // Border color matching the message
                ),
                child: Text(
                  _errorMessage!,
                  style: const TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold, // Make the error message bold
                  ),
                ),
              ),
            ],

// Display confirmation message if any
            if (_confirmationMessage != null) ...[
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10.0),
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: Colors.green[50], // Light green background for the box
                  borderRadius: BorderRadius.circular(8.0), // Rounded corners
                  border: Border.all(
                      color: Colors.green), // Border color matching the message
                ),
                child: Text(
                  _confirmationMessage!,
                  style: const TextStyle(
                    color: Colors.green,
                    fontWeight:
                        FontWeight.bold, // Bold text for confirmation message
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
