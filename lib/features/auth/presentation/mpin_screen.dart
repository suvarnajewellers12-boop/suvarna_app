import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../screens/home_screen.dart';
import '../data/auth_service.dart';
import '../../../core/session_manager.dart';

enum MPinMode { setup, verify }

class MPinScreen extends StatefulWidget {
  final MPinMode mode;
  final String username;

  const MPinScreen({
    super.key,
    required this.mode,
    required this.username,
  });

  @override
  State<MPinScreen> createState() => _MPinScreenState();
}

class _MPinScreenState extends State<MPinScreen> {
  static const int maxLength = 4;

  String _mpin = '';
  String _confirmMpin = '';
  bool _isConfirmStep = false;
  String? _error;

  String get _currentValue =>
      _isConfirmStep ? _confirmMpin : _mpin;

  void _handleDigit(String digit) {
    if (_currentValue.length >= maxLength) return;

    setState(() {
      _error = null;

      if (_isConfirmStep) {
        _confirmMpin += digit;
      } else {
        _mpin += digit;
      }
    });

    if (_currentValue.length == maxLength) {
      Future.delayed(const Duration(milliseconds: 200), () {
        _processCompletion();
      });
    }
  }

  void _handleDelete() {
    setState(() {
      _error = null;

      if (_isConfirmStep && _confirmMpin.isNotEmpty) {
        _confirmMpin =
            _confirmMpin.substring(0, _confirmMpin.length - 1);
      } else if (!_isConfirmStep && _mpin.isNotEmpty) {
        _mpin = _mpin.substring(0, _mpin.length - 1);
      }
    });
  }

  void _processCompletion() {
    if (widget.mode == MPinMode.verify) {
      _onComplete(_currentValue);
      return;
    }

    if (!_isConfirmStep) {
      setState(() {
        _isConfirmStep = true;
      });
      return;
    }

    if (_mpin == _confirmMpin) {
      _onComplete(_mpin);
    } else {
      setState(() {
        _error = "MPIN does not match. Try again.";
        _mpin = '';
        _confirmMpin = '';
        _isConfirmStep = false;
      });
    }
  }

  void _onComplete(String mpin) async {

    // ================= SETUP MODE =================
    if (widget.mode == MPinMode.setup) {

      await SessionManager.saveMpin(widget.username, mpin);

      // Save login session
      await SessionManager.saveLoginSession(widget.username);
    }

    // ================= VERIFY MODE =================
    if (widget.mode == MPinMode.verify) {

      final savedMpin = await SessionManager.getMpin(widget.username);

      if (savedMpin == null || savedMpin != mpin) {
        setState(() {
          _error = "Incorrect MPIN";
          _mpin = '';
          _confirmMpin = '';
          _isConfirmStep = false;
        });
        return;
      }

      // Ensure session remains active
      await SessionManager.saveLoginSession(widget.username);
    }

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => const HomeScreen(),
      ),
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isSetup = widget.mode == MPinMode.setup;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F3E8),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 40),

            /// Logo
            Image.asset(
              "assets/images/suvarna_logo.png",
              height: 70,
            ),

            const SizedBox(height: 24),

            /// Lock Icon
            Container(
              height: 48,
              width: 48,
              decoration: const BoxDecoration(
                color: Color(0xFFE9DFCF),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.lock_outline,
                color: Color(0xFFB48A2C),
                size: 22,
              ),
            ),

            const SizedBox(height: 20),

            /// Title
            Text(
              isSetup
                  ? (_isConfirmStep
                  ? "Confirm MPIN"
                  : "Create MPIN")
                  : "Enter MPIN",
              style: GoogleFonts.playfairDisplay(
                fontSize: 26,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF3B2A1F),
              ),
            ),

            const SizedBox(height: 8),

            /// Subtitle
            Text(
              isSetup
                  ? (_isConfirmStep
                  ? "Re-enter your MPIN to confirm"
                  : "Set a 4-digit MPIN for quick access")
                  : "Enter your 4-digit MPIN to continue",
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: const Color(0xFFA79E91),
              ),
            ),

            const SizedBox(height: 30),

            /// Dots
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                maxLength,
                    (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  margin:
                  const EdgeInsets.symmetric(horizontal: 6),
                  height: 14,
                  width: 14,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: index < _currentValue.length
                        ? const Color(0xFFD4AF37)
                        : Colors.transparent,
                    border: Border.all(
                      color: const Color(0xFFD4AF37),
                      width: 2,
                    ),
                  ),
                ),
              ),
            ),

            if (_error != null) ...[
              const SizedBox(height: 16),
              Text(
                _error!,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: Colors.redAccent,
                ),
              ),
            ],

            const Spacer(),

            /// Keypad
            Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 40),
              child: GridView.builder(
                shrinkWrap: true,
                physics:
                const NeverScrollableScrollPhysics(),
                itemCount: 12,
                gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                ),
                itemBuilder: (context, index) {
                  final keys = [
                    '1','2','3',
                    '4','5','6',
                    '7','8','9',
                    '','0','del'
                  ];

                  final key = keys[index];

                  if (key.isEmpty) return const SizedBox();

                  if (key == 'del') {
                    return _buildKey(
                      icon: Icons.backspace_outlined,
                      onTap: _handleDelete,
                      isDelete: true,
                    );
                  }

                  return _buildKey(
                    label: key,
                    onTap: () => _handleDigit(key),
                  );
                },
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildKey({
    String? label,
    IconData? icon,
    required VoidCallback onTap,
    bool isDelete = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 64,
        decoration: BoxDecoration(
          color: isDelete
              ? const Color(0xFFE0D8CC)
              : const Color(0xFFF1E8DA),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Center(
          child: icon != null
              ? Icon(icon,
              color: const Color(0xFF6E665A))
              : Text(
            label!,
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color:
              const Color(0xFF3B2A1F),
            ),
          ),
        ),
      ),
    );
  }
}