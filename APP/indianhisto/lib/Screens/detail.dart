import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:indianhisto/components/map.dart';
import 'dart:convert';
import 'detail.dart';

class MonumentDetailsPage extends StatefulWidget {
  final int id;

  MonumentDetailsPage({required this.id});

  @override
  _MonumentDetailsPageState createState() => _MonumentDetailsPageState();
}

class _MonumentDetailsPageState extends State<MonumentDetailsPage> {
  late Future<Map<String, dynamic>> _futureDetails;
  bool _showDetails = false;

  @override
  void initState() {
    super.initState();
    _futureDetails = fetchMonumentDetails();
  }

  Future<Map<String, dynamic>> fetchMonumentDetails() async {
    final response = await http
        .get(Uri.parse('http://172.16.33.173:3000/api/monuments/${widget.id}'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch monument details');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          FutureBuilder(
            future: _futureDetails,
            builder: (context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                final details = snapshot.data!;
                return Image.network(
                  details['imageUrl'],
                  fit: BoxFit.cover,
                );
              }
            },
          ),
          Positioned(
            bottom: 16.0,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Icon(
                  Icons.keyboard_arrow_up,
                  color: Colors.white,
                  size: 32.0,
                ),
                SizedBox(height: 8.0),
              ],
            ),
          ),
          NotificationListener<DraggableScrollableNotification>(
            onNotification: (notification) {
              if (notification.extent == 1.0) {
                setState(() {
                  _showDetails = true;
                });
              } else if (notification.extent == 0.0) {
                setState(() {
                  _showDetails = false;
                });
              }
              return true;
            },
            child: DraggableScrollableSheet(
              initialChildSize: 0.3,
              minChildSize: 0.3,
              maxChildSize: 1.0,
              builder:
                  (BuildContext context, ScrollController scrollController) {
                return Container(
                  padding: EdgeInsets.all(16.0),
                  color: Colors.black.withOpacity(0.5),
                  child: FutureBuilder(
                    future: _futureDetails,
                    builder: (context,
                        AsyncSnapshot<Map<String, dynamic>> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else {
                        final details = snapshot.data!;
                        return ListView(
                          controller: scrollController,
                          shrinkWrap: true,
                          children: [
                            Container(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                details['name'],
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 50.0,
                                  fontFamily: 'Avilock',
                                ),
                              ),
                            ),
                            SizedBox(height: 8.0),
                            Container(
                              padding: EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '📍 Location:',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Oswald',
                                      fontSize: 18,
                                    ),
                                  ),
                                  Text(
                                    details['place'],
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Oswald',
                                        fontSize: 25),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 8.0),
                            Container(
                              padding: EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Remarks:',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Oswald',
                                      fontSize: 18,
                                    ),
                                  ),
                                  Text(
                                    details['remarks'],
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Oswald',
                                        fontSize: 20),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 8.0),
                            Container(
                              padding: EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'About Monument:',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                      fontFamily: 'Oswald',
                                    ),
                                  ),
                                  Text(
                                    details['about_monument'],
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Oswald',
                                        fontSize: 20),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 8.0),
                            SizedBox(height: 8.0),
                            Container(
                              padding: EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Architectural Style:',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                      fontFamily: 'Oswald',
                                    ),
                                  ),
                                  Text(
                                    details['architectural_style'],
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Oswald',
                                        fontSize: 25),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 8.0),
                            Container(
                              padding: EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Construction Materials:',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Oswald',
                                      fontSize: 18,
                                    ),
                                  ),
                                  Text(
                                    details['construction_materials'],
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Oswald',
                                        fontSize: 25),
                                  ),
                                  GestureDetector(
                                    onTap: () async {
                                      // Navigate to another screen here
                                      final response =
                                          await fetchMonumentDetails();
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => MonumentMapPage(
                                            monumentCoordinate:
                                                response['location_coordinate'],
                                            monunsame: response['name'],
                                            place: response['place'],
                                          ),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      alignment: Alignment.centerLeft,
                                      padding: EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                            8), // Optional: Add border radius for rounded corners
                                      ),
                                      child: Row(
                                        children: [
                                          IconButton(
                                            onPressed: () {},
                                            icon: Icon(
                                              Icons.location_pin,
                                              color: Colors.red,
                                              size: 40,
                                            ),
                                          ),
                                          SizedBox(width: 10),
                                          Text(
                                            'Map Location',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontFamily: 'Oswald',
                                                fontSize: 25),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        );
                      }
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
