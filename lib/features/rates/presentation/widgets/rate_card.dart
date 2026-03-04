import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/rate_model.dart';

class RateCard extends StatelessWidget {
  final RateModel rate;

  const RateCard({super.key, required this.rate});

  @override
  Widget build(BuildContext context) {

    final bool isUp = rate.change >= 0;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: const Color(0xFFF1E8DA),   // MATCHES APP CARDS
        borderRadius: BorderRadius.circular(20),

        border: Border.all(
          color: const Color(0xFFD4AF37),
          width: 1,
        ),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          )
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// TOP ROW
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text(
                    rate.label,
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  Text(
                    "Purity: ${rate.purity}",
                    style: GoogleFonts.poppins(
                      fontSize: 10,
                      color: const Color(0xFF6E665A),
                    ),
                  ),
                ],
              ),

              /// RATE CHANGE
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 4),

                decoration: BoxDecoration(
                  color: isUp
                      ? Colors.green.withOpacity(0.12)
                      : Colors.red.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20),
                ),

                child: Row(
                  children: [

                    Icon(
                      isUp
                          ? Icons.trending_up
                          : Icons.trending_down,
                      size: 14,
                      color: isUp
                          ? Colors.green
                          : Colors.red,
                    ),

                    const SizedBox(width: 3),

                    Text(
                      "${isUp ? '+' : ''}${rate.change}",
                      style: TextStyle(
                        fontSize: 12,
                        color: isUp
                            ? Colors.green
                            : Colors.red,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  ],
                ),
              )
            ],
          ),

          const SizedBox(height: 10),

          /// MAIN PRICE
          Text.rich(
            TextSpan(
              text: "₹${rate.rate.toStringAsFixed(0)}",
              style: GoogleFonts.poppins(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: const Color(0xFFB78628),
              ),

              children: [
                TextSpan(
                  text: " /gram",
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.grey,
                    fontWeight: FontWeight.normal,
                  ),
                )
              ],
            ),
          ),

          const SizedBox(height: 14),

          /// PER VALUES
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _box("Per 10g", rate.per10g),
              _box("Per 100g", rate.per100g),
              _box("Per Tola", rate.perTola),
            ],
          ),

          const SizedBox(height: 10),

          /// UPDATED TIME
          Row(
            children: [

              const Icon(
                Icons.access_time,
                size: 12,
                color: Colors.grey,
              ),

              const SizedBox(width: 4),

              Text(
                rate.lastUpdated,
                style: GoogleFonts.poppins(
                  fontSize: 10,
                  color: Colors.grey,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _box(String title, double value) {

    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(vertical: 10),

        decoration: BoxDecoration(
          color: const Color(0xFFEADFCF),  // INNER BOX COLOR FIX
          borderRadius: BorderRadius.circular(12),
        ),

        child: Column(
          children: [

            Text(
              title,
              style: const TextStyle(
                fontSize: 9,
                color: Color(0xFF6E665A),
              ),
            ),

            const SizedBox(height: 2),

            Text(
              "₹${value.toStringAsFixed(0)}",
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            )
          ],
        ),
      ),
    );
  }
}