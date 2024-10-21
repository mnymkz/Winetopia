import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:winetopia/models/exhibitor.dart';
import 'package:winetopia/models/winetopia_user.dart';
import 'package:winetopia/services/database_service.dart';
import 'package:winetopia/shared/loading.dart';

/// ExhibitorList screen displays list of exhibitors from the database
class ExhibitorList extends StatefulWidget {
  const ExhibitorList({super.key});

  @override
  State<ExhibitorList> createState() => _ExhibitorListState();
}

class _ExhibitorListState extends State<ExhibitorList> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = Provider.of<WinetopiaUser?>(context);

    return StreamBuilder<List<Exhibitor>>(
        stream: DataBaseService(uid: currentUser!.uid).exhibitorData,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Error loading exhibitors'));
          }

          if (!snapshot.hasData) {
            return const Center(child: Loading());
          }

          final exhibitors = snapshot.data ?? [];
          if (exhibitors.isEmpty) {
            return const Center(child: Text('No Exhibitors'));
          }

          return Center(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  const Text(
                      'Check out the wineries from Winetopia Wellington & Auckland 2024!',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14)),
                  const Divider(),
                  Expanded(
                    child: CupertinoScrollbar(
                      controller: _scrollController,
                      thumbVisibility: true,
                      child: GridView.builder(
                        controller: _scrollController,
                        itemCount: exhibitors.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3, // 3 items per row
                          crossAxisSpacing: 10.0,
                          mainAxisSpacing: 20.0,
                          childAspectRatio:
                              1.0, // To maintain square aspect ratio
                        ),
                        itemBuilder: (context, index) {
                          // Cycle through 15 images
                          final imageUrl =
                              'assets/img/wineries/${index % 15}.png';
                          return ExhibitorTile(
                              exhibitor: exhibitors[index], imageUrl: imageUrl);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}

class ExhibitorTile extends StatelessWidget {
  final Exhibitor exhibitor;
  final String imageUrl; // Add imageUrl as a parameter

  const ExhibitorTile(
      {super.key, required this.exhibitor, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.asset(
              imageUrl, // Use the imageUrl passed from GridView.builder
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(height: 5),
        Text(
          exhibitor.name,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 14),
        ),
      ],
    );
  }
}
