import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/auth_service.dart';
import '../../../screens/home_screen.dart';

class LoginOtpScreen extends StatefulWidget {
  final String username;

  const LoginOtpScreen({
    super.key,
    required this.username,
  });

  @override
  State<LoginOtpScreen> createState() =>
      _LoginOtpScreenState();
}

class _LoginOtpScreenState
    extends State<LoginOtpScreen> {
  final List<TextEditingController> _controllers =
  List.generate(
      6, (_) => TextEditingController());

  final List<FocusNode> _focusNodes =
  List.generate(6, (_) => FocusNode());

  bool _isLoading = false;
  String? _error;

  String get _otp =>
      _controllers.map((c) => c.text).join();

  void _onOtpChanged(int index, String value) {
    if (value.isNotEmpty && index < 5) {
      _focusNodes[index + 1].requestFocus();
    }
  }

  void _verifyOtp() async {
    if (_otp.length != 6) {
      setState(() {
        _error = "Enter 6-digit OTP";
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    final response =
    await AuthService.verifyLoginOtp(
      otp: _otp,
    );

    setState(() {
      _isLoading = false;
    });

    if (!response.success) {
      setState(() {
        _error = response.message;
      });
      return;
    }

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => HomeScreen(
          username: widget.username,
        ),
      ),
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
      const Color(0xFFF8F3E8),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 40),

            Image.asset(
              "assets/images/suvarna_logo.png",
              height: 70,
            ),

            const SizedBox(height: 30),

            Text(
              "Verify OTP",
              style: GoogleFonts.playfairDisplay(
                fontSize: 26,
                fontWeight: FontWeight.w700,
                color:
                const Color(0xFF3B2A1F),
              ),
            ),

            const SizedBox(height: 8),

            Text(
              "Enter the OTP sent to your phone",
              style: GoogleFonts.poppins(
                fontSize: 14,
                color:
                const Color(0xFFA79E91),
              ),
            ),

            const SizedBox(height: 30),

            Row(
              mainAxisAlignment:
              MainAxisAlignment.center,
              children: List.generate(
                6,
                    (index) => Container(
                  margin:
                  const EdgeInsets.symmetric(
                      horizontal: 6),
                  width: 42,
                  child: TextField(
                    controller:
                    _controllers[index],
                    focusNode:
                    _focusNodes[index],
                    keyboardType:
                    TextInputType.number,
                    textAlign:
                    TextAlign.center,
                    maxLength: 1,
                    decoration:
                    InputDecoration(
                      counterText: "",
                      filled: true,
                      fillColor:
                      const Color(
                          0xFFF1E8DA),
                      border:
                      OutlineInputBorder(
                        borderRadius:
                        BorderRadius
                            .circular(12),
                        borderSide:
                        const BorderSide(
                          color: Color(
                              0xFFD4AF37),
                        ),
                      ),
                      focusedBorder:
                      OutlineInputBorder(
                        borderRadius:
                        BorderRadius
                            .circular(12),
                        borderSide:
                        const BorderSide(
                          color: Color(
                              0xFFD4AF37),
                          width: 2,
                        ),
                      ),
                    ),
                    onChanged: (value) =>
                        _onOtpChanged(
                            index, value),
                  ),
                ),
              ),
            ),

            if (_error != null) ...[
              const SizedBox(height: 14),
              Text(
                _error!,
                style:
                const TextStyle(
                  color:
                  Colors.redAccent,
                  fontSize: 13,
                ),
              ),
            ],

            const SizedBox(height: 30),

            SizedBox(
              width: 220,
              child: ElevatedButton(
                onPressed:
                _isLoading
                    ? null
                    : _verifyOtp,
                style:
                ElevatedButton
                    .styleFrom(
                  backgroundColor:
                  const Color(
                      0xFFD4AF37),
                  padding:
                  const EdgeInsets
                      .symmetric(
                      vertical:
                      14),
                  shape:
                  RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius
                        .circular(
                        24),
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                  height: 18,
                  width: 18,
                  child:
                  CircularProgressIndicator(
                    strokeWidth:
                    2,
                    color: Colors
                        .white,
                  ),
                )
                    : const Text(
                  "Verify OTP",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}