import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:winetopia/models/wine_transaction.dart';
import 'package:winetopia/models/winetopia_user.dart';
import 'package:winetopia/screens/transaction_history/wine_transaction_info_widget.dart';
import 'package:winetopia/services/database_service.dart';
import 'package:winetopia/shared/loading.dart';

/// Widget showing list of wine transactions
class TransactionList extends StatelessWidget {
  final int? limit; // Limit to show only a certain number of transactions

  const TransactionList({
    super.key,
    this.limit,
  });

  @override
  Widget build(BuildContext context) {
    final currentUser = Provider.of<WinetopiaUser?>(context);

    return StreamBuilder<List<WineTransaction>>(
      stream: DataBaseService(uid: currentUser!.uid).allTransactions,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text('Error loading transactions'));
        }

        if (!snapshot.hasData) {
          return const Center(child: Loading());
        }

        final transactions = snapshot.data ?? [];
        if (transactions.isEmpty) {
          return const Center(child: Text('No transactions yet'));
        }

        final displayedTransactions =
            limit != null ? transactions.take(limit!).toList() : transactions;

        return limit != null
            ? ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: displayedTransactions.length,
                itemBuilder: (context, index) {
                  final transaction = displayedTransactions[index];
                  return Container(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    margin: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: WineTransactionInfoWidget(transaction: transaction),
                  );
                },
              )
            : Column(
                children: [
                  Container(
                    height: 6,
                    color: Colors.transparent,
                  ),
                  Expanded(
                    child: ListView.builder(
                      physics: limit != null
                          ? const NeverScrollableScrollPhysics()
                          : null,
                      shrinkWrap: true,
                      itemCount: displayedTransactions.length,
                      itemBuilder: (context, index) {
                        final transaction = displayedTransactions[index];
                        return Container(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          margin: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: WineTransactionInfoWidget(
                              transaction: transaction),
                        );
                      },
                    ),
                  ),
                ],
              );
      },
    );
  }
}
