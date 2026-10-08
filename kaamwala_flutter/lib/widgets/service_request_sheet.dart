import 'package:flutter/material.dart';
import '../models/app_models.dart';
import '../services/app_state.dart';

class ServiceRequestSheet extends StatefulWidget {
  final ServiceCategory category;
  final AppState appState;

  const ServiceRequestSheet({
    super.key,
    required this.category,
    required this.appState,
  });

  @override
  State<ServiceRequestSheet> createState() => _ServiceRequestSheetState();
}

class _ServiceRequestSheetState extends State<ServiceRequestSheet> {
  int _currentStep = 0;
  SubService? _selectedSubService;
  final TextEditingController _descController = TextEditingController();
  String _selectedDate = 'Tomorrow';
  String _selectedSlot = '10:00 AM - 12:00 PM';
  bool _isUrgent = false;

  final List<String> _dateOptions = ['Today', 'Tomorrow', 'Day After Tomorrow'];
  final List<String> _slotOptions = [
    '09:00 AM - 11:00 AM',
    '11:00 AM - 01:00 PM',
    '02:00 PM - 04:00 PM',
    '05:00 PM - 07:00 PM',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.category.subServices.isNotEmpty) {
      _selectedSubService = widget.category.subServices.first;
    }
  }

  @override
  void dispose() {
    _descController.dispose();
    super.dispose();
  }

  void _submitBooking() {
    final serviceTitle = _selectedSubService?.title ?? widget.category.name;
    final price = _selectedSubService?.price ?? widget.category.startingPrice;
    final description = _descController.text.trim().isEmpty
        ? 'Standard service request for $serviceTitle'
        : _descController.text.trim();

    widget.appState.createNewJob(
      category: widget.category.id,
      serviceName: serviceTitle,
      description: description,
      date: _selectedDate,
      time: _isUrgent ? 'Urgent (Within 45 mins)' : _selectedSlot,
      price: price,
    );

    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Request broadcasted to verified technicians near ${widget.appState.currentLocality.name}!',
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF059669),
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.90,
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
              width: 48,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              children: [
                Text(
                  widget.category.icon,
                  style: const TextStyle(fontSize: 28),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.category.name,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Step ${_currentStep + 1} of 3 • Transparent Pricing',
                        style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // Stepper indicator
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            color: const Color(0xFFF8FAFC),
            child: Row(
              children: [
                _buildStepPill(0, 'Service'),
                Expanded(child: Container(height: 2, color: _currentStep >= 1 ? const Color(0xFF059669) : Colors.grey.shade300)),
                _buildStepPill(1, 'Details'),
                Expanded(child: Container(height: 2, color: _currentStep >= 2 ? const Color(0xFF059669) : Colors.grey.shade300)),
                _buildStepPill(2, 'Schedule'),
              ],
            ),
          ),

          // Step Body
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: _buildStepContent(),
            ),
          ),

          // Footer actions
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -4)),
              ],
            ),
            child: Row(
              children: [
                if (_currentStep > 0)
                  OutlinedButton(
                    onPressed: () => setState(() => _currentStep--),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Back'),
                  ),
                if (_currentStep > 0) const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_currentStep < 2) {
                        setState(() => _currentStep++);
                      } else {
                        _submitBooking();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF059669),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                    child: Text(
                      _currentStep == 2 ? 'Broadcast Request to Technicians' : 'Continue',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepPill(int stepIndex, String title) {
    final isActive = _currentStep == stepIndex;
    final isDone = _currentStep > stepIndex;

    return Row(
      children: [
        CircleAvatar(
          radius: 12,
          backgroundColor: isDone
              ? const Color(0xFF059669)
              : (isActive ? const Color(0xFF059669) : Colors.grey.shade300),
          child: isDone
              ? const Icon(Icons.check, size: 14, color: Colors.white)
              : Text(
                  '${stepIndex + 1}',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: isActive ? Colors.white : Colors.grey.shade700,
                  ),
                ),
        ),
        const SizedBox(width: 6),
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
            color: isActive ? const Color(0xFF059669) : Colors.grey.shade700,
          ),
        ),
      ],
    );
  }

  Widget _buildStepContent() {
    switch (_currentStep) {
      case 0:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select Service Package',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              'Technician will bring diagnostic gear and genuine company spares.',
              style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 16),
            ...widget.category.subServices.map((sub) {
              final isSelected = _selectedSubService?.id == sub.id;
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFFECFDF5) : Colors.white,
                  border: Border.all(
                    color: isSelected ? const Color(0xFF059669) : Colors.grey.shade200,
                    width: isSelected ? 2 : 1,
                  ),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: ListTile(
                  onTap: () => setState(() => _selectedSubService = sub),
                  title: Text(
                    sub.title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isSelected ? const Color(0xFF065F46) : const Color(0xFF1E293B),
                    ),
                  ),
                  subtitle: Text('Est. duration: ${sub.duration} • 30-Day Warranty'),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '₹${sub.price}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF059669),
                        ),
                      ),
                      Text('Starts from', style: TextStyle(fontSize: 10, color: Colors.grey.shade500)),
                    ],
                  ),
                ),
              );
            }),
          ],
        );

      case 1:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Describe the Issue',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              'Help technicians bring the right tools & parts.',
              style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _descController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'e.g. AC making loud rattling sound and cooling is weak...',
                hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                filled: true,
                fillColor: const Color(0xFFF8FAFC),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Urgency Toggle
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: _isUrgent ? const Color(0xFFFFFBEB) : const Color(0xFFF8FAFC),
                border: Border.all(
                  color: _isUrgent ? const Color(0xFFF59E0B) : Colors.grey.shade200,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: _isUrgent ? const Color(0xFFF59E0B) : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.bolt, color: Colors.white, size: 20),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Urgent 45-Min Dispatch', style: TextStyle(fontWeight: FontWeight.bold)),
                        Text('Get nearest technician assigned immediately', style: TextStyle(fontSize: 12)),
                      ],
                    ),
                  ),
                  Switch(
                    value: _isUrgent,
                    activeColor: const Color(0xFFF59E0B),
                    onChanged: (val) => setState(() => _isUrgent = val),
                  ),
                ],
              ),
            ),
          ],
        );

      case 2:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select Preferred Date & Time',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Text('Service Date', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: _dateOptions.map((date) {
                final isSelected = _selectedDate == date;
                return ChoiceChip(
                  label: Text(date),
                  selected: isSelected,
                  selectedColor: const Color(0xFF059669),
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : Colors.black87,
                    fontWeight: FontWeight.bold,
                  ),
                  onSelected: (val) => setState(() => _selectedDate = date),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            const Text('Time Slot', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _slotOptions.map((slot) {
                final isSelected = _selectedSlot == slot;
                return ChoiceChip(
                  label: Text(slot),
                  selected: isSelected,
                  selectedColor: const Color(0xFF059669),
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : Colors.black87,
                    fontSize: 12,
                  ),
                  onSelected: (val) => setState(() => _selectedSlot = slot),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            // Location summary
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF0FDF4),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFA7F3D0)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.location_on, color: Color(0xFF059669)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Service Address', style: TextStyle(fontSize: 11, color: Color(0xFF065F46))),
                        Text(
                          widget.appState.currentLocality.fullAddress,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        );

      default:
        return const SizedBox();
    }
  }
}
