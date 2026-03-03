import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'auth_choice_screen.dart';
import '../core/session_manager.dart';

class HomeScreen extends StatefulWidget {
  final String username;

  const HomeScreen({super.key, required this.username});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  void _onLogout() async {
    await SessionManager.clearSession();

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => const AuthChoiceScreen(),
      ),
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          /// Background
          Positioned.fill(
            child: Image.asset(
              "assets/images/showroom_bg.png",
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(
              color: const Color(0xFFF5EBDD).withOpacity(0.60),
            ),
          ),

          SafeArea(
            child: IndexedStack(
              index: _currentIndex,
              children: [
                _buildHomeContent(),
                _buildPlaceholder("Products"),
                _buildPlaceholder("Schemes"),
                _buildPlaceholder("Rates"),
                _buildProfile(),
              ],
            ),
          ),
        ],
      ),

      /// Bottom Navbar
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF6F0E4),
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(22),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, -2),
            )
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedItemColor: const Color(0xFFD4AF37),
          unselectedItemColor: const Color(0xFF7A7267),
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined), label: "Home"),
            BottomNavigationBarItem(
                icon: Icon(Icons.shopping_bag_outlined), label: "Products"),
            BottomNavigationBarItem(
                icon: Icon(Icons.description_outlined), label: "Schemes"),
            BottomNavigationBarItem(
                icon: Icon(Icons.trending_up_outlined), label: "Rates"),
            BottomNavigationBarItem(
                icon: Icon(Icons.person_outline), label: "Profile"),
          ],
        ),
      ),
    );
  }

  /// HOME CONTENT (Your existing UI stays here)
  Widget _buildHomeContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 28),

          /// Greeting
          Row(
            children: [
              Image.asset(
                "assets/images/suvarna_logo.png",
                height: 52,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Hello, ${widget.username} 👋",
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF3B2A1F),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Build your golden future with Suvarna Jewellers",
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: const Color(0xFF6E665A),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 28),

          /// Total Savings Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.95),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: const Color(0xFFD4AF37),
                width: 0.6,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "TOTAL SAVINGS",
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    letterSpacing: 1.1,
                    color: const Color(0xFF7A7267),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "₹38,000",
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFFB48A2C),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 36),

          Text(
            "My Schemes",
            style: GoogleFonts.playfairDisplay(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF3B2A1F),
            ),
          ),

          const SizedBox(height: 20),

          _buildSchemeCard("Suvarna Gold Savings"),
          const SizedBox(height: 18),
          _buildSchemeCard("Suvarna Heritage Plan"),

          const SizedBox(height: 120),
        ],
      ),
    );
  }

  Widget _buildSchemeCard(String title) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFD4AF37),
          width: 0.5,
        ),
      ),
      child: Text(
        title,
        style: GoogleFonts.playfairDisplay(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF3B2A1F),
        ),
      ),
    );
  }

  Widget _buildPlaceholder(String title) {
    return Center(
      child: Text(
        "$title Page",
        style: GoogleFonts.playfairDisplay(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF3B2A1F),
        ),
      ),
    );
  }

  Widget _buildProfile() {
    return Center(
      child: ElevatedButton(
        onPressed: _onLogout,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFD4AF37),
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
        child: const Text("Logout"),
      ),
    );
  }
}