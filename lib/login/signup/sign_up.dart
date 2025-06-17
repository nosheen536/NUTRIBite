

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _isLoading = false;
  bool _obscurePassword = true;
  late FocusNode _passwordFocusNode;
  bool _showPasswordWarning = false;

  String? _usernameError;
  String? _passwordError;

  RegExp _passwordRegEx = RegExp(r'^[A-Za-z\d_]{8,}$');

  DateTime? _lastBackPressTime;

  @override
  void initState() {
    super.initState();
    _passwordFocusNode = FocusNode();
    _passwordFocusNode.addListener(() {
      setState(() {
        _showPasswordWarning = _passwordFocusNode.hasFocus;
      });
    });
    _fullNameController.addListener(_validateUsername);
    _passwordController.addListener(_validatePassword);
  }

  void _validateUsername() async {
    final username = _fullNameController.text.trim();
    if (username.isEmpty) {
      setState(() => _usernameError = 'Username cannot be empty');
      return;
    }
    final isTaken = await _isUsernameTaken(username);
    setState(() => _usernameError = isTaken ? 'Username already taken' : null);
  }

  void _validatePassword() {
    final password = _passwordController.text.trim();
    setState(() {
      _passwordError = !_passwordRegEx.hasMatch(password)
          ? 'Must be 8+ chars, only letters, numbers, underscores'
          : null;
    });
  }

  Future<bool> _isUsernameTaken(String username) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('username', isEqualTo: username)
        .get();
    return querySnapshot.docs.isNotEmpty;
  }

  Future<void> _createAccount() async {
    if (_usernameError != null || _passwordError != null) return;
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      final userDoc = FirebaseFirestore.instance
          .collection('users')
          .doc(_auth.currentUser!.uid);

      await userDoc.set({
        'fullName': _fullNameController.text.trim(),
        'username': _fullNameController.text.trim(),
        'email': _emailController.text.trim(),
        'createdAt': Timestamp.now(),
        'favorites': [],
        'hydration': {},
      });

      setState(() => _isLoading = false);

      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: const Color.fromRGBO(217, 233, 193, 1),
          contentPadding: const EdgeInsets.all(24),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.star_rounded, size: 60, color: Colors.green),
              SizedBox(height: 20),
              Text(
                'Let’s Get to Know You Better!',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Chewy',
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              Text(
                'Personalize your journey for better recommendations.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Color.fromRGBO(186, 216, 135, 1),
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                  side: const BorderSide(color: Colors.black, width: 2),
                ),
              ),
              onPressed: () async {
                Navigator.of(context).pop();

                final prefs = await SharedPreferences.getInstance();
                await prefs.setBool('justSignedIn', true);

                Navigator.pushReplacementNamed(context, '/authHandler');
              },
              child: const Text(
                'Continue',
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ],
        ),
      );
    } on FirebaseAuthException catch (e) {
      setState(() => _isLoading = false);
      String errorMessage = 'Error occurred. Please try again.';

      if (e.code == 'email-already-in-use') {
        errorMessage = 'The email is already in use. Please use a different email.';
      } else if (e.code == 'weak-password') {
        errorMessage = 'Password is too weak. Use at least 6 characters.';
      } else if (e.code == 'invalid-email') {
        errorMessage = 'Invalid email format. Please check and try again.';
      }

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorMessage)));
    } catch (_) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An unknown error occurred.')),
      );
    }
  }

  @override
  void dispose() {
    _passwordFocusNode.dispose();
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<bool> _onWillPop() async {
    DateTime now = DateTime.now();
    if (_lastBackPressTime == null || now.difference(_lastBackPressTime!) > const Duration(seconds: 2)) {
      _lastBackPressTime = now;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Press back again to exit')),
      );
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
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
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 50),
                      child: Column(
                        children: [
                          const Text(
                            "Sign Up",
                            style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900),
                          ),
                          const SizedBox(height: 15),
                          const Text(
                            "Create Your Free Account",
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500, fontFamily: 'Chewy'),
                          ),
                          const SizedBox(height: 30),
                          _buildTextField(_fullNameController, "Username", _usernameError),
                          const SizedBox(height: 10),
                          _buildTextField(_emailController, "Email", null),
                          const SizedBox(height: 10),
                          _buildPasswordField(_passwordController, "Password", _passwordError),
                          const SizedBox(height: 10),
                          _buildPasswordField(_confirmPasswordController, "Confirm Password", null),
                          const SizedBox(height: 30),
                          if (_isLoading)
                            const CircularProgressIndicator()
                          else
                            ElevatedButton(
                              onPressed: _createAccount,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color.fromRGBO(186, 216, 135, 1),
                                side: const BorderSide(color: Colors.black, width: 2),
                                padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              child: const Text(
                                "Create Account",
                                style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.w800),
                              ),
                            ),
                          const SizedBox(height: 40),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("Already have an account? ",
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                              GestureDetector(
                                onTap: () => Navigator.pushNamed(context, '/login'),
                                child: const Text(
                                  "Log In",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          OutlinedButton(
                            onPressed: () => Navigator.pushNamed(context, '/guestscreen'),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Colors.black, width: 2),
                              padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              backgroundColor: const Color.fromRGBO(186, 216, 135, 1),
                            ),
                            child: const Text(
                              "Skip & Explore",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hintText, String? errorText) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        filled: false,
        fillColor: const Color.fromARGB(0, 217, 233, 193),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: Colors.black, width: 2),
        ),
        errorText: errorText,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: Colors.black, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: Color.fromARGB(255, 0, 0, 0), width: 2),
        ),
      ),
    );
  }

  Widget _buildPasswordField(TextEditingController controller, String hintText, String? errorText) {
    return TextField(
      controller: controller,
      focusNode: hintText == "Password" ? _passwordFocusNode : null,
      obscureText: _obscurePassword,
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: const Color.fromARGB(0, 217, 233, 193),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: Colors.black, width: 2),
        ),
        errorText: errorText,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: Colors.black, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: Colors.black, width: 2),
        ),
        suffixIcon: GestureDetector(
          onTap: () {
            setState(() => _obscurePassword = !_obscurePassword);
          },
          child: Icon(
            _obscurePassword ? Icons.visibility_off : Icons.visibility,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
