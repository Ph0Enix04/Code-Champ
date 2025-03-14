import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:code_champ/Settings.dart';
import 'package:code_champ/home.dart';
import 'package:flutter/material.dart';

class ClubDashboard extends StatelessWidget {
  const ClubDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Coding Warriors'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildClubInfo(context),
            const SizedBox(height: 20),
            _buildJoinedClubs(context),
            const SizedBox(height: 20),
            _buildLeaderboard(context),
            const SizedBox(height: 20),
            _buildUpcomingEvents(context),
            const SizedBox(height: 20),
            _buildRecentAnnouncements(context),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HomePage()), // Navigate to Home
              );
              break;
            case 1:
              break; // Already on ClubDashboard

            case 2:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => SettingsPage()), // Navigate to Settings
              );
              break;
/*
            case 3:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => ProfilePage()), // Navigate to Profile
              );
              break;
*/

          }
        },
        items: const [
          BottomNavigationBarItem(
            label: "Home",
            icon: Icon(Icons.home_filled),
          ),
          BottomNavigationBarItem(
            label: "Clubs",
            icon: Icon(Icons.people_alt_outlined),
          ),
          BottomNavigationBarItem(
            label: "Settings",
            icon: Icon(Icons.settings_sharp),
          ),
          BottomNavigationBarItem(
            label: "Profile",
            icon: Icon(Icons.account_circle_sharp),
          ),
        ],
      ),
    );
  }

  Widget _buildClubInfo(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
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
          Row(
            children: [
              const CircleAvatar(
                radius: 30,
                backgroundImage: AssetImage('assets/club_logo.png'),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Coding Warriors',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Members: 150 | Active Since: 2022',
                    style: TextStyle(
                      fontSize: 14,
                      color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _buildBadge(context, 'Rank: #1 in Programming'),
              const SizedBox(width: 10),
              _buildBadge(context, 'Level: Platinum'),
            ],
          ),
        ],
      ),
    );
  }


  Widget _buildBadge(BuildContext context, String text) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.blueGrey[800] : Colors.blue[50],
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          color: isDarkMode ? Colors.blue[200] : Colors.blue[800],
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }


  Widget _buildJoinedClubs(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
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
            'Joined Clubs',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
          ),
          const SizedBox(height: 10),
          _buildClubTile(context, 'Algorithm Masters', '300 Members', '#2 Rank'),
          const Divider(),
          _buildClubTile(context, 'Data Science Titans', '200 Members', '#5 Rank'),
          const SizedBox(height: 10),
          TextButton(
            onPressed: () {
              // Navigate to explore clubs
            },
            child: Text(
              'Search Clubs...',
              style: TextStyle(
                color: isDarkMode ? Colors.blue[200] : Colors.blue[800],
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildClubTile(BuildContext context, String name, String members, String rank) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        name,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: isDarkMode ? Colors.white : Colors.black,
        ),
      ),
      subtitle: Text(
        '$members | $rank',
        style: TextStyle(
          fontSize: 14,
          color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
        ),
      ),
    );
  }


  Widget _buildLeaderboard(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
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
            'Leaderboard (This Week)',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
          ),
          const SizedBox(height: 10),
          _buildLeaderboardRow(context, '1🏆', 'UserA', '4500', '30', 0.9),
          _buildLeaderboardRow(context, '2🥈', 'UserB', '4200', '28', 0.6),
          _buildLeaderboardRow(context, '3🥉', 'UserC', '4000', '25', 0.5),
          _buildLeaderboardRow(context, '4', 'You (Emon)', '3800', '22', 0.4),
        ],
      ),
    );
  }


  Widget _buildLeaderboardRow(BuildContext context, String rank, String name, String points, String solved, double activity) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Text(
            rank,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.blue[200] : Colors.blue[800],
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              name,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
          ),
          Text(
            points,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.grey[400] : Colors.grey[800],
            ),
          ),
          const SizedBox(width: 10),
          Text(
            solved,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 2,
            child: LinearProgressIndicator(
              value: activity,
              backgroundColor: isDarkMode ? Colors.grey[700] : Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(isDarkMode ? Colors.blue[300]! : Colors.blue[800]!),
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildUpcomingEvents(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
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
            'Upcoming Club Events',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
          ),
          const SizedBox(height: 10),
          _buildEventTile(context, 'June 15: Coding Marathon'),
          _buildEventTile(context, 'June 20: Algorithm Workshop'),
          _buildEventTile(context, 'June 25: Hackathon Qualifiers'),
        ],
      ),
    );
  }


  Widget _buildEventTile(BuildContext context, String event) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(
        Icons.event,
        color: isDarkMode ? Colors.blue[300] : Colors.blue,
      ),
      title: Text(
        event,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: isDarkMode ? Colors.white : Colors.black,
        ),
      ),
    );
  }


  Widget _buildRecentAnnouncements(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
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
            'Recent Announcements',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
          ),
          const SizedBox(height: 10),
          _buildAnnouncementTile(context, 'New contest: "Summer Code Sprint"!'),
          _buildAnnouncementTile(context, 'Leaderboard rewards updated.'),
        ],
      ),
    );
  }


  Widget _buildAnnouncementTile(BuildContext context, String announcement) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(
        Icons.announcement,
        color: isDarkMode ? Colors.blue[300] : Colors.blue,
      ),
      title: Text(
        announcement,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: isDarkMode ? Colors.white : Colors.black,
        ),
      ),
    );
  }


}