import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final TextEditingController _searchController = TextEditingController();
  String _searchResult = '';

  Future<void> _search() async {
    final CollectionReference halalHaramCollection =
        FirebaseFirestore.instance.collection('Halal-Haram');

    // Replace 'Name' with the actual field name in your documents
    QuerySnapshot querySnapshot = await halalHaramCollection
        .where('Name', isEqualTo: _searchController.text)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      setState(() {
        _searchResult = querySnapshot.docs.first['Name'];
      });
    } else {
      setState(() {
        _searchResult = 'Not Found';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Enter Ecode to search',
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _search,
              child: Text('Search'),
            ),
            SizedBox(height: 16.0),
            Text(
              'Search Result: $_searchResult',
              style: TextStyle(fontSize: 18.0),
            ),
          ],
        ),
      ),
    );
  }
}
