import 'dart:ui';
import 'package:flutter/material.dart';

class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [

          /// showroom background
          Positioned.fill(
            child: Image.asset(
              "assets/images/showroom_bg.png",
              fit: BoxFit.cover,
            ),
          ),

          /// blur overlay (same as Home/Profile)
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
              child: Container(
                color: const Color(0xFFF5EBDD).withOpacity(0.55),
              ),
            ),
          ),

          SafeArea(
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
                        "Contact Us",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                /// LOGO
                Image.asset(
                  "assets/images/suvarna_logo.png",
                  height: 60,
                ),

                const SizedBox(height: 16),

                /// TITLE
                const Text(
                  "Contact Us to Enroll",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: Text(
                    "Please visit our showroom or call us to complete your scheme enrollment.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      color: Color(0xFF6E665A),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                /// CONTACT CARD
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1E8DA),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [

                        contactTile(
                          Icons.phone,
                          "Call Us",
                          "+91 98765 43210",
                        ),

                        const Divider(height: 1),

                        contactTile(
                          Icons.chat,
                          "WhatsApp",
                          "Message us directly",
                        ),

                        const Divider(height: 1),

                        contactTile(
                          Icons.location_on,
                          "Visit Showroom",
                          "MG Road, Bangalore",
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget contactTile(
      IconData icon,
      String title,
      String subtitle,
      ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [

          /// icon circle
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

          const SizedBox(width: 14),

          /// text
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Text(
                title,
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.grey,
                ),
              ),

              const SizedBox(height: 2),

              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}