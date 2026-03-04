import 'dart:ui';
import 'package:flutter/material.dart';

class RateAppScreen extends StatefulWidget {
  const RateAppScreen({super.key});

  @override
  State<RateAppScreen> createState() => _RateAppScreenState();
}

class _RateAppScreenState extends State<RateAppScreen> {

  int rating = 0;
  bool submitted = false;

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

          /// blur overlay
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
              child: Container(
                color: const Color(0xFFF5EBDD).withOpacity(.55),
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

                      const SizedBox(width: 6),

                      const Text(
                        "Rate the App",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                /// CONTENT
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 40,
                          horizontal: 20,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1E8DA),
                          borderRadius: BorderRadius.circular(20),
                        ),

                        child: submitted
                            ? Column(
                          mainAxisSize: MainAxisSize.min,
                          children: const [

                            Icon(
                              Icons.check_circle,
                              size: 60,
                              color: Color(0xFFB78628),
                            ),

                            SizedBox(height: 20),

                            Text(
                              "Thank you for your feedback!",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            )
                          ],
                        )

                            : Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [

                            const Text(
                              "How's your experience?",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),

                            const SizedBox(height: 30),

                            /// STARS
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.center,
                              children: List.generate(5, (index) {

                                final star = index + 1;

                                return IconButton(
                                  icon: Icon(
                                    Icons.star,
                                    size: 42,
                                    color: star <= rating
                                        ? const Color(0xFFB78628)
                                        : Colors.grey.shade400,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      rating = star;
                                    });
                                  },
                                );
                              }),
                            ),

                            const SizedBox(height: 20),

                            /// SUBMIT BUTTON
                            if (rating > 0)
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                  const Color(0xFFB78628),
                                  padding:
                                  const EdgeInsets.symmetric(
                                    horizontal: 40,
                                    vertical: 14,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.circular(14),
                                  ),
                                ),
                                onPressed: () {
                                  setState(() {
                                    submitted = true;
                                  });
                                },
                                child: const Text(
                                  "Submit Rating",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              )
                          ],
                        ),
                      ),
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
}