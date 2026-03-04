import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:suvarna_jewellers/core/session_manager.dart';
import 'package:suvarna_jewellers/features/auth/data/local_auth_database.dart';
import 'package:suvarna_jewellers/features/profile/presentation/screens/edit_profile_screen.dart';
import 'package:suvarna_jewellers/features/profile/presentation/screens/change_mpin_screen.dart';
import 'package:suvarna_jewellers/features/profile/presentation/screens/notifications_screen.dart';
import 'package:suvarna_jewellers/features/profile/presentation/screens/contact_screen.dart';
import 'package:suvarna_jewellers/features/profile/presentation/screens/help_faq_screen.dart';
import 'package:suvarna_jewellers/features/profile/presentation/screens/rate_app_screen.dart';
import 'package:suvarna_jewellers/features/profile/presentation/screens/terms_screen.dart';
import 'package:suvarna_jewellers/features/profile/presentation/screens/about_screen.dart';
import 'package:suvarna_jewellers/features/profile/presentation/widgets/profile_menu_tile.dart';
import 'package:suvarna_jewellers/screens/auth_choice_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  Map<String, dynamic>? user;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {

    final username = await SessionManager.getUsername();

    if (username == null) return;

    final dbUser = await LocalAuthDatabase.findByUsername(username);

    setState(() {
      user = dbUser;
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

    if (user == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: Stack(
        children: [

          /// Background Image
          Positioned.fill(
            child: Image.asset(
              "assets/images/showroom_bg.png",
              fit: BoxFit.cover,
            ),
          ),

          /// Blur Overlay (same as HomeScreen)
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
              child: Container(
                color: const Color(0xFFF5EBDD).withOpacity(0.55),
              ),
            ),
          ),

          /// Page Content
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 80),
              child: Column(
                children: [

                  const SizedBox(height: 50),

                  Image.asset(
                    "assets/images/suvarna_logo.png",
                    height: 50,
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    "My Profile",
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 20),

                  /// USER CARD
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    padding: const EdgeInsets.all(16),
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
                              user?["fullName"] ?? "",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold),
                            ),

                            Text("@${user?["username"] ?? ""}"),

                            Text(
                              "+91 ${user?["mobile"] ?? ""}",
                              style: const TextStyle(fontSize: 12),
                            ),

                          ],
                        )
                      ],
                    ),
                  ),

                  const SizedBox(height: 25),

                  sectionTitle("ACCOUNT"),

                  menuCard([
                    ProfileMenuTile(
                        icon: Icons.person,
                        title: "Edit Profile",
                        subtitle: "Name, mobile number",
                        onTap: () =>
                            push(context, const EditProfileScreen())),

                    ProfileMenuTile(
                        icon: Icons.lock,
                        title: "Change MPIN",
                        subtitle: "Update your security PIN",
                        onTap: () =>
                            push(context, const ChangeMPINScreen())),

                    ProfileMenuTile(
                        icon: Icons.notifications,
                        title: "Notifications",
                        subtitle: "Manage push notifications",
                        onTap: () =>
                            push(context, const NotificationsScreen())),
                  ]),

                  sectionTitle("GENERAL"),

                  menuCard([
                    ProfileMenuTile(
                        icon: Icons.message,
                        title: "Contact Us",
                        subtitle: "Get in touch with us",
                        onTap: () =>
                            push(context, const ContactScreen())),

                    ProfileMenuTile(
                        icon: Icons.help,
                        title: "Help & FAQ",
                        subtitle: "Common questions answered",
                        onTap: () =>
                            push(context, const HelpFAQScreen())),

                    ProfileMenuTile(
                        icon: Icons.star,
                        title: "Rate the App",
                        subtitle: "Share your feedback",
                        onTap: () =>
                            push(context, const RateAppScreen())),

                    ProfileMenuTile(
                        icon: Icons.description,
                        title: "Terms & Conditions",
                        subtitle: "Our policies",
                        onTap: () =>
                            push(context, const TermsScreen())),

                    ProfileMenuTile(
                        icon: Icons.info,
                        title: "About Suvarna Jewellers",
                        subtitle: "Since 1985",
                        onTap: () =>
                            push(context, const AboutScreen())),
                  ]),

                  const SizedBox(height: 20),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade50,
                        foregroundColor: Colors.red,
                        minimumSize: const Size(double.infinity, 48),
                      ),
                      onPressed: _logout,
                      icon: const Icon(Icons.logout),
                      label: const Text("Logout"),
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.grey),
        ),
      ),
    );
  }

  Widget menuCard(List<Widget> children) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF1E8DA),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(children: children),
    );
  }

  void push(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
  }
}