import 'dart:ui';
import 'package:flutter/material.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final terms = [
      {
        "title": "1. Scheme Enrollment",
        "text": "Enrollment requires valid ID verification."
      },
      {
        "title": "2. Payments",
        "text": "Monthly installments must be paid before due date."
      },
      {
        "title": "3. Gold Rate",
        "text": "Market rate at maturity will apply."
      },
      {
        "title": "4. Premature Closure",
        "text": "Benefits may not apply if closed early."
      },
      {
        "title": "5. Privacy",
        "text": "Your data will not be shared."
      },
      {
        "title": "6. App Usage",
        "text": "App is informational only."
      },
    ];

    return Scaffold(
      body: Stack(
        children: [

          /// Background image
          Positioned.fill(
            child: Image.asset(
              "assets/images/showroom_bg.png",
              fit: BoxFit.cover,
            ),
          ),

          /// Blur overlay
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
                    constraints:
                    BoxConstraints(minHeight: constraints.maxHeight),
                    child: Column(
                      children: [

                        /// HEADER
                        Padding(
                          padding:
                          const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            children: [

                              IconButton(
                                icon: const Icon(
                                    Icons.arrow_back_ios_new),
                                onPressed: () =>
                                    Navigator.pop(context),
                              ),

                              const SizedBox(width: 6),

                              const Text(
                                "Terms & Conditions",
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        /// TERMS CARD
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 18, vertical: 20),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF1E8DA),
                              borderRadius:
                              BorderRadius.circular(24),
                            ),
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: terms.map((t) {

                                return Padding(
                                  padding:
                                  const EdgeInsets.only(
                                      bottom: 18),
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment
                                        .start,
                                    children: [

                                      Text(
                                        t["title"]!,
                                        style: const TextStyle(
                                          fontWeight:
                                          FontWeight.w600,
                                          fontSize: 16,
                                        ),
                                      ),

                                      const SizedBox(height: 6),

                                      Text(
                                        t["text"]!,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color:
                                          Color(0xFF6E665A),
                                        ),
                                      ),
                                    ],
                                  ),
                                );

                              }).toList(),
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
}