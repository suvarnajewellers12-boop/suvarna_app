import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'mpin_screen.dart';
import '../data/auth_service.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String fullName;
  final String mobile;
  final String password;

  const OtpVerificationScreen({
    super.key,
    required this.fullName,
    required this.mobile,
    required this.password,
  });

  @override
  State<OtpVerificationScreen> createState() =>
      _OtpVerificationScreenState();
}

class _OtpVerificationScreenState
    extends State<OtpVerificationScreen> {
  final List<TextEditingController> _controllers =
  List.generate(6, (_) => TextEditingController());

  final List<FocusNode> _focusNodes =
  List.generate(6, (_) => FocusNode());

  bool _isLoading = false;

  String get _otp =>
      _controllers.map((c) => c.text).join();

  bool get _isOtpComplete => _otp.length == 6;

  void _onOtpChanged(int index, String value) {
    if (value.isNotEmpty && index < 5) {
      _focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }

    setState(() {});
  }

  void _verifyOtp() async {
    if (!_isOtpComplete) return;

    setState(() => _isLoading = true);

    final otpResponse = await AuthService.verifySignupOtp(
      mobile: widget.mobile,
      otp: _otp,
    );

    if (!otpResponse.success) {
      setState(() => _isLoading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            otpResponse.message ?? "Invalid OTP",
          ),
        ),
      );
      return;
    }

    final signupResponse = await AuthService.register(
      fullName: widget.fullName,
      mobile: widget.mobile,
      password: widget.password,
    );

    setState(() => _isLoading = false);

    if (!signupResponse.success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            signupResponse.message ?? "Signup failed",
          ),
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MPinScreen(
          mode: MPinMode.setup,
          username: widget.mobile,
        ),
      ),
    );
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
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
              filter:
              ImageFilter.blur(sigmaX: 6, sigmaY: 6),
              child: Container(
                color: const Color(0xFFF5EBDD)
                    .withValues(alpha: 0.65),
              ),
            ),
          ),
          SafeArea(
            child: Center(
              child: Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 22),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 26,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8F3E8)
                        .withValues(alpha: 0.96),
                    borderRadius:
                    BorderRadius.circular(24),
                    border: Border.all(
                      color: const Color(0xFFD4AF37)
                          .withValues(alpha: 0.6),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: GestureDetector(
                          onTap: () =>
                              Navigator.pop(context),
                          child: Row(
                            mainAxisSize:
                            MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.arrow_back_ios_new,
                                size: 14,
                                color:
                                Color(0xFF6E665A),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                "Back",
                                style:
                                GoogleFonts.poppins(
                                  fontSize: 13,
                                  color:
                                  const Color(
                                    0xFF6E665A,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 22),
                      Text(
                        "Create Account",
                        style: GoogleFonts
                            .playfairDisplay(
                          fontSize: 27,
                          fontWeight:
                          FontWeight.w700,
                          color: const Color(
                              0xFF3B2A1F),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Verify the OTP sent to your phone",
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color:
                          const Color(0xFFA79E91),
                        ),
                      ),
                      const SizedBox(height: 26),
                      Row(
                        mainAxisAlignment:
                        MainAxisAlignment
                            .spaceBetween,
                        children: List.generate(
                          6,
                              (index) => SizedBox(
                            width: 44,
                            height: 54,
                            child: TextField(
                              controller:
                              _controllers[index],
                              focusNode:
                              _focusNodes[index],
                              keyboardType:
                              TextInputType.number,
                              maxLength: 1,
                              textAlign:
                              TextAlign.center,
                              decoration:
                              InputDecoration(
                                counterText: '',
                                filled: true,
                                fillColor:
                                const Color(
                                    0xFFF5EBDD),
                                border:
                                OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius
                                      .circular(
                                      18),
                                ),
                              ),
                              onChanged: (value) =>
                                  _onOtpChanged(
                                      index,
                                      value),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 28),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed:
                          _isOtpComplete &&
                              !_isLoading
                              ? _verifyOtp
                              : null,
                          child: _isLoading
                              ? const CircularProgressIndicator(
                            color:
                            Colors.white,
                          )
                              : const Text(
                            "Verify & Continue",
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