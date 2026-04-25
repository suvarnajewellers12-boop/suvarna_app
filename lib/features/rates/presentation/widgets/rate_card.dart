import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/rate_model.dart';

class RateCard extends StatelessWidget {
  final RateModel rate;

  const RateCard({super.key, required this.rate});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(vertical: 24),

      decoration: BoxDecoration(
        color: const Color(0xFFF6F0E4),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFD4AF37),
          width: 0.8,
        ),
      ),

      child: Column(
        children: [
          Text(
            rate.metal,
            style: GoogleFonts.playfairDisplay(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF3B2A1F),
            ),
          ),

          const SizedBox(height: 14),

          Text(
            "₹${rate.rate.toStringAsFixed(2)}",
            style: GoogleFonts.playfairDisplay(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: const Color(0xFFB78628),
            ),
          ),

          Text(
            "/gram",
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: const Color(0xFF7A7267),
            ),
          ),
        ],
      ),
    );
  }
}