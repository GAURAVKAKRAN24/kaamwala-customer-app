import 'package:flutter/material.dart';
import '../services/app_state.dart';

class LoginScreen extends StatefulWidget {
  final AppState appState;
  final VoidCallback onLoginSuccess;

  const LoginScreen({
    super.key,
    required this.appState,
    required this.onLoginSuccess,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  int _selectedAuthTab = 0; // 0: Mobile OTP, 1: Email/Password
  bool _isSignUp = false;
  bool _isOtpSent = false;
  bool _obscurePassword = true;
  bool _isLoading = false;

  // Controllers
  final _phoneController = TextEditingController();
  final _otpController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();

  late AnimationController _animController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic));

    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    _phoneController.dispose();
    _otpController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _handleGoogleLogin() {
    setState(() => _isLoading = true);
    Future.delayed(const Duration(milliseconds: 700), () {
      if (mounted) {
        widget.appState.loginWithGoogle();
        widget.onLoginSuccess();
      }
    });
  }

  void _handleSendOtp() {
    final phone = _phoneController.text.trim();
    if (phone.length < 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid 10-digit mobile number'),
          backgroundColor: Colors.redAccent,
        ),
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
          _isOtpSent = true;
          _otpController.text = '4829'; // Auto-fill demonstration for instant easy login
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('OTP sent to your mobile: 4829'),
            backgroundColor: Color(0xFF059669),
          ),
        );
      }
    });
  }

  void _handleVerifyOtp() {
    setState(() => _isLoading = true);
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) {
        widget.appState.loginWithPhone(_phoneController.text.trim());
        widget.onLoginSuccess();
      }
    });
  }

  void _handleEmailAuth() {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || !email.contains('@')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid email address'), backgroundColor: Colors.redAccent),
      );
      return;
    }
    if (password.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password must be at least 6 characters'), backgroundColor: Colors.redAccent),
      );
      return;
    }

    setState(() => _isLoading = true);
    Future.delayed(const Duration(milliseconds: 700), () {
      if (mounted) {
        if (_isSignUp) {
          widget.appState.register(
            name: _nameController.text.trim().isEmpty ? 'Customer' : _nameController.text.trim(),
            email: email,
            phone: _phoneController.text.trim().isEmpty ? '+91 98765 43210' : _phoneController.text.trim(),
            password: password,
          );
        } else {
          widget.appState.loginWithEmail(email, password);
        }
        widget.onLoginSuccess();
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
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 12),
                  // Skip button top right
                  Align(
                    alignment: Alignment.topRight,
                    child: TextButton.icon(
                      onPressed: widget.onLoginSuccess,
                      icon: const Text('Skip for now', style: TextStyle(color: Color(0xFF059669), fontWeight: FontWeight.bold)),
                      label: const Icon(Icons.arrow_forward, size: 16, color: Color(0xFF059669)),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Brand Logo & Header
                  Center(
                    child: Column(
                      children: [
                        Container(
                          width: 72,
                          height: 72,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF059669), Color(0xFF047857)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(22),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF059669).withOpacity(0.35),
                                blurRadius: 16,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: const Icon(Icons.home_repair_service, color: Colors.white, size: 38),
                        ),
                        const SizedBox(height: 14),
                        const Text(
                          'KaamWala',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -0.5,
                            color: Color(0xFF064E3B),
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Aapka Bharosemand Sahayak • Doorstep Services',
                          style: TextStyle(fontSize: 13, color: Color(0xFF64748B), fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // 1-Tap Google Sign-In Button (Prominent Easy Login)
                  OutlinedButton(
                    onPressed: _isLoading ? null : _handleGoogleLogin,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                      side: BorderSide(color: Colors.grey.shade300, width: 1.2),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      backgroundColor: Colors.white,
                      elevation: 0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.network(
                          'https://upload.wikimedia.org/wikipedia/commons/thumb/c/c1/Google_%22G%22_logo.svg/1200px-Google_%22G%22_logo.svg.png',
                          width: 22,
                          height: 22,
                          errorBuilder: (context, error, stackTrace) => const Icon(Icons.g_mobiledata, size: 28, color: Colors.blue),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'Continue with Google',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Divider "OR"
                  Row(
                    children: [
                      Expanded(child: Divider(color: Colors.grey.shade300)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        child: Text(
                          'OR SIGN IN WITH',
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey.shade500, letterSpacing: 0.8),
                        ),
                      ),
                      Expanded(child: Divider(color: Colors.grey.shade300)),
                    ],
                  ),

                  const SizedBox(height: 18),

                  // Segmented Tabs: Mobile OTP vs Email/Password
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () => setState(() => _selectedAuthTab = 0),
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: _selectedAuthTab == 0 ? Colors.white : Colors.transparent,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: _selectedAuthTab == 0
                                    ? [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 4, offset: const Offset(0, 2))]
                                    : null,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.phone_android, size: 16, color: _selectedAuthTab == 0 ? const Color(0xFF059669) : Colors.grey),
                                  const SizedBox(width: 6),
                                  Text(
                                    'Mobile OTP',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                      color: _selectedAuthTab == 0 ? const Color(0xFF059669) : Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () => setState(() => _selectedAuthTab = 1),
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: _selectedAuthTab == 1 ? Colors.white : Colors.transparent,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: _selectedAuthTab == 1
                                    ? [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 4, offset: const Offset(0, 2))]
                                    : null,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.email_outlined, size: 16, color: _selectedAuthTab == 1 ? const Color(0xFF059669) : Colors.grey),
                                  const SizedBox(width: 6),
                                  Text(
                                    'Email & Password',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                      color: _selectedAuthTab == 1 ? const Color(0xFF059669) : Colors.grey.shade600,
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

                  const SizedBox(height: 20),

                  // TAB CONTENT
                  if (_selectedAuthTab == 0) ...[
                    // Mobile OTP View
                    if (!_isOtpSent) ...[
                      const Text(
                        'Enter your Mobile Number',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF334155)),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          prefixIcon: const Padding(
                            padding: EdgeInsets.only(left: 14, right: 10, top: 14, bottom: 14),
                            child: Text(
                              '+91',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF1E293B)),
                            ),
                          ),
                          hintText: '98765 43210',
                          hintStyle: TextStyle(color: Colors.grey.shade400),
                          filled: true,
                          fillColor: const Color(0xFFF8FAFC),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(color: Color(0xFF059669), width: 2),
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      ElevatedButton(
                        onPressed: _isLoading ? null : _handleSendOtp,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF059669),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          elevation: 0,
                        ),
                        child: _isLoading
                            ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                            : const Text('Get OTP via SMS', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                      ),
                    ] else ...[
                      // Enter OTP View
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Enter 4-digit OTP sent to ${_phoneController.text}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                          TextButton(
                            onPressed: () => setState(() => _isOtpSent = false),
                            child: const Text('Change', style: TextStyle(fontSize: 12, color: Color(0xFF059669))),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _otpController,
                        keyboardType: TextInputType.number,
                        maxLength: 4,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, letterSpacing: 10),
                        decoration: InputDecoration(
                          hintText: '• • • •',
                          counterText: '',
                          filled: true,
                          fillColor: const Color(0xFFF8FAFC),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _isLoading ? null : _handleVerifyOtp,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF059669),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          elevation: 0,
                        ),
                        child: _isLoading
                            ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                            : const Text('Verify & Continue', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ] else ...[
                    // Email & Password View
                    if (_isSignUp) ...[
                      TextField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.person_outline, color: Color(0xFF059669)),
                          hintText: 'Full Name',
                          filled: true,
                          fillColor: const Color(0xFFF8FAFC),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: Colors.grey.shade300)),
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],

                    TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.alternate_email, color: Color(0xFF059669)),
                        hintText: 'Email address',
                        filled: true,
                        fillColor: const Color(0xFFF8FAFC),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: Colors.grey.shade300)),
                      ),
                    ),
                    const SizedBox(height: 12),

                    TextField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFF059669)),
                        suffixIcon: IconButton(
                          icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility, color: Colors.grey),
                          onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                        ),
                        hintText: 'Password',
                        filled: true,
                        fillColor: const Color(0xFFF8FAFC),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: Colors.grey.shade300)),
                      ),
                    ),
                    const SizedBox(height: 16),

                    ElevatedButton(
                      onPressed: _isLoading ? null : _handleEmailAuth,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF059669),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        elevation: 0,
                      ),
                      child: _isLoading
                          ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                          : Text(_isSignUp ? 'Create KaamWala Account' : 'Sign In', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                    ),

                    const SizedBox(height: 10),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(_isSignUp ? 'Already have an account?' : "Don't have an account?", style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
                        TextButton(
                          onPressed: () => setState(() => _isSignUp = !_isSignUp),
                          child: Text(_isSignUp ? 'Sign In' : 'Sign Up', style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF059669))),
                        ),
                      ],
                    ),
                  ],

                  const SizedBox(height: 24),

                  // Trust guarantees footer
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.security, size: 14, color: Color(0xFF059669)),
                        const SizedBox(width: 6),
                        Text(
                          '256-bit SSL Encrypted • 100% Privacy Protected',
                          style: TextStyle(fontSize: 11, color: Colors.grey.shade500, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
