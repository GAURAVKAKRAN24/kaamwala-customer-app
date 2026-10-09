import 'dart:async';
import 'package:flutter/material.dart';
import '../services/app_state.dart';

class LoginScreen extends StatefulWidget {
  final AppState appState;

  const LoginScreen({super.key, required this.appState});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  // Phone Tab
  final TextEditingController _phoneController = TextEditingController(text: '9876543210');
  final List<TextEditingController> _otpControllers = List.generate(4, (_) => TextEditingController());
  final List<FocusNode> _otpFocusNodes = List.generate(4, (_) => FocusNode());
  bool _otpSent = false;
  int _otpCountdown = 30;
  Timer? _countdownTimer;

  // Email Tab
  final TextEditingController _emailController = TextEditingController(text: 'ankit@email.com');
  final TextEditingController _passwordController = TextEditingController(text: 'pass123');
  final TextEditingController _nameController = TextEditingController(text: 'Ankit Verma');
  bool _isSignUp = false;
  bool _obscurePassword = true;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    // Prefill demo OTP
    _otpControllers[0].text = '1';
    _otpControllers[1].text = '2';
    _otpControllers[2].text = '3';
    _otpControllers[3].text = '4';
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _tabController.dispose();
    _phoneController.dispose();
    for (var c in _otpControllers) {
      c.dispose();
    }
    for (var f in _otpFocusNodes) {
      f.dispose();
    }
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _sendOtp() {
    if (_phoneController.text.trim().length < 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid 10-digit mobile number')),
      );
      return;
    }
    setState(() {
      _isLoading = true;
    });
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _otpSent = true;
          _otpCountdown = 30;
        });
        _countdownTimer?.cancel();
        _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
          if (_otpCountdown > 0) {
            setState(() => _otpCountdown--);
          } else {
            _countdownTimer?.cancel();
          }
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Demo OTP sent: 1234'),
            backgroundColor: Color(0xFF0F766E),
          ),
        );
      }
    });
  }

  void _verifyOtpAndLogin() {
    setState(() => _isLoading = true);
    Future.delayed(const Duration(milliseconds: 700), () {
      if (mounted) {
        setState(() => _isLoading = false);
        widget.appState.login(
          name: 'Ankit Verma',
          email: 'ankit@email.com',
          phone: '+91 ${_phoneController.text.trim()}',
          method: 'phone_otp',
        );
      }
    });
  }

  void _loginWithGoogle() {
    setState(() => _isLoading = true);
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) {
        setState(() => _isLoading = false);
        widget.appState.login(
          name: 'Ankit Verma',
          email: 'ankit.verma@gmail.com',
          phone: '+91 98765 43210',
          method: 'google',
        );
      }
    });
  }

  void _loginWithEmail() {
    if (_emailController.text.trim().isEmpty || _passwordController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter email and password')),
      );
      return;
    }
    setState(() => _isLoading = true);
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) {
        setState(() => _isLoading = false);
        final name = _isSignUp ? _nameController.text.trim() : 'Ankit Verma';
        widget.appState.login(
          name: name.isEmpty ? 'Customer' : name,
          email: _emailController.text.trim(),
          phone: '+91 98765 43210',
          method: 'email',
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              // Logo & App Name
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF0F766E), Color(0xFF115E59)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF0F766E).withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Text(
                        'K',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'KaamWala',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF18181B),
                          letterSpacing: -0.5,
                        ),
                      ),
                      Text(
                        'Trusted Doorstep Services',
                        style: TextStyle(fontSize: 12, color: Color(0xFF71717A)),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 28),

              const Text(
                'Welcome Back',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF18181B),
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Sign in to book verified technicians at transparent rates',
                style: TextStyle(fontSize: 14, color: Color(0xFF71717A)),
              ),

              const SizedBox(height: 24),

              // Google 1-Tap Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton(
                  onPressed: _isLoading ? null : _loginWithGoogle,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFFE4E4E7), width: 1.5),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    backgroundColor: Colors.white,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 22,
                        height: 22,
                        decoration: const BoxDecoration(shape: BoxShape.circle),
                        child: const Center(
                          child: Text(
                            'G',
                            style: TextStyle(
                              color: Color(0xFFEA4335),
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Continue with Google',
                        style: TextStyle(
                          color: Color(0xFF18181B),
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Row(
                children: [
                  Expanded(child: Divider(color: Colors.grey.shade300)),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Text('OR', style: TextStyle(color: Color(0xFFA1A1AA), fontSize: 12, fontWeight: FontWeight.bold)),
                  ),
                  Expanded(child: Divider(color: Colors.grey.shade300)),
                ],
              ),

              const SizedBox(height: 20),

              // Tab Bar (Phone vs Email)
              Container(
                height: 46,
                decoration: BoxDecoration(
                  color: const Color(0xFFF4F4F5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TabBar(
                  controller: _tabController,
                  indicator: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4),
                    ],
                  ),
                  labelColor: const Color(0xFF0F766E),
                  unselectedLabelColor: const Color(0xFF71717A),
                  labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  tabs: const [
                    Tab(text: 'Mobile Number'),
                    Tab(text: 'Email / Password'),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Tab Views
              SizedBox(
                height: 280,
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    // Phone View
                    _buildPhoneAuthView(),

                    // Email View
                    _buildEmailAuthView(),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // Skip Demo Login
              Center(
                child: TextButton(
                  onPressed: () {
                    widget.appState.navigateTo('app');
                  },
                  child: const Text(
                    'Explore services as Guest →',
                    style: TextStyle(
                      color: Color(0xFF0F766E),
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Privacy & Security footer
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.shield_outlined, color: Color(0xFF059669), size: 14),
                    SizedBox(width: 6),
                    Text(
                      'End-to-End Encrypted • Verified Technicians Only',
                      style: TextStyle(fontSize: 11, color: Color(0xFF71717A)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPhoneAuthView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!_otpSent) ...[
          const Text('Enter 10-digit mobile number', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF3F3F46))),
          const SizedBox(height: 8),
          Container(
            height: 52,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFE4E4E7)),
            ),
            child: Row(
              children: [
                const Text('+91', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF18181B))),
                const SizedBox(width: 10),
                Container(width: 1, height: 22, color: const Color(0xFFE4E4E7)),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: '98765 43210',
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _sendOtp,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0F766E),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                elevation: 0,
              ),
              child: _isLoading
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : const Text('Get OTP', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
            ),
          ),
        ] else ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('OTP sent to +91 ${_phoneController.text}', style: const TextStyle(fontSize: 12, color: Color(0xFF71717A))),
              InkWell(
                onTap: () => setState(() => _otpSent = false),
                child: const Text('Change', style: TextStyle(color: Color(0xFF0F766E), fontSize: 12, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(4, (index) {
              return SizedBox(
                width: 58,
                height: 58,
                child: TextField(
                  controller: _otpControllers[index],
                  focusNode: _otpFocusNodes[index],
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  maxLength: 1,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  decoration: InputDecoration(
                    counterText: '',
                    filled: true,
                    fillColor: const Color(0xFFF8FAFC),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: Color(0xFFE4E4E7), width: 1.5),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: Color(0xFF0F766E), width: 2),
                    ),
                  ),
                  onChanged: (val) {
                    if (val.isNotEmpty && index < 3) {
                      _otpFocusNodes[index + 1].requestFocus();
                    }
                  },
                ),
              );
            }),
          ),
          const SizedBox(height: 12),
          Text(
            _otpCountdown > 0 ? 'Resend OTP in ${_otpCountdown}s' : 'Didn’t get OTP? Tap Resend',
            style: const TextStyle(fontSize: 11, color: Color(0xFF71717A)),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _verifyOtpAndLogin,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0F766E),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                elevation: 0,
              ),
              child: _isLoading
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : const Text('Verify & Continue', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildEmailAuthView() {
    return Column(
      children: [
        if (_isSignUp) ...[
          Container(
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE4E4E7)),
            ),
            child: TextField(
              controller: _nameController,
              decoration: const InputDecoration(border: InputBorder.none, hintText: 'Full Name'),
            ),
          ),
          const SizedBox(height: 10),
        ],
        Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE4E4E7)),
          ),
          child: TextField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(border: InputBorder.none, hintText: 'Email address'),
          ),
        ),
        const SizedBox(height: 10),
        Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE4E4E7)),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: const InputDecoration(border: InputBorder.none, hintText: 'Password'),
                ),
              ),
              IconButton(
                icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility, size: 18, color: const Color(0xFF71717A)),
                onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            onPressed: _isLoading ? null : _loginWithEmail,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0F766E),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 0,
            ),
            child: _isLoading
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                : Text(_isSignUp ? 'Create Account' : 'Sign In', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          ),
        ),
        const SizedBox(height: 6),
        InkWell(
          onTap: () => setState(() => _isSignUp = !_isSignUp),
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Text(
              _isSignUp ? 'Already have an account? Sign In' : 'New to KaamWala? Create Account',
              style: const TextStyle(fontSize: 12, color: Color(0xFF0F766E), fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }
}
