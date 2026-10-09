import 'dart:async';
import 'package:flutter/material.dart';
import '../services/app_state.dart';

class MobileAuthScreen extends StatefulWidget {
  final AppState appState;
  const MobileAuthScreen({super.key, required this.appState});

  @override
  State<MobileAuthScreen> createState() => _MobileAuthScreenState();
}

class _MobileAuthScreenState extends State<MobileAuthScreen> {
  final TextEditingController _phoneController = TextEditingController(text: '98765 43210');
  final List<TextEditingController> _otpControllers = List.generate(4, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());

  int _resendCountdown = 24;
  Timer? _timer;
  bool _isVerifying = false;

  @override
  void initState() {
    super.initState();
    _startCountdown();
    // Default demo OTP prefill for instant smooth testing
    _otpControllers[0].text = '1';
    _otpControllers[1].text = '2';
    _otpControllers[2].text = '3';
    _otpControllers[3].text = '4';
  }

  @override
  void dispose() {
    _timer?.cancel();
    _phoneController.dispose();
    for (var c in _otpControllers) {
      c.dispose();
    }
    for (var f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  void _startCountdown() {
    _resendCountdown = 24;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendCountdown > 0) {
        setState(() => _resendCountdown--);
      } else {
        _timer?.cancel();
      }
    });
  }

  void _verifyAndProceed() {
    setState(() => _isVerifying = true);
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) {
        setState(() => _isVerifying = false);
        widget.appState.navigateTo('app');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF18181B)),
          onPressed: () => widget.appState.navigateTo('address'),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Enter your mobile\nnumber',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF18181B),
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'We’ll send an OTP to verify • OTP is masked',
                style: TextStyle(fontSize: 14, color: Color(0xFF71717A)),
              ),
              const SizedBox(height: 32),

              // Mobile Input Container (+91 prefix)
              Container(
                height: 56,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE4E4E7)),
                ),
                child: Row(
                  children: [
                    const Text(
                      '+91',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF18181B)),
                    ),
                    const SizedBox(width: 12),
                    Container(width: 1, height: 24, color: const Color(0xFFE4E4E7)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, letterSpacing: 0.5),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: '98765 43210',
                        ),
                      ),
                    ),
                    const Icon(Icons.verified, color: Color(0xFF059669), size: 20),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // OTP Boxes
              const Text(
                'Enter OTP (demo: 1234)',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF3F3F46)),
              ),
              const SizedBox(height: 12),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(4, (index) {
                  return SizedBox(
                    width: 64,
                    height: 64,
                    child: TextField(
                      controller: _otpControllers[index],
                      focusNode: _focusNodes[index],
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      maxLength: 1,
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      decoration: InputDecoration(
                        counterText: '',
                        filled: true,
                        fillColor: Colors.white,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(color: Color(0xFFE4E4E7), width: 2),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(color: Color(0xFF0F766E), width: 2),
                        ),
                      ),
                      onChanged: (val) {
                        if (val.isNotEmpty && index < 3) {
                          _focusNodes[index + 1].requestFocus();
                        }
                      },
                    ),
                  );
                }),
              ),

              const SizedBox(height: 20),

              // Resend / Privacy Security Note
              Row(
                children: [
                  const Icon(Icons.shield_outlined, color: Color(0xFF059669), size: 16),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      _resendCountdown > 0
                          ? 'OTP encrypted • Auto-read enabled • Resend in ${_resendCountdown}s'
                          : 'OTP encrypted • Resend available via SMS or WhatsApp',
                      style: const TextStyle(fontSize: 12, color: Color(0xFF71717A)),
                    ),
                  ),
                ],
              ),

              const Spacer(),

              // Verify & Continue Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isVerifying ? null : _verifyAndProceed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0F766E),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 0,
                  ),
                  child: _isVerifying
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        )
                      : const Text(
                          'Verify & Continue',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
