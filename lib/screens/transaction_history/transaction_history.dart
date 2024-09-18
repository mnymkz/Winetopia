import 'package:flutter/material.dart';
import 'package:winetopia/screens/transaction_history/transaction_list.dart';

/// TransactionHistoryScreen widget displays all the user's wine transactions
class TransactionHistoryScreen extends StatelessWidget {
  const TransactionHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const TransactionList();
  }
}
