import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final messageController = TextEditingController();

  bool isSending = false;

  Future<void> sendMessage() async {
    if (nameController.text.isEmpty ||
        emailController.text.isEmpty ||
        messageController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields")),
      );
      return;
    }

    setState(() {
      isSending = true;
    });

    try {
      final response = await http.post(
        Uri.parse("https://suvarna-jewellers-customer-backend.vercel.app/api/contact"),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "name": nameController.text.trim(),
          "email": emailController.text.trim(),
          "message": messageController.text.trim(),
        }),
      );

      if (response.statusCode == 200) {
        nameController.clear();
        emailController.clear();
        messageController.clear();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Message sent successfully")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to send message")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }

    setState(() {
      isSending = false;
    });
  }

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
                color: const Color(0xFFF5EBDD).withOpacity(0.55),
              ),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const Text(
                        "Contact Us",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),

                  const SizedBox(height: 20),

                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1E8DA),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        contactRow(Icons.phone, "Phone", "+91 98765 43210"),
                        const SizedBox(height: 20),
                        contactRow(Icons.email, "Email",
                            "support@suvarnajewellers.com"),
                        const SizedBox(height: 20),
                        contactRow(
                          Icons.location_on,
                          "Address",
                          "Suvarna Jewellers Showroom\nD.No 10-45, Main Road, Gajuwaka\nVisakhapatnam, Andhra Pradesh",
                        ),

                        const SizedBox(height: 28),

                        inputField("Your Name", nameController),

                        const SizedBox(height: 14),

                        inputField("Email", emailController),

                        const SizedBox(height: 14),

                        inputField(
                          "Your Message",
                          messageController,
                          maxLines: 4,
                        ),

                        const SizedBox(height: 20),

                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFB78628),
                              foregroundColor: Colors.white,
                              minimumSize: const Size(double.infinity, 52),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            onPressed: isSending ? null : sendMessage,
                            icon: isSending
                                ? const SizedBox(
                              height: 18,
                              width: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                                : const Icon(Icons.send),
                            label: Text(
                              isSending ? "Sending..." : "Send Message",
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget contactRow(IconData icon, String title, String subtitle) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          backgroundColor: const Color(0xFFE6D7C3),
          child: Icon(icon, color: const Color(0xFFB78628)),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 13,
                  )),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget inputField(
      String hint,
      TextEditingController controller, {
        int maxLines = 1,
      }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white.withOpacity(0.6),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}