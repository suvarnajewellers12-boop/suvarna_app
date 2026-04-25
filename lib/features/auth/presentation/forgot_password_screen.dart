import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/auth_service.dart';
import 'login_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  // Steps: phone → otp → password → done
  String _step = 'phone';

  final _phoneController = TextEditingController();
  final List<TextEditingController> _otpControllers =
  List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _otpFocusNodes =
  List.generate(6, (_) => FocusNode());
  final _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;
  String? _error;

  String get _otp => _otpControllers.map((c) => c.text).join();

  static const String baseUrl =
      "https://suvarna-jewellers-customer-backend.vercel.app/api/auth";

  // Step 1: Send OTP
  void _sendOtp() async {
    final phone = _phoneController.text.trim();

    if (phone.length != 10) {
      setState(() => _error = "Enter valid 10-digit number");
      return;
    }

    setState(() { _isLoading = true; _error = null; });

    final result = await AuthService.sendForgotPasswordOtp(mobile: phone);

    setState(() => _isLoading = false);

    if (!result.success) {
      setState(() => _error = result.message ?? "Failed to send OTP");
      return;
    }

    setState(() => _step = 'otp');
  }

  // Step 2: Verify OTP
  void _verifyOtp() async {
    if (_otp.length != 6) {
      setState(() => _error = "Enter complete 6-digit OTP");
      return;
    }

    setState(() { _isLoading = true; _error = null; });

    final result = await AuthService.verifyForgotPasswordOtp(
      mobile: _phoneController.text.trim(),
      otp: _otp,
    );

    setState(() => _isLoading = false);

    if (!result.success) {
      setState(() => _error = result.message ?? "Invalid OTP");
      return;
    }

    setState(() => _step = 'password');
  }

  // Step 3: Reset Password
  void _resetPassword() async {
    final password = _passwordController.text.trim();

    if (password.length < 6) {
      setState(() => _error = "Password must be at least 6 characters");
      return;
    }

    setState(() { _isLoading = true; _error = null; });

    final result = await AuthService.resetPassword(
      mobile: _phoneController.text.trim(),
      otp: _otp,
      newPassword: password,
    );

    setState(() => _isLoading = false);

    if (!result.success) {
      setState(() => _error = result.message ?? "Reset failed");
      return;
    }

    setState(() => _step = 'done');

    await Future.delayed(const Duration(seconds: 2));

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
          (route) => false,
    );
  }

  void _onOtpChanged(int index, String value) {
    if (value.isNotEmpty && index < 5) {
      _otpFocusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _otpFocusNodes[index - 1].requestFocus();
    }
    setState(() {});
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    for (final c in _otpControllers) c.dispose();
    for (final f in _otpFocusNodes) f.dispose();
    super.dispose();
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

                      // Back button
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
                              _step == 'done'
                                  ? "Password Reset!"
                                  : "Reset Password",
                              style: GoogleFonts.playfairDisplay(
                                fontSize: 26,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF3B2A1F),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              _step == 'phone'
                                  ? "Enter your registered mobile number"
                                  : _step == 'otp'
                                  ? "Enter the OTP sent to your phone"
                                  : _step == 'password'
                                  ? "Set your new password"
                                  : "Redirecting to login...",
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                color: const Color(0xFF8E8578),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // ── Step: Phone ──
                      if (_step == 'phone') ...[
                        Container(
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
                              Text("+91",
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    color: const Color(0xFF6E665A),
                                  )),
                              Container(
                                height: 28, width: 1,
                                margin: const EdgeInsets.symmetric(horizontal: 12),
                                color: const Color(0xFFD4AF37).withOpacity(0.5),
                              ),
                              Expanded(
                                child: TextField(
                                  controller: _phoneController,
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
                      ],

                      // ── Step: OTP ──
                      if (_step == 'otp') ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: List.generate(6, (index) => SizedBox(
                            width: 44,
                            height: 54,
                            child: TextField(
                              controller: _otpControllers[index],
                              focusNode: _otpFocusNodes[index],
                              keyboardType: TextInputType.number,
                              maxLength: 1,
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                counterText: '',
                                filled: true,
                                fillColor: const Color(0xFFF5EBDD),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(18),
                                ),
                              ),
                              onChanged: (v) => _onOtpChanged(index, v),
                            ),
                          )),
                        ),
                      ],

                      // ── Step: New Password ──
                      if (_step == 'password') ...[
                        Container(
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
                                    hintText: "New password (min 6 chars)",
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
                                onTap: () => setState(() =>
                                _obscurePassword = !_obscurePassword),
                                child: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                  color: const Color(0xFF6E665A),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],

                      // ── Step: Done ──
                      if (_step == 'done') ...[
                        const Center(
                          child: Icon(
                            Icons.check_circle_outline,
                            color: Color(0xFFD4AF37),
                            size: 56,
                          ),
                        ),
                      ],

                      // Error
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

                      // Action button
                      if (_step != 'done')
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : () {
                              if (_step == 'phone') _sendOtp();
                              else if (_step == 'otp') _verifyOtp();
                              else if (_step == 'password') _resetPassword();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFD4AF37),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 15),
                            ),
                            child: _isLoading
                                ? const SizedBox(
                              height: 18, width: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                                : Text(
                              _step == 'phone'
                                  ? "Send OTP"
                                  : _step == 'otp'
                                  ? "Verify OTP"
                                  : "Reset Password",
                              style: const TextStyle(fontSize: 15),
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
}