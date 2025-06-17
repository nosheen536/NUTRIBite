
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async'; // For timer
import 'package:flutter/services.dart'; // For SystemNavigator.pop()

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _exitWarning = false;

  final Color inputBorderColor = Colors.black;
  final double borderRadius = 30.0;

  Future<void> _login() async {
    setState(() => _isLoading = true);
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login successful!')),
      );

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          backgroundColor: const Color.fromRGBO(217, 233, 193, 1),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.check_circle, size: 60, color: Colors.green),
                SizedBox(height: 20),
                Text(
                  'Welcome Back!',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                ),
                SizedBox(height: 12),
                Text(
                  'We\'re glad to see you again!',
                  style: TextStyle(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      );

      await Future.delayed(const Duration(seconds: 3));
      if (mounted) {
        Navigator.pop(context); // Close dialog

        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('justSignedIn', true);
        Navigator.pushReplacementNamed(context, '/authHandler');
      }
    } on FirebaseAuthException catch (e) {
      setState(() => _isLoading = false);
      String message = 'Login failed.';

      if (e.code == 'user-not-found') {
        message = 'No user found with this email.';
      } else if (e.code == 'wrong-password') {
        message = 'Incorrect password.';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double fieldWidth = screenWidth * 0.89;
    final double buttonWidth = fieldWidth * 0.8;

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color.fromRGBO(245, 255, 235, 1),
                Color.fromRGBO(210, 235, 175, 1),
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Log In',
                      style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(height: 30),
                    _buildTextField(
                      controller: _emailController,
                      hint: 'Email',
                      width: fieldWidth,
                    ),
                    const SizedBox(height: 10),
                    _buildPasswordField(width: fieldWidth),
                    const SizedBox(height: 20),
                    _isLoading
                        ? const CircularProgressIndicator()
                        : _buildButton('Log In', _login, buttonWidth),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Don't have an account? ",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, '/signup');
                          },
                          child: const Text(
                            "Sign Up",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                              fontSize: 18,
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 20),
                    _buildButton('Skip & Explore', () {
                      Navigator.pushNamed(context, '/guestscreen');
                    }, buttonWidth),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _onWillPop() async {
    if (_exitWarning) {
      SystemNavigator.pop();
      return true;
    } else {
      setState(() => _exitWarning = true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tap again to exit'),
          duration: Duration(seconds: 2),
        ),
      );
      Timer(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() => _exitWarning = false);
        }
      });
      return false;
    }
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required double width,
    bool obscureText = false,
  }) {
    return SizedBox(
      width: width,
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          hintText: hint,
          filled: true,
          fillColor: Colors.transparent,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: BorderSide(color: inputBorderColor, width: 2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: BorderSide(color: inputBorderColor, width: 2),
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField({required double width}) {
    return SizedBox(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          TextField(
            controller: _passwordController,
            obscureText: _obscurePassword,
            decoration: InputDecoration(
              hintText: 'Password',
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility_off : Icons.visibility,
                  color: Colors.black,
                ),
                onPressed: () {
                  setState(() => _obscurePassword = !_obscurePassword);
                },
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius),
                borderSide: BorderSide(color: inputBorderColor, width: 2),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius),
                borderSide: BorderSide(color: inputBorderColor, width: 2),
              ),
            ),
          ),
          const SizedBox(height: 6),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/forgotpassword');
            },
            child: const Text(
              'Forgot Password?',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildButton(String text, VoidCallback onPressed, double width) {
    return SizedBox(
      width: width,
      height: 55,
      child: Container(
        decoration: BoxDecoration(
          color: const Color.fromRGBO(186, 216, 135, 1),
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(color: inputBorderColor, width: 2),
        ),
        child: TextButton(
          onPressed: onPressed,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: Text(
              text,
              style: const TextStyle(
                  color: Colors.black, fontSize: 18, fontWeight: FontWeight.w800),
            ),
          ),
        ),
      ),
    );
  }
}
