import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:indianhisto/Screens/detail.dart';

class MonumentListPage extends StatefulWidget {
  @override
  _MonumentListPageState createState() => _MonumentListPageState();
}

class _MonumentListPageState extends State<MonumentListPage> {
  List<String> monumentNames = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchMonumentNames();
  }

  Future<void> fetchMonumentNames() async {
    final response =
        await http.get(Uri.parse('http://172.16.33.173:3000/api/names'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      setState(() {
        monumentNames = data.cast<String>();
      });
    } else {
      throw Exception('Failed to fetch monument names');
    }
  }

  Future<Map<String, dynamic>> fetchMonumentDetails(int id) async {
    final response = await http
        .get(Uri.parse('http://172.16.33.173:3000/api/monuments/$id'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch monument details');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(
            top: 20.0), // Adjust the top padding as needed
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              margin: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(24.0),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TypeAheadFormField<String>(
                      textFieldConfiguration: TextFieldConfiguration(
                        controller: searchController,
                        decoration: InputDecoration(
                          hintText: 'Search...',
                          border: InputBorder.none,
                        ),
                        onChanged: (value) {
                          setState(
                              () {}); // Trigger rebuild to update clear icon visibility
                        },
                      ),
                      suggestionsCallback: (pattern) {
                        final patternLowerCase = pattern.toLowerCase();
                        final startingWithPattern = monumentNames
                            .where((name) =>
                                name.toLowerCase().startsWith(patternLowerCase))
                            .toSet() // Convert to a set to remove duplicates
                            .toList();
                        final containingPattern = monumentNames
                            .where((name) =>
                                name.toLowerCase().contains(patternLowerCase) &&
                                !startingWithPattern.contains(
                                    name)) // Exclude names already added
                            .toSet() // Convert to a set to remove duplicates
                            .toList();
                        startingWithPattern.sort();
                        containingPattern.sort();
                        return [...startingWithPattern, ...containingPattern];
                      },
                      itemBuilder: (context, suggestion) {
                        return ListTile(
                          title: Text(suggestion),
                        );
                      },
                      onSuggestionSelected: (suggestion) async {
                        searchController.text = suggestion;
                        // Fetch and display monument details
                        final response = await fetchMonumentDetails(
                            monumentNames.indexOf(suggestion) +
                                1); // Index starts from 0, but IDs start from 1
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                MonumentDetailsPage(id: response['id']),
                          ),
                        );
                      },
                    ),
                  ),
                  if (searchController
                      .text.isNotEmpty) // Only show clear icon if there's text
                    IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: () {
                        searchController.clear();
                        setState(
                            () {}); // Trigger rebuild to update clear icon visibility
                      },
                    ),
                ],
              ),
            ),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Two monuments per row
                  mainAxisSpacing: 1.0, // Vertical spacing between items
                  crossAxisSpacing: 1.0, // Horizontal spacing between items
                  childAspectRatio:
                      0.7, // Aspect ratio for each item (adjust as needed)
                ),
                itemCount: (monumentNames.length / 4).ceil() *
                    4, // Ensure the total count is a multiple of 4
                itemBuilder: (context, index) {
                  if (index < monumentNames.length) {
                    return FutureBuilder(
                      future: fetchMonumentDetails(index + 1),
                      builder: (context,
                          AsyncSnapshot<Map<String, dynamic>> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        } else {
                          final details = snapshot.data!;
                          return GestureDetector(
                            onTap: () async {
                              final response = await fetchMonumentDetails(index +
                                  1); // Index starts from 0, but IDs start from 1
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      MonumentDetailsPage(id: response['id']),
                                ),
                              );
                            },
                            child: Stack(
                              alignment: Alignment.bottomCenter,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                      16.0), // Make all corners circular
                                  child: Container(
                                    height: 300, // Adjust height as needed
                                    width: 200, // Adjust width as needed
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.transparent,
                                          width: 2.0), // Transparent border
                                    ),
                                    child: Image.network(
                                      details['imageUrl'],
                                      fit: BoxFit
                                          .cover, // Ensure the image fills the container
                                    ),
                                  ),
                                ),
                                Container(
                                  color: Colors.black.withOpacity(0.5),
                                  padding: EdgeInsets.symmetric(
                                      vertical: 8.0, horizontal: 16.0),
                                  child: Text(
                                    details['name'],
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16.0),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                      },
                    );
                  } else {
                    return Container(); // Placeholder for empty spaces
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
