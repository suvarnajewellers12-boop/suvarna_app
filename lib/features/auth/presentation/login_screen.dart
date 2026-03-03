import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/auth_service.dart';
import 'login_otp_screen.dart';

enum LoginMethod { mobile, username }

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _identifierController =
  TextEditingController();
  final TextEditingController _passwordController =
  TextEditingController();

  LoginMethod _method = LoginMethod.mobile;
  bool _isLoading = false;
  bool _obscurePassword = true;
  String? _error;

  void _submit() async {
    setState(() => _error = null);

    final identifier = _identifierController.text.trim();
    final password = _passwordController.text.trim();

    if (identifier.isEmpty) {
      setState(() {
        _error = _method == LoginMethod.mobile
            ? "Enter your mobile number"
            : "Enter your username";
      });
      return;
    }

    if (_method == LoginMethod.mobile && identifier.length != 10) {
      setState(() => _error = "Enter valid 10-digit mobile number");
      return;
    }

    if (password.length < 6) {
      setState(() => _error = "Enter your password");
      return;
    }

    setState(() => _isLoading = true);

    final response = await AuthService.login(
      identifier: identifier,
      password: password,
    );

    setState(() => _isLoading = false);

    if (!response.success) {
      setState(() => _error = response.message);
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => LoginOtpScreen(
          username: response.username!,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              "assets/images/showroom_bg.png",
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
              child: Container(
                color: const Color(0xFFF5EBDD).withOpacity(0.70),
              ),
            ),
          ),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 22, vertical: 24),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF6F0E4),
                    borderRadius: BorderRadius.circular(26),
                    border: Border.all(
                      color: const Color(0xFFD4AF37).withOpacity(0.25),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Icon(
                          Icons.arrow_back_ios_new,
                          size: 16,
                          color: Color(0xFF7A7267),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: Column(
                          children: [
                            Text(
                              "Welcome Back",
                              style: GoogleFonts.playfairDisplay(
                                fontSize: 26,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF3B2A1F),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              "Login to your account",
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                color: const Color(0xFF8E8578),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 22),

                      /// Toggle
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildToggle(
                            title: "Mobile",
                            active: _method == LoginMethod.mobile,
                            onTap: () {
                              setState(() {
                                _method = LoginMethod.mobile;
                                _identifierController.clear();
                              });
                            },
                          ),
                          const SizedBox(width: 10),
                          _buildToggle(
                            title: "Username",
                            active: _method == LoginMethod.username,
                            onTap: () {
                              setState(() {
                                _method = LoginMethod.username;
                                _identifierController.clear();
                              });
                            },
                          ),
                        ],
                      ),

                      const SizedBox(height: 18),

                      _buildIdentifierField(),
                      _buildPasswordField(),

                      if (_error != null) ...[
                        const SizedBox(height: 10),
                        Text(
                          _error!,
                          style: const TextStyle(
                            color: Colors.redAccent,
                            fontSize: 13,
                          ),
                        ),
                      ],

                      const SizedBox(height: 22),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _submit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFD4AF37),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                            padding:
                            const EdgeInsets.symmetric(vertical: 15),
                          ),
                          child: _isLoading
                              ? const SizedBox(
                            height: 18,
                            width: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                              : const Text(
                            "Continue",
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggle({
    required String title,
    required bool active,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding:
        const EdgeInsets.symmetric(horizontal: 18, vertical: 7),
        decoration: BoxDecoration(
          color: active ? const Color(0xFFD4AF37) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFD4AF37)),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: active ? Colors.white : const Color(0xFF6E665A),
          ),
        ),
      ),
    );
  }

  Widget _buildIdentifierField() {
    if (_method == LoginMethod.mobile) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Container(
          height: 56,
          decoration: BoxDecoration(
            color: const Color(0xFFF5EBDD),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: const Color(0xFFD4AF37).withOpacity(0.4),
            ),
          ),
          child: Row(
            children: [
              const SizedBox(width: 14),
              Text(
                "+91",
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: const Color(0xFF6E665A),
                ),
              ),
              Container(
                height: 28,
                width: 1,
                margin: const EdgeInsets.symmetric(horizontal: 12),
                color: const Color(0xFFD4AF37).withOpacity(0.5),
              ),
              Expanded(
                child: TextField(
                  controller: _identifierController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "10-digit number",
                    hintStyle: GoogleFonts.poppins(
                      fontSize: 14,
                      color: const Color(0xFFB8B0A4),
                    ),
                  ),
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: const Color(0xFF6E665A),
                  ),
                ),
              ),
              const SizedBox(width: 14),
            ],
          ),
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Container(
          height: 56,
          decoration: BoxDecoration(
            color: const Color(0xFFF5EBDD),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: const Color(0xFFD4AF37).withOpacity(0.4),
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: TextField(
            controller: _identifierController,
            textAlignVertical: TextAlignVertical.center,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: "Enter your username",
              hintStyle: GoogleFonts.poppins(
                fontSize: 14,
                color: const Color(0xFFB8B0A4),
              ),
            ),
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: const Color(0xFF6E665A),
            ),
          ),
        ),
      );
    }
  }

  Widget _buildPasswordField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          color: const Color(0xFFF5EBDD),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: const Color(0xFFD4AF37).withOpacity(0.4),
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Enter password",
                  hintStyle: GoogleFonts.poppins(
                    fontSize: 14,
                    color: const Color(0xFFB8B0A4),
                  ),
                ),
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: const Color(0xFF6E665A),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
              child: Icon(
                _obscurePassword
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                color: const Color(0xFF6E665A),
              ),
            )
          ],
        ),
      ),
    );
  }
}