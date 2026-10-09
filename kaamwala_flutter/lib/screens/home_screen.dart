import 'dart:async';
import 'package:flutter/material.dart';
import '../models/app_models.dart';
import '../services/app_state.dart';
import '../services/mock_data.dart';
import 'address_screen.dart';
import 'create_request_screen.dart';
import 'job_detail_screen.dart';
import 'search_screen.dart';

class HomeScreen extends StatefulWidget {
  final AppState appState;
  final Function(int) onNavigateTab;

  const HomeScreen({
    super.key,
    required this.appState,
    required this.onNavigateTab,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Banner Carousel
  late PageController _bannerController;
  int _currentBannerIndex = 0;
  Timer? _bannerTimer;

  // Morphing Search Text
  final List<String> _searchPlaceholders = [
    "Search for 'Plumber'...",
    "Search for 'Electrician'...",
    "Search for 'AC Deep Jet Clean'...",
    "Search for 'RO Water Purifier'...",
    "Search for 'Refrigerator Repair'...",
    "Search for 'Washing Machine'...",
    "Search for 'Bathroom Deep Clean'...",
    "Search for 'Kitchen Chimney'...",
    "Search for 'Carpenter & Lock Fix'...",
  ];
  int _searchPlaceholderIndex = 0;
  Timer? _searchPlaceholderTimer;

  final List<Map<String, dynamic>> _promoBanners = [
    {
      'title': 'AC Summer & Monsoon Care',
      'subtitle': 'Power Jet Wash + Gas Leak Check at flat 30% OFF',
      'tag': 'LIMITED TIME • 30% OFF',
      'code': 'SUMMER30',
      'gradient': [const Color(0xFF0F766E), const Color(0xFF134E4A)],
      'icon': Icons.ac_unit,
    },
    {
      'title': '15-Min Express Plumber',
      'subtitle': 'Verified master plumbers arriving at your doorstep in 15 mins',
      'tag': 'FIRST-PICKUP DISPATCH',
      'code': 'FAST15',
      'gradient': [const Color(0xFF1E3A8A), const Color(0xFF1E40AF)],
      'icon': Icons.plumbing,
    },
    {
      'title': 'Flat ₹100 Wallet Cashback',
      'subtitle': 'Instant discount on your first service booking',
      'tag': 'WELCOME REWARD',
      'code': 'FIRST100',
      'gradient': [const Color(0xFF047857), const Color(0xFF065F46)],
      'icon': Icons.account_balance_wallet,
    },
    {
      'title': '100% Police Verified Pros',
      'subtitle': 'Every visit backed by 30-day guarantee & masked calling',
      'tag': 'TRUST & SAFETY',
      'code': 'SAFEHOME',
      'gradient': [const Color(0xFF7C2D12), const Color(0xFF9A3412)],
      'icon': Icons.verified_user,
    },
  ];

  @override
  void initState() {
    super.initState();
    _bannerController = PageController(initialPage: 0);

    // Auto-advance banner every 3.8 seconds
    _bannerTimer = Timer.periodic(const Duration(milliseconds: 3800), (timer) {
      if (_bannerController.hasClients) {
        final nextPage = (_currentBannerIndex + 1) % _promoBanners.length;
        _bannerController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
        );
      }
    });

    // Auto-advance search placeholder every 2.2 seconds
    _searchPlaceholderTimer = Timer.periodic(const Duration(milliseconds: 2200), (timer) {
      if (mounted) {
        setState(() {
          _searchPlaceholderIndex = (_searchPlaceholderIndex + 1) % _searchPlaceholders.length;
        });
      }
    });
  }

  @override
  void dispose() {
    _bannerTimer?.cancel();
    _searchPlaceholderTimer?.cancel();
    _bannerController.dispose();
    super.dispose();
  }

  void _openCategoryBooking(BuildContext context, ServiceCategory category) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateRequestScreen(
          appState: widget.appState,
          initialCategory: category,
        ),
      ),
    );
  }

  void _openSearchScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchScreen(appState: widget.appState),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isHi = widget.appState.language == 'hi';
    final user = widget.appState.currentUser;
    final activeJob = widget.appState.activeJob;
    final hasActiveJob = activeJob.status != 'CLOSED' && activeJob.status != 'CANCELLED';

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. TOP HEADER: ONLY Location on Left, ONLY User Avatar on Right
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Location Pill on the Left
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddressScreen(appState: widget.appState),
                            ),
                          );
                        },
                        borderRadius: BorderRadius.circular(10),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(7),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF0FDFA),
                                shape: BoxShape.circle,
                                border: Border.all(color: const Color(0xFFCCFBF1)),
                              ),
                              child: const Icon(Icons.location_on, color: Color(0xFF0F766E), size: 18),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        isHi ? 'वर्तमान स्थान' : 'CURRENT LOCATION',
                                        style: const TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 0.8,
                                          color: Color(0xFFA1A1AA),
                                        ),
                                      ),
                                      const Icon(Icons.arrow_drop_down, size: 16, color: Color(0xFFA1A1AA)),
                                    ],
                                  ),
                                  Text(
                                    '${widget.appState.currentLocality.name}, ${widget.appState.currentLocality.city}',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF18181B),
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    // User Avatar on the Right (Tapping navigates to Profile Tab)
                    InkWell(
                      onTap: () => widget.onNavigateTab(4),
                      borderRadius: BorderRadius.circular(22),
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: const Color(0xFF0F766E), width: 2),
                        ),
                        child: CircleAvatar(
                          radius: 18,
                          backgroundColor: const Color(0xFF18181B),
                          child: Text(
                            user.avatar.isNotEmpty ? user.avatar : 'A',
                            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 14),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // 2. ANIMATED PROMOTIONAL BANNER SECTION
              SizedBox(
                height: 160,
                child: PageView.builder(
                  controller: _bannerController,
                  onPageChanged: (idx) => setState(() => _currentBannerIndex = idx),
                  itemCount: _promoBanners.length,
                  itemBuilder: (context, index) {
                    final item = _promoBanners[index];
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: item['gradient'],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(22),
                        boxShadow: [
                          BoxShadow(
                            color: (item['gradient'][0] as Color).withOpacity(0.28),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.22),
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: Text(
                                    item['tag'],
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 9,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  item['title'],
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: -0.2,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  item['subtitle'],
                                  style: const TextStyle(
                                    color: Color(0xFFE2E8F0),
                                    fontSize: 11,
                                    height: 1.25,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
                          Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.18),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(item['icon'], color: Colors.white, size: 32),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 8),

              // Banner Indicator Dots
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_promoBanners.length, (idx) {
                  final isActive = idx == _currentBannerIndex;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    width: isActive ? 18 : 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: isActive ? const Color(0xFF0F766E) : const Color(0xFFD4D4D8),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  );
                }),
              ),

              const SizedBox(height: 14),

              // 3. ANIMATED MORPHING SEARCH BAR (Directly under banner)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: InkWell(
                  onTap: () => _openSearchScreen(context),
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    height: 52,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFE4E4E7)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.search, color: Color(0xFF0F766E), size: 22),
                        const SizedBox(width: 12),
                        Expanded(
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 350),
                            transitionBuilder: (Widget child, Animation<double> animation) {
                              return FadeTransition(
                                opacity: animation,
                                child: SlideTransition(
                                  position: Tween<Offset>(
                                    begin: const Offset(0, 0.3),
                                    end: Offset.zero,
                                  ).animate(animation),
                                  child: child,
                                ),
                              );
                            },
                            child: Text(
                              _searchPlaceholders[_searchPlaceholderIndex],
                              key: ValueKey<int>(_searchPlaceholderIndex),
                              style: const TextStyle(
                                color: Color(0xFF71717A),
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF0FDFA),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.mic, color: Color(0xFF0F766E), size: 18),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // 4. Ongoing Active Job Card (If job in progress)
              if (hasActiveJob) ...[
                Container(
                  margin: const EdgeInsets.fromLTRB(20, 16, 20, 0),
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
                        blurRadius: 16,
                        offset: const Offset(0, 4),
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
                                style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF92400E)),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 20,
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
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                  ),
                                  Text(
                                    '0.8 km away • ${activeJob.serviceName}',
                                    style: const TextStyle(fontSize: 11, color: Color(0xFF71717A)),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
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
                                        appState: widget.appState,
                                      ),
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.near_me, size: 15),
                                label: const Text('Track Live', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF18181B),
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                  elevation: 0,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              onPressed: () => widget.onNavigateTab(2),
                              icon: const Icon(Icons.chat_bubble_outline, color: Color(0xFF18181B), size: 20),
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

              // 5. 12 SERVICE CATEGORIES WITH REAL IMAGES
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      isHi ? 'सेवा श्रेणियां (12 श्रेणियां)' : 'Home Services (12 Categories)',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF18181B)),
                    ),
                    InkWell(
                      onTap: () => _openSearchScreen(context),
                      child: Text(
                        isHi ? 'सभी देखें' : 'View all',
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF0F766E)),
                      ),
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
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.82,
                  ),
                  itemCount: MockRepository.categories.length,
                  itemBuilder: (context, index) {
                    final cat = MockRepository.categories[index];
                    return InkWell(
                      onTap: () => _openCategoryBooking(context, cat),
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFF4F4F5)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.02),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Photographic Image
                            ClipRRect(
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                              child: Image.network(
                                cat.imageUrl,
                                height: 72,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    height: 72,
                                    color: const Color(0xFFF0FDFA),
                                    child: Center(
                                      child: Text(cat.icon, style: const TextStyle(fontSize: 28)),
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 6),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 6),
                              child: Text(
                                isHi ? cat.nameHi : cat.name,
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF18181B),
                                ),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'From ₹${cat.startingPrice}',
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0F766E),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              // 6. POPULAR NEAR YOU WITH REAL IMAGES
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      isHi ? 'आपके पास लोकप्रिय' : 'Popular Near You',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF18181B)),
                    ),
                    const Row(
                      children: [
                        Icon(Icons.timer_outlined, size: 14, color: Color(0xFF71717A)),
                        SizedBox(width: 4),
                        Text('15-30 min arrival', style: TextStyle(fontSize: 11, color: Color(0xFF71717A))),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              SizedBox(
                height: 155,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    _buildPopularImageCard(
                      'AC Foam Jet Cleaning',
                      '₹499',
                      '4.9 (2.4k)',
                      'https://images.unsplash.com/photo-1621905251189-08b45d6a269e?auto=format&fit=crop&w=300&q=80',
                      MockRepository.categories[0],
                    ),
                    _buildPopularImageCard(
                      'Tap & Mixer Leakage',
                      '₹149',
                      '4.8 (1.8k)',
                      'https://images.unsplash.com/photo-1585704032915-c3400ca199e7?auto=format&fit=crop&w=300&q=80',
                      MockRepository.categories[1],
                    ),
                    _buildPopularImageCard(
                      'MCB & Switchboard',
                      '₹199',
                      '4.8 (3.1k)',
                      'https://images.unsplash.com/photo-1621905252507-b35492cc74b4?auto=format&fit=crop&w=300&q=80',
                      MockRepository.categories[2],
                    ),
                    _buildPopularImageCard(
                      'RO Filter Kit Change',
                      '₹799',
                      '4.9 (980)',
                      'https://images.unsplash.com/photo-1548839140-29a749e1bc4e?auto=format&fit=crop&w=300&q=80',
                      MockRepository.categories[3],
                    ),
                  ],
                ),
              ),

              // 7. 24/7 EMERGENCY SOS CARD
              Container(
                margin: const EdgeInsets.fromLTRB(20, 20, 20, 24),
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
                          Text('24/7 Emergency Service', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFFB91C1C))),
                          Text('15 min priority dispatch • Pipe burst, Short circuit, Lockout', style: TextStyle(fontSize: 11, color: Color(0xFFDC2626))),
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

  Widget _buildPopularImageCard(
    String title,
    String price,
    String rating,
    String imageUrl,
    ServiceCategory category,
  ) {
    return InkWell(
      onTap: () => _openCategoryBooking(context, category),
      borderRadius: BorderRadius.circular(18),
      child: Container(
        width: 150,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFF4F4F5)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
              child: Image.network(
                imageUrl,
                height: 78,
                width: 150,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  height: 78,
                  width: 150,
                  color: const Color(0xFFF0FDFA),
                  child: const Center(child: Icon(Icons.handyman, color: Color(0xFF0F766E))),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        price,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF0F766E)),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.star, size: 11, color: Colors.amber),
                          const SizedBox(width: 2),
                          Text(rating, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
