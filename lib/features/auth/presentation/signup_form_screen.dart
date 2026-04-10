import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'otp_verification_screen.dart';
import '../data/auth_service.dart';

class SignUpFormScreen extends StatefulWidget {
  const SignUpFormScreen({super.key});

  @override
  State<SignUpFormScreen> createState() => _SignUpFormScreenState();
}

class _SignUpFormScreenState extends State<SignUpFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;

  void _validateAndProceed() async {
    if (!_formKey.currentState!.validate()) return;

    if (_mobileController.text.trim().length != 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enter valid 10-digit mobile number")),
      );
      return;
    }

    setState(() => _isLoading = true);

    print("STEP 1 -> calling sendSignupOtp");

    final response = await AuthService.sendSignupOtp(
      mobile: _mobileController.text.trim(),
    );

    print("STEP 2 -> response received");
    print("SUCCESS: ${response.success}");
    print("MESSAGE: ${response.message}");

    if (!mounted) return;

    setState(() => _isLoading = false);

    if (!response.success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response.message ?? "Something went wrong")),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => OtpVerificationScreen(
          fullName: _fullNameController.text.trim(),
          mobile: _mobileController.text.trim(),
          password: _passwordController.text.trim(),
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
                color: const Color(0xFFF5EBDD).withValues(alpha: 0.70),
              ),
            ),
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.center,
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  margin: const EdgeInsets.only(top: 24, bottom: 16),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 22,
                    vertical: 24,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF6F0E4),
                    borderRadius: BorderRadius.circular(26),
                    border: Border.all(
                      color: const Color(0xFFD4AF37).withValues(alpha: 0.30),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.arrow_back_ios_new,
                                size: 14,
                                color: Color(0xFF7A7267),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                "Back",
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  color: const Color(0xFF7A7267),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 22),
                        Center(
                          child: Column(
                            children: [
                              Text(
                                "Create Account",
                                style: GoogleFonts.playfairDisplay(
                                  fontSize: 26,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF3B2A1F),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                "Fill in your details to get started",
                                style: GoogleFonts.poppins(
                                  fontSize: 12.5,
                                  color: const Color(0xFFA79E91),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 22),
                        _buildInputField(
                          label: "Full Name",
                          controller: _fullNameController,
                          hint: "Enter your full name",
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return "Full name is required";
                            }
                            return null;
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: Text(
                            "Mobile Number",
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF6E665A),
                            ),
                          ),
                        ),
                        _buildMobileField(),
                        _buildPasswordField(),
                        const SizedBox(height: 22),
                        _buildContinueButton(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required String hint,
    required String? Function(String?) validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF6E665A),
            ),
          ),
          const SizedBox(height: 6),
          TextFormField(
            controller: controller,
            validator: validator,
            style: GoogleFonts.poppins(fontSize: 14),
            decoration: _inputDecoration(hint),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        height: 56,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: const Color(0xFFF5EBDD),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: const Color(0xFFD4AF37).withValues(alpha: 0.4),
          ),
        ),
        child: Row(
          children: [
            const SizedBox(width: 18),
            Text("+91", style: GoogleFonts.poppins(fontSize: 14)),
            Container(
              height: 22,
              width: 1,
              margin: const EdgeInsets.symmetric(horizontal: 14),
              color: const Color(0xFFD4AF37).withValues(alpha: 0.5),
            ),
            Expanded(
              child: TextField(
                controller: _mobileController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "10-digit number",
                  hintStyle: GoogleFonts.poppins(
                    fontSize: 14,
                    color: const Color(0xFFB8B0A4),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 18),
          ],
        ),
      ),
    );
  }

  Widget _buildPasswordField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Password",
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF6E665A),
            ),
          ),
          const SizedBox(height: 6),
          TextFormField(
            controller: _passwordController,
            obscureText: _obscurePassword,
            validator: (value) {
              if (value == null || value.length < 6) {
                return "Minimum 6 characters required";
              }
              return null;
            },
            decoration: _inputDecoration(
              "Min 6 characters",
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                ),
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(String hint, {Widget? suffixIcon}) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: const Color(0xFFF5EBDD),
      suffixIcon: suffixIcon,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }

  Widget _buildContinueButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _validateAndProceed,
        child: _isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : const Text("Continue"),
      ),
    );
  }
}