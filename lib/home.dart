import 'package:code_champ/Club.dart';
import 'package:code_champ/Profile.dart';
import 'package:code_champ/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'Settings.dart';

class HomePage extends StatelessWidget {
  // Initialize the controller
  final UserController userController = Get.put(UserController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("CodeChamp"),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {},
          ),
          const CircleAvatar(
            backgroundImage: AssetImage("lib/assets/user_avatar.png"),
          ),
          const SizedBox(width: 10),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        currentIndex: 0, // Home is index 0
        onTap: (index) {
          switch (index) {
            case 0:
              break; // Already on Home
            case 1:
              Navigator.push(
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
            case 3:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const ProfilePage()),
              );
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GetBuilder<UserController>(
                builder: (controller) {
                  return Text(
                    "Welcome, ${controller.userName.text.isEmpty ? 'Guest' : controller.userName.text}!",
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  );
                },
              ),
              const SizedBox(height: 10),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildStatCard("Upcoming Contests", "3"),
                    _buildStatCard("Total Participations", "15"),
                    _buildStatCard("Highest Rank", "#12"),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Text("Upcoming Contests",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              _buildContestList(),
              const SizedBox(height: 20),
              const Text("Recent Achievements",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              _buildAchievements(),
              const SizedBox(height: 20),
              const Text("Leaderboard Preview",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              _buildLeaderboardPreview(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text(title, style: const TextStyle(fontSize: 14)),
          ],
        ),
      ),
    );
  }

  Widget _buildContestList() {
    return Column(
      children: List.generate(
        3,
            (index) => Card(
          child: ListTile(
            title: Text("Codeforces Round ${1001 + index}, Div(${index + 1})"),
            subtitle: const Text("Platform: Codeforces"),
            trailing: ElevatedButton(
              onPressed: () {},
              child: const Text("Register"),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAchievements() {
    return Column(
      children: List.generate(
        3,
            (index) => Card(
          child: ListTile(
            leading: const Icon(Icons.emoji_events, color: Colors.amber),
            title: Text("Achievement ${index + 1}"),
            subtitle: Text("Reached the rating of ${1200 - index * 100}"),
          ),
        ),
      ),
    );
  }

  Widget _buildLeaderboardPreview() {
    return Column(
      children: List.generate(
        3,
            (index) => ListTile(
          leading: CircleAvatar(child: Text("#${index + 1}")),
          title: Text("User ${index + 1}"),
          subtitle: Text("Rating: ${1600 - index * 50}"),
        ),
      ),
    );
  }
}