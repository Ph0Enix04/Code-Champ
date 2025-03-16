import 'package:flutter/material.dart';

class AddFriendsPage extends StatefulWidget {
  @override
  _AddFriendsPageState createState() => _AddFriendsPageState();
}

class _AddFriendsPageState extends State<AddFriendsPage> {

  final List<Map<String, dynamic>> suggestedFriends = [
    {
      'name': 'Emon',
      'profileImage': 'assets/user_avatar.png',
      'rating': 1500,
      'achievements': ['Codeforces Expert', 'Hackathon Finalist'],
      'bio': 'Passionate about competitive programming and problem-solving.',
      'recentContests': ['Codeforces Round #750', 'Google Code Jam 2023'],
      'socialMedia': {
        'Codeforces': 'https://codeforces.com/profile/emon',
        'LeetCode': 'https://leetcode.com/emon',
      },
      'friendStatus': 'Not Friends',
    },
    {
      'name': 'Fiona',
      'profileImage': 'assets/user_avatar.png',
      'rating': 1400,
      'achievements': ['LeetCode Specialist'],
      'bio': 'Enjoys solving algorithmic challenges and learning new technologies.',
      'recentContests': ['LeetCode Weekly Contest 300'],
      'socialMedia': {
        'LeetCode': 'https://leetcode.com/fiona',
      },
      'friendStatus': 'Not Friends',
    },
    {
      'name': 'George',
      'profileImage': 'assets/user_avatar.png',
      'rating': 1700,
      'achievements': ['Google Code Jam Finalist'],
      'bio': 'Aspiring software engineer with a love for coding competitions.',
      'recentContests': ['Google Code Jam 2023'],
      'socialMedia': {
        'Codeforces': 'https://codeforces.com/profile/george',
      },
      'friendStatus': 'Not Friends',
    },
  ];


  String searchQuery = '';
  List<Map<String, dynamic>> filteredFriends = [];

  @override
  void initState() {
    super.initState();
    filteredFriends = suggestedFriends;
  }

  void _filterFriends(String query) {
    setState(() {
      searchQuery = query;
      filteredFriends = suggestedFriends
          .where((friend) =>
          friend['name'].toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _sendFriendRequest(Map<String, dynamic> friend) {
    setState(() {
      friend['friendStatus'] = 'Request Sent';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Friend request sent to ${friend['name']}'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _cancelFriendRequest(Map<String, dynamic> friend) {
    setState(() {
      friend['friendStatus'] = 'Not Friends';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Friend request to ${friend['name']} canceled'),
        backgroundColor: Colors.orange,
      ),
    );
  }

  void _navigateToFriendDetails(Map<String, dynamic> friend) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FriendDetailsPage(friend: friend),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Friends'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search for friends...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onChanged: _filterFriends,
            ),
          ),
          // Filter Options
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                FilterChip(
                  label: Text('Top Coders'),
                  onSelected: (bool value) {
                  },
                ),
                SizedBox(width: 8),
                FilterChip(
                  label: Text('Recent Activity'),
                  onSelected: (bool value) {
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16.0),
              itemCount: filteredFriends.length,
              itemBuilder: (context, index) {
                final friend = filteredFriends[index];
                return Card(
                  margin: EdgeInsets.only(bottom: 16.0),
                  child: ListTile(
                    onTap: () {
                      _navigateToFriendDetails(friend);
                    },
                    leading: CircleAvatar(
                      backgroundImage: AssetImage(friend['profileImage']),
                    ),
                    title: Text(
                      friend['name'],
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Rating: ${friend['rating']}',
                          style: TextStyle(fontSize: 14),
                        ),
                        SizedBox(height: 4),
                        Wrap(
                          spacing: 4.0,
                          children: friend['achievements']
                              .map<Widget>((achievement) => Chip(
                            label: Text(achievement),
                            backgroundColor: Colors.blue[50],
                          ))
                              .toList(),
                        ),
                      ],
                    ),
                    trailing: friend['friendStatus'] == 'Not Friends'
                        ? ElevatedButton(
                      onPressed: () {
                        _sendFriendRequest(friend);
                      },
                      child: Text('Add Friend'),
                    )
                        : friend['friendStatus'] == 'Request Sent'
                        ? ElevatedButton(
                      onPressed: () {
                        _cancelFriendRequest(friend);
                      },
                      child: Text('Cancel Request'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                      ),
                    )
                        : Text(
                      friend['friendStatus'],
                      style: TextStyle(
                        color: Colors.green,
                      ),
                    ),
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

class FriendDetailsPage extends StatelessWidget {
  final Map<String, dynamic> friend;

  FriendDetailsPage({required this.friend});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(friend['name']),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage(friend['profileImage']),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Rating: ${friend['rating']}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Bio:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              friend['bio'],
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 10),
            Text(
              'Recent Contests:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: friend['recentContests']
                  .map<Widget>((contest) => Text('- $contest'))
                  .toList(),
            ),
            SizedBox(height: 10),
            Text(
              'Social Media:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: friend['socialMedia'].entries.map<Widget>((entry) {
                return ListTile(
                  leading: Icon(Icons.link),
                  title: Text(entry.key),
                  subtitle: Text(entry.value),
                  onTap: () {
                  },
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}