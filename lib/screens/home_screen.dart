import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatelessWidget {
  final String username;

  const HomeScreen({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          /// Background Image
          Positioned.fill(
            child: Image.asset(
              "assets/images/showroom_bg.png",
              fit: BoxFit.cover,
            ),
          ),

          /// Light Blur + Overlay (opacity reduced)
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 2.5, sigmaY: 2.5),
              child: Container(
                color: const Color(0xFFF8F3E8)
                    .withValues(alpha: 0.45),
              ),
            ),
          ),

          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: IntrinsicHeight(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 28),

                            /// HERO
                            Row(
                              children: [
                                Image.asset(
                                  "assets/images/suvarna_logo.png",
                                  height: 60,
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Hello, $username 👋",
                                        style:
                                        GoogleFonts.playfairDisplay(
                                          fontSize: 32,
                                          fontWeight: FontWeight.w700,
                                          color: const Color(0xFF3B2A1F),
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        "Build your golden future with Suvarna Jewellers",
                                        style: GoogleFonts.poppins(
                                          fontSize: 15,
                                          color:
                                          const Color(0xFF6E665A),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 32),

                            _buildTotalSavingsCard(),

                            const SizedBox(height: 36),

                            /// MY SCHEMES HEADER
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "My Schemes",
                                  style: GoogleFonts
                                      .playfairDisplay(
                                    fontSize: 20,
                                    fontWeight:
                                    FontWeight.w600,
                                    color:
                                    const Color(0xFF3B2A1F),
                                  ),
                                ),
                                Text(
                                  "2 active",
                                  style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    color:
                                    const Color(0xFF7A7164),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 18),

                            _schemeCard(
                              title:
                              "Suvarna Gold Savings",
                              progress: 0.72,
                              paidText:
                              "₹8,000 paid",
                              monthText:
                              "8/11 months",
                            ),

                            const SizedBox(height: 18),

                            _schemeCard(
                              title:
                              "Suvarna Heritage Plan",
                              progress: 0.25,
                              paidText:
                              "₹30,000 paid",
                              monthText:
                              "6/24 months",
                            ),

                            const SizedBox(height: 40),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  /// TOTAL SAVINGS CARD
  Widget _buildTotalSavingsCard() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Container(
            height: 4,
            decoration: const BoxDecoration(
              borderRadius:
              BorderRadius.vertical(top: Radius.circular(24)),
              gradient: LinearGradient(
                colors: [
                  Color(0xFFD4AF37),
                  Color(0xFFE6C979)
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white
                  .withValues(alpha: 0.95),
              borderRadius:
              const BorderRadius.vertical(
                  bottom:
                  Radius.circular(24)),
              border: Border.all(
                color: const Color(0xFFD4AF37)
                    .withValues(alpha: 0.4),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black
                      .withValues(alpha: 0.05),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment:
                  MainAxisAlignment
                      .spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment:
                      CrossAxisAlignment
                          .start,
                      children: [
                        Text(
                          "TOTAL SAVINGS",
                          style:
                          GoogleFonts.poppins(
                            fontSize: 11,
                            letterSpacing: 1,
                            color: const Color(
                                0xFFA79E91),
                          ),
                        ),
                        const SizedBox(
                            height: 6),
                        Text(
                          "₹38,000",
                          style: GoogleFonts
                              .playfairDisplay(
                            fontSize: 30,
                            fontWeight:
                            FontWeight.w700,
                            color: const Color(
                                0xFFB48A2C),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      height: 54,
                      width: 54,
                      decoration:
                      const BoxDecoration(
                        shape:
                        BoxShape.circle,
                        color:
                        Color(0xFFF1E8DA),
                      ),
                      child: const Icon(
                        Icons.card_giftcard,
                        color:
                        Color(0xFFD4AF37),
                        size: 26,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _ratePill(
                        "Gold 22K",
                        "₹6,850/g"),
                    const SizedBox(
                        width: 10),
                    _ratePill(
                        "Silver",
                        "₹92/g"),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _ratePill(
      String label, String value) {
    return Container(
      padding:
      const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 8),
      decoration: BoxDecoration(
        color:
        const Color(0xFFF5EBDD),
        borderRadius:
        BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          const Icon(
              Icons.diamond_outlined,
              size: 14,
              color:
              Color(0xFFD4AF37)),
          const SizedBox(width: 6),
          Text(
            label,
            style:
            GoogleFonts.poppins(
              fontSize: 11,
              color: const Color(
                  0xFF6E665A),
            ),
          ),
          const SizedBox(width: 6),
          Text(
            value,
            style:
            GoogleFonts.poppins(
              fontSize: 11,
              fontWeight:
              FontWeight.w600,
              color: const Color(
                  0xFFB48A2C),
            ),
          ),
        ],
      ),
    );
  }

  Widget _schemeCard({
    required String title,
    required double progress,
    required String paidText,
    required String monthText,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white
            .withValues(alpha: 0.95),
        borderRadius:
        BorderRadius.circular(20),
        border: Border.all(
          color:
          const Color(0xFFD4AF37),
          width: 0.5,
        ),
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style:
            GoogleFonts.playfairDisplay(
              fontSize: 18,
              fontWeight:
              FontWeight.w600,
              color: const Color(
                  0xFF3B2A1F),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                monthText,
                style:
                GoogleFonts.poppins(
                  fontSize: 13,
                  color: const Color(
                      0xFFA79E91),
                ),
              ),
              const SizedBox(width: 14),
              Text(
                paidText,
                style:
                GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight:
                  FontWeight.w600,
                  color: const Color(
                      0xFFB48A2C),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          AnimatedGoldBar(
              progress: progress),
        ],
      ),
    );
  }
}

/// Animated Moving Gold Shimmer Bar
class AnimatedGoldBar extends StatefulWidget {
  final double progress;

  const AnimatedGoldBar({super.key, required this.progress});

  @override
  State<AnimatedGoldBar> createState() => _AnimatedGoldBarState();
}

class _AnimatedGoldBarState extends State<AnimatedGoldBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
    AnimationController(vsync: this, duration: const Duration(seconds: 2))
      ..repeat();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Stack(
        children: [
          Container(
            height: 6,
            color: const Color(0xFFF1E8DA),
          ),
          FractionallySizedBox(
            widthFactor: widget.progress,
            child: AnimatedBuilder(
              animation: _controller,
              builder: (_, __) {
                return Container(
                  height: 6,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment(-1 + _controller.value * 2, 0),
                      end: Alignment(1 + _controller.value * 2, 0),
                      colors: const [
                        Color(0xFFD4AF37),
                        Color(0xFFE6C979),
                        Color(0xFFD4AF37),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}