import 'package:flutter/material.dart';
import '../models/app_models.dart';
import '../services/app_state.dart';
import '../services/mock_data.dart';
import 'create_request_screen.dart';

class SearchResultItem {
  final ServiceCategory category;
  final SubService? subService;
  final String title;
  final String subtitle;
  final int price;

  SearchResultItem({
    required this.category,
    this.subService,
    required this.title,
    required this.subtitle,
    required this.price,
  });
}

class SearchScreen extends StatefulWidget {
  final AppState appState;
  final String initialQuery;

  const SearchScreen({
    super.key,
    required this.appState,
    this.initialQuery = '',
  });

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late TextEditingController _searchController;
  List<SearchResultItem> _searchResults = [];
  final List<String> _popularTags = [
    'AC Deep Jet Clean',
    'Tap Leakage Fix',
    'Switchboard Fix',
    'RO Filter Change',
    'Fridge Cooling',
    'Washing Machine',
    'Bathroom Scrub',
    'Door Lock Fit',
    'Geyser Element',
    'Pest Control',
  ];

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.initialQuery);
    if (widget.initialQuery.isNotEmpty) {
      _performSearch(widget.initialQuery);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _performSearch(String query) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) {
      setState(() => _searchResults = []);
      return;
    }

    final List<SearchResultItem> results = [];

    for (final cat in MockRepository.categories) {
      // Check category name and description
      if (cat.name.toLowerCase().contains(q) ||
          cat.nameHi.toLowerCase().contains(q) ||
          cat.desc.toLowerCase().contains(q)) {
        results.add(
          SearchResultItem(
            category: cat,
            title: cat.name,
            subtitle: cat.desc,
            price: cat.startingPrice,
          ),
        );
      }

      // Check sub-services
      for (final sub in cat.subServices) {
        if (sub.title.toLowerCase().contains(q) ||
            sub.titleHi.toLowerCase().contains(q)) {
          results.add(
            SearchResultItem(
              category: cat,
              subService: sub,
              title: sub.title,
              subtitle: '${cat.name} • ${sub.duration}',
              price: sub.price,
            ),
          );
        }
      }
    }

    setState(() {
      _searchResults = results;
    });
  }

  void _onSelectResult(SearchResultItem item) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateRequestScreen(
          appState: widget.appState,
          initialCategory: item.category,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isHi = widget.appState.language == 'hi';

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF18181B)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Container(
          height: 44,
          decoration: BoxDecoration(
            color: const Color(0xFFF4F4F5),
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            controller: _searchController,
            autofocus: true,
            style: const TextStyle(fontSize: 14, color: Color(0xFF18181B)),
            decoration: InputDecoration(
              hintText: isHi ? 'प्लंबर, एसी, इलेक्ट्रीशियन खोजें...' : 'Search for Plumber, AC, Electrician...',
              hintStyle: const TextStyle(color: Color(0xFFA1A1AA), fontSize: 13),
              prefixIcon: const Icon(Icons.search, color: Color(0xFF71717A), size: 20),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear, color: Color(0xFF71717A), size: 18),
                      onPressed: () {
                        _searchController.clear();
                        _performSearch('');
                      },
                    )
                  : null,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
            ),
            onChanged: _performSearch,
          ),
        ),
      ),
      body: _searchController.text.trim().isEmpty
          ? _buildDefaultView(isHi)
          : _buildSearchResultsView(isHi),
    );
  }

  Widget _buildDefaultView(bool isHi) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.trending_up, size: 18, color: Color(0xFF0F766E)),
              const SizedBox(width: 6),
              Text(
                isHi ? 'लोकप्रिय खोजें' : 'Popular Searches',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF18181B),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _popularTags.map((tag) {
              return ActionChip(
                label: Text(tag),
                labelStyle: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF3F3F46),
                ),
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: const BorderSide(color: Color(0xFFE4E4E7)),
                ),
                onPressed: () {
                  _searchController.text = tag;
                  _performSearch(tag);
                },
              );
            }).toList(),
          ),

          const SizedBox(height: 24),

          Text(
            isHi ? 'सभी श्रेणियां' : 'All Categories',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFF18181B),
            ),
          ),
          const SizedBox(height: 12),

          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: MockRepository.categories.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final cat = MockRepository.categories[index];
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CreateRequestScreen(
                        appState: widget.appState,
                        initialCategory: cat,
                      ),
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFF4F4F5)),
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          cat.imageUrl,
                          width: 48,
                          height: 48,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            width: 48,
                            height: 48,
                            color: const Color(0xFFF0FDFA),
                            child: Center(child: Text(cat.icon, style: const TextStyle(fontSize: 22))),
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isHi ? cat.nameHi : cat.name,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF18181B)),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              cat.desc,
                              style: const TextStyle(fontSize: 11, color: Color(0xFF71717A)),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'From ₹${cat.startingPrice}',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF0F766E)),
                          ),
                          const SizedBox(height: 2),
                          const Icon(Icons.chevron_right, size: 16, color: Color(0xFFA1A1AA)),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResultsView(bool isHi) {
    if (_searchResults.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Color(0xFFF1F5F9),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.search_off, size: 40, color: Color(0xFFA1A1AA)),
              ),
              const SizedBox(height: 16),
              Text(
                'No service found for "${_searchController.text}"',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF18181B)),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 6),
              const Text(
                'Try searching "AC", "Plumber", "Electrician", "Tap", or "Filter"',
                style: TextStyle(color: Color(0xFF71717A), fontSize: 13),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: _searchResults.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final item = _searchResults[index];
        return InkWell(
          onTap: () => _onSelectResult(item),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE4E4E7)),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 6, offset: const Offset(0, 2)),
              ],
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    item.category.imageUrl,
                    width: 52,
                    height: 52,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: 52,
                      height: 52,
                      color: const Color(0xFFF0FDFA),
                      child: Center(child: Text(item.category.icon, style: const TextStyle(fontSize: 24))),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF18181B)),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.subtitle,
                        style: const TextStyle(fontSize: 12, color: Color(0xFF71717A)),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '₹${item.price}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Color(0xFF0F766E),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0FDFA),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        'Book',
                        style: TextStyle(
                          color: Color(0xFF0F766E),
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
