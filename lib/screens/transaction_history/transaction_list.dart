import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:winetopia/models/wine_transaction.dart';
import 'package:winetopia/models/winetopia_user.dart';
import 'package:winetopia/screens/transaction_history/wine_transaction_info_widget.dart';
import 'package:winetopia/services/database_service.dart';
import 'package:winetopia/shared/loading.dart';

/// Widget showing list of wine transactions
class TransactionList extends StatefulWidget {
  final int? limit;
  const TransactionList({
    super.key,
    this.limit,
  });

  @override
  State<TransactionList> createState() => _TransactionListState();
}

class _TransactionListState extends State<TransactionList> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

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

        final displayedTransactions = widget.limit != null
            ? transactions.take(widget.limit!).toList()
            : transactions;

        return widget.limit != null
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
            : Padding(
                padding: const EdgeInsets.only(top: 15, left: 10, right: 10),
                child: Expanded(
                  child: CupertinoScrollbar(
                    thumbVisibility: true,
                    controller: _scrollController,
                    child: ListView.builder(
                      controller: _scrollController,
                      physics: const AlwaysScrollableScrollPhysics(),
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
                ),
              );
      },
    );
  }
}
