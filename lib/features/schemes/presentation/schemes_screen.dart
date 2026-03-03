import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:suvarna_jewellers/features/schemes/data/scheme_service.dart';
import 'package:suvarna_jewellers/features/schemes/presentation/widgets/scheme_card.dart';
import 'contact_screen.dart';

class SchemesScreen extends StatelessWidget {
  const SchemesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final schemes = SchemeService.getSchemes();

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          /// Background Image
          Positioned.fill(
            child: Image.asset(
              "assets/images/showroom_bg.png",
              fit: BoxFit.cover,
            ),
          ),

          /// Blur Layer
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
              child: Container(
                color: const Color(0xFFF5EBDD).withOpacity(0.65),
              ),
            ),
          ),

          /// Scrollable Content
          SafeArea(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              physics: const BouncingScrollPhysics(),
              children: [
                const SizedBox(height: 28),

                /// Logo
                Center(
                  child: Image.asset(
                    "assets/images/suvarna_logo.png",
                    height: 70,
                  ),
                ),

                const SizedBox(height: 18),

                /// Title
                Center(
                  child: Text(
                    "Saving Schemes",
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF3B2A1F),
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                /// Subtitle
                Center(
                  child: Text(
                    "Invest in your golden future",
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      color: const Color(0xFF7A7267),
                    ),
                  ),
                ),

                const SizedBox(height: 36),

                /// Schemes List
                ...schemes.map(
                      (scheme) => Padding(
                    padding: const EdgeInsets.only(bottom: 28),
                    child: SchemeCard(
                      scheme: scheme,
                      onEnroll: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ContactScreen(),
                          ),
                        );
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 120),
              ],
            ),
          ),
        ],
      ),
    );
  }
}