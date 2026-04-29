import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/auth_service.dart';
import 'mpin_screen.dart';

class ForgotMpinScreen extends StatefulWidget {
  const ForgotMpinScreen({super.key});

  @override
  State<ForgotMpinScreen> createState() => _ForgotMpinScreenState();
}

class _ForgotMpinScreenState extends State<ForgotMpinScreen> {
  final _phoneController = TextEditingController();
  final _otpController = TextEditingController();

  bool otpSent = false;
  bool loading = false;

  void sendOtp() async {
    setState(() => loading = true);

    final result = await AuthService.sendForgotMpinOtp(
      mobile: _phoneController.text.trim(),
    );

    setState(() {
      otpSent = result.success;
      loading = false;
    });
  }

  void verifyOtp() async {
    setState(() => loading = true);

    final result = await AuthService.verifyForgotMpinOtp(
      mobile: _phoneController.text.trim(),
      otp: _otpController.text.trim(),
    );


    setState(() => loading = false);

    if (result.success) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => MPinScreen(
            mode: MPinMode.forgotReset,
            username: _phoneController.text.trim(),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F3E8),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 80),
            Text(
              "Forgot MPIN",
              style: GoogleFonts.playfairDisplay(
                fontSize: 28,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(
                hintText: "Enter phone number",
              ),
            ),
            const SizedBox(height: 20),

            if (!otpSent)
              ElevatedButton(
                onPressed: loading ? null : sendOtp,
                child: const Text("Send OTP"),
              ),

            if (otpSent) ...[
              TextField(
                controller: _otpController,
                decoration: const InputDecoration(
                  hintText: "Enter OTP",
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: loading ? null : verifyOtp,
                child: const Text("Verify OTP"),
              ),
            ]
          ],
        ),
      ),
    );
  }
}