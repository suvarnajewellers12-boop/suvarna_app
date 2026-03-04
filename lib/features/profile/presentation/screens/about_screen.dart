import 'dart:ui';
import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Stack(
        children: [

          /// BACKGROUND IMAGE
          Positioned.fill(
            child: Image.asset(
              "assets/images/showroom_bg.png",
              fit: BoxFit.cover,
            ),
          ),

          /// BLUR OVERLAY
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
              child: Container(
                color: const Color(0xFFF5EBDD).withOpacity(.55),
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

                    child: Column(
                      children: [

                        /// HEADER
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            children: [

                              IconButton(
                                icon: const Icon(Icons.arrow_back_ios_new),
                                onPressed: () => Navigator.pop(context),
                              ),

                              const SizedBox(width: 8),

                              const Text(
                                "About Suvarna",
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        /// MAIN CARD
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 24),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF1E8DA),
                              borderRadius: BorderRadius.circular(24),
                            ),

                            child: Column(
                              children: [

                                /// LOGO
                                Image.asset(
                                  "assets/images/suvarna_logo.png",
                                  height: 80,
                                ),

                                const SizedBox(height: 12),

                                const Text(
                                  "Suvarna Jewellers",
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                const SizedBox(height: 4),

                                const Text(
                                  "Crafting Trust Since 1985",
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Color(0xFF6E665A),
                                  ),
                                ),

                                const SizedBox(height: 24),

                                /// INFO TILES
                                infoTile(
                                  Icons.access_time,
                                  "Established",
                                  "Since 1985",
                                ),

                                infoTile(
                                  Icons.verified,
                                  "Hallmark",
                                  "BIS Certified",
                                ),

                                infoTile(
                                  Icons.location_on,
                                  "Location",
                                  "MG Road, Bangalore",
                                ),

                                infoTile(
                                  Icons.favorite,
                                  "Customers",
                                  "50,000+ Families",
                                ),

                                const SizedBox(height: 20),

                                /// DESCRIPTION
                                const Text(
                                  "Suvarna Jewellers is a family-owned jewellery house based in Bangalore, known for craftsmanship and transparent pricing.",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF6E665A),
                                  ),
                                ),

                                const SizedBox(height: 22),

                                const Text(
                                  "App Version 1.0.0",
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 40),
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

  /// INFO TILE
  Widget infoTile(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),

      child: Row(
        children: [

          Container(
            height: 40,
            width: 40,
            decoration: const BoxDecoration(
              color: Color(0xFFE6D7C3),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: Color(0xFFB78628),
              size: 20,
            ),
          ),

          const SizedBox(width: 12),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),

              Text(
                value,
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF6E665A),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}