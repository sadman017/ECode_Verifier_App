import 'package:ecode_verifier/src/features/authentication/models/Halal.dart';
import 'package:ecode_verifier/src/features/authentication/models/haram.dart';
import 'package:ecode_verifier/src/features/authentication/models/mushbooh.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final TextEditingController _searchController = TextEditingController();

  String? searchResult;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Page'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Enter Ecode to search',
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                for (String ecode in halalEcodes) {
                  if (ecode == _searchController.text) {
                    setState(() {
                      searchResult = "Halal";
                    });
                    return;
                  }
                }
                for (String ecode in haramEcodes) {
                  if (ecode == _searchController.text) {
                    setState(() {
                      searchResult = "Haram";
                    });
                    return;
                  }
                }
                for (String ecode in mushboohEcodes) {
                  if (ecode == _searchController.text) {
                    setState(() {
                      searchResult = "Mushbooh";
                    });
                    return;
                  }
                }
                setState(() {
                  searchResult = "Not Found";
                });
              },
              child: const Text('Search'),
            ),
            const SizedBox(height: 16.0),
            if (searchResult != null)
              ListTile(
                leading: getIconForSearchResult(searchResult!),
                title: Text(searchResult!,
                    style: Theme.of(context).textTheme.titleLarge),
              ),
          ],
        ),
      ),
    );
  }

  Icon getIconForSearchResult(String result) {
    switch (result) {
      case 'Halal':
        return const Icon(Icons.check_circle, color: Colors.green);
      case 'Haram':
        return const Icon(Icons.error, color: Colors.red);
      case 'Mushbooh':
        return const Icon(Icons.warning, color: Colors.yellow);
      default:
        return const Icon(Icons.error, color: Colors.red);
    }
  }
}
