import 'package:flutter/material.dart';
import 'package:winetopia/models/wine_transaction.dart';
import 'package:winetopia/screens/transaction_history/wine_transaction_info_widget.dart';

/// Widget showing list of wine transactions
class TransactionList extends StatelessWidget {
  final List<WineTransaction> transactions;
  final int? limit; // Limit to show only a certain number of transactions

  const TransactionList({
    super.key,
    required this.transactions,
    this.limit,
  });

  @override
  Widget build(BuildContext context) {
    final displayedTransactions =
        limit != null ? transactions.take(limit!).toList() : transactions;

    if (displayedTransactions.isEmpty) {
      return const Center(child: Text('No transactions yet'));
    }

    return ListView.builder(
      physics: limit != null ? const NeverScrollableScrollPhysics() : null,
      shrinkWrap: true,
      itemCount: displayedTransactions.length,
      itemBuilder: (context, index) {
        final transaction = displayedTransactions[index];
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          margin: const EdgeInsets.symmetric(horizontal: 15.0),
          child: WineTransactionInfoWidget(transaction: transaction),
        );
      },
    );
  }
}
