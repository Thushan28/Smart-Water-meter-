import 'package:flutter/material.dart';

class About extends StatelessWidget {
  const About({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact and About'),
        
        centerTitle: true,
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // CONTACT DETAILS SECTION
            Text(
              "CONTACT DETAILS",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            Divider(thickness: 2),
            SizedBox(height: 8),
            Text(
              "+94 112054128",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 4),
            Text(
              "+94 712054128",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 4),
            Text(
              "ar@tec.rjt.ac.lk",
              style: TextStyle(fontSize: 16, color: Colors.blue),
            ),
            SizedBox(height: 24),

            // ABOUT SECTION
            Text(
              "ABOUT",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            Divider(thickness: 2),
            SizedBox(height: 8),

            // VISION SECTION
            Text(
              "Vision",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 4),
            Text(
              "To be a center of excellence in higher education and research.",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),

            // MISSION SECTION
            Text(
              "Mission",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 4),
            Text(
              "To produce innovative intellectuals capable of taking challenges in the context of global development through the competencies developed from the academic programmes, research, and training of wide nature.",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 40),

            // VERSION INFO
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.settings,
                  size: 24,
                ),
                SizedBox(width: 8),
                Text(
                  "Version 1.0.0",
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
