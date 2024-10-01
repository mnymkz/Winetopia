// ignore_for_file: use_super_parameters

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:winetopia/models/winetopia_user.dart';
import 'package:winetopia/screens/authenticate/authenticate.dart';
import 'package:winetopia/screens/home/nfc_purchase_button.dart';
import 'package:winetopia/screens/navigation.dart';
import 'package:winetopia/screens/transaction_history/transaction_list.dart';
import 'package:winetopia/screens/home/checkout.dart';
import 'package:winetopia/services/database_service.dart';
import 'package:winetopia/shared/loading.dart';
import 'package:winetopia/shared/nfc_state.dart';

/// HomeScreen widget serves as the main screen of the app where users can pay
/// for wine samples and see their most recent wine transactions.
class HomeScreen extends StatefulWidget {
  final GlobalKey<NavigationScreenState>? navKey;
  const HomeScreen({Key? key, this.navKey}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final currentUser = Provider.of<WinetopiaUser?>(context);

    return currentUser == null
        ? const Authenticate()
        : Center(
            child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(height: 10),

              StreamBuilder<UserData>(
                stream: DataBaseService(uid: currentUser.uid).userData,
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
                        // Gold and silver token balance
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(0),
                            height: 50.0,
                            decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.purple, width: 2),
                              borderRadius: BorderRadius.circular(12.0),
                              color: Colors.purple,
                            ),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    'Gold: ${userData?.goldTokens}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                  Text(
                                    'Silver: ${userData?.silverTokens}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  )
                                ]),
                          ),
                        ),
                        const SizedBox(width: 10),

                        //Button to checkout screen
                        Container(
                          width: 60,
                          height: 50.0,
                          padding: const EdgeInsets.all(4.0),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.purple, width: 2),
                            borderRadius: BorderRadius.circular(12.0),
                            color: Colors.purple[200],
                          ),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const CheckoutScreen(),
                                ),
                              ).then((_) {
                                // Reset NFC state or perform other actions here
                                Provider.of<NfcState>(context, listen: false)
                                    .resetState();
                              });
                            },
                            child: const Text(
                              'TOP UP',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 10),

              // Nfc Button that starts an Nfc reading session
              const NfcPurchaseButton(),
              const SizedBox(height: 10),

              // Recent Transactions
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 15.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.purple, width: 2),
                  borderRadius: BorderRadius.circular(15.0),
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

                    // Wine Transactions list
                    const TransactionList(
                      limit: 3,
                    ),

                    // "See More" button
                    Align(
                      alignment: Alignment.bottomRight,
                      child: TextButton(
                        onPressed: () {
                          widget.navKey?.currentState?.navigateToPage(1);
                        },
                        child: const Text(
                          'See more...',
                          style: TextStyle(
                            color: Colors.black,
                            letterSpacing: 2.0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ));
  }
}
