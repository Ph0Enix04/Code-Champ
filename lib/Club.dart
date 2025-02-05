import 'package:flutter/material.dart';

void main() {
  runApp(const CodingWarriorsApp());
}

class CodingWarriorsApp extends StatelessWidget {
  const CodingWarriorsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Coding Warriors',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFFF5F5F5),
      ),
      home: const ClubDashboard(),
    );
  }
}

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
            _buildClubInfo(),
            const SizedBox(height: 20),
            _buildJoinedClubs(),
            const SizedBox(height: 20),
            _buildLeaderboard(),
            const SizedBox(height: 20),
            _buildUpcomingEvents(),
            const SizedBox(height: 20),
            _buildRecentAnnouncements(),
          ],
        ),
      ),
    );
  }

  Widget _buildClubInfo() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
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
                backgroundImage: AssetImage('assets/club_logo.png'), // Add your logo asset
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Coding Warriors',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Members: 150 | Active Since: 2022',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _buildBadge('Rank: #1 in Programming'),
              const SizedBox(width: 10),
              _buildBadge('Level: Platinum'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBadge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          color: Colors.blue[800],
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildJoinedClubs() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Joined Clubs',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          _buildClubTile('Algorithm Masters', '300 Members', '#2 Rank'),
          const Divider(),
          _buildClubTile('Data Science Titans', '200 Members', '#5 Rank'),
          const SizedBox(height: 10),
          TextButton(
            onPressed: () {
              // Navigate to explore clubs
            },
            child: const Text('Search Clubs...'),
          ),
        ],
      ),
    );
  }

  Widget _buildClubTile(String name, String members, String rank) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        name,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        '$members | $rank',
        style: TextStyle(
          fontSize: 14,
          color: Colors.grey[600],
        ),
      ),
    );
  }

  Widget _buildLeaderboard() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Leaderboard (This Week)',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          _buildLeaderboardRow('1🏆', 'UserA', '4500', '30', 0.7),
          _buildLeaderboardRow('2🥈', 'UserB', '4200', '28', 0.6),
          _buildLeaderboardRow('3🥉', 'UserC', '4000', '25', 0.5),
          _buildLeaderboardRow('4', 'You (Emon)', '3800', '22', 0.4),
        ],
      ),
    );
  }

  Widget _buildLeaderboardRow(String rank, String name, String points, String solved, double activity) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Text(
            rank,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              name,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Text(
            points,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 10),
          Text(
            solved,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 2,
            child: LinearProgressIndicator(
              value: activity,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue[800]!),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUpcomingEvents() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Upcoming Club Events',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          _buildEventTile('June 15: Coding Marathon'),
          _buildEventTile('June 20: Algorithm Workshop'),
          _buildEventTile('June 25: Hackathon Qualifiers'),
        ],
      ),
    );
  }

  Widget _buildEventTile(String event) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: const Icon(Icons.event, color: Colors.blue),
      title: Text(
        event,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildRecentAnnouncements() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Recent Announcements',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          _buildAnnouncementTile('New contest: "Summer Code Sprint"!'),
          _buildAnnouncementTile('Leaderboard rewards updated.'),
        ],
      ),
    );
  }

  Widget _buildAnnouncementTile(String announcement) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: const Icon(Icons.announcement, color: Colors.blue),
      title: Text(
        announcement,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
