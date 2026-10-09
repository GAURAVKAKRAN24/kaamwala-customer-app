import 'package:flutter/material.dart';
import '../services/app_state.dart';

class ReviewSheet extends StatefulWidget {
  final AppState appState;

  const ReviewSheet({
    super.key,
    required this.appState,
  });

  @override
  State<ReviewSheet> createState() => _ReviewSheetState();
}

class _ReviewSheetState extends State<ReviewSheet> {
  double _overallRating = 5.0;
  double _quality = 5.0;
  double _behaviour = 5.0;
  double _punctuality = 5.0;
  double _fairness = 5.0;
  final TextEditingController _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _submit() {
    widget.appState.submitReview();
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Row(
          children: [
            Icon(Icons.verified, color: Colors.white),
            SizedBox(width: 8),
            Expanded(child: Text('Thank you! Your verified rating helps our community.')),
          ],
        ),
        backgroundColor: Color(0xFF0F766E),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final worker = widget.appState.activeJob.assignedWorker;
    final workerName = worker?.name ?? 'Ramesh Kumar';

    return Container(
      height: MediaQuery.of(context).size.height * 0.86,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Drag handle
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              width: 44,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFE4E4E7),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              children: [
                const Icon(Icons.star, color: Colors.amber, size: 24),
                const SizedBox(width: 10),
                const Text(
                  'Rate & Review Service',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF18181B)),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close, color: Color(0xFF71717A)),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 34,
                    backgroundColor: const Color(0xFF18181B),
                    child: Text(
                      worker?.avatar ?? 'RK',
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'How was your experience with $workerName?',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF18181B)),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'KaamWala Verified Review Protocol',
                    style: TextStyle(fontSize: 12, color: Color(0xFF71717A)),
                  ),
                  const SizedBox(height: 16),

                  // Big star selector
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      final starVal = index + 1;
                      return IconButton(
                        iconSize: 36,
                        icon: Icon(
                          _overallRating >= starVal ? Icons.star : Icons.star_border,
                          color: Colors.amber,
                        ),
                        onPressed: () => setState(() => _overallRating = starVal.toDouble()),
                      );
                    }),
                  ),

                  const SizedBox(height: 20),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Detailed Sub-Ratings',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF18181B)),
                    ),
                  ),
                  const SizedBox(height: 12),

                  _buildSubRatingRow('Work Quality', _quality, (val) => setState(() => _quality = val)),
                  _buildSubRatingRow('Worker Behaviour', _behaviour, (val) => setState(() => _behaviour = val)),
                  _buildSubRatingRow('Punctuality', _punctuality, (val) => setState(() => _punctuality = val)),
                  _buildSubRatingRow('Price Fairness', _fairness, (val) => setState(() => _fairness = val)),

                  const SizedBox(height: 16),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Write Feedback (Optional)',
                      style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF3F3F46), fontSize: 13),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _commentController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: 'Polite technician, cleaned up after repair, highly recommended...',
                      hintStyle: const TextStyle(fontSize: 13, color: Color(0xFFA1A1AA)),
                      filled: true,
                      fillColor: const Color(0xFFF8FAFC),
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
                ],
              ),
            ),
          ),

          // Submit button
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Colors.grey.shade200)),
            ),
            child: SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0F766E),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  elevation: 0,
                ),
                child: const Text(
                  'Submit Verified Review',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubRatingRow(String label, double rating, Function(double) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 13, color: Color(0xFF3F3F46))),
          Row(
            children: List.generate(5, (index) {
              final star = index + 1;
              return InkWell(
                onTap: () => onChanged(star.toDouble()),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: Icon(
                    rating >= star ? Icons.star : Icons.star_border,
                    size: 20,
                    color: Colors.amber,
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
