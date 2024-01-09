
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class Search extends StatelessWidget{
  Search({super.key});
  final TextEditingController _searchController = TextEditingController();

  void _search() {
    String searchTerm = _searchController.text.trim().toLowerCase();

    if (searchTerm.isEmpty) {
      // Handle empty search term
      return;
    }

    // Specify the fields you want to search on
    List<String> searchFields = ['fieldName', 'anotherField'];

    final SearchController searchController = Get.find();
    searchController.search(searchFields, searchTerm);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Page'),
      ),
      body:  Padding(padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: _searchController,
            decoration: const InputDecoration(
              labelText: "search Ecode",
            ),
          ),
          const Gap(16.0),
          ElevatedButton(onPressed: _search,
              child: const Text('Search'),
          ),
          const Gap(16.0),
          GetX<SearchController>(
              builder: (controller){
                if(controller.isLoading.value){
                  return const CircularProgressIndicator();
                }
                else if (controller.searchResults.isEmpty){
                  return const Text("No results found.");
                }
                else{
                  return Expanded(child: ListView.builder(
                      itemCount: controller.searchResults.length,
                      itemBuilder: (context, index) {
                        var result = controller.searchResults[index];
                        return ListTile(
                          title: Text(result['fieldName']),
                          subtitle: Text(result["fieldValue"]),
                        );
                      },
                  ));
                }
              })
        ],
      ),
      ),
    );
  }

}
class SearchController extends GetxController{
  RxBool isLoading = false.obs;
  RxList<DocumentSnapshot> searchResults = RxList<DocumentSnapshot>();

  void search(List<String> searchFields, String searchTerm) async {
    try {
      isLoading.value = true;
      searchResults.clear();

      CollectionReference collectionRef = FirebaseFirestore.instance
          .collection("Halal-Haram")
          .doc("1")
          .collection("subcollection");

      Query query = collectionRef;

      for (String field in searchFields) {
        query = query.where(field, isEqualTo: searchTerm);
      }

      QuerySnapshot querySnapshot = await query.get();

      searchResults.addAll(querySnapshot.docs);
    } finally {
      isLoading.value = false;
    }
  }

}