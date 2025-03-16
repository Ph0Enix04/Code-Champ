import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:get/get.dart';

class PersonalTrackerPage extends StatefulWidget {
  const PersonalTrackerPage({super.key});

  @override
  _PersonalTrackerPageState createState() => _PersonalTrackerPageState();
}

class _PersonalTrackerPageState extends State<PersonalTrackerPage> {
  final TextEditingController _leetcodeController = TextEditingController();
  final TextEditingController _codeforcesController = TextEditingController();
  final TextEditingController _hackerrankController = TextEditingController();
  final TextEditingController _contestsController = TextEditingController();
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, Map<String, dynamic>> _trackerData = {};

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _loadTrackerData();
  }

  Future<void> _loadTrackerData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('problem_tracker')
        .get();

    setState(() {
      _trackerData = {
        for (var doc in snapshot.docs)
          DateTime.parse(doc.id): doc.data() as Map<String, dynamic>
      };
    });
  }

  Future<void> _saveTrackerData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      Get.snackbar("Error", "Please log in to save data",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white);
      return;
    }

    int leetcode = int.tryParse(_leetcodeController.text) ?? 0;
    int codeforces = int.tryParse(_codeforcesController.text) ?? 0;
    int hackerrank = int.tryParse(_hackerrankController.text) ?? 0;
    int contests = int.tryParse(_contestsController.text) ?? 0;
    int totalProblems = leetcode + codeforces + hackerrank;

    if (totalProblems == 0 && contests == 0) {
      Get.snackbar("Error", "Please enter at least one problem or contest",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white);
      return;
    }

    String dateKey = _selectedDay!.toIso8601String().split('T')[0]; // YYYY-MM-DD
    Map<String, dynamic> data = {
      'leetcode': leetcode,
      'codeforces': codeforces,
      'hackerrank': hackerrank,
      'total': totalProblems,
      'contests': contests,
      'timestamp': FieldValue.serverTimestamp(),
    };

    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('problem_tracker')
        .doc(dateKey)
        .set(data);

    setState(() {
      _trackerData[_selectedDay!] = data;
      _leetcodeController.clear();
      _codeforcesController.clear();
      _hackerrankController.clear();
      _contestsController.clear();
    });

    Get.snackbar("Success", "Data saved for $dateKey",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white);
  }

  @override
  void dispose() {
    _leetcodeController.dispose();
    _codeforcesController.dispose();
    _hackerrankController.dispose();
    _contestsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Personal Tracker'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Calendar
            Container(
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
              child: TableCalendar(
                firstDay: DateTime.utc(2020, 1, 1),
                lastDay: DateTime.utc(2030, 12, 31),
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                },
                eventLoader: (day) {
                  return _trackerData.containsKey(day) ? [day] : [];
                },
                calendarBuilders: CalendarBuilders(
                  markerBuilder: (context, day, events) {
                    if (_trackerData.containsKey(day)) {
                      int totalProblems = _trackerData[day]!['total'] as int;
                      int contests = _trackerData[day]!['contests'] as int;
                      return Positioned(
                        right: 1,
                        bottom: 1,
                        child: Row(
                          children: [
                            if (totalProblems > 0)
                              Container(
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.blue,
                                ),
                                width: 16.0,
                                height: 16.0,
                                child: Center(
                                  child: Text(
                                    '$totalProblems',
                                    style: const TextStyle(color: Colors.white, fontSize: 10),
                                  ),
                                ),
                              ),
                            if (contests > 0) const SizedBox(width: 4),
                            if (contests > 0)
                              Container(
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.green,
                                ),
                                width: 16.0,
                                height: 16.0,
                                child: Center(
                                  child: Text(
                                    '$contests',
                                    style: const TextStyle(color: Colors.white, fontSize: 10),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      );
                    }
                    return null;
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Input Section
            Text(
              'Log Activity for ${_selectedDay!.toString().split(' ')[0]}',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _leetcodeController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'LeetCode Problems',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.star, color: Colors.yellow), // Star for LeetCode
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _codeforcesController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Codeforces Problems',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.shield, color: Colors.red), // Shield for Codeforces
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _hackerrankController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'HackerRank Problems',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.emoji_events, color: Colors.green), // Trophy for HackerRank
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _contestsController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Contests Given',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.event, color: Colors.purple), // Event for contests
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveTrackerData,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
              ),
              child: const Text('Save', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}