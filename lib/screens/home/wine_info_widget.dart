import 'dart:math';
import 'package:flutter/material.dart';
import 'package:winetopia/models/wine_sample.dart';

/// Widget displaying most recently purchased wine sample
class WineInfoWidget extends StatelessWidget {
  final WineSample? wine;

  const WineInfoWidget({super.key, required this.wine});

  @override
  Widget build(BuildContext context) {
    if (wine == null) {
      return const SizedBox(); // Return an empty widget if wine is null
    }

    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16.0),
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        decoration: BoxDecoration(
          color: Colors.transparent, // Make the background color transparent
          borderRadius: BorderRadius.circular(20.0),
          border: Border.all(
            color: Colors.purple, // Border color
            width: 2.0, // Border width
          ),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.all(8.0),
          leading: Container(
            padding: const EdgeInsets.all(5.0),
            decoration: BoxDecoration(
              color:
                  Colors.purple[500], // Background color for the leading widget
              borderRadius: BorderRadius.circular(10.0), // Rounded corners
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                // Use constraints.maxHeight to size the icon
                final double iconSize = min(constraints.maxHeight * 0.6, 40.0);
                final double textSize = min(constraints.maxHeight * 0.25, 20.0);

                return Column(
                  mainAxisAlignment:
                      MainAxisAlignment.center, // Center content vertically
                  children: [
                    Icon(
                      Icons.wine_bar,
                      color: Colors.white,
                      size: iconSize,
                    ),
                    Text(
                      '${wine!.tPrice} ${wine!.tPrice > 1 ? 'tokens' : 'token'}',
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
            wine!.name,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            wine!.exhibitor.name,
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}
