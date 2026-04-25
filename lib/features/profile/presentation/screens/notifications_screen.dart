import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:suvarna_jewellers/features/schemes/data/enrolled_scheme_service.dart';
import 'package:suvarna_jewellers/features/schemes/models/enrolled_scheme.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

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
            child: FutureBuilder<List<EnrolledScheme>>(
              future: EnrolledSchemeService.getUserSchemes(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                final schemes = snapshot.data!;

                final notifications = schemes
                    .where((s) => s.nextDueDate != "Completed")
                    .map((scheme) {
                  final parts = scheme.nextDueDate.split("-");

                  if (parts.length != 3) return null;

                  final dueDate = DateTime(
                    int.parse(parts[2]),
                    int.parse(parts[1]),
                    int.parse(parts[0]),
                  );

                  final today = DateTime.now();

                  final diff =
                      dueDate.difference(DateTime(today.year, today.month, today.day)).inDays;

                  if (diff > 5) return null;

                  String desc;

                  if (diff > 1) {
                    desc = "${scheme.name} payment due in $diff days";
                  } else if (diff == 1) {
                    desc = "${scheme.name} payment due tomorrow";
                  } else if (diff == 0) {
                    desc = "${scheme.name} payment due today";
                  } else {
                    desc = "${scheme.name} payment overdue. Visit showroom.";
                  }

                  return {
                    "title": "Scheme Reminder",
                    "desc": desc,
                    "icon": Icons.notifications,
                  };
                }).whereType<Map<String, dynamic>>().toList();

                return LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      child: ConstrainedBox(
                        constraints:
                        BoxConstraints(minHeight: constraints.maxHeight),
                        child: Column(
                          children: [
                            Padding(
                              padding:
                              const EdgeInsets.symmetric(horizontal: 16),
                              child: Row(
                                children: [
                                  IconButton(
                                    icon:
                                    const Icon(Icons.arrow_back_ios_new),
                                    onPressed: () => Navigator.pop(context),
                                  ),
                                  const SizedBox(width: 8),
                                  const Text(
                                    "Notifications",
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 10),

                            Padding(
                              padding:
                              const EdgeInsets.symmetric(horizontal: 16),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF1E8DA),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: notifications.isEmpty
                                    ? const Padding(
                                  padding: EdgeInsets.all(20),
                                  child: Text(
                                    "No notifications right now",
                                    style: TextStyle(fontSize: 14),
                                  ),
                                )
                                    : Column(
                                  children: List.generate(
                                    notifications.length,
                                        (i) {
                                      final n = notifications[i];

                                      return Column(
                                        children: [
                                          if (i != 0)
                                            Divider(
                                              height: 1,
                                              color:
                                              Colors.grey.shade300,
                                            ),

                                          Padding(
                                            padding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 12,
                                                vertical: 14),
                                            child: Row(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  height: 40,
                                                  width: 40,
                                                  decoration:
                                                  const BoxDecoration(
                                                    color:
                                                    Color(0xFFE6D7C3),
                                                    shape:
                                                    BoxShape.circle,
                                                  ),
                                                  child: Icon(
                                                    n["icon"]
                                                    as IconData,
                                                    color: const Color(
                                                        0xFFB78628),
                                                    size: 20,
                                                  ),
                                                ),

                                                const SizedBox(width: 12),

                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment
                                                        .start,
                                                    children: [
                                                      Text(
                                                        n["title"]
                                                        as String,
                                                        style:
                                                        const TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                          FontWeight
                                                              .w600,
                                                        ),
                                                      ),

                                                      const SizedBox(
                                                          height: 2),

                                                      Text(
                                                        n["desc"]
                                                        as String,
                                                        style:
                                                        const TextStyle(
                                                          fontSize: 13,
                                                          color: Color(
                                                              0xFF6E665A),
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
                                    },
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 40),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}