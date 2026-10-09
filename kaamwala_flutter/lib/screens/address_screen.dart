import 'package:flutter/material.dart';
import '../models/app_models.dart';
import '../services/app_state.dart';
import '../services/mock_data.dart';

class AddressScreen extends StatefulWidget {
  final AppState appState;
  const AddressScreen({super.key, required this.appState});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Locality> _filtered = [];
  bool _isDetectingGps = false;

  @override
  void initState() {
    super.initState();
    _filtered = List.from(MockRepository.localities);
    _searchController.addListener(_onSearch);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearch() {
    final query = _searchController.text.trim().toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filtered = List.from(MockRepository.localities);
      } else {
        _filtered = MockRepository.localities.where((l) {
          return l.name.toLowerCase().contains(query) ||
              l.area.toLowerCase().contains(query) ||
              l.city.toLowerCase().contains(query) ||
              l.pincode.contains(query);
        }).toList();
      }
    });
  }

  void _handleGpsDetect() {
    setState(() => _isDetectingGps = true);
    Future.delayed(const Duration(milliseconds: 900), () {
      if (mounted) {
        setState(() => _isDetectingGps = false);
        final detected = MockRepository.localities.first;
        widget.appState.setLocality(detected);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text('GPS Auto-detected: ${detected.name}, ${detected.city} • ${detected.pincode}'),
                ),
              ],
            ),
            backgroundColor: const Color(0xFF0F766E),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final activeLoc = widget.appState.currentLocality;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF18181B)),
          onPressed: () => widget.appState.navigateTo('lang'),
        ),
        actions: [
          TextButton(
            onPressed: () => widget.appState.navigateTo('otp'),
            child: const Text('Skip', style: TextStyle(color: Color(0xFF0F766E), fontWeight: FontWeight.bold)),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Where should we come?',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF18181B),
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Pinpoint your doorstep for instant technician dispatch',
                style: TextStyle(fontSize: 14, color: Color(0xFF71717A)),
              ),
              const SizedBox(height: 20),

              // GPS Auto-detect Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: _isDetectingGps ? null : _handleGpsDetect,
                  icon: _isDetectingGps
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        )
                      : const Icon(Icons.near_me, size: 18),
                  label: Text(
                    _isDetectingGps ? 'Detecting via GPS satellite...' : 'Use current GPS location',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF18181B),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    elevation: 0,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Search Bar
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search city, area or pincode (e.g. Noida, Indirapuram)...',
                  hintStyle: const TextStyle(color: Color(0xFFA1A1AA), fontSize: 13),
                  prefixIcon: const Icon(Icons.search, color: Color(0xFF0F766E)),
                  filled: true,
                  fillColor: const Color(0xFFF8FAFC),
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: Color(0xFFE4E4E7)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: Color(0xFF0F766E), width: 1.5),
                  ),
                ),
              ),

              const SizedBox(height: 18),
              const Text(
                'SAVED SERVICE HUBS & LOCALITIES',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                  color: Color(0xFFA1A1AA),
                ),
              ),
              const SizedBox(height: 10),

              // Localities suggestion list
              Expanded(
                child: ListView.separated(
                  itemCount: _filtered.length,
                  separatorBuilder: (context, index) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final item = _filtered[index];
                    final isSelected = item.id == activeLoc.id;

                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      tileColor: isSelected ? const Color(0xFFF0FDFA) : null,
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: isSelected ? const Color(0xFF0F766E) : const Color(0xFFF4F4F5),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.location_on,
                          color: isSelected ? Colors.white : const Color(0xFF71717A),
                          size: 20,
                        ),
                      ),
                      title: Row(
                        children: [
                          Text(
                            item.name,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: isSelected ? const Color(0xFF0F766E) : const Color(0xFF18181B),
                            ),
                          ),
                          if (item.isPopular) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFEF3C7),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                'POPULAR',
                                style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Color(0xFF92400E)),
                              ),
                            ),
                          ],
                        ],
                      ),
                      subtitle: Text(
                        '${item.area}, ${item.city} • ${item.pincode}',
                        style: const TextStyle(fontSize: 12, color: Color(0xFF71717A)),
                      ),
                      trailing: isSelected
                          ? const Icon(Icons.check_circle, color: Color(0xFF0F766E))
                          : const Icon(Icons.chevron_right, size: 18, color: Colors.grey),
                      onTap: () {
                        widget.appState.setLocality(item);
                      },
                    );
                  },
                ),
              ),

              // Bottom Continue Button
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () => widget.appState.navigateTo('otp'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0F766E),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 0,
                    ),
                    child: const Text('Confirm Location & Continue', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
