// First, ensure you have these dependencies in pubspec.yaml
// ignore_for_file: unused_import

/*
dependencies:
  firebase_core: ^2.24.2
  firebase_database: ^10.4.0
  firebase_auth: ^4.16.0
*/

// main.dart
import 'package:firebase_core/firebase_core.dart';
import 'package:flowflex/login.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}

class DataDisplayPage extends StatefulWidget {
  @override
  _DataDisplayPageState createState() => _DataDisplayPageState();
}

class _DataDisplayPageState extends State<DataDisplayPage> {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  // Replace 'your_data_path' with your actual database path
  late Stream<DatabaseEvent> _dataStream;

  @override
  void initState() {
    super.initState();
    _dataStream = _database.child('/users/').onValue;
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Real-time Data'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const Login()),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder(
        stream: _dataStream,
        builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data?.snapshot.value == null) {
            return const Center(child: Text('No data available'));
          }

          // Convert the data to a more usable format
          Map<dynamic, dynamic> data =
              snapshot.data!.snapshot.value as Map<dynamic, dynamic>;

          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              String key = data.keys.elementAt(index);
              dynamic value = data[key];
              return ListTile(
                title: Text(key),
                subtitle: Text(value.toString()),
              );
            },
          );
        },
      ),
    );
  }
}
