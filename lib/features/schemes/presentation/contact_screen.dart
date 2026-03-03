import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

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
              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
              child: Container(
                color: const Color(0xFFF5EBDD).withOpacity(0.65),
              ),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22),
              child: Column(
                children: [

                  const SizedBox(height: 40),

                  Image.asset(
                    "assets/images/suvarna_logo.png",
                    height: 70,
                  ),

                  const SizedBox(height: 20),

                  Text(
                    "Contact Us to Enroll",
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF3B2A1F),
                    ),
                  ),

                  const SizedBox(height: 12),

                  Text(
                    "Please visit our showroom or call us to complete your scheme enrollment. Our experts will guide you personally.",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: const Color(0xFF7A7267),
                    ),
                  ),

                  const SizedBox(height: 30),

                  _contactCard(
                    icon: Icons.phone,
                    title: "Call Us",
                    subtitle: "+91 98765 43210",
                  ),

                  const SizedBox(height: 18),

                  _contactCard(
                    icon: Icons.chat_bubble_outline,
                    title: "WhatsApp",
                    subtitle: "Message us directly",
                  ),

                  const SizedBox(height: 18),

                  _contactCard(
                    icon: Icons.location_on_outlined,
                    title: "Visit Showroom",
                    subtitle: "MG Road, Bangalore",
                  ),

                  const Spacer(),

                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Text(
                      "← Back to Schemes",
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        decoration: TextDecoration.underline,
                        color: const Color(0xFF6E665A),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _contactCard({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFF6F0E4).withOpacity(0.97),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFFD4AF37),
          width: 0.5,
        ),
      ),
      child: Row(
        children: [
          Container(
            height: 48,
            width: 48,
            decoration: const BoxDecoration(
              color: Color(0xFFE9DFCF),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: const Color(0xFFD4AF37)),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: const Color(0xFF6E665A),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: GoogleFonts.playfairDisplay(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF3B2A1F),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}