import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:suvarna_jewellers/core/session_manager.dart';
import 'package:suvarna_jewellers/features/auth/data/local_auth_database.dart';

class ChangeMPINScreen extends StatefulWidget {
  const ChangeMPINScreen({super.key});

  @override
  State<ChangeMPINScreen> createState() => _ChangeMPINScreenState();
}

class _ChangeMPINScreenState extends State<ChangeMPINScreen> {

  final TextEditingController current = TextEditingController();
  final TextEditingController newPin = TextEditingController();
  final TextEditingController confirm = TextEditingController();

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

  Future<void> updateMPIN() async {

    if (user == null) return;

    if (current.text != user!["mpin"]) {
      showError("Current MPIN is incorrect");
      return;
    }

    if (newPin.text.length != 4) {
      showError("MPIN must be 4 digits");
      return;
    }

    if (newPin.text != confirm.text) {
      showError("New MPIN does not match");
      return;
    }

    user!["mpin"] = newPin.text;

    await LocalAuthDatabase.updateUser(user!);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("MPIN updated successfully")),
    );

    Navigator.pop(context);
  }

  void showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
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

          /// background
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
                color: const Color(0xFFF5EBDD).withOpacity(0.55),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [

                /// header
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
                        "Change MPIN",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1E8DA),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [

                        pinField("Current MPIN", current),

                        const SizedBox(height: 20),

                        pinField("New MPIN", newPin),

                        const SizedBox(height: 20),

                        pinField("Confirm New MPIN", confirm),

                        const SizedBox(height: 25),

                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFD4A02A),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            onPressed: updateMPIN,
                            child: const Text(
                              "Update MPIN",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        )
                      ],
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

  Widget pinField(String label, TextEditingController controller) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Text(
          label,
          style: const TextStyle(fontSize: 14),
        ),

        const SizedBox(height: 8),

        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          obscureText: true,
          maxLength: 4,
          textAlign: TextAlign.center,
          style: const TextStyle(
            letterSpacing: 20,
            fontSize: 20,
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFFE9DFCF),
            counterText: "",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
          ),
        )
      ],
    );
  }
}