import 'dart:math';
import 'package:flutter/material.dart';
import 'package:winetopia/models/wine_transaction.dart';

/// Widget displaying wine transaction information
class WineTransactionInfoWidget extends StatelessWidget {
  final WineTransaction transaction;

  const WineTransactionInfoWidget({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      decoration: BoxDecoration(
        color: const Color(0x40761973),
        borderRadius: BorderRadius.circular(15.0),
        border: Border.all(
          color: Colors.purple,
          width: 1.0,
        ),
      ),
      child: ListTile(
        dense: true,
        contentPadding: const EdgeInsets.all(0),
        leading: Container(
          width: 62.0,
          padding: const EdgeInsets.all(5.0),
          decoration: BoxDecoration(
            color: const Color(0xE6761973),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final double iconSize = min(constraints.maxHeight * 0.6, 40.0);
              final double textSize = min(constraints.maxHeight * 0.25, 20.0);

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.wine_bar,
                    color: transaction.isGoldPurchase
                        ? Colors.amber
                        : Colors.white,
                    size: iconSize,
                  ),
                  Text(
                    '${transaction.cost} ${transaction.cost > 1 ? 'tokens' : 'token'}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: textSize,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        title: Text(
          transaction.wineName,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          transaction.exhibitorName,
          style: const TextStyle(fontSize: 14),
        ),
      ),
    );
  }
}
