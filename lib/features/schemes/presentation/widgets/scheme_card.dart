import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:suvarna_jewellers/features/schemes/data/scheme_model.dart';

class SchemeCard extends StatelessWidget {
  final SchemeModel scheme;
  final VoidCallback onEnroll;

  const SchemeCard({
    super.key,
    required this.scheme,
    required this.onEnroll,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF6F0E4).withOpacity(0.97),
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 25,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          children: [
            /// GOLD TOP STRIP (now perfectly clipped to card radius)
            Container(
              height: 4,
              width: double.infinity,
              color: const Color(0xFFD4AF37),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 26),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// TITLE
                  Text(
                    scheme.title,
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF3B2A1F),
                    ),
                  ),

                  const SizedBox(height: 16),

                  /// Duration + Min Amount
                  Row(
                    children: [
                      const Icon(Icons.access_time,
                          size: 16, color: Color(0xFFD4AF37)),
                      const SizedBox(width: 6),
                      Text(
                        scheme.duration,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: const Color(0xFF6E665A),
                        ),
                      ),
                      const SizedBox(width: 24),
                      const Icon(Icons.shield_outlined,
                          size: 16, color: Color(0xFFD4AF37)),
                      const SizedBox(width: 6),
                      Text(
                        "Min. ${scheme.minAmount}",
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: const Color(0xFF6E665A),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 22),

                  /// BENEFITS
                  ...scheme.benefits.map(
                        (b) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.card_giftcard,
                              size: 16, color: Color(0xFFD4AF37)),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              b,
                              style: GoogleFonts.poppins(
                                fontSize: 14.5,
                                color: const Color(0xFF5E564A),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 26),

                  /// ENROLL BUTTON
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: onEnroll,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD4AF37),
                        padding:
                        const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        "Enroll Now",
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}