import 'package:flowflex/login.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'main.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _initialsController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _waterMeterController = TextEditingController();
  final TextEditingController _accountOwnerController = TextEditingController();
  final TextEditingController _nicController = TextEditingController();
  final TextEditingController _installationDateController =
      TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool _isLoading = false;
  bool _isPasswordVisible = false;

  // Show Alert Dialog
  void _showDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  // Registration Function
  Future<void> registerUser() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        // Firebase Authentication
        UserCredential userCredential =
            await _auth.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        // Firestore User Data
        await _firestore.collection('users').doc(userCredential.user!.uid).set({
          'full_name': _fullNameController.text.trim(),
          'name_with_initials': _initialsController.text.trim(),
          'address': _addressController.text.trim(),
          'water_meter_number': _waterMeterController.text.trim(),
          'account_owner_name': _accountOwnerController.text.trim(),
          'nic_number': _nicController.text.trim(),
          'installation_date': _installationDateController.text.trim(),
          'email': _emailController.text.trim(),
          'uid': userCredential.user!.uid,
        });

        setState(() {
          _isLoading = false;
        });

        // Success Dialog
        _showDialog('Registration Successful',
            'Your account has been created successfully!');

        // Navigate to Home
        // ignore: use_build_context_synchronously
        Navigator.push(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(builder: (context) => const Login()),
        );
      } catch (e) {
        setState(() {
          _isLoading = false;
        });

        // Error Dialog
        _showDialog('Registration Failed', e.toString());
      }
    }
  }

  // Reusable TextField Widget
  Widget buildTextField({
    required TextEditingController controller,
    required String label,
    required String? Function(String?) validator,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    void Function()? onTap,
    bool readOnly = false,
    Widget? suffixIcon,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      readOnly: readOnly,
      onTap: onTap,
      decoration: InputDecoration(
        labelText: label,
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      validator: validator,
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
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Stack(
        children: [
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                padding: const EdgeInsets.all(20),
                width: MediaQuery.of(context).size.width * 0.9,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Center(
                        child: Text(
                          'REGISTER NOW',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      buildTextField(
                        controller: _fullNameController,
                        label: 'Full Name',
                        validator: (value) => value!.isEmpty
                            ? 'Please enter your full name'
                            : null,
                      ),
                      const SizedBox(height: 10),
                      buildTextField(
                        controller: _initialsController,
                        label: 'Name with Initials',
                        validator: (value) => value!.isEmpty
                            ? 'Please enter your initials'
                            : null,
                      ),
                      const SizedBox(height: 10),
                      buildTextField(
                        controller: _addressController,
                        label: 'Address',
                        validator: (value) =>
                            value!.isEmpty ? 'Please enter your address' : null,
                      ),
                      const SizedBox(height: 10),
                      buildTextField(
                        controller: _waterMeterController,
                        label: 'Water Meter Number',
                        keyboardType: TextInputType.number,
                        validator: (value) => value!.isEmpty
                            ? 'Please enter your water meter number'
                            : null,
                      ),
                      const SizedBox(height: 10),
                      buildTextField(
                        controller: _accountOwnerController,
                        label: 'Account Owner Name',
                        validator: (value) => value!.isEmpty
                            ? 'Please enter the account owner\'s name'
                            : null,
                      ),
                      const SizedBox(height: 10),
                      buildTextField(
                        controller: _nicController,
                        label: 'NIC Number',
                        validator: (value) => value!.isEmpty
                            ? 'Please enter your NIC number'
                            : null,
                      ),
                      const SizedBox(height: 10),
                      buildTextField(
                        controller: _installationDateController,
                        label: 'Installation Date',
                        readOnly: true,
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                          );
                          _installationDateController.text =
                              "${pickedDate?.year}-${pickedDate?.month}-${pickedDate?.day}";
                        },
                        validator: (value) =>
                            value!.isEmpty ? 'Please select a date' : null,
                      ),
                      const SizedBox(height: 10),
                      buildTextField(
                        controller: _emailController,
                        label: 'Email Address',
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) =>
                            value!.isEmpty || !value.contains('@')
                                ? 'Please enter a valid email address'
                                : null,
                      ),
                      const SizedBox(height: 10),
                      buildTextField(
                        controller: _passwordController,
                        label: 'Password',
                        obscureText: !_isPasswordVisible,
                        validator: (value) => value!.length < 6
                            ? 'Password must be at least 6 characters long'
                            : null,
                        suffixIcon: IconButton(
                          icon: Icon(_isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: 10),
                      buildTextField(
                        controller: _confirmPasswordController,
                        label: 'Confirm Password',
                        obscureText: true,
                        validator: (value) =>
                            value != _passwordController.text.trim()
                                ? 'Passwords do not match'
                                : null,
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: registerUser,
                        child: const Text('Register Now'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Login()),
                          );
                        },
                        child: const Text('Have an account? Log in here'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black54,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
          Positioned(
            bottom: 16,
            right: 16,
            child: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const WelcomePage()),
                );
              },
              child: const Icon(Icons.home),
            ),
          ),
        ],
      ),
    );
  }
}
