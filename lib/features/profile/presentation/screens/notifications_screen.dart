import 'dart:ui';
import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final notifications = [
      {
        "title": "Payment Reminder",
        "desc": "Your scheme installment of ₹1,000 is due on 15 Mar 2026.",
        "time": "2 hours ago",
        "icon": Icons.credit_card
      },
      {
        "title": "New Scheme Available",
        "desc": "Suvarna Diamond Savings scheme is now open for enrollment!",
        "time": "1 day ago",
        "icon": Icons.card_giftcard
      },
      {
        "title": "Payment Received",
        "desc": "Your payment of ₹1,000 for Gold Savings has been recorded.",
        "time": "3 days ago",
        "icon": Icons.calendar_today
      },
      {
        "title": "Rate Update",
        "desc": "Gold rate has been updated to ₹7,250/gram (22K).",
        "time": "5 days ago",
        "icon": Icons.notifications
      }
    ];

    return Scaffold(
      body: Stack(
        children: [

          /// BACKGROUND
          Positioned.fill(
            child: Image.asset(
              "assets/images/showroom_bg.png",
              fit: BoxFit.cover,
            ),
          ),

          /// BLUR
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

                              const SizedBox(width: 8),

                              const Text(
                                "Notifications",
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ],
                          ),
                        ),

                        const SizedBox(height: 10),

                        /// CARD
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFFF1E8DA),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              children: List.generate(notifications.length, (i) {

                                final n = notifications[i];

                                return Column(
                                  children: [

                                    if (i != 0)
                                      Divider(
                                        height: 1,
                                        color: Colors.grey.shade300,
                                      ),

                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 14),
                                      child: Row(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [

                                          /// ICON
                                          Container(
                                            height: 40,
                                            width: 40,
                                            decoration: const BoxDecoration(
                                              color: Color(0xFFE6D7C3),
                                              shape: BoxShape.circle,
                                            ),
                                            child: Icon(
                                              n["icon"] as IconData,
                                              color: const Color(0xFFB78628),
                                              size: 20,
                                            ),
                                          ),

                                          const SizedBox(width: 12),

                                          /// TEXT
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [

                                                Text(
                                                  n["title"] as String,
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),

                                                const SizedBox(height: 2),

                                                Text(
                                                  n["desc"] as String,
                                                  style: const TextStyle(
                                                    fontSize: 13,
                                                    color: Color(0xFF6E665A),
                                                  ),
                                                ),

                                                const SizedBox(height: 4),

                                                Text(
                                                  n["time"] as String,
                                                  style: const TextStyle(
                                                    fontSize: 11,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
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