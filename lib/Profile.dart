import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:code_champ/Friendlist.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:code_champ/Club.dart';
import 'package:code_champ/Settings.dart';
import 'package:code_champ/home.dart';
import 'package:fl_chart/fl_chart.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String _nickname = '';
  String _email = '';
  int _totalProblemsSolved = 0;
  int _totalContests = 0;
  String _currentClub = 'Coding Warriors';
  DateTime _joinDate = DateTime.now();
  List<FlSpot> _contestSpots = [];

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      Get.snackbar("Error", "User not logged in",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white);
      return;
    }

    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    if (userDoc.exists) {
      Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;
      setState(() {
        _nickname = data['username'] ?? 'Anonymous';
        _email = data['email'] ?? user.email ?? 'No email';
        _joinDate = (data['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now();
      });
    } else {
      setState(() {
        _nickname = user.email!.split('@')[0];
        _email = user.email ?? 'No email';
      });
    }

    QuerySnapshot trackerSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('problem_tracker')
        .where('timestamp',
        isGreaterThanOrEqualTo:
        Timestamp.fromDate(DateTime.now().subtract(const Duration(days: 30))))
        .orderBy('timestamp')
        .get();

    int totalProblems = 0;
    int totalContests = 0;
    Map<DateTime, int> contestMap = {};
    DateTime startDate = DateTime.now().subtract(const Duration(days: 30));

    for (var doc in trackerSnapshot.docs) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      totalProblems += data['total'] as int;
      totalContests += data['contests'] as int;
      DateTime date = DateTime.parse(doc.id);
      contestMap[date] = data['contests'] as int;
    }

    List<FlSpot> spots = [];
    for (int i = 0; i <= 30; i++) {
      DateTime day = startDate.add(Duration(days: i));
      double x = i.toDouble();
      double y = contestMap[DateTime(day.year, day.month, day.day)]?.toDouble() ?? 0.0;
      spots.add(FlSpot(x, y));
    }

    setState(() {
      _totalProblemsSolved = totalProblems;
      _totalContests = totalContests;
      _contestSpots = spots;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: const AssetImage('assets/user_avatar.png'),
                    backgroundColor: isDarkMode ? Colors.grey[800] : Colors.grey[200],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _nickname,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    _email,
                    style: TextStyle(
                      fontSize: 16,
                      color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Friends Button
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => FriendsListPage()),
                      );
                    },
                    icon: const Icon(Icons.group, color: Colors.white),
                    label: const Text(
                      'View Friends',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: isDarkMode ? Colors.grey[900] : Colors.white,
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: [
                  BoxShadow(
                    color: isDarkMode ? Colors.black.withOpacity(0.5) : Colors.grey.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Stats',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _buildStatRow(context, 'Total Problems Solved', '$_totalProblemsSolved'),
                  _buildStatRow(context, 'Total Contests', '$_totalContests'),
                  _buildStatRow(context, 'Current Club', _currentClub),
                  _buildStatRow(context, 'Joined', '${_joinDate.toString().split(' ')[0]}'),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: isDarkMode ? Colors.grey[900] : Colors.white,
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: [
                  BoxShadow(
                    color: isDarkMode ? Colors.black.withOpacity(0.5) : Colors.grey.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Contests Given (Last 30 Days)',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 200,
                    child: LineChart(
                      LineChartData(
                        gridData: FlGridData(
                          drawHorizontalLine: true,
                          drawVerticalLine: true,
                        ),
                        titlesData: FlTitlesData(
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 30,
                              getTitlesWidget: (value, meta) {
                                return Text(
                                  value.toInt().toString(),
                                  style: TextStyle(
                                    color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                                    fontSize: 12,
                                  ),
                                );
                              },
                            ),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 30,
                              getTitlesWidget: (value, meta) {
                                int daysAgo = 30 - value.toInt();
                                return Text(
                                  daysAgo % 5 == 0 ? '$daysAgo' : '',
                                  style: TextStyle(
                                    color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                                    fontSize: 12,
                                  ),
                                );
                              },
                            ),
                          ),
                          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        ),
                        borderData: FlBorderData(show: false),
                        minX: 0,
                        maxX: 30,
                        minY: 0,
                        maxY: _contestSpots.isNotEmpty
                            ? _contestSpots.map((spot) => spot.y).reduce((a, b) => a > b ? a : b) + 1
                            : 5,
                        lineBarsData: [
                          LineChartBarData(
                            spots: _contestSpots,
                            isCurved: true,
                            color: isDarkMode ? Colors.blue[300] : Colors.blue[800],
                            barWidth: 2,
                            belowBarData: BarAreaData(
                              show: true,
                              color: (isDarkMode ? Colors.blue[300] : Colors.blue[800])!.withOpacity(0.2),
                            ),
                            dotData: const FlDotData(show: false),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        currentIndex: 3, // Profile is now index 3
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
              );
              break;
            case 1:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const ClubDashboard()),
              );
              break;
            case 2:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const SettingsPage()),
              );
              break;
            case 3: // Profile (do nothing since we're already here)
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(label: "Home", icon: Icon(Icons.home_filled)),
          BottomNavigationBarItem(label: "Clubs", icon: Icon(Icons.people_alt_outlined)),
          BottomNavigationBarItem(label: "Settings", icon: Icon(Icons.settings_sharp)),
          BottomNavigationBarItem(label: "Profile", icon: Icon(Icons.account_circle_sharp)),
        ],
      ),
    );
  }

  Widget _buildStatRow(BuildContext context, String label, String value) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}