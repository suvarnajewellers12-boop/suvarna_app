import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../screens/home_screen.dart';
import '../data/auth_service.dart';

class LoginOtpScreen extends StatefulWidget {
  final String username;

  const LoginOtpScreen({super.key, required this.username});

  @override
  State<LoginOtpScreen> createState() => _LoginOtpScreenState();
}

class _LoginOtpScreenState extends State<LoginOtpScreen> {
  final List<TextEditingController> _controllers =
  List.generate(6, (_) => TextEditingController());

  final List<FocusNode> _focusNodes =
  List.generate(6, (_) => FocusNode());

  bool _isLoading = false;
  String? _error;

  String get _otp => _controllers.map((c) => c.text).join();

  void _onOtpChanged(int index, String value) {
    if (value.isNotEmpty && index < 5) {
      _focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
  }

  void _verifyOtp() async {
    if (_otp.length != 6) {
      setState(() => _error = "Enter 6-digit OTP");
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    final response = await AuthService.verifyLoginOtp(otp: _otp);

    setState(() => _isLoading = false);

    if (!response.success) {
      setState(() => _error = response.message);
      return;
    }

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => HomeScreen(username: widget.username),
      ),
          (route) => false,
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
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(
                color: const Color(0xFFF5EBDD).withOpacity(0.68),
              ),
            ),
          ),

          SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 22),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24, vertical: 26),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8F3E8).withOpacity(0.96),
                    borderRadius: BorderRadius.circular(26),
                    border: Border.all(
                      color: const Color(0xFFD4AF37).withOpacity(0.5),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [

                      /// Back
                      Align(
                        alignment: Alignment.centerLeft,
                        child: GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.arrow_back_ios_new,
                                size: 14,
                                color: Color(0xFF6E665A),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                "Back",
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  color: const Color(0xFF6E665A),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      /// Title
                      Text(
                        "Verify OTP",
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 27,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF3B2A1F),
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        "Enter the OTP sent to your phone",
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: const Color(0xFFA79E91),
                        ),
                      ),

                      const SizedBox(height: 28),

                      /// ✅ RESPONSIVE OTP ROW (NO OVERFLOW EVER)
                      LayoutBuilder(
                        builder: (context, constraints) {
                          double totalWidth = constraints.maxWidth;
                          double boxWidth =
                              (totalWidth - (5 * 10)) / 6;

                          return Row(
                            children: List.generate(
                              6,
                                  (index) => Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 4),
                                  child: SizedBox(
                                    height: 54,
                                    child: TextField(
                                      controller: _controllers[index],
                                      focusNode: _focusNodes[index],
                                      keyboardType: TextInputType.number,
                                      textAlign: TextAlign.center,
                                      maxLength: 1,
                                      style: GoogleFonts.poppins(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xFF3B2A1F),
                                      ),
                                      decoration: InputDecoration(
                                        counterText: "",
                                        filled: true,
                                        fillColor: const Color(0xFFF5EBDD),
                                        contentPadding: EdgeInsets.zero,
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(18),
                                          borderSide: const BorderSide(
                                            color: Color(0xFFE7C98C),
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(18),
                                          borderSide: const BorderSide(
                                            color: Color(0xFFD4AF37),
                                            width: 1.4,
                                          ),
                                        ),
                                      ),
                                      onChanged: (value) =>
                                          _onOtpChanged(index, value),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),

                      if (_error != null) ...[
                        const SizedBox(height: 14),
                        Text(
                          _error!,
                          style: const TextStyle(
                            color: Colors.redAccent,
                            fontSize: 13,
                          ),
                        ),
                      ],

                      const SizedBox(height: 30),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _verifyOtp,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFCF9B2E),
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                          ),
                          child: _isLoading
                              ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                              : Text(
                            "Verify OTP",
                            style: GoogleFonts.poppins(
                              fontSize: 15.5,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
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