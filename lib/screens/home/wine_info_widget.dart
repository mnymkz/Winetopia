import 'package:flutter/material.dart';
import 'package:winetopia/models/wine_sample.dart';

class WinePurchaseInfoWidget extends StatelessWidget {
  final WineSample? wine;

  const WinePurchaseInfoWidget({Key? key, required this.wine})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (wine == null) {
      return const SizedBox(); // Return an empty widget if wine is null
    }

    return Center(
        child: Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      color: Colors.purple,
      child: ListTile(
        contentPadding: const EdgeInsets.all(16.0),
        leading: CircleAvatar(
          backgroundColor: Colors.purple[200],
          child: Text(
            '${wine!.tPrice}',
            style: const TextStyle(color: Colors.white),
          ),
        ),
        title: Text(
          wine!.name,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          'Exhibitor: ${wine!.exhibitorId}',
          style: const TextStyle(fontSize: 16),
        ),
      ),
    ));
  }
}
