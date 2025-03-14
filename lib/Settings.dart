import 'package:code_champ/home.dart';
import 'package:code_champ/login.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:code_champ/theme_provider.dart';

import 'Club.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notificationsEnabled = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _notificationsEnabled = prefs.getBool('notifications') ?? true;
    });
  }

  Future<void> _toggleNotifications(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notifications', value);
    setState(() {
      _notificationsEnabled = value;
    });
  }

  void _changeUsername() {
    // Implement Firebase username change logic
  }

  void _changePassword() {
    // Implement Firebase password change logic
  }

  void _logout() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  void _deleteAccount() {
    // Implement account deletion logic
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Settings', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
              );
            case 1:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ClubDashboard()),
              );
              break;
            case 2:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => SettingsPage()), // Navigate to Settings
              );
              break;
              break;
            case 3:

              break;
          }
        },
        items: [
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
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          _buildSettingTile(Icons.person, 'Change Username', _changeUsername),
          _buildSettingTile(Icons.lock, 'Change Password', _changePassword),
          _buildSwitchTile(Icons.dark_mode, 'Dark Mode', themeProvider.isDarkMode, (value) {
            themeProvider.toggleTheme(value);
          }),
          _buildSwitchTile(Icons.notifications, 'Notifications', _notificationsEnabled, _toggleNotifications),
          Divider(),
          _buildSettingTile(Icons.exit_to_app, 'Logout', _logout, isDestructive: true),
          _buildSettingTile(Icons.delete_forever, 'Delete Account', _deleteAccount, isDestructive: true),
        ],
      ),
    );
  }

  Widget _buildSettingTile(IconData icon, String title, VoidCallback onTap, {bool isDestructive = false}) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: isDestructive ? Colors.red : null),
        title: Text(title, style: TextStyle(fontSize: 16)),
        trailing: Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }

  Widget _buildSwitchTile(IconData icon, String title, bool value, Function(bool) onChanged) {
    return Card(
      child: SwitchListTile(
        secondary: Icon(icon),
        title: Text(title, style: TextStyle(fontSize: 16)),
        value: value,
        onChanged: onChanged,
      ),
    );
  }
}
