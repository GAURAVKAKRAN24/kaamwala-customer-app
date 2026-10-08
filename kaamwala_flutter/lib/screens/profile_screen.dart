import 'package:flutter/material.dart';
import '../services/app_state.dart';

class ProfileScreen extends StatelessWidget {
  final AppState appState;

  const ProfileScreen({
    super.key,
    required this.appState,
  });

  @override
  Widget build(BuildContext context) {
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
            // User Profile Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundColor: const Color(0xFF059669).withOpacity(0.12),
                    child: const Text('AS', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF059669))),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Text('Aarav Sharma', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            SizedBox(width: 6),
                            Icon(Icons.verified, color: Color(0xFF059669), size: 18),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text('+91 98765 43210', style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFFECFDF5),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            'Aadhaar Verified Customer',
                            style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF065F46)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // KaamWala Safety Shield Card (PRD spec)
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

            // Account & Preferences
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
                ],
              ),
            ),

            const SizedBox(height: 24),

            // App details
            Text('KaamWala Customer App v1.0.0 (Pure Flutter)', style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
            const SizedBox(height: 4),
            Text('Built for high-trust doorstep repairs in India', style: TextStyle(color: Colors.grey.shade400, fontSize: 11)),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
