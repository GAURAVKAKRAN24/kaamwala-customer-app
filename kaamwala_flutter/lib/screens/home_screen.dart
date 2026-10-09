import 'package:flutter/material.dart';
import '../models/app_models.dart';
import '../services/app_state.dart';
import '../services/mock_data.dart';
import 'address_screen.dart';
import 'create_request_screen.dart';
import 'job_detail_screen.dart';

class HomeScreen extends StatelessWidget {
  final AppState appState;
  final Function(int) onNavigateTab;

  const HomeScreen({
    super.key,
    required this.appState,
    required this.onNavigateTab,
  });

  void _openCategoryBooking(BuildContext context, ServiceCategory category) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateRequestScreen(
          appState: appState,
          initialCategory: category,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isHi = appState.language == 'hi';
    final user = appState.currentUser;
    final activeJob = appState.activeJob;
    final hasActiveJob = activeJob.status != 'CLOSED' && activeJob.status != 'CANCELLED';

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Sticky Mobile Top Bar (Matching HTML: Avatar + Location + Lang Toggle + Shield)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                color: Colors.white,
                child: Row(
                  children: [
                    // User Avatar
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: const Color(0xFF18181B),
                      child: Text(
                        user.avatar,
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 15),
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Location Pill (Tap opens Address Screen)
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => AddressScreen(appState: appState)),
                          );
                        },
                        borderRadius: BorderRadius.circular(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  isHi ? 'घर (होम)' : 'HOME',
                                  style: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.0,
                                    color: Color(0xFFA1A1AA),
                                  ),
                                ),
                                const Icon(Icons.arrow_drop_down, size: 16, color: Color(0xFFA1A1AA)),
                              ],
                            ),
                            Row(
                              children: [
                                const Icon(Icons.location_on, color: Color(0xFF0F766E), size: 16),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    '${appState.currentLocality.name}, ${appState.currentLocality.city} • ${appState.currentLocality.pincode}',
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF18181B),
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Language Toggle
                    InkWell(
                      onTap: () => appState.setLanguage(isHi ? 'en' : 'hi'),
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF4F4F5),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: const Color(0xFFE4E4E7)),
                        ),
                        child: Text(
                          isHi ? 'हि • EN' : 'EN • हि',
                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF18181B)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),

                    // Safety Shield Badge
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0FDFA),
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFFCCFBF1)),
                      ),
                      child: const Icon(Icons.shield, color: Color(0xFF0F766E), size: 18),
                    ),
                  ],
                ),
              ),

              // 2. Incomplete Profile Banner (If profile < 100%)
              if (user.profileCompletion < 100) ...[
                Container(
                  margin: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFFBEB),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFFDE68A)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF59E0B),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.person, color: Colors.white, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isHi ? 'प्रोफाइल पूरा करें (${user.profileCompletion}%)' : 'Complete profile (${user.profileCompletion}%)',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF92400E)),
                            ),
                            Text(
                              isHi ? 'नाम और ईमेल जोड़ें और तेजी से बुकिंग पाएं' : 'Add name, email to unlock faster booking',
                              style: const TextStyle(fontSize: 11, color: Color(0xFFB45309)),
                            ),
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: () => onNavigateTab(4), // Go to profile tab
                        child: Text(
                          isHi ? 'पूरा करें' : 'Complete',
                          style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0F766E), fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              // 3. Search Bar
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: Container(
                  height: 52,
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFF4F4F5)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.search, color: Color(0xFFA1A1AA), size: 20),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          isHi ? 'आपको कौन सी सेवा चाहिए?' : 'What service do you need?',
                          style: const TextStyle(color: Color(0xFFA1A1AA), fontSize: 14),
                        ),
                      ),
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: const Color(0xFF0F766E),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.filter_list, color: Colors.white, size: 18),
                      ),
                    ],
                  ),
                ),
              ),

              // 4. Live Active Job Card (Gradient border from #0F766E to #115E59)
              if (hasActiveJob) ...[
                Container(
                  margin: const EdgeInsets.fromLTRB(20, 18, 20, 0),
                  padding: const EdgeInsets.all(1.5),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF0F766E), Color(0xFF115E59)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF0F766E).withOpacity(0.12),
                        blurRadius: 20,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(19),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF10B981),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  '${activeJob.status.replaceAll('_', ' ')} • ETA ${activeJob.arrivalEta ?? "12 min"}',
                                  style: const TextStyle(
                                    color: Color(0xFF047857),
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.8,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFEF3C7),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                activeJob.id,
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF92400E),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 22,
                              backgroundColor: const Color(0xFF18181B),
                              child: Text(
                                activeJob.assignedWorker?.avatar ?? 'RK',
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${activeJob.assignedWorker?.name ?? "Ramesh Kumar"} is arriving',
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                  ),
                                  Text(
                                    '0.8 km away • ${activeJob.serviceName} • Live',
                                    style: const TextStyle(fontSize: 12, color: Color(0xFF71717A)),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => JobDetailScreen(
                                        job: activeJob,
                                        appState: appState,
                                      ),
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.near_me, size: 16),
                                label: const Text('Track Live', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF18181B),
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                  elevation: 0,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              onPressed: () => onNavigateTab(2), // Messages
                              icon: const Icon(Icons.chat_bubble_outline, color: Color(0xFF18181B)),
                              style: IconButton.styleFrom(
                                side: const BorderSide(color: Color(0xFFE4E4E7)),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],

              // 5. 9 Service Categories Grid
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      isHi ? 'सेवा श्रेणियां (9 श्रेणियां)' : 'Service Categories',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF18181B)),
                    ),
                    Text(
                      isHi ? 'सभी देखें' : 'View all',
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF0F766E)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 0.95,
                  ),
                  itemCount: MockRepository.categories.length,
                  itemBuilder: (context, index) {
                    final cat = MockRepository.categories[index];
                    return InkWell(
                      onTap: () => _openCategoryBooking(context, cat),
                      borderRadius: BorderRadius.circular(18),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: const Color(0xFFF4F4F5)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.02),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(cat.icon, style: const TextStyle(fontSize: 26)),
                            const SizedBox(height: 6),
                            Text(
                              isHi ? cat.nameHi : cat.name,
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF18181B)),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${cat.bookingCount} bookings',
                              style: const TextStyle(fontSize: 9, color: Color(0xFFA1A1AA)),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              // 6. Popular Near You Carousel
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      isHi ? 'आपके पास लोकप्रिय' : 'Popular near you',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF18181B)),
                    ),
                    const Row(
                      children: [
                        Icon(Icons.timer_outlined, size: 14, color: Color(0xFF71717A)),
                        SizedBox(width: 4),
                        Text('30 min response', style: TextStyle(fontSize: 11, color: Color(0xFF71717A))),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              SizedBox(
                height: 140,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    _buildPopularCard('❄️', 'AC Deep Clean', '₹599', '4.9'),
                    _buildPopularCard('🚿', 'Plumber Visit', '₹149', '4.7'),
                    _buildPopularCard('⚡', 'Electric Check', '₹199', '4.8'),
                    _buildPopularCard('💧', 'RO Service', '₹399', '4.9'),
                  ],
                ),
              ),

              // 7. Maintenance Care Plan Banner (Save 30%)
              Container(
                margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF0F766E), Color(0xFF134E4A)],
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
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              'MAINTENANCE PLAN • SAVE 30%',
                              style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'AC Care Plan • Summer Ready',
                            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            '3 services + 2 gas checks at ₹1,999',
                            style: TextStyle(color: Color(0xFFCCFBF1), fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.verified, color: Colors.white, size: 40),
                  ],
                ),
              ),

              // 8. Emergency Service 24/7 Red Card
              Container(
                margin: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF2F2),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: const Color(0xFFFECACA)),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFDC2626),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFDC2626).withOpacity(0.25),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: const Icon(Icons.warning_amber_rounded, color: Colors.white, size: 22),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Emergency Service', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFFB91C1C))),
                          Text('30 min response • Electric, Plumber, Lock', style: TextStyle(fontSize: 11, color: Color(0xFFDC2626))),
                        ],
                      ),
                    ),
                    const Icon(Icons.arrow_forward_ios, size: 14, color: Color(0xFFF87171)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPopularCard(String emoji, String title, String price, String rating) {
    return Container(
      width: 140,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFF4F4F5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 52,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(child: Text(emoji, style: const TextStyle(fontSize: 26))),
          ),
          const SizedBox(height: 8),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12), maxLines: 1),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(price, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF0F766E))),
              Row(
                children: [
                  const Icon(Icons.star, size: 12, color: Colors.amber),
                  Text(rating, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
