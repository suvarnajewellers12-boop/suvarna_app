import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/session_manager.dart';
import 'auth_choice_screen.dart';
import '../features/schemes/models/enrolled_scheme.dart';
import '../features/schemes/presentation/schemes_screen.dart';
import '../features/schemes/data/enrolled_scheme_service.dart';

class HomeScreen extends StatefulWidget {
  final String username;

  const HomeScreen({super.key, required this.username});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  late Future<List<EnrolledScheme>> _schemesFuture;

  List<String> paymentDone = [];

  @override
  void initState() {
    super.initState();
    _schemesFuture = EnrolledSchemeService.getUserSchemes();
  }

  void _onLogout() async {
    await SessionManager.clearSession();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const AuthChoiceScreen()),
          (route) => false,
    );
  }

  void _openSchemeDetails(EnrolledScheme scheme) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFFF6F0E4),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
      ),
      builder: (_) => _buildBottomSheet(scheme),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
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
                color: const Color(0xFFF5EBDD).withOpacity(0.55),
              ),
            ),
          ),
          SafeArea(
            child: IndexedStack(
              index: _currentIndex,
              children: [
                _buildHomeContent(),
                _placeholder("Products"),
                const SchemesScreen(),
                _placeholder("Rates"),
                _buildProfile(),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildHomeContent() {
    return FutureBuilder<List<EnrolledScheme>>(
      future: _schemesFuture,
      builder: (context, snapshot) {

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return const Center(child: Text("Something went wrong"));
        }

        final schemes = snapshot.data ?? [];

        int totalSaved =
        schemes.fold(0, (sum, s) => sum + s.amountPaid);

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              const SizedBox(height: 28),

              Row(
                children: [
                  Image.asset("assets/images/suvarna_logo.png", height: 52),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Welcome, ${widget.username}",
                          style: GoogleFonts.playfairDisplay(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF3B2A1F),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Build your golden future with Suvarna Jewellers",
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: const Color(0xFF6E665A),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 28),

              _buildTotalSavingsCard(totalSaved),

              const SizedBox(height: 36),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "My Schemes",
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF3B2A1F),
                    ),
                  ),
                  Text(
                    "${schemes.length} active",
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: const Color(0xFF6E665A),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 6),

              Text(
                "Tap any scheme to view details",
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  color: const Color(0xFF8C8578),
                ),
              ),

              const SizedBox(height: 20),

              if (schemes.isEmpty)
                const Padding(
                  padding: EdgeInsets.only(top: 40),
                  child: Center(child: Text("No schemes enrolled yet")),
                )
              else
                ...schemes.map((scheme) =>
                    _buildSchemeCard(scheme)),

              const SizedBox(height: 120),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTotalSavingsCard(int totalSaved) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [

          /// Top Gold Line
          Container(
            height: 4,
            decoration: const BoxDecoration(
              color: Color(0xFFD4AF37),
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(26),
              ),
            ),
          ),

          /// Main Card
          Container(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
            decoration: BoxDecoration(
              color: const Color(0xFFF6F0E4).withOpacity(0.98),
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(26),
              ),
              border: Border.all(
                color: const Color(0xFFD4AF37),
                width: 0.8,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                /// Label + Icon
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "TOTAL SAVINGS",
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                        letterSpacing: 1.5,
                        color: const Color(0xFF7A7267),
                      ),
                    ),
                    Container(
                      height: 44,
                      width: 44,
                      decoration: const BoxDecoration(
                        color: Color(0xFFE9DFCF),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.card_giftcard,
                        color: Color(0xFFD4AF37),
                        size: 20,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                /// Amount
                Text(
                  "₹${totalSaved.toString().replaceAllMapped(
                    RegExp(r'\B(?=(\d{3})+(?!\d))'),
                        (match) => ',',
                  )}",
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFFB48A2C),
                  ),
                ),

                const SizedBox(height: 14),

                /// Pills
                Row(
                  children: [
                    _pricePill(
                      icon: Icons.diamond_outlined,
                      label: "Gold 22K",
                      value: "₹6,850/g",
                    ),
                    const SizedBox(width: 10),
                    _pricePill(
                      icon: Icons.trending_up,
                      label: "Silver",
                      value: "₹92/g",
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _pricePill({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF1E8DA),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          Icon(icon, size: 14, color: const Color(0xFFD4AF37)),
          const SizedBox(width: 6),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 11,
              color: const Color(0xFF7A7267),
            ),
          ),
          const SizedBox(width: 6),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: const Color(0xFFB48A2C),
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildSchemeCard(EnrolledScheme scheme) {
    double progress = scheme.monthsPaid / scheme.totalMonths;

    return Padding(
      padding: const EdgeInsets.only(bottom: 22),
      child: InkWell(
        borderRadius: BorderRadius.circular(26),
        onTap: () => _openSchemeDetails(scheme),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFFF6F0E4).withOpacity(0.97),
            borderRadius: BorderRadius.circular(26),
            border: Border.all(
              color: const Color(0xFFD4AF37),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      scheme.name,
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF3B2A1F),
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.chevron_right,
                    color: Color(0xFFD4AF37),
                  )
                ],
              ),

              const SizedBox(height: 8),

              Row(
                children: [
                  Text(
                    "${scheme.monthsPaid}/${scheme.totalMonths} months",
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: const Color(0xFF6E665A),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    "₹${scheme.amountPaid} paid",
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFFB48A2C),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 6,
                  backgroundColor: const Color(0xFFE7DBC9),
                  valueColor: const AlwaysStoppedAnimation(
                    Color(0xFFB48A2C),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomSheet(EnrolledScheme scheme) {
    return Padding(
      padding: const EdgeInsets.all(22),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[400],
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            scheme.name,
            style: GoogleFonts.playfairDisplay(
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 22),
          _detailItem("Total Scheme Amount", "₹${scheme.totalAmount}"),
          _detailItem("Amount Paid", "₹${scheme.amountPaid}"),
          _detailItem("Balance Amount", "₹${scheme.amountBalance}"),
          _detailItem("Months Completed",
              "${scheme.monthsPaid} of ${scheme.totalMonths}"),
          _detailItem("Last Payment Date", scheme.lastPaymentDate),
          _detailItem("Next Due Date", scheme.nextDueDate),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              setState(() {
                paymentDone.add(scheme.id);
              });
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFD4AF37),
              minimumSize: const Size(double.infinity, 52),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
            ),
            child: Text(
              "Pay Now — ₹${(scheme.totalAmount / scheme.totalMonths).round()}/month",
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _detailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: GoogleFonts.poppins(fontSize: 13)),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: (i) => setState(() => _currentIndex = i),
      selectedItemColor: const Color(0xFFD4AF37),
      unselectedItemColor: const Color(0xFF7A7267),
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
        BottomNavigationBarItem(icon: Icon(Icons.shopping_bag), label: "Products"),
        BottomNavigationBarItem(icon: Icon(Icons.description), label: "Schemes"),
        BottomNavigationBarItem(icon: Icon(Icons.trending_up), label: "Rates"),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
      ],
    );
  }

  Widget _placeholder(String title) {
    return Center(child: Text("$title Page"));
  }

  Widget _buildProfile() {
    return Center(
      child: ElevatedButton(
        onPressed: _onLogout,
        child: const Text("Logout"),
      ),
    );
  }
}