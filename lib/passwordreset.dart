import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Passwordreset extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();

  Passwordreset({super.key});

  void sendPasswordResetEmail(BuildContext context) async {
    final email = emailController.text.trim();

    // Input validation
    if (email.isEmpty) {
      _showAlertDialog(
        context,
        title: 'Error',
        content: 'Please enter your email address.',
      );
      return;
    }

    try {
      // Show progress indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      // Send password reset email
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text.trim());

      // Close progress indicator
      Navigator.of(context).pop();

      // Clear email field and unfocus keyboard
      emailController.clear();
      FocusScope.of(context).unfocus();

      // Show success message
      _showAlertDialog(
        context,
        title: 'Success',
        content: 'Password reset email has been sent to $email.',
      );
    } catch (e) {
      // Close progress indicator
      Navigator.of(context).pop();

      // Handle Firebase errors
      String errorMessage = 'An error occurred. Please try again.';
      if (e is FirebaseAuthException) {
        switch (e.code) {
          case 'user-not-found':
            errorMessage = 'No user found for that email.';
            break;
          case 'invalid-email':
            errorMessage = 'The email address is not valid.';
            break;
        }
      }

      _showAlertDialog(
        context,
        title: 'Error',
        content: errorMessage,
      );
    }
  }

  void _showAlertDialog(BuildContext context,
      {required String title, required String content}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reset Password')),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 170, 169, 169), // Light
              Color(0xFFFAE8D0), // Dark
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: GestureDetector(
          onTap: () =>
              FocusScope.of(context).unfocus(), // Dismiss keyboard on tap
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => sendPasswordResetEmail(context),
                  child: const Text('Send Password Reset Email'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
