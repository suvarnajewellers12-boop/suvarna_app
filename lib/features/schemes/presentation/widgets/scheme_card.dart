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

    final displayedBenefits =
    scheme.benefits.length > 2
        ? scheme.benefits.take(2).toList()
        : scheme.benefits;

    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF6F0E4).withOpacity(0.97),
          border: Border.all(
            color: const Color(0xFFD4AF37),
            width: 0.6,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          children: [

            /// Gold top strip (now perfectly clipped)
            Container(
              height: 3,
              width: double.infinity,
              color: const Color(0xFFD4AF37),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text(
                    scheme.title,
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 19,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF3B2A1F),
                    ),
                  ),

                  const SizedBox(height: 10),

                  Row(
                    children: [
                      const Icon(Icons.access_time,
                          size: 14, color: Color(0xFFD4AF37)),
                      const SizedBox(width: 5),
                      Text(
                        scheme.duration,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: const Color(0xFF6E665A),
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Icon(Icons.shield_outlined,
                          size: 14, color: Color(0xFFD4AF37)),
                      const SizedBox(width: 5),
                      Text(
                        "Min. ${scheme.minAmount}",
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: const Color(0xFF6E665A),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  ...displayedBenefits.map(
                        (b) => Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Row(
                        children: [
                          const Icon(Icons.card_giftcard,
                              size: 14, color: Color(0xFFD4AF37)),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              b,
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                color: const Color(0xFF5E564A),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  if (scheme.benefits.length > 2)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(
                        "+ ${scheme.benefits.length - 2} more benefits",
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          color: const Color(0xFF8C8578),
                        ),
                      ),
                    ),

                  const SizedBox(height: 16),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: onEnroll,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD4AF37),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      child: Text(
                        "Enroll",
                        style: GoogleFonts.poppins(
                          fontSize: 14,
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