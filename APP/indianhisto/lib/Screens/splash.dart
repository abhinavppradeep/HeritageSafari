import 'dart:async';
import 'package:flutter/material.dart';
import 'package:indianhisto/Screens/browse_page.dart';
import 'package:indianhisto/Screens/home_bottom.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<String> imagePaths = [
    'assets/taj.jpg',
    'assets/hawa.jpg',
    'assets/gateway.jpg',
  ];

  final List<String> monumentNames = [
    'Taj Mahal',
    'Hawa Mahal',
    'Gateway of India'
  ];

  final List<Color> textColors = [
    Colors.white, // Taj Mahal (white)
    Color.fromARGB(119, 29, 29, 30), // Hawa Mahal (light red)
    Color.fromARGB(255, 239, 223, 205), // Gateway of India (light blue)
  ];

  final List<String> monumentDescriptions = [
    "Behold the Taj Mahal's ivory embrace, where time stands still and love's essence whispers, beckoning the soul to linger in its eternal splendor.",
    "A mesmerizing symphony of delicate architecture, where history whispers through every intricately carved breeze",
    "India's majestic sentinel standing tall, welcoming whispers of history's call."
  ];

  final List<Color> descriptionColors = [
    Colors.white,
    Color.fromARGB(255, 51, 50, 50),
    Color.fromARGB(255, 255, 255, 255),
  ];

  int _currentIndex = 0;
  late PageController _pageController;
  late Timer _timer;

  bool _showMenu = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
    _timer = Timer.periodic(Duration(seconds: 5), (timer) {
      _currentIndex = (_currentIndex + 1) % imagePaths.length;
      _pageController.animateToPage(
        _currentIndex,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GestureDetector(
            onVerticalDragUpdate: (details) {
              if (details.delta.dy < -20) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NewPage()),
                );
              }
            },
            child: PageView.builder(
              controller: _pageController,
              itemCount: imagePaths.length * 2 - 2,
              itemBuilder: (context, index) {
                final actualIndex = index % imagePaths.length;
                return Stack(
                  children: [
                    Image.asset(
                      imagePaths[actualIndex],
                      fit: BoxFit.cover,
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                    ),
                    Positioned(
                      top: 16.0,
                      left: 0,
                      right: 0,
                      child: Column(
                        children: [
                          Center(
                            child: Text(
                              monumentNames[actualIndex] == 'Gateway of India'
                                  ? 'Gateway of\nIndia'
                                  : monumentNames[actualIndex],
                              style: TextStyle(
                                fontFamily: 'bajern',
                                color: textColors[
                                    actualIndex], // Dynamic color based on monument name
                                fontSize: 80.0,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(height: 8.0),
                          AnimatedOpacity(
                            duration: Duration(milliseconds: 300),
                            opacity: 1.0,
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 16.0),
                              color:
                                  Colors.transparent, // Transparent background
                              child: Text(
                                monumentDescriptions[actualIndex],
                                style: TextStyle(
                                  color: descriptionColors[
                                      actualIndex], // Select color based on index
                                  fontSize: 16.0,
                                  fontStyle: FontStyle.italic,
                                  fontFamily: 'Cambria',
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          Positioned(
            bottom: 40.0,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Text(
                  'Swipe to explore more',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Avilock',
                    letterSpacing: 1,
                  ),
                ),
                Icon(
                  Icons.keyboard_arrow_up,
                  color: Colors.white,
                  size: 40.0,
                ),
              ],
            ),
          ),
          AnimatedPositioned(
            duration: Duration(milliseconds: 300),
            bottom: _showMenu ? 0 : -MediaQuery.of(context).size.height,
            left: 0,
            right: 0,
            child: AnimatedContainer(
              duration: Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              height: _showMenu ? MediaQuery.of(context).size.height : 0,
              color: Colors.black.withOpacity(0.7),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    height: 50.0,
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MonumentListPage()),
                        );
                      },
                      child: Center(
                        child: Text(
                          'Browse Monuments',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 50.0,
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: GestureDetector(
                      onTap: () {
                        // Handle menu item 2 tap
                      },
                      child: Center(
                        child: Text(
                          'Add Monuments',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 50.0,
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: GestureDetector(
                      onTap: () {
                        // Handle menu item 3 tap
                      },
                      child: Center(
                        child: Text(
                          'Menu Item 3',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
