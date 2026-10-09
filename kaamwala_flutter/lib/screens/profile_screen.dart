import 'package:flutter/material.dart';
import '../services/app_state.dart';
import 'login_screen.dart';

class ProfileScreen extends StatelessWidget {
  final AppState appState;

  const ProfileScreen({
    super.key,
    required this.appState,
  });

  void _openLogin(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LoginScreen(
          appState: appState,
          onLoginSuccess: () => Navigator.pop(context),
        ),
      ),
    );
  }

  void _handleLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Log Out', style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text('Are you sure you want to log out of KaamWala?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              appState.logout();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Logged out successfully'),
                  backgroundColor: Color(0xFF059669),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
              elevation: 0,
            ),
            child: const Text('Log Out'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = appState.currentUser;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('My Profile & Safety', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF1E293B),
        elevation: 0.5,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // User Profile Card / Login Prompt Card
            if (user != null) ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey.shade200),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 6, offset: const Offset(0, 2)),
                  ],
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 32,
                      backgroundColor: const Color(0xFF059669).withOpacity(0.12),
                      child: Text(
                        user.avatar,
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF059669)),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(user.name, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                              const SizedBox(width: 6),
                              const Icon(Icons.verified, color: Color(0xFF059669), size: 18),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(user.phone, style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                          Text(user.email, style: TextStyle(color: Colors.grey.shade500, fontSize: 11)),
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFFECFDF5),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              'Verified via ${user.authProvider.toUpperCase()}',
                              style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Color(0xFF065F46)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ] else ...[
              // Prompt to Sign In
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  children: [
                    const Icon(Icons.account_circle, size: 48, color: Color(0xFF059669)),
                    const SizedBox(height: 10),
                    const Text('Sign in to unlock faster booking', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text('Manage orders, view invoice history, and connect with verified technicians.', textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => _openLogin(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF059669),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          elevation: 0,
                        ),
                        child: const Text('Sign In or Register', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 16),

            // KaamWala Safety Shield Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF064E3B), Color(0xFF047857)],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.shield, color: Colors.amber, size: 24),
                      SizedBox(width: 10),
                      Text(
                        'KaamWala 24x7 Safety Shield',
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 15),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'All jobs are monitored with encrypted phone masks, live geolocation tracking, and verified police background checks.',
                    style: TextStyle(color: Color(0xFFA7F3D0), fontSize: 12),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Calling Emergency 112...')),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.white70),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          child: const Text('SOS / 112'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Calling KaamWala 24x7 Helpline: 1800-890-4128')),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: const Color(0xFF065F46),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            elevation: 0,
                          ),
                          child: const Text('Support Desk', style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Account & Preferences Options
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.language, color: Color(0xFF059669)),
                    title: const Text('Language (भाषा)'),
                    subtitle: Text(appState.language == 'hi' ? 'हिन्दी (Hindi)' : 'English'),
                    trailing: Switch(
                      value: appState.language == 'hi',
                      activeColor: const Color(0xFF059669),
                      onChanged: (val) => appState.toggleLanguage(),
                    ),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.home_outlined, color: Color(0xFF059669)),
                    title: const Text('Saved Addresses'),
                    subtitle: const Text('Home: Shipra Sun City, Indirapuram'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {},
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.account_balance_wallet_outlined, color: Color(0xFF059669)),
                    title: const Text('KaamWala Credits & Vouchers'),
                    subtitle: const Text('₹100 First Order Credit available'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {},
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.lock_outline, color: Color(0xFF059669)),
                    title: const Text('Privacy & Masked Calling'),
                    subtitle: const Text('Phone masking active on all bookings'),
                    trailing: const Icon(Icons.check_circle, color: Color(0xFF059669), size: 20),
                  ),
                  if (user != null) ...[
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.logout, color: Colors.redAccent),
                      title: const Text('Log Out', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
                      trailing: const Icon(Icons.chevron_right, color: Colors.redAccent),
                      onTap: () => _handleLogout(context),
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 24),

            // App details
            Text('KaamWala Customer App v1.0.0 (Production Release)', style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
            const SizedBox(height: 4),
            Text('Built for high-trust doorstep repairs in India', style: TextStyle(color: Colors.grey.shade400, fontSize: 11)),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
