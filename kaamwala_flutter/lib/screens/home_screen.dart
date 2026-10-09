import 'package:flutter/material.dart';
import '../models/app_models.dart';
import '../services/app_state.dart';
import '../services/mock_data.dart';
import '../widgets/location_picker_sheet.dart';
import '../widgets/service_request_sheet.dart';
import 'job_detail_screen.dart';
import 'login_screen.dart';

class HomeScreen extends StatelessWidget {
  final AppState appState;

  const HomeScreen({
    super.key,
    required this.appState,
  });

  void _openLocationPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => LocationPickerSheet(
        currentLocality: appState.currentLocality,
        onSelect: (locality) => appState.setLocality(locality),
      ),
    );
  }

  void _openServiceRequest(BuildContext context, ServiceCategory category) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ServiceRequestSheet(
        category: category,
        appState: appState,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isHindi = appState.language == 'hi';

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Header
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                color: Colors.white,
                child: Column(
                  children: [
                    Row(
                      children: [
                        // Location Picker Trigger
                        Expanded(
                          child: InkWell(
                            onTap: () => _openLocationPicker(context),
                            borderRadius: BorderRadius.circular(10),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFECFDF5),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(Icons.location_on, color: Color(0xFF059669), size: 20),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            appState.currentLocality.name,
                                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const Icon(Icons.keyboard_arrow_down, size: 18),
                                        ],
                                      ),
                                      Text(
                                        '${appState.currentLocality.area}, ${appState.currentLocality.city}',
                                        style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Bilingual toggle
                        InkWell(
                          onTap: () => appState.toggleLanguage(),
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF1F5F9),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.translate, size: 14, color: Color(0xFF059669)),
                                const SizedBox(width: 4),
                                Text(
                                  isHindi ? 'हिन्दी' : 'EN',
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),

                        // User Auth Avatar or Login Button
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LoginScreen(
                                  appState: appState,
                                  onLoginSuccess: () => Navigator.pop(context),
                                ),
                              ),
                            );
                          },
                          borderRadius: BorderRadius.circular(20),
                          child: appState.currentUser != null
                              ? CircleAvatar(
                                  radius: 16,
                                  backgroundColor: const Color(0xFF059669),
                                  child: Text(
                                    appState.currentUser!.avatar,
                                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white),
                                  ),
                                )
                              : Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFECFDF5),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(color: const Color(0xFFA7F3D0)),
                                  ),
                                  child: const Row(
                                    children: [
                                      Icon(Icons.person, size: 14, color: Color(0xFF059669)),
                                      SizedBox(width: 4),
                                      Text(
                                        'Login',
                                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF065F46)),
                                      ),
                                    ],
                                  ),
                                ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),
                    // Search bar
                    TextField(
                      readOnly: true,
                      onTap: () => _openLocationPicker(context),
                      decoration: InputDecoration(
                        hintText: isHindi
                          ? 'सर्च करें "एसी सर्विस", "इलेक्ट्रीशियन", "नल रिपेयर"...'
                          : 'Search "AC repair", "Electrician", "RO filter"...',
                        hintStyle: TextStyle(fontSize: 13, color: Colors.grey.shade400),
                        prefixIcon: const Icon(Icons.search, color: Color(0xFF059669), size: 20),
                        filled: true,
                        fillColor: const Color(0xFFF1F5F9),
                        contentPadding: const EdgeInsets.symmetric(vertical: 10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Active booking banner (if any)
              if (appState.activeJob.status != 'CLOSED') ...[
                Container(
                  margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF059669), Color(0xFF047857)],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(color: const Color(0xFF059669).withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 4)),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.schedule, color: Colors.white, size: 22),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Active Job: ${appState.activeJob.id}',
                              style: const TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              appState.activeJob.serviceName,
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              'Status: ${appState.activeJob.status.replaceAll('_', ' ')}',
                              style: const TextStyle(color: Color(0xFFA7F3D0), fontSize: 11, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => JobDetailScreen(
                                job: appState.activeJob,
                                appState: appState,
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFF065F46),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          elevation: 0,
                        ),
                        child: const Text('Track', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                      ),
                    ],
                  ),
                ),
              ],

              // Banner Hero Carousel
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF064E3B), Color(0xFF065F46)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF59E0B),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              'FLAT ₹100 OFF',
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10),
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Trusted Doorstep Home Repairs',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              height: 1.2,
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'Verified technicians • 30-Day Guarantee • Masked Calls',
                            style: TextStyle(color: Color(0xFFA7F3D0), fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        shape: BoxShape.circle,
                      ),
                      child: const Text('⚡', style: TextStyle(fontSize: 32)),
                    ),
                  ],
                ),
              ),

              // Categories Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      isHindi ? 'सेवाएं चुनें (9 श्रेणियां)' : 'Select Service (9 Categories)',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                    ),
                    Text(
                      'Doorstep in 15m',
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade600, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Categories Grid
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 0.85,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: MockRepository.categories.length,
                  itemBuilder: (context, index) {
                    final cat = MockRepository.categories[index];
                    return InkWell(
                      onTap: () => _openServiceRequest(context, cat),
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.grey.shade200),
                          boxShadow: [
                            BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 4, offset: const Offset(0, 2)),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(cat.icon, style: const TextStyle(fontSize: 28)),
                            const SizedBox(height: 6),
                            Text(
                              isHindi ? cat.nameHi : cat.name,
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1E293B),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '₹${cat.startingPrice}+',
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF059669),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 24),

              // Trust & Safety Badges
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'The KaamWala Promise',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        _buildTrustBadge(Icons.verified, '100% Verified', 'Aadhaar & Police check'),
                        const SizedBox(width: 10),
                        _buildTrustBadge(Icons.currency_rupee, 'Fixed Rates', 'No hidden charges'),
                        const SizedBox(width: 10),
                        _buildTrustBadge(Icons.security, '30-Day Cover', 'Free revisit rework'),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTrustBadge(IconData icon, String title, String subtitle) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          children: [
            Icon(icon, color: const Color(0xFF059669), size: 22),
            const SizedBox(height: 6),
            Text(title, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
            const SizedBox(height: 2),
            Text(subtitle, textAlign: TextAlign.center, style: TextStyle(fontSize: 9, color: Colors.grey.shade500)),
          ],
        ),
      ),
    );
  }
}
