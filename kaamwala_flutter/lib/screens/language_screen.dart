import 'package:flutter/material.dart';
import '../services/app_state.dart';

class LanguageScreen extends StatelessWidget {
  final AppState appState;
  const LanguageScreen({super.key, required this.appState});

  @override
  Widget build(BuildContext context) {
    final currentLang = appState.language;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFF0F766E),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.home_repair_service,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(height: 28),
              const Text(
                'Choose your\nlanguage',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF18181B),
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Select a language to continue',
                style: TextStyle(
                  fontSize: 15,
                  color: Color(0xFF71717A),
                ),
              ),
              const SizedBox(height: 36),

              // English Choice Card
              _buildLangCard(
                code: 'en',
                label: 'English',
                sub: 'Continue in English',
                flag: '🇬🇧',
                isSelected: currentLang == 'en',
                onTap: () => appState.setLanguage('en'),
              ),
              const SizedBox(height: 16),

              // Hindi Choice Card
              _buildLangCard(
                code: 'hi',
                label: 'हिन्दी',
                sub: 'हिन्दी में जारी रखें',
                flag: '🇮🇳',
                isSelected: currentLang == 'hi',
                onTap: () => appState.setLanguage('hi'),
              ),

              const Spacer(),

              // Continue Button (Matching HTML zinc-900 56px height)
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () => appState.navigateTo('address'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF18181B),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Continue',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward, size: 20),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 14),
              const Center(
                child: Text(
                  'By continuing, you agree to Terms & Privacy. Your data is encrypted and verified.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 11,
                    color: Color(0xFFA1A1AA),
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLangCard({
    required String code,
    required String label,
    required String sub,
    required String flag,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFF0FDFA) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? const Color(0xFF0F766E) : const Color(0xFFE4E4E7),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFF0F766E).withOpacity(0.08),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            Text(flag, style: const TextStyle(fontSize: 28)),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF18181B),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    sub,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF71717A),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF0F766E) : Colors.transparent,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? const Color(0xFF0F766E) : const Color(0xFFD4D4D8),
                  width: 2,
                ),
              ),
              child: isSelected
                  ? const Icon(Icons.check, size: 16, color: Colors.white)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
