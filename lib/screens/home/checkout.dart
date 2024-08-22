import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // First token input
            Text(
              'Enter silver token amount:',
              style: const TextStyle(fontSize: 18),
            ),
            TextField(
              controller: _tokenAmountController1,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                FilteringTextInputFormatter.allow(
                    RegExp(r'^([1-9]|10)$')), // Limits input to 1-10
              ],
              decoration: const InputDecoration(
                hintText: 'Enter a number between 1 and 10',
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // Handle purchase logic for the first token amount
                _purchaseTokens(
                    int.tryParse(_tokenAmountController1.text) ?? 1);
              },
              child: const Text('Purchase Silver Token'),
            ),
            const SizedBox(height: 20),

            // Second token input
            Text(
              'Enter gold token amount:',
              style: const TextStyle(fontSize: 18),
            ),
            TextField(
              controller: _tokenAmountController2,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                FilteringTextInputFormatter.allow(
                    RegExp(r'^([1-9]|10)$')), // Limits input to 1-10
              ],
              decoration: const InputDecoration(
                hintText: 'Enter a number between 1 and 10',
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // Handle purchase logic for the second token amount
                _purchaseTokens(
                    int.tryParse(_tokenAmountController2.text) ?? 1);
              },
              child: const Text('Purchase Gold Token'),
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
