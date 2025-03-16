import 'package:code_champ/AddFriends.dart';
import 'package:flutter/material.dart';

class FriendsListPage extends StatefulWidget {
  @override
  _FriendsListPageState createState() => _FriendsListPageState();
}

class _FriendsListPageState extends State<FriendsListPage> {
  // Sample data for friends list
  final List<Map<String, dynamic>> friends = [
    {
      'name': 'Alice',
      'profileImage': 'assets/user_avatar.png',
      'status': 'Online',
      'lastActive': '2 mins ago',
      'rating': 1450,
      'achievements': ['Codeforces Specialist', 'Hackathon Winner'],
      'isFriend': true,
    },
    {
      'name': 'Bob',
      'profileImage': 'assets/user_avatar.png',
      'status': 'Offline',
      'lastActive': '1 hour ago',
      'rating': 1200,
      'achievements': ['LeetCode Expert'],
      'isFriend': true,
    },
    {
      'name': 'Charlie',
      'profileImage': 'assets/user_avatar.png',
      'status': 'Online',
      'lastActive': '5 mins ago',
      'rating': 1600,
      'achievements': ['Google Code Jam Participant'],
      'isFriend': true,
    },
    {
      'name': 'Diana',
      'profileImage': 'assets/user_avatar.png',
      'status': 'Offline',
      'lastActive': '3 hours ago',
      'rating': 1300,
      'achievements': ['TopCoder Competitor'],
      'isFriend': false,
    },
  ];

  String searchQuery = '';
  List<Map<String, dynamic>> filteredFriends = [];

  @override
  void initState() {
    super.initState();
    filteredFriends = friends;
  }

  void _filterFriends(String query) {
    setState(() {
      searchQuery = query;
      filteredFriends = friends
          .where((friend) =>
          friend['name'].toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Friends List'),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: FriendsSearchDelegate(friends),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddFriendsPage()),
          );
        },
        child: Icon(Icons.person_add),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search friends...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onChanged: _filterFriends,
            ),
          ),
          // Friend Requests Section
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16.0),
              itemCount: filteredFriends.length,
              itemBuilder: (context, index) {
                final friend = filteredFriends[index];
                return Card(
                  margin: EdgeInsets.only(bottom: 16.0),
                  child: ListTile(
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
                          friend['status'] == 'Online'
                              ? 'Online'
                              : 'Last active: ${friend['lastActive']}',
                          style: TextStyle(
                            color: friend['status'] == 'Online'
                                ? Colors.green
                                : Colors.grey,
                          ),
                        ),
                        SizedBox(height: 4),
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
                    trailing: friend['isFriend']
                        ? null // Remove the message button
                        : ElevatedButton(
                      onPressed: () {
                        // Accept friend request
                        setState(() {
                          friend['isFriend'] = true;
                        });
                      },
                      child: Text('Accept'),
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

// Search Delegate for Friends List
class FriendsSearchDelegate extends SearchDelegate<String> {
  final List<Map<String, dynamic>> friends;

  FriendsSearchDelegate(this.friends);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, ''); // Return an empty string instead of null
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = friends
        .where((friend) =>
        friend['name'].toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final friend = results[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: AssetImage(friend['profileImage']),
          ),
          title: Text(friend['name']),
          subtitle: Text('Rating: ${friend['rating']}'),
          onTap: () {
            close(context, friend['name']); // Return the selected friend's name
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = friends
        .where((friend) =>
        friend['name'].toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final friend = suggestions[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: AssetImage(friend['profileImage']),
          ),
          title: Text(friend['name']),
          subtitle: Text('Rating: ${friend['rating']}'),
          onTap: () {
            query = friend['name']; // Update the query with the selected friend's name
            showResults(context); // Show the results for the selected friend
          },
        );
      },
    );
  }
}