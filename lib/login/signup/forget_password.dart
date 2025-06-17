import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController emailController = TextEditingController();
  bool _isSending = false;
   void _sendResetEmail() async {
  FocusScope.of(context).unfocus(); // hide keyboard
  final email = emailController.text.trim();

  if (email.isEmpty) {
    _showSnackBar('Please enter your email.');
    return;
  }

  setState(() => _isSending = true);

  try {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    _showSnackBar('Reset link sent! Check your email.');

    // Navigate to login page after sending reset email
    Navigator.pushReplacementNamed(context, '/login');
  } on FirebaseAuthException catch (e) {
    String message = 'Something went wrong.';
    if (e.code == 'user-not-found') {
      message = 'No user found with this email.';
    } else if (e.code == 'invalid-email') {
      message = 'Please enter a valid email address.';
    }
    _showSnackBar(message);
  } finally {
    setState(() => _isSending = false);
  }
}


  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: const Color.fromRGBO(217,233, 193, 1),
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
      child:GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(), // dismiss keyboard on tap outside
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 70,),
                const Text(
                  'Forgot your password?',
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 27,
                    fontFamily: 'Comic Sans MS',
                  ),
                ),
                const SizedBox(height: 40),
                const Text(
                  'Enter your registered email below and we\'ll send you a link to reset your password.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500,fontStyle: FontStyle.italic),
                ),
                const SizedBox(height: 37),

                // TextField with 75% screen width
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.89, // 75% width
                  child: TextField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: 'Email',
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                      // Consistent borders for both focused and unfocused
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: const BorderSide(color: Colors.black, width: 2),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: const BorderSide(color: Colors.black, width: 2),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: const BorderSide(color: Colors.black, width: 2),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                // Button with 30% screen width
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.70, // 30% width
                  height: 57, // Set a fixed height for the button
                  child: ElevatedButton(
                    onPressed: _isSending ? null : _sendResetEmail,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(186, 216, 135, 1),
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                        side: const BorderSide(color: Colors.black, width: 2),
                      ),
                    ),
                    child: _isSending
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                            ),
                          )
                        : const Text(
                            'Send Reset Link',
                            style: TextStyle(fontSize: 18,fontWeight: FontWeight.w800),
                          ),
                  ),
                ),
                const SizedBox(height: 280),

                // Back to login text positioned at the bottom-right
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 15.0),
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Text(
                        '← Back to Login',
                        style: TextStyle(
                          fontSize: 21, // Increased size
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      )
    );
  }
}
