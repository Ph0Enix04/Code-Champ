import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Profile.dart';
import 'controller.dart';
import 'home.dart';
import 'login.dart';
import 'Club.dart';
import 'theme_provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notificationsEnabled = true;
  final UserController userController = Get.find<UserController>();

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

  String _handleFirebaseAuthError(dynamic e) {
    if (e is FirebaseAuthException) {
      switch (e.code) {
        case 'wrong-password':
          return "Incorrect current password.";
        case 'requires-recent-login':
          return "Please sign in again for security.";
        case 'network-request-failed':
          return "Check your internet connection.";
        default:
          return e.message ?? "An error occurred.";
      }
    }
    return "An unexpected error occurred.";
  }

  Future<void> _changeUsername(BuildContext context) async {
    TextEditingController usernameController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Change Username"),
          content: TextField(
            controller: usernameController,
            decoration: const InputDecoration(hintText: "Enter new username"),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                String newUsername = usernameController.text.trim();
                if (newUsername.isEmpty) {
                  Get.snackbar("Error", "Username cannot be empty",
                      snackPosition: SnackPosition.TOP,
                      backgroundColor: Colors.red,
                      colorText: Colors.white);
                  return;
                }

                User? user = FirebaseAuth.instance.currentUser;
                if (user == null) {
                  Get.snackbar("Error", "User not logged in",
                      snackPosition: SnackPosition.TOP,
                      backgroundColor: Colors.red,
                      colorText: Colors.white);
                  return;
                }

                bool exists = await userController.checkName(newUsername);
                if (exists) {
                  Get.snackbar("Error", "Username already exists",
                      snackPosition: SnackPosition.TOP,
                      backgroundColor: Colors.red,
                      colorText: Colors.white);
                  return;
                }

                DatabaseReference userRef = FirebaseDatabase.instance.ref("users/${user.uid}");
                DataSnapshot snapshot = await userRef.get();
                if (snapshot.exists) {
                  await userRef.update({"username": newUsername});
                  userController.userName.text = newUsername;
                  Get.snackbar("Success", "Username updated",
                      snackPosition: SnackPosition.TOP,
                      backgroundColor: Colors.green,
                      colorText: Colors.white);
                  Navigator.of(context).pop();
                } else {
                  Get.snackbar("Error", "User data not found",
                      snackPosition: SnackPosition.TOP,
                      backgroundColor: Colors.red,
                      colorText: Colors.white);
                }
              },
              child: const Text("Save"),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancel"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _changePassword(BuildContext context) async {
    TextEditingController currentPasswordController = TextEditingController();
    TextEditingController newPasswordController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Change Password"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: currentPasswordController,
                decoration: const InputDecoration(
                  hintText: "Enter current password",
                  prefixIcon: Icon(Icons.lock_outline),
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 10),
              TextField(
                controller: newPasswordController,
                decoration: const InputDecoration(
                  hintText: "Enter new password",
                  prefixIcon: Icon(Icons.lock),
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                String currentPassword = currentPasswordController.text.trim();
                String newPassword = newPasswordController.text.trim();

                if (currentPassword.isEmpty || newPassword.isEmpty) {
                  Get.snackbar("Error", "Fields cannot be empty",
                      snackPosition: SnackPosition.TOP,
                      backgroundColor: Colors.red,
                      colorText: Colors.white);
                  return;
                }

                User? user = FirebaseAuth.instance.currentUser;
                if (user == null || user.email == null) {
                  Get.snackbar("Error", "No user signed in. Please log in again.",
                      snackPosition: SnackPosition.TOP,
                      backgroundColor: Colors.red,
                      colorText: Colors.white);
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                        (route) => false,
                  );
                  return;
                }

                print("User email: ${user.email}");
                print("Current password entered: $currentPassword");
                print("New password: $newPassword");

                try {
                  AuthCredential credential = EmailAuthProvider.credential(
                    email: user.email!,
                    password: currentPassword,
                  );
                  await user.reauthenticateWithCredential(credential);
                  print("Re-authentication successful");

                  await user.updatePassword(newPassword);
                  print("Password updated successfully");

                  Get.snackbar("Success", "Password changed successfully",
                      snackPosition: SnackPosition.TOP,
                      backgroundColor: Colors.green,
                      colorText: Colors.white);
                  Navigator.of(context).pop();
                } on FirebaseAuthException catch (e) {
                  print("FirebaseAuthException: ${e.code} - ${e.message}");
                  String errorMessage;
                  switch (e.code) {
                    case 'wrong-password':
                      errorMessage = "Incorrect current password.";
                      break;
                    case 'requires-recent-login':
                      errorMessage = "Session expired. Please log in again.";
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginPage()),
                            (route) => false,
                      );
                      break;
                    case 'network-request-failed':
                      errorMessage = "Network error. Check your connection.";
                      break;
                    default:
                      errorMessage = e.message ?? "An error occurred.";
                  }
                  Get.snackbar("Error", errorMessage,
                      snackPosition: SnackPosition.TOP,
                      backgroundColor: Colors.red,
                      colorText: Colors.white);
                } catch (e) {
                  print("Unexpected error: $e");
                  Get.snackbar("Error", "An unexpected error occurred: $e",
                      snackPosition: SnackPosition.TOP,
                      backgroundColor: Colors.red,
                      colorText: Colors.white);
                }
              },
              child: const Text("Save"),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancel"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteAccount(BuildContext context) async {
    TextEditingController passwordController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Delete Account"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Enter your password to confirm account deletion."),
              const SizedBox(height: 10),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: "Enter password",
                  prefixIcon: Icon(Icons.lock),
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                String password = passwordController.text.trim();
                if (password.isEmpty) {
                  Get.snackbar("Error", "Password cannot be empty",
                      snackPosition: SnackPosition.TOP,
                      backgroundColor: Colors.red,
                      colorText: Colors.white);
                  return;
                }

                User? user = FirebaseAuth.instance.currentUser;
                if (user == null || user.email == null) {
                  Get.snackbar("Error", "No user signed in",
                      snackPosition: SnackPosition.TOP,
                      backgroundColor: Colors.red,
                      colorText: Colors.white);
                  return;
                }

                try {
                  AuthCredential credential = EmailAuthProvider.credential(
                    email: user.email!,
                    password: password,
                  );
                  await user.reauthenticateWithCredential(credential);
                  DatabaseReference userRef = FirebaseDatabase.instance.ref("users/${user.uid}");
                  await userRef.remove();
                  await user.delete();

                  Get.snackbar("Success", "Account deleted successfully",
                      snackPosition: SnackPosition.TOP,
                      backgroundColor: Colors.green,
                      colorText: Colors.white);

                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                        (route) => false,
                  );
                } on FirebaseAuthException catch (e) {
                  Get.snackbar("Error", _handleFirebaseAuthError(e),
                      snackPosition: SnackPosition.TOP,
                      backgroundColor: Colors.red,
                      colorText: Colors.white);
                }
              },
              child: const Text("Delete"),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancel"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
            (route) => false,
      );
    } catch (e) {
      Get.snackbar("Error", "Failed to log out: $e",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        currentIndex: 2, // Settings tab is selected
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) =>  HomePage()),
              );
              break;
            case 1:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const ClubDashboard()),
              );
              break;
            case 2:
            // Already on SettingsPage, no action needed
              break;
            case 3:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) =>  ProfilePage()),
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
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSettingTile(
            icon: Icons.person,
            title: 'Change Username',
            onTap: () => _changeUsername(context),
          ),
          _buildSettingTile(
            icon: Icons.lock,
            title: 'Change Password',
            onTap: () => _changePassword(context),
          ),
          _buildSwitchTile(
            icon: Icons.dark_mode,
            title: 'Dark Mode',
            value: themeProvider.isDarkMode,
            onChanged: themeProvider.toggleTheme,
          ),
          _buildSwitchTile(
            icon: Icons.notifications,
            title: 'Notifications',
            value: _notificationsEnabled,
            onChanged: _toggleNotifications,
          ),
          const Divider(),
          _buildSettingTile(
            icon: Icons.exit_to_app,
            title: 'Logout',
            onTap: () => _logout(context),
            isDestructive: true,
          ),
          _buildSettingTile(
            icon: Icons.delete_forever,
            title: 'Delete Account',
            onTap: () => _deleteAccount(context),
            isDestructive: true,
          ),
        ],
      ),
    );
  }

  Widget _buildSettingTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: isDestructive ? Colors.red : null),
        title: Text(title, style: const TextStyle(fontSize: 16)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Card(
      child: SwitchListTile(
        secondary: Icon(icon),
        title: Text(title, style: const TextStyle(fontSize: 16)),
        value: value,
        onChanged: onChanged,
      ),
    );
  }
}