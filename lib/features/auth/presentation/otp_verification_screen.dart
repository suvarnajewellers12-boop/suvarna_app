import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'mpin_screen.dart';
import '../data/auth_service.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String username;

  const OtpVerificationScreen({
    super.key,
    required this.username,
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

    final response =
    await AuthService.verifySignupOtp(otp: _otp);

    setState(() => _isLoading = false);

    if (!response.success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
          Text(response.message ?? "Invalid OTP"),
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MPinScreen(
          mode: MPinMode.setup,
          username: widget.username,
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

          /// Background
          Positioned.fill(
            child: Image.asset(
              "assets/images/showroom_bg.png",
              fit: BoxFit.cover,
            ),
          ),

          /// Premium Blur Overlay
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(
                  sigmaX: 6, sigmaY: 6),
              child: Container(
                color: const Color(0xFFF5EBDD)
                    .withOpacity(0.65),
              ),
            ),
          ),

          SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 22),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24, vertical: 26),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8F3E8)
                        .withOpacity(0.96),
                    borderRadius:
                    BorderRadius.circular(24),
                    border: Border.all(
                      color: const Color(0xFFD4AF37)
                          .withOpacity(0.6),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black
                            .withOpacity(0.08),
                        blurRadius: 20,
                        offset:
                        const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize:
                    MainAxisSize.min,
                    children: [

                      /// Back
                      Align(
                        alignment:
                        Alignment.centerLeft,
                        child: GestureDetector(
                          onTap: () =>
                              Navigator.pop(
                                  context),
                          child: Row(
                            mainAxisSize:
                            MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons
                                    .arrow_back_ios_new,
                                size: 14,
                                color: Color(
                                    0xFF6E665A),
                              ),
                              const SizedBox(
                                  width: 6),
                              Text(
                                "Back",
                                style:
                                GoogleFonts
                                    .poppins(
                                  fontSize: 13,
                                  color:
                                  const Color(
                                      0xFF6E665A),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 22),

                      /// Title
                      Text(
                        "Create Account",
                        style:
                        GoogleFonts
                            .playfairDisplay(
                          fontSize: 27,
                          fontWeight:
                          FontWeight.w700,
                          letterSpacing: 0.5,
                          color: const Color(
                              0xFF3B2A1F),
                        ),
                      ),

                      const SizedBox(height: 8),

                      /// Subtitle
                      Text(
                        "Verify the OTP sent to your phone",
                        style:
                        GoogleFonts.poppins(
                          fontSize: 13,
                          color: const Color(
                              0xFFA79E91),
                        ),
                      ),

                      const SizedBox(height: 26),

                      /// OTP BOXES
                      Row(
                        mainAxisAlignment:
                        MainAxisAlignment
                            .spaceBetween,
                        children:
                        List.generate(
                          6,
                              (index) =>
                              SizedBox(
                                width: 44,
                                height: 54,
                                child: TextField(
                                  controller:
                                  _controllers[
                                  index],
                                  focusNode:
                                  _focusNodes[
                                  index],
                                  keyboardType:
                                  TextInputType
                                      .number,
                                  maxLength: 1,
                                  textAlign:
                                  TextAlign
                                      .center,
                                  style:
                                  GoogleFonts
                                      .poppins(
                                    fontSize: 18,
                                    fontWeight:
                                    FontWeight
                                        .w600,
                                    color: const Color(
                                        0xFF3B2A1F),
                                  ),
                                  decoration:
                                  InputDecoration(
                                    counterText:
                                    '',
                                    filled:
                                    true,
                                    fillColor:
                                    const Color(
                                        0xFFF5EBDD),
                                    contentPadding:
                                    EdgeInsets
                                        .zero,
                                    enabledBorder:
                                    OutlineInputBorder(
                                      borderRadius:
                                      BorderRadius
                                          .circular(
                                          18),
                                      borderSide:
                                      BorderSide(
                                        color: const Color(
                                            0xFFE6C979)
                                            .withOpacity(
                                            0.5),
                                        width: 1,
                                      ),
                                    ),
                                    focusedBorder:
                                    const OutlineInputBorder(
                                      borderRadius:
                                      BorderRadius
                                          .all(
                                        Radius
                                            .circular(
                                            18),
                                      ),
                                      borderSide:
                                      BorderSide(
                                        color: Color(
                                            0xFFD4AF37),
                                        width: 1.5,
                                      ),
                                    ),
                                  ),
                                  onChanged:
                                      (value) =>
                                      _onOtpChanged(
                                          index,
                                          value),
                                ),
                              ),
                        ),
                      ),

                      const SizedBox(height: 28),

                      /// VERIFY BUTTON
                      SizedBox(
                        width:
                        double.infinity,
                        child:
                        ElevatedButton(
                          onPressed:
                          _isOtpComplete &&
                              !_isLoading
                              ? _verifyOtp
                              : null,
                          style:
                          ElevatedButton
                              .styleFrom(
                            backgroundColor:
                            _isOtpComplete
                                ? const Color(
                                0xFFD4AF37)
                                : const Color(
                                0xFFD4AF37)
                                .withOpacity(
                                0.4),
                            foregroundColor:
                            Colors.white,
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
                                  22),
                            ),
                            elevation: 3,
                          ),
                          child: _isLoading
                              ? const SizedBox(
                            height: 18,
                            width: 18,
                            child:
                            CircularProgressIndicator(
                              strokeWidth:
                              2,
                              color:
                              Colors
                                  .white,
                            ),
                          )
                              : Row(
                            mainAxisAlignment:
                            MainAxisAlignment
                                .center,
                            children:
                            const [
                              Text(
                                "Verify & Continue",
                                style:
                                TextStyle(
                                  fontWeight:
                                  FontWeight
                                      .w600,
                                ),
                              ),
                              SizedBox(
                                  width:
                                  6),
                              Icon(
                                Icons
                                    .shield_outlined,
                                size:
                                18,
                              )
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 14),

                      TextButton(
                        onPressed: () =>
                            Navigator.pop(
                                context),
                        child: Text(
                          "Go back",
                          style:
                          GoogleFonts
                              .poppins(
                            fontSize: 13,
                            color: const Color(
                                0xFF6E665A),
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