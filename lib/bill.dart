import 'package:flowflex/news.dart';
import 'package:flowflex/usage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class BillDetailsPage extends StatefulWidget {
  const BillDetailsPage({super.key});

  @override
  _BillDetailsPageState createState() => _BillDetailsPageState();
}

class _BillDetailsPageState extends State<BillDetailsPage> {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  int units = 0;

  @override
  void initState() {
    super.initState();
    _fetchUnits();
  }

  void _fetchUnits() {
    _database.child('units').onValue.listen((event) {
      if (event.snapshot.value != null) {
        setState(() {
          units = int.parse(event.snapshot.value.toString());
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        title: Row(
          children: [
            Image.asset(
              'assets/appbar.png', // Ensure this image is in your assets
              height: 50,
            ),
            const SizedBox(width: 8),
            const Text('Bill Details'),
          ],
        ),
        actions: const [
          CircleAvatar(
            backgroundColor: Colors.blue,
            child: Icon(Icons.person, color: Colors.white),
          ),
          SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'BILL DETAILS...',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A237E),
                ),
              ),
              const SizedBox(height: 24),
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Units of usage:',
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 16,
                        ),
                      ),
                      const Text(
                        'From:- 12 Sep To:- 22 Sep',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '$units',
                            style: const TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const Text(
                            ' of units',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Base rate charges:'),
                          Text('Rs. 114.21'),
                        ],
                      ),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Tax:'),
                          Text('Rs. 3.21'),
                        ],
                      ),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Additional charges:'),
                          Text('Rs. 0'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      // Add view usage history functionality
                    },
                    child: const Text('View Usage History >'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Add payment functionality
                    },
                    child: const Text('PAY NOW'),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _buildOptionButton(
                  'WATER USAGE', Icons.water_drop, DataDisplayPage()),
              _buildOptionButton(
                  'NOTIFICATIONS', Icons.notifications, const NewsScreen()),
              _buildOptionButton(
                  'ACCOUNT SETTINGS', Icons.settings, DataDisplayPage()),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      // Add logout functionality
                    },
                    child: const Text('≫ Logout'),
                  ),
                  TextButton(
                    onPressed: () {
                      // Add home navigation
                    },
                    child: const Text('⟪ Home'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOptionButton(String title, IconData icon, Widget targetPage) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => targetPage),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 50),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.blue),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(color: Colors.blue),
            ),
          ],
        ),
      ),
    );
  }
}
