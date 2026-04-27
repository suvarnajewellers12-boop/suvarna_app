import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:suvarna_jewellers/core/session_manager.dart';
import 'package:suvarna_jewellers/features/auth/data/local_auth_database.dart';
import 'package:suvarna_jewellers/features/profile/presentation/screens/notifications_screen.dart';
import 'package:suvarna_jewellers/features/profile/presentation/screens/contact_screen.dart';
import 'package:suvarna_jewellers/features/profile/presentation/widgets/profile_menu_tile.dart';
import 'package:suvarna_jewellers/screens/auth_choice_screen.dart';
import 'package:suvarna_jewellers/features/profile/presentation/screens/coupons_screen.dart';
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? mobile;
  String? fullName;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final username = await SessionManager.getUsername();

    if (username == null) return;

    final user = await LocalAuthDatabase.findByUsername(username);

    print("USERNAME: $username");
    print("USER DATA: $user");

    final dbName = user?["name"]?.toString().trim();

    setState(() {
      mobile = user?["phone"] ?? username;

      fullName = (dbName != null && dbName.isNotEmpty)
          ? dbName
          : username.split(RegExp(r'[^a-zA-Z]')).first;

      print("FINAL NAME: $fullName");
    });
  }

  Future<void> _logout() async {
    await SessionManager.clearSession();

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const AuthChoiceScreen()),
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (mobile == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

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
                color: const Color(0xFFF5EBDD).withOpacity(0.55),
              ),
            ),
          ),

          SafeArea(
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 20),
                child: Column(
                  children: [
                    const SizedBox(height: 24),

                    Image.asset(
                      "assets/images/suvarna_logo.png",
                      height: 50,
                    ),

                    const SizedBox(height: 8),

                    const Text(
                      "My Profile",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 20),

                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 20,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1E8DA),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          const CircleAvatar(
                            radius: 28,
                            backgroundColor: Color(0xFFE6D7C3),
                            child: Icon(
                              Icons.person,
                              color: Color(0xFFB78628),
                            ),
                          ),

                          const SizedBox(width: 14),

                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                (fullName != null && fullName!.trim().isNotEmpty)
                                    ? fullName!
                                    : "Customer",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                "+91 $mobile",
                                style: const TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1E8DA),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          ProfileMenuTile(
                            icon: Icons.notifications,
                            title: "Notifications",
                            subtitle: "Scheme payment reminders",
                            onTap: () =>
                                push(context, const NotificationsScreen()),
                          ),

                          ProfileMenuTile(
                            icon: Icons.card_giftcard,
                            title: "My Coupons",
                            subtitle: "View your earned reward coupons",
                            onTap: () => push(context, const CouponsScreen()),
                          ),

                          ProfileMenuTile(
                            icon: Icons.message,
                            title: "Contact Us",
                            subtitle: "Get in touch with showroom",
                            onTap: () =>
                                push(context, const ContactScreen()),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 18),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFF1E8DA),
                          foregroundColor: Colors.red,
                          elevation: 0,
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        onPressed: _logout,
                        icon: const Icon(Icons.logout),
                        label: const Text("Logout"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void push(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
  }
}