import 'dart:io' show Platform; // Used to detect iPhone vs Android
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vibration/vibration.dart';
import '../../../screens/home_screen.dart';
import '../data/auth_service.dart';
import '../data/biometric_service.dart';
import '../../../core/session_manager.dart';
import 'forgot_mpin_screen.dart';

enum MPinMode { setup, verify, forgotReset }

class MPinScreen extends StatefulWidget {
  final MPinMode mode;
  final String username;

  const MPinScreen({super.key, required this.mode, required this.username});

  @override
  State<MPinScreen> createState() => _MPinScreenState();
}

class _MPinScreenState extends State<MPinScreen> {
  static const int maxLength = 4;

  String _mpin = '';
  String _confirmMpin = '';
  bool _isConfirmStep = false;
  String? _error;

  // Biometric state flags
  bool _showFingerprintUI = false;

  String get _currentValue => _isConfirmStep ? _confirmMpin : _mpin;

  // ─── Lifecycle ──────────────────────────────────────────────────────────────

  @override
  void initState() {
    super.initState();
    debugPrint('🎬 [MPinScreen] Initialization triggered.');

    // Only handle fingerprint actions if we are logging in (verify) AND it's NOT an iPhone
    if (widget.mode == MPinMode.verify && !Platform.isIOS) {
      _checkAndRunBiometrics();
    }
  }

  /// Evaluates device-level fingerprint capabilities directly
  Future<void> _checkAndRunBiometrics() async {
    final hardwareSupported = await BiometricService.isAvailable();
    final hasEnrolledFingers = await BiometricService.hasFingerprint();

    debugPrint(
      '🔍 [MPinScreen:DirectCheck] Hardware Supported: $hardwareSupported, Enrolled on Device: $hasEnrolledFingers',
    );

    if (!mounted) return;

    if (hardwareSupported && hasEnrolledFingers) {
      // Fingerprints exist on the phone -> Show the button UI and auto-trigger the scanner prompt
      setState(() => _showFingerprintUI = true);
      await Future.delayed(const Duration(milliseconds: 400));
      if (mounted) _triggerBiometric();
    } else if (hardwareSupported && !hasEnrolledFingers) {
      // Hardware exists but no fingerprints are enrolled -> Prompt system settings guide dialog
      await Future.delayed(const Duration(milliseconds: 300));
      if (mounted) _showEnrollmentSettingsDialog();
    }
  }

  /// Displays an actionable dialog instructing the user to configure their system security settings
  void _showEnrollmentSettingsDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFFF8F3E8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            'Fingerprint Not Configured',
            style: GoogleFonts.playfairDisplay(
              fontWeight: FontWeight.bold,
              color: const Color(0xFF3B2A1F),
            ),
          ),
          content: Text(
            'Your device supports fingerprint login, but no fingerprints are registered in your phone settings.\n\nPlease go to Settings -> Security -> Add Fingerprint to enable instant login.',
            style: GoogleFonts.poppins(
              color: const Color(0xFF6E665A),
              fontSize: 14,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: GoogleFonts.poppins(color: const Color(0xFFA79E91)),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);
                debugPrint(
                  '⚙️ Opening device system security configuration panel via native Intent...',
                );

                // Create a generic native application intent caller
                const MethodChannel intentChannel = MethodChannel(
                  'suvarna_jewellers/system_intent',
                );
                try {
                  // Force Android to switch to the main Security Settings Activity window directly
                  await intentChannel.invokeMethod('openSecuritySettings');
                } catch (e) {
                  debugPrint(
                    '❌ Native custom intent channel layout failed: $e',
                  );

                  // Secondary fallback if everything fails
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Could not launch settings automatically. Please open your phone Settings -> Security to add a fingerprint.',
                          style: GoogleFonts.poppins(fontSize: 13),
                        ),
                        backgroundColor: const Color(0xFF3B2A1F),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFD4AF37),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'Open Settings',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // ─── Vibration helpers ──────────────────────────────────────────────────────

  Future<void> _vibrateDigit() async {
    final hasVibrator = await Vibration.hasVibrator() ?? false;
    if (hasVibrator) {
      Vibration.vibrate(duration: 40, amplitude: 80);
    } else {
      HapticFeedback.mediumImpact();
    }
  }

  Future<void> _vibrateError() async {
    final hasVibrator = await Vibration.hasVibrator() ?? false;
    if (hasVibrator) {
      await Vibration.vibrate(duration: 80);
      await Future.delayed(const Duration(milliseconds: 60));
      await Vibration.vibrate(duration: 80);
    } else {
      HapticFeedback.vibrate();
    }
  }

  Future<void> _vibrateDelete() async {
    final hasVibrator = await Vibration.hasVibrator() ?? false;
    if (hasVibrator) {
      Vibration.vibrate(duration: 25, amplitude: 50);
    } else {
      HapticFeedback.selectionClick();
    }
  }

  // ─── Keypad logic ───────────────────────────────────────────────────────────

  void _handleDigit(String digit) {
    if (_currentValue.length >= maxLength) return;

    _vibrateDigit();

    setState(() {
      _error = null;
      if (_isConfirmStep) {
        _confirmMpin += digit;
      } else {
        _mpin += digit;
      }
    });

    if (_currentValue.length == maxLength) {
      Future.delayed(const Duration(milliseconds: 80), _processCompletion);
    }
  }

  void _handleDelete() {
    _vibrateDelete();
    setState(() {
      _error = null;
      if (_isConfirmStep && _confirmMpin.isNotEmpty) {
        _confirmMpin = _confirmMpin.substring(0, _confirmMpin.length - 1);
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
      setState(() => _isConfirmStep = true);
      return;
    }

    if (_mpin == _confirmMpin) {
      _onComplete(_mpin);
    } else {
      _vibrateError();
      setState(() {
        _error = "MPIN does not match. Try again.";
        _mpin = '';
        _confirmMpin = '';
        _isConfirmStep = false;
      });
    }
  }

  // ─── Completion / navigation ────────────────────────────────────────────────

  void _onComplete(String mpin) async {
    if (widget.mode == MPinMode.setup || widget.mode == MPinMode.forgotReset) {
      final result = widget.mode == MPinMode.forgotReset
          ? await AuthService.resetMpin(mobile: widget.username, mpin: mpin)
          : await AuthService.setMpin(username: widget.username, mpin: mpin);

      if (!result.success) {
        _vibrateError();
        setState(() {
          _error = result.message ?? "Failed to save MPIN";
          _mpin = '';
          _confirmMpin = '';
          _isConfirmStep = false;
        });
        return;
      }

      await SessionManager.saveLoginSession(widget.username);

      if (!mounted) return;

      // Post-Registration always routes straight to home dashboard now
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
        (route) => false,
      );
      return;
    }

    // ── Verify mode ──────────────────────────────────────────────────────────
    if (widget.mode == MPinMode.verify) {
      final result = await AuthService.verifyMpin(
        username: widget.username,
        mpin: mpin,
      );

      if (!result.success) {
        _vibrateError();
        setState(() {
          _error = result.message ?? "Incorrect MPIN";
          _mpin = '';
          _confirmMpin = '';
          _isConfirmStep = false;
        });
        return;
      }

      await SessionManager.saveLoginSession(widget.username);

      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
        (route) => false,
      );
    }
  }

  // ─── Biometric trigger (verify mode) ────────────────────────────────────────

  Future<void> _triggerBiometric() async {
    final success = await BiometricService.authenticate(
      reason: 'Use your fingerprint to log in',
    );

    if (!mounted) return;

    if (success) {
      await SessionManager.saveLoginSession(widget.username);
      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
        (route) => false,
      );
    }
  }

  // ─── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final isSetup =
        widget.mode == MPinMode.setup || widget.mode == MPinMode.forgotReset;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xFFF8F3E8),
      body: SafeArea(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const SizedBox(height: 40),

                  Image.asset('assets/images/suvarna_logo.png', height: 70),

                  const SizedBox(height: 24),

                  // ── Lock icon ────────────────────────────────────────────
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

                  // ── Title ────────────────────────────────────────────────
                  Text(
                    isSetup
                        ? (_isConfirmStep ? "Confirm MPIN" : "Create MPIN")
                        : "Enter MPIN",
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF3B2A1F),
                    ),
                  ),

                  const SizedBox(height: 8),

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

                  // ── Dot indicators ───────────────────────────────────────
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      maxLength,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        margin: const EdgeInsets.symmetric(horizontal: 6),
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

                  // ── Error message ────────────────────────────────────────
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

                  const SizedBox(height: 40),

                  // ── Keypad ───────────────────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: 12,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            mainAxisSpacing: 16,
                            crossAxisSpacing: 16,
                            childAspectRatio: 1.2,
                          ),
                      itemBuilder: (context, index) {
                        final keys = [
                          '1',
                          '2',
                          '3',
                          '4',
                          '5',
                          '6',
                          '7',
                          '8',
                          '9',
                          '',
                          '0',
                          'del',
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

                  // ── Fingerprint button UI (Hidden on iPhone automatically) ──
                  if (_showFingerprintUI) ...[
                    const SizedBox(height: 28),
                    // _buildFingerprintButton(),
                  ],

                  // ── Forgot MPIN (verify mode only) ────────────────────────
                  if (widget.mode == MPinMode.verify) ...[
                    const SizedBox(height: 10),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ForgotMpinScreen(),
                          ),
                        );
                      },
                      child: Text(
                        "Forgot MPIN?",
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: const Color(0xFFB48A2C),
                        ),
                      ),
                    ),
                  ],

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ─── Fingerprint button widget ──────────────────────────────────────────────

  // Widget _buildFingerprintButton() {
  //   return GestureDetector(
  //     onTap: _triggerBiometric,
  //     child: Column(
  //       children: [
  //         Container(
  //           height: 64,
  //           width: 64,
  //           decoration: BoxDecoration(
  //             shape: BoxShape.circle,
  //             color: const Color(0xFFE9DFCF),
  //             boxShadow: [
  //               BoxShadow(
  //                 color: const Color(0xFFD4AF37).withOpacity(0.20),
  //                 blurRadius: 16,
  //                 spreadRadius: 2,
  //               ),
  //             ],
  //           ),
  //           child: const Icon(
  //             Icons.fingerprint,
  //             size: 34,
  //             color: Color(0xFFB48A2C),
  //           ),
  //         ),
  //         const SizedBox(height: 8),
  //         Text(
  //           'Use Fingerprint',
  //           style: GoogleFonts.poppins(
  //             fontSize: 12,
  //             color: const Color(0xFFB48A2C),
  //             fontWeight: FontWeight.w500,
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // ─── Key widget ─────────────────────────────────────────────────────────────

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
          color: isDelete ? const Color(0xFFE0D8CC) : const Color(0xFFF1E8DA),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Center(
          child: icon != null
              ? Icon(icon, color: const Color(0xFF6E665A))
              : Text(
                  label!,
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF3B2A1F),
                  ),
                ),
        ),
      ),
    );
  }
}
