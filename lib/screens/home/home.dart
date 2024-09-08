import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:winetopia/models/wine_transaction.dart';
import 'package:winetopia/models/winetopia_user.dart';
import 'package:winetopia/screens/home/nfc_button.dart';
import 'package:winetopia/screens/navigation.dart';
import 'package:winetopia/screens/profile.dart';
import 'package:winetopia/screens/transaction_history/transaction_list.dart';
import 'package:winetopia/services/database.dart';
import 'package:winetopia/shared/loading.dart';

/// HomeScreen widget serves as the main screen of the app where users can pay
/// for wine samples and see their most recent wine transactions.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final currentUser = Provider.of<WinetopiaUser?>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      body: Center(
          child: Column(
        children: [
          const SizedBox(height: 20),

          // User's gold and silver token balance
          StreamBuilder<UserData>(
            stream: DataBaseService(uid: currentUser!.uid).userData,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Center(child: Text('Error loading user'));
              }

              if (!snapshot.hasData) {
                return const Center(child: Loading());
              }

              UserData? userData = snapshot.data;

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(5.0),
                        height: 50.0,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.purple, width: 2),
                          borderRadius: BorderRadius.circular(12.0),
                          color: Colors.purple,
                        ),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 50.0),
                                child: Text(
                                  'Gold: ${userData?.goldTokens}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 50.0),
                                child: Text(
                                  'Silver: ${userData?.silverTokens}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              )
                            ]),
                      ),
                    ),
                    const SizedBox(width: 5),
                    Container(
                      height: 50.0,
                      padding: const EdgeInsets.all(5.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.purple, width: 2),
                        borderRadius: BorderRadius.circular(12.0),
                        color: Colors.purple[200],
                      ),
                      child: const Text('TOP\n UP',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 15),

          // Nfc Button that starts an Nfc reading session
          const NfcButton(),
          const SizedBox(height: 15),

          // Recent Transactions
          Flexible(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 15.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.purple, width: 2),
                borderRadius: BorderRadius.circular(8.0),
                color: const Color(0x1A761973),
              ),
              child: Column(
                children: [
                  // Recent Transactions title
                  const Text(
                    'Recent Transactions',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      letterSpacing: 2.0,
                    ),
                  ),
                  const SizedBox(height: 2.0),

                  // Fetch and display three most recent wine transactions
                  Expanded(
                    child: StreamBuilder<List<WineTransaction>>(
                      stream:
                          DataBaseService(uid: currentUser.uid).allTransactions,
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return const Center(
                              child: Text('Error loading transactions'));
                        }

                        if (!snapshot.hasData) {
                          return const Center(child: Loading());
                        }

                        List<WineTransaction> transactions =
                            snapshot.data ?? [];

                        if (transactions.isEmpty) {
                          return const Center(
                              child: Text('No transactions yet'));
                        }

                        return TransactionList(
                          transactions: transactions,
                          limit: 3,
                        );
                      },
                    ),
                  ),

                  // "See More" button
                  Align(
                    alignment: Alignment.bottomRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => const NavigationScreen(
                                initialIndex: 1), // TransactionHistoryPage
                          ),
                        );
                      },
                      child: const Text(
                        'See more...',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 15.0),
          Center(
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => NewScreen()),
                    );
                  },
                  child: const Text('My Profile'))),
        ],
      )),
    );
  }
}
