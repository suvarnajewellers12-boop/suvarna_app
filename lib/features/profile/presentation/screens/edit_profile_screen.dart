import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:suvarna_jewellers/core/session_manager.dart';
import 'package:suvarna_jewellers/features/auth/data/local_auth_database.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {

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

          /// Blur + opacity overlay
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
              child: Container(
                color: const Color(0xFFF5EBDD).withOpacity(0.55),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [

                /// Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [

                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new, size: 18),
                        onPressed: () => Navigator.pop(context),
                      ),

                      const SizedBox(width: 6),

                      const Text(
                        "Edit Profile",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                /// Content
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 40),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      child: Column(
                        children: [

                          /// Profile Card
                          Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFFF1E8DA), // NEW COLOR
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(.05),
                                  blurRadius: 10,
                                  offset: const Offset(0, 6),
                                )
                              ],
                            ),
                            child: Column(
                              children: [

                                ListTile(
                                  leading: const CircleAvatar(
                                    backgroundColor: Color(0xFFE6D7C3),
                                    child: Icon(
                                      Icons.person,
                                      color: Color(0xFFB78628),
                                    ),
                                  ),
                                  title: const Text(
                                    "Full Name",
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  subtitle: Text(
                                    user?["fullName"] ?? "",
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),

                                const Divider(height: 1),

                                ListTile(
                                  leading: const CircleAvatar(
                                    backgroundColor: Color(0xFFE6D7C3),
                                    child: Icon(
                                      Icons.phone,
                                      color: Color(0xFFB78628),
                                    ),
                                  ),
                                  title: const Text(
                                    "Mobile Number",
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  subtitle: Text(
                                    "+91 ${user?["mobile"] ?? ""}",
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),

                                const Divider(height: 1),

                                ListTile(
                                  leading: const CircleAvatar(
                                    backgroundColor: Color(0xFFE6D7C3),
                                    child: Icon(
                                      Icons.mail,
                                      color: Color(0xFFB78628),
                                    ),
                                  ),
                                  title: const Text(
                                    "Username",
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  subtitle: Text(
                                    "@${user?["username"] ?? ""}",
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 20),

                          /// Bottom Text
                          const Text(
                            "To update your profile details, please visit our showroom or contact us.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF7A7267),
                            ),
                          ),
                        ],
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