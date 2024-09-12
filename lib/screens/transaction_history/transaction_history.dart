import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:winetopia/models/winetopia_user.dart';
import 'package:winetopia/screens/transaction_history/transaction_list.dart';
import 'package:winetopia/services/database_service.dart';
import 'package:winetopia/models/wine_transaction.dart';

/// TransactionHistoryScreen widget displays all the user's wine transactions
class TransactionHistoryScreen extends StatelessWidget {
  const TransactionHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = Provider.of<WinetopiaUser?>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      body: StreamBuilder<List<WineTransaction>>(
        stream: DataBaseService(uid: currentUser!.uid)
            .allTransactions, // Listening to transactions stream
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Error loading transactions'));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          List<WineTransaction> transactions = snapshot.data!;

          return TransactionList(
            transactions: transactions, // Shows all transactions
          );
        },
      ),
    );
  }
}
