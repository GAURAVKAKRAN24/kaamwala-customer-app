import 'dart:async';
import 'package:flutter/material.dart';
import '../models/app_models.dart';
import '../services/app_state.dart';
import '../services/mock_data.dart';
import '../widgets/masked_call_dialog.dart';
import 'job_detail_screen.dart';

class CreateRequestScreen extends StatefulWidget {
  final AppState appState;
  final ServiceCategory initialCategory;

  const CreateRequestScreen({
    super.key,
    required this.appState,
    required this.initialCategory,
  });

  @override
  State<CreateRequestScreen> createState() => _CreateRequestScreenState();
}

class _CreateRequestScreenState extends State<CreateRequestScreen>
    with SingleTickerProviderStateMixin {
  int _step = 0; // 0 to 6 (7 steps total)
  late ServiceCategory _category;
  SubService? _subService;
  final TextEditingController _descController = TextEditingController();
  final List<String> _selectedSymptoms = [];
  final List<String> _uploadedFiles = ['ac_indoor_unit.jpg'];
  bool _isUploadingMedia = false;
  double _uploadProgress = 1.0;

  String _selectedDate = 'Today';
  String _selectedSlot = '02:00 PM - 04:00 PM';
  bool _isEmergency = false;

  double _estimatedBudget = 1200; // repair estimate

  // Broadcasting State
  bool _isBroadcasting = false;
  int _broadcastSeconds = 0;
  Timer? _broadcastTimer;
  late AnimationController _radarController;

  final Map<String, List<String>> _symptomsByCategory = {
    'ac': ['Not cooling', 'Water dripping inside', 'Loud rattling sound', 'Gas refill needed', 'Jet service'],
    'plumber': ['Water tap leakage', 'Pipe burst / dripping', 'Drain blockage', 'Geyser connection', 'Low pressure'],
    'electrician': ['MCB tripping', 'Switch sparking', 'Fan regulator fix', 'Wiring burnt', 'Appliance socket'],
    'ro': ['Water taste bad', 'Filter choking', 'Motor vibrating', 'Slow flow rate', 'Membrane change'],
    'fridge': ['Freezer not freezing', 'Water leaking on floor', 'Compressor hot', 'Gas leak', 'Door gasket worn'],
    'washing': ['Drum not spinning', 'Water not draining', 'Heavy vibration', 'Power not on', 'Error code E4'],
    'carpenter': ['Door lock broken', 'Cabinet hinge loose', 'Drawer stuck', 'Bed repair', 'Curtain rod fixing'],
    'painter': ['Water seepage patch', 'Wall dampness', 'Single room repaint', 'Ceiling peeling', 'Touch up'],
    'cleaner': ['Deep bathroom clean', 'Kitchen chimney de-grease', 'Sofa shampooing', 'Balcony pressure wash'],
  };

  @override
  void initState() {
    super.initState();
    _category = widget.initialCategory;
    if (_category.subServices.isNotEmpty) {
      _subService = _category.subServices.first;
    }
    _radarController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat();
  }

  @override
  void dispose() {
    _broadcastTimer?.cancel();
    _radarController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void _addMediaSimulation() {
    setState(() {
      _isUploadingMedia = true;
      _uploadProgress = 0.2;
    });

    Timer(const Duration(milliseconds: 300), () {
      if (mounted) setState(() => _uploadProgress = 0.6);
    });

    Timer(const Duration(milliseconds: 700), () {
      if (mounted) {
        setState(() {
          _isUploadingMedia = false;
          _uploadProgress = 1.0;
          _uploadedFiles.add('damage_detail_${_uploadedFiles.length + 1}.jpg');
        });
      }
    });
  }

  void _startBroadcast() {
    setState(() {
      _isBroadcasting = true;
      _broadcastSeconds = 0;
    });

    final serviceTitle = _subService?.title ?? _category.name;
    final symptomsText = _selectedSymptoms.isNotEmpty ? ' (${_selectedSymptoms.join(', ')})' : '';
    final finalDesc = '${_descController.text.trim()}$symptomsText'.trim();

    // Call backend/state broadcast
    final newJob = widget.appState.broadcastJob(
      category: _category.id,
      serviceName: serviceTitle,
      description: finalDesc.isEmpty ? 'Service requested for $serviceTitle' : finalDesc,
      date: _selectedDate,
      time: _isEmergency ? 'Emergency (Within 30 mins)' : _selectedSlot,
      budget: _estimatedBudget.toInt(),
      mediaUrls: List.from(_uploadedFiles),
    );

    _broadcastTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() => _broadcastSeconds++);
      }
    });

    // Simulate First Accept lock after 2.4s
    Timer(const Duration(milliseconds: 2400), () {
      if (mounted) {
        _broadcastTimer?.cancel();
        setState(() => _isBroadcasting = false);
        _showWorkerAcceptedDialog(newJob);
      }
    });
  }

  void _showWorkerAcceptedDialog(CustomerJob job) {
    final worker = job.assignedWorker ?? MockRepository.workers.first;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        contentPadding: const EdgeInsets.all(20),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Celebration header
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFF0FDFA),
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFF99F6E4)),
              ),
              child: const Icon(Icons.verified, color: Color(0xFF0F766E), size: 40),
            ),
            const SizedBox(height: 14),
            const Text(
              'Job Accepted Instantly!',
              style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold, color: Color(0xFF18181B)),
            ),
            const SizedBox(height: 4),
            const Text(
              'First verified pro accepted your request via atomic lock',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Color(0xFF71717A)),
            ),
            const SizedBox(height: 16),

            // Worker Profile Card
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE4E4E7)),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 26,
                    backgroundColor: const Color(0xFF18181B),
                    child: Text(
                      worker.avatar,
                      style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 16),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(worker.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                            const SizedBox(width: 4),
                            const Icon(Icons.check_circle, color: Color(0xFF0F766E), size: 15),
                          ],
                        ),
                        Text(
                          '★ ${worker.rating} • ${worker.jobsCompleted}+ jobs completed',
                          style: const TextStyle(fontSize: 12, color: Color(0xFF71717A)),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: const Color(0xFFCCFBF1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                'Aadhaar & Police Verified',
                                style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Color(0xFF0F766E)),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Visit Fee & Arrival note
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFFFFBEB),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFFDE68A)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.near_me, color: Color(0xFFB45309), size: 18),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Fixed Visit Charge: ₹199 • Arriving in ~12 mins with tools',
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF92400E)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.pop(ctx);
                      showDialog(
                        context: context,
                        builder: (_) => MaskedCallDialog(
                          workerName: worker.name,
                          workerPhoto: worker.avatar,
                        ),
                      );
                    },
                    icon: const Icon(Icons.call, size: 16, color: Color(0xFF0F766E)),
                    label: const Text('Call', style: TextStyle(color: Color(0xFF0F766E), fontWeight: FontWeight.bold)),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFF0F766E)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(ctx); // Close dialog
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => JobDetailScreen(
                            job: job,
                            appState: widget.appState,
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.navigation, size: 16),
                    label: const Text('Track Live', style: TextStyle(fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0F766E),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      elevation: 0,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isBroadcasting) {
      return _buildBroadcastingView();
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF18181B)),
          onPressed: () {
            if (_step > 0) {
              setState(() => _step--);
            } else {
              Navigator.pop(context);
            }
          },
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${_category.icon} ${_category.name}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF18181B)),
            ),
            Text(
              'Step ${_step + 1} of 7 • First Accept Model',
              style: const TextStyle(fontSize: 11, color: Color(0xFF71717A)),
            ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: LinearProgressIndicator(
            value: (_step + 1) / 7,
            backgroundColor: const Color(0xFFE4E4E7),
            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF0F766E)),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: _buildCurrentStepContent(),
              ),
            ),
            _buildBottomBar(),
          ],
        ),
      ),
    );
  }

  // --- Step Content Switcher ---
  Widget _buildCurrentStepContent() {
    switch (_step) {
      case 0:
        return _buildStep1Category();
      case 1:
        return _buildStep2Symptoms();
      case 2:
        return _buildStep3Media();
      case 3:
        return _buildStep4Address();
      case 4:
        return _buildStep5Schedule();
      case 5:
        return _buildStep6Budget();
      case 6:
        return _buildStep7Review();
      default:
        return const SizedBox();
    }
  }

  // Step 1: SubService Selection
  Widget _buildStep1Category() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Choose Service Package',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF18181B)),
        ),
        const SizedBox(height: 6),
        const Text(
          'Select the specific job you need help with',
          style: TextStyle(fontSize: 13, color: Color(0xFF71717A)),
        ),
        const SizedBox(height: 18),
        ..._category.subServices.map((sub) {
          final isSelected = _subService?.id == sub.id;
          return InkWell(
            onTap: () => setState(() => _subService = sub),
            borderRadius: BorderRadius.circular(16),
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFFF0FDFA) : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected ? const Color(0xFF0F766E) : const Color(0xFFE4E4E7),
                  width: isSelected ? 2 : 1,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          sub.title,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: isSelected ? const Color(0xFF0F766E) : const Color(0xFF18181B),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Estimated time: ${sub.duration} • 30-Day Guarantee',
                          style: const TextStyle(fontSize: 12, color: Color(0xFF71717A)),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '₹${sub.price}',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0F766E)),
                      ),
                      const Text('Standard price', style: TextStyle(fontSize: 10, color: Color(0xFFA1A1AA))),
                    ],
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  // Step 2: Symptom chips & Issue Description
  Widget _buildStep2Symptoms() {
    final symptoms = _symptomsByCategory[_category.id] ?? ['Problem check', 'Repair needed', 'Servicing'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'What is the issue?',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF18181B)),
        ),
        const SizedBox(height: 6),
        const Text(
          'Select symptoms or describe what is happening',
          style: TextStyle(fontSize: 13, color: Color(0xFF71717A)),
        ),
        const SizedBox(height: 16),
        const Text(
          'COMMON SYMPTOMS',
          style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.0, color: Color(0xFFA1A1AA)),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: symptoms.map((sym) {
            final isPicked = _selectedSymptoms.contains(sym);
            return FilterChip(
              label: Text(sym),
              selected: isPicked,
              onSelected: (val) {
                setState(() {
                  if (val) {
                    _selectedSymptoms.add(sym);
                  } else {
                    _selectedSymptoms.remove(sym);
                  }
                });
              },
              selectedColor: const Color(0xFFCCFBF1),
              checkmarkColor: const Color(0xFF0F766E),
              labelStyle: TextStyle(
                color: isPicked ? const Color(0xFF0F766E) : const Color(0xFF27272A),
                fontWeight: isPicked ? FontWeight.bold : FontWeight.normal,
                fontSize: 12,
              ),
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: isPicked ? const Color(0xFF0F766E) : const Color(0xFFE4E4E7),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 20),
        const Text(
          'ADDITIONAL DETAILS',
          style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.0, color: Color(0xFFA1A1AA)),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _descController,
          maxLines: 4,
          decoration: InputDecoration(
            hintText: 'Describe issue (e.g. AC smells musty, cooling is very low on 16°C)...',
            hintStyle: const TextStyle(color: Color(0xFFA1A1AA), fontSize: 13),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Color(0xFFE4E4E7)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Color(0xFF0F766E), width: 1.5),
            ),
          ),
        ),
      ],
    );
  }

  // Step 3: Media Upload with Progress Bar
  Widget _buildStep3Media() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Upload Photos / Videos',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF18181B)),
        ),
        const SizedBox(height: 6),
        const Text(
          'Help technician arrive with the exact spare parts',
          style: TextStyle(fontSize: 13, color: Color(0xFF71717A)),
        ),
        const SizedBox(height: 20),

        // Upload Button Box
        InkWell(
          onTap: _isUploadingMedia ? null : _addMediaSimulation,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 28),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFCBD5E1), style: BorderStyle.solid),
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: const BoxDecoration(
                    color: Color(0xFFF0FDFA),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.add_photo_alternate, color: Color(0xFF0F766E), size: 30),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Tap to capture or upload photo/video',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF18181B)),
                ),
                const SizedBox(height: 4),
                const Text(
                  'PNG, JPG, MP4 up to 25MB • Encrypted',
                  style: TextStyle(fontSize: 11, color: Color(0xFFA1A1AA)),
                ),
              ],
            ),
          ),
        ),

        if (_isUploadingMedia) ...[
          const SizedBox(height: 16),
          LinearProgressIndicator(
            value: _uploadProgress,
            backgroundColor: const Color(0xFFE4E4E7),
            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF0F766E)),
          ),
          const SizedBox(height: 6),
          const Text('Compressing & encrypting file...', style: TextStyle(fontSize: 11, color: Color(0xFF71717A))),
        ],

        const SizedBox(height: 20),
        const Text(
          'ATTACHED MEDIA (2)',
          style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.0, color: Color(0xFFA1A1AA)),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: _uploadedFiles.map((file) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE4E4E7)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.image, size: 16, color: Color(0xFF0F766E)),
                  const SizedBox(width: 8),
                  Text(file, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                  const SizedBox(width: 8),
                  InkWell(
                    onTap: () {
                      setState(() => _uploadedFiles.remove(file));
                    },
                    child: const Icon(Icons.close, size: 16, color: Color(0xFFA1A1AA)),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  // Step 4: Address Confirmation
  Widget _buildStep4Address() {
    final locality = widget.appState.currentLocality;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Confirm Service Address',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF18181B)),
        ),
        const SizedBox(height: 6),
        const Text(
          'Technician will be dispatched directly to this doorstep location',
          style: TextStyle(fontSize: 13, color: Color(0xFF71717A)),
        ),
        const SizedBox(height: 20),

        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFFE4E4E7)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0FDFA),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.location_on, color: Color(0xFF0F766E), size: 22),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(locality.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        Text('${locality.area}, ${locality.city} • ${locality.pincode}', style: const TextStyle(fontSize: 12, color: Color(0xFF71717A))),
                      ],
                    ),
                  ),
                ],
              ),
              const Divider(height: 24),
              const Text('Flat / House / Doorstep Note', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  'Flat 402, 4th Floor, Tower B • Gate entry OTP will be shared on arrival',
                  style: TextStyle(fontSize: 12, color: Color(0xFF3F3F46)),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Step 5: Schedule Slot Picker
  Widget _buildStep5Schedule() {
    final dates = ['Today', 'Tomorrow', 'Day After Tomorrow'];
    final slots = ['09:00 AM - 11:00 AM', '11:00 AM - 01:00 PM', '02:00 PM - 04:00 PM', '05:00 PM - 07:00 PM'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Choose Service Slot',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF18181B)),
        ),
        const SizedBox(height: 6),
        const Text(
          'Select when you want the pro to arrive',
          style: TextStyle(fontSize: 13, color: Color(0xFF71717A)),
        ),
        const SizedBox(height: 20),

        // Emergency 30-min toggle
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: _isEmergency ? const Color(0xFFFEF2F2) : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: _isEmergency ? const Color(0xFFF87171) : const Color(0xFFE4E4E7)),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _isEmergency ? const Color(0xFFDC2626) : const Color(0xFFF4F4F5),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.bolt, color: _isEmergency ? Colors.white : const Color(0xFF71717A), size: 20),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Emergency Dispatch (30 mins)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    Text('Technician dispatches immediately', style: TextStyle(fontSize: 11, color: Color(0xFF71717A))),
                  ],
                ),
              ),
              Switch(
                value: _isEmergency,
                activeColor: const Color(0xFFDC2626),
                onChanged: (val) => setState(() => _isEmergency = val),
              ),
            ],
          ),
        ),

        if (!_isEmergency) ...[
          const SizedBox(height: 20),
          const Text('SERVICE DATE', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.0, color: Color(0xFFA1A1AA))),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: dates.map((d) {
              final isSel = _selectedDate == d;
              return ChoiceChip(
                label: Text(d),
                selected: isSel,
                selectedColor: const Color(0xFF0F766E),
                labelStyle: TextStyle(
                  color: isSel ? Colors.white : const Color(0xFF18181B),
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
                onSelected: (val) => setState(() => _selectedDate = d),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          const Text('PREFERRED TIME WINDOW', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.0, color: Color(0xFFA1A1AA))),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: slots.map((s) {
              final isSel = _selectedSlot == s;
              return ChoiceChip(
                label: Text(s),
                selected: isSel,
                selectedColor: const Color(0xFF0F766E),
                labelStyle: TextStyle(
                  color: isSel ? Colors.white : const Color(0xFF18181B),
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
                onSelected: (val) => setState(() => _selectedSlot = s),
              );
            }).toList(),
          ),
        ],
      ],
    );
  }

  // Step 6: Budget Estimate Slider
  Widget _buildStep6Budget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Estimated Budget Range',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF18181B)),
        ),
        const SizedBox(height: 6),
        const Text(
          'Visit charge is fixed. Technician provides inspection estimate on-site before work begins.',
          style: TextStyle(fontSize: 13, color: Color(0xFF71717A)),
        ),
        const SizedBox(height: 24),

        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFE4E4E7)),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Fixed Visit & Inspection Fee:', style: TextStyle(fontSize: 13, color: Color(0xFF71717A))),
                  const Text('₹199', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF0F766E))),
                ],
              ),
              const Divider(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Estimated Repair Cost:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  Text(
                    '₹${_estimatedBudget.toInt()}',
                    style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 22, color: Color(0xFF18181B)),
                  ),
                ],
              ),
              Slider(
                value: _estimatedBudget,
                min: 300,
                max: 3000,
                divisions: 27,
                activeColor: const Color(0xFF0F766E),
                inactiveColor: const Color(0xFFE4E4E7),
                onChanged: (val) => setState(() => _estimatedBudget = val),
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('₹300 (Minor fix)', style: TextStyle(fontSize: 10, color: Color(0xFFA1A1AA))),
                  Text('₹3,000 (Major overhaul)', style: TextStyle(fontSize: 10, color: Color(0xFFA1A1AA))),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFF0FDFA),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFCCFBF1)),
          ),
          child: const Row(
            children: [
              Icon(Icons.security, color: Color(0xFF0F766E), size: 18),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Inspection Gate Guarantee: No work starts without your explicit 1-tap approval.',
                  style: TextStyle(fontSize: 11, color: Color(0xFF0F766E), fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Step 7: Review & Submit
  Widget _buildStep7Review() {
    final serviceTitle = _subService?.title ?? _category.name;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Review & Broadcast',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF18181B)),
        ),
        const SizedBox(height: 6),
        const Text(
          'Your request will be sent to 12 verified pros within 3km',
          style: TextStyle(fontSize: 13, color: Color(0xFF71717A)),
        ),
        const SizedBox(height: 20),

        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFE4E4E7)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildReviewRow(Icons.build, 'Service', serviceTitle),
              const Divider(height: 20),
              _buildReviewRow(Icons.place, 'Address', widget.appState.currentLocality.fullAddress),
              const Divider(height: 20),
              _buildReviewRow(
                Icons.schedule,
                'Slot',
                _isEmergency ? 'Emergency (Within 30 mins)' : '$_selectedDate • $_selectedSlot',
              ),
              const Divider(height: 20),
              _buildReviewRow(
                Icons.currency_rupee,
                'Pricing',
                'Visit ₹199 + Repair Est. ₹${_estimatedBudget.toInt()}',
              ),
              if (_selectedSymptoms.isNotEmpty) ...[
                const Divider(height: 20),
                _buildReviewRow(Icons.check_circle_outline, 'Symptoms', _selectedSymptoms.join(', ')),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildReviewRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: const Color(0xFF0F766E)),
        const SizedBox(width: 10),
        SizedBox(
          width: 75,
          child: Text(label, style: const TextStyle(fontSize: 13, color: Color(0xFF71717A))),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF18181B)),
          ),
        ),
      ],
    );
  }

  // --- Bottom Bar ---
  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        children: [
          if (_step > 0)
            OutlinedButton(
              onPressed: () => setState(() => _step--),
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              ),
              child: const Text('Back'),
            ),
          if (_step > 0) const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                if (_step < 6) {
                  setState(() => _step++);
                } else {
                  _startBroadcast();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0F766E),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                padding: const EdgeInsets.symmetric(vertical: 14),
                elevation: 0,
              ),
              child: Text(
                _step == 6 ? 'Broadcast Request (First Accept)' : 'Continue',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- Broadcasting Radar Pulse Screen ---
  Widget _buildBroadcastingView() {
    return Scaffold(
      backgroundColor: const Color(0xFF0F766E),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              // Animated Radar Pulse
              AnimatedBuilder(
                animation: _radarController,
                builder: (context, child) {
                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 180 + (_radarController.value * 60),
                        height: 180 + (_radarController.value * 60),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.12 * (1 - _radarController.value)),
                        ),
                      ),
                      Container(
                        width: 140 + (_radarController.value * 40),
                        height: 140 + (_radarController.value * 40),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.2 * (1 - _radarController.value)),
                        ),
                      ),
                      Container(
                        width: 90,
                        height: 90,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.radar, color: Color(0xFF0F766E), size: 48),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 36),
              const Text(
                'Broadcasting Request...',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Searching 12 verified pros within 3km of ${widget.appState.currentLocality.name}',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Color(0xFFCCFBF1), fontSize: 13),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'First pro to tap accept gets the job • 00:${_broadcastSeconds.toString().padLeft(2, '0')}s',
                  style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton(
                  onPressed: () {
                    _broadcastTimer?.cancel();
                    setState(() => _isBroadcasting = false);
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.white70),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: const Text('Cancel Broadcast', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
