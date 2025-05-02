import 'package:firebase_auth/firebase_auth.dart';
import 'package:flowflex/bill.dart';
import 'package:flowflex/news.dart';
import 'package:flowflex/usage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'login.dart';
import 'package:flowflex/about.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  String currentDateTime = '';
  String userName = '';

  @override
  void initState() {
    super.initState();
    updateDateTime();
  }

  void updateDateTime() {
    setState(() {
      currentDateTime =
          DateFormat('EEEE, MMMM d, yyyy\nhh:mm a').format(DateTime.now());
    });
    Future.delayed(const Duration(minutes: 1), updateDateTime);
  }

  Future<String?> _getUserName(BuildContext context) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final userData = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        return userData['account_owner_name'] as String?;
      }
    } catch (e) {
      _showErrorDialog(context, "Error fetching user name: $e");
    }
    return "User Name";
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Error"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            Image.asset(
              'assets/appbar.png',
              height: 50,
              width: 250,
            ),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.dehaze),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const About()),
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notification_important_outlined,
                color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const NewsScreen()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Text(
              currentDateTime,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            Text(
              "WELCOME $userName",
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.indigo,
              ),
            ),
            const SizedBox(height: 20),
            StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc('account_owner_name') // Replace with actual user ID
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Text('Something went wrong');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }

                final data = snapshot.data?.data() as Map<String, dynamic>?;

                return Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ListTile(
                    leading: const CircleAvatar(
                      backgroundImage: NetworkImage(
                        'https://cdn2.iconfinder.com/data/icons/audio-16/96/user_avatar_profile_login_button_account_member-512.png',
                      ),
                      radius: 30,
                    ),
                    title: Text(
                      data?['account_owner_name'] ?? 'Yasith Inosh',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(data?['water_meter_number'] ?? '22551144'),
                    trailing: TextButton(
                      onPressed: () {
                        // Handle edit profile
                      },
                      child: const Text(
                        "edit profile",
                        style: TextStyle(color: Colors.teal),
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            _buildButton(
              context,
              "WATER USAGE",
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DataDisplayPage()),
                );
              },
            ),
            _buildButton(context, "BILLS", () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const BillDetailsPage()));
              // Add navigation for "BILLS" if required
            }),
            _buildButton(context, "NOTIFICATIONS", () {
              // Add navigation for "NOTIFICATIONS" if required
            }),
            _buildButton(context, "ACCOUNT SETTINGS", () {
              // Add navigation for "ACCOUNT SETTINGS" if required
            }),
            const Spacer(),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Login()),
                  );
                },
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Logout", style: TextStyle(color: Colors.blue)),
                    SizedBox(width: 5),
                    Icon(Icons.logout, color: Colors.blue),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(
      BuildContext context, String text, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.indigo,
          backgroundColor: Colors.white,
          side: const BorderSide(color: Colors.indigo, width: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        onPressed: onPressed,
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: Center(
            child: Text(
              text,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}
