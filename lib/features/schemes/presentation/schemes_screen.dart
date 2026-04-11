import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:suvarna_jewellers/features/schemes/data/scheme_model.dart';
import 'package:suvarna_jewellers/features/schemes/data/scheme_service.dart';
import 'package:suvarna_jewellers/features/schemes/data/enrolled_scheme_service.dart';
import 'package:suvarna_jewellers/features/schemes/models/enrolled_scheme.dart';
import 'package:suvarna_jewellers/features/schemes/presentation/widgets/scheme_card.dart';
import '../data/payment_service.dart';

class SchemesScreen extends StatefulWidget {
  const SchemesScreen({super.key});

  @override
  State<SchemesScreen> createState() => _SchemesScreenState();
}

class _SchemesScreenState extends State<SchemesScreen> {
  late Future<List<SchemeModel>> _schemesFuture;
  late Future<List<EnrolledScheme>> _enrolledFuture;

  @override
  void initState() {
    super.initState();
    _schemesFuture = SchemeService.getSchemes();
    _enrolledFuture = EnrolledSchemeService.getUserSchemes();
  }

  Future<void> _refreshData() async {
    setState(() {
      _schemesFuture = SchemeService.getSchemes();
      _enrolledFuture = EnrolledSchemeService.getUserSchemes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
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
            child: FutureBuilder<List<dynamic>>(
              future: Future.wait([
                _schemesFuture,
                _enrolledFuture,
              ]),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFFD4AF37),
                    ),
                  );
                }

                if (snapshot.hasError) {
                  return const Center(
                    child: Text("Failed to load schemes"),
                  );
                }

                final schemes = snapshot.data![0] as List<SchemeModel>;
                final enrolled = snapshot.data![1] as List<EnrolledScheme>;

                final enrolledIds = enrolled.map((e) => e.name.trim()).toSet();

                if (schemes.isEmpty) {
                  return const Center(
                    child: Text("No schemes available"),
                  );
                }

                return RefreshIndicator(
                  onRefresh: _refreshData,
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    physics: const BouncingScrollPhysics(),
                    children: [
                      const SizedBox(height: 28),

                      Center(
                        child: Image.asset(
                          "assets/images/suvarna_logo.png",
                          height: 70,
                        ),
                      ),

                      const SizedBox(height: 18),

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

                      ...schemes.map(
                            (scheme) {
                              final isEnrolled = enrolledIds.contains(scheme.name.trim());

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 28),
                            child: SchemeCard(
                              scheme: scheme,
                              isEnrolled: isEnrolled,
                              onEnroll: () {
                                PaymentService.startPayment(
                                  context: context,
                                  schemeId: scheme.id,
                                  amount: scheme.monthlyAmount,
                                  onSuccess: () {
                                    _refreshData();
                                  },
                                );
                              },
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 120),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}