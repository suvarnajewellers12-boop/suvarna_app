import 'dart:ui';
import 'package:flutter/material.dart';

class HelpFAQScreen extends StatefulWidget {
  const HelpFAQScreen({super.key});

  @override
  State<HelpFAQScreen> createState() => _HelpFAQScreenState();
}

class _HelpFAQScreenState extends State<HelpFAQScreen> {

  int? openIndex;

  final faqs = [
    {
      "q": "How do I enroll in a savings scheme?",
      "a": "Visit our showroom or contact us to enroll."
    },
    {
      "q": "What payment methods are accepted?",
      "a": "Cash, UPI, bank transfer, cards."
    },
    {
      "q": "Can I close my scheme early?",
      "a": "Yes. Please visit showroom."
    },
    {
      "q": "How is the gold rate calculated?",
      "a": "Based on daily market rate."
    },
    {
      "q": "Is my money safe?",
      "a": "Suvarna Jewellers has been trusted since 1985."
    },
    {
      "q": "How do I reset my MPIN?",
      "a": "Go to Profile → Change MPIN. If forgotten, logout and login again."
    }
  ];

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
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            children: [

                              IconButton(
                                icon: const Icon(Icons.arrow_back_ios_new),
                                onPressed: () => Navigator.pop(context),
                              ),

                              const SizedBox(width: 6),

                              const Text(
                                "Help & FAQ",
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ],
                          ),
                        ),

                        const SizedBox(height: 12),

                        /// FAQ CARD
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFFF1E8DA),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              children: List.generate(faqs.length, (i) {

                                final faq = faqs[i];
                                final isOpen = openIndex == i;

                                return Column(
                                  children: [

                                    if (i != 0)
                                      Divider(
                                        height: 1,
                                        color: Colors.grey.shade300,
                                      ),

                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          openIndex =
                                          isOpen ? null : i;
                                        });
                                      },

                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 18),

                                        child: Row(
                                          children: [

                                            Expanded(
                                              child: Text(
                                                faq["q"]!,
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),

                                            Icon(
                                              isOpen
                                                  ? Icons.keyboard_arrow_up
                                                  : Icons.keyboard_arrow_down,
                                              color: const Color(0xFFB78628),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),

                                    AnimatedCrossFade(
                                      duration:
                                      const Duration(milliseconds: 200),

                                      crossFadeState: isOpen
                                          ? CrossFadeState.showFirst
                                          : CrossFadeState.showSecond,

                                      firstChild: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            16, 0, 16, 18),
                                        child: Align(
                                          alignment:
                                          Alignment.centerLeft,
                                          child: Text(
                                            faq["a"]!,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: Color(0xFF6E665A),
                                            ),
                                          ),
                                        ),
                                      ),

                                      secondChild:
                                      const SizedBox.shrink(),
                                    ),
                                  ],
                                );
                              }),
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