//purchase_tokens screen contains the screen with the purchase token button
import 'package:flutter/material.dart';

class PurchaseTokensScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Purchase Tokens'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Placeholder action
            print('Purchase Tokens button pressed');
          },
          child: Text('Purchase Tokens'),
        ),
      ),
    );
  }
}
