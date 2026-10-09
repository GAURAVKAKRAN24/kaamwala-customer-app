import 'package:flutter/material.dart';
import '../models/app_models.dart';
import '../services/app_state.dart';
import '../widgets/masked_call_dialog.dart';
import '../widgets/payment_sheet.dart';
import '../widgets/review_sheet.dart';

class JobDetailScreen extends StatefulWidget {
  final CustomerJob job;
  final AppState appState;

  const JobDetailScreen({
    super.key,
    required this.job,
    required this.appState,
  });

  @override
  State<JobDetailScreen> createState() => _JobDetailScreenState();
}

class _JobDetailScreenState extends State<JobDetailScreen> {
  // 11 stages matching PDF Version 2.0
  static const List<String> _stages = [
    'REQUESTED',
    'BROADCASTING',
    'WORKER_CONFIRMED',
    'ON_THE_WAY',
    'ARRIVED',
    'INSPECTION',
    'WORK_STARTED',
    'WORK_COMPLETED',
    'PAYMENT',
    'REVIEW',
    'CLOSED',
  ];

  static const Map<String, String> _stageTitles = {
    'REQUESTED': 'Job Requested',
    'BROADCASTING': 'Broadcasting to Pros',
    'WORKER_CONFIRMED': 'Technician Confirmed',
    'ON_THE_WAY': 'Technician En Route',
    'ARRIVED': 'Technician Arrived at Doorstep',
    'INSPECTION': 'Inspection & Diagnostics Gate',
    'WORK_STARTED': 'Work in Progress',
    'WORK_COMPLETED': 'Work Completed',
    'PAYMENT': 'Payment Pending',
    'REVIEW': 'Rate & Review',
    'CLOSED': 'Completed & 30-Day Warranty Active',
  };

  static const Map<String, String> _stageDescriptions = {
    'REQUESTED': 'Your requirement was captured and processed.',
    'BROADCASTING': 'Broadcasting to nearest 12 verified pros within 3km.',
    'WORKER_CONFIRMED': 'Worker accepted your job via atomic first-pickup lock.',
    'ON_THE_WAY': 'Technician is travelling with diagnostic tools & genuine parts.',
    'ARRIVED': 'Technician has reached your doorstep. Please verify photo badge.',
    'INSPECTION': 'Appliance inspected. Customer estimate approval required before starting work.',
    'WORK_STARTED': 'Authorized repair & servicing in progress under standard safety protocols.',
    'WORK_COMPLETED': 'Technician has concluded service and tested appliance performance.',
    'PAYMENT': 'Review itemized invoice and pay safely via UPI, Wallet, Card or Cash.',
    'REVIEW': 'Rate technician quality, punctuality, and behavior.',
    'CLOSED': 'Job successfully closed. Protected under KaamWala 30-Day Guarantee.',
  };

  void _openMaskedCall(WorkerProfile worker) {
    showDialog(
      context: context,
      builder: (context) => MaskedCallDialog(
        workerName: worker.name,
        workerPhoto: worker.avatar,
      ),
    );
  }

  void _openPayment() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => PaymentSheet(appState: widget.appState),
    );
  }

  void _openReview() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ReviewSheet(appState: widget.appState),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentStatus = widget.job.status;
    final stageIndex = _stages.indexOf(currentStatus);
    final worker = widget.job.assignedWorker;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.job.id, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text(widget.job.serviceName, style: const TextStyle(fontSize: 12, color: Color(0xFF71717A))),
          ],
        ),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF18181B),
        elevation: 0.5,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Stage Status Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Color(0xFF0F766E),
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: Color(0xFF99F6E4),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'BOOKING #${widget.job.id}',
                              style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '${widget.job.date} • ${widget.job.time}',
                        style: const TextStyle(color: Color(0xFFCCFBF1), fontSize: 12),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Text(
                    _stageTitles[currentStatus] ?? currentStatus,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _stageDescriptions[currentStatus] ?? '',
                    style: const TextStyle(color: Color(0xFFE6FFFA), fontSize: 13, height: 1.3),
                  ),
                ],
              ),
            ),

            // Live Doorstep Status Progress Card
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE4E4E7)),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 8, offset: const Offset(0, 2)),
                ],
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
                        child: const Icon(Icons.near_me, color: Color(0xFF0F766E), size: 20),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Doorstep Service Dispatch',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                            Text(
                              currentStatus == 'CLOSED'
                                  ? 'Service completed & covered under 30-day warranty'
                                  : 'First verified pro allocated • 0.8 km away • ETA 12 min',
                              style: const TextStyle(fontSize: 12, color: Color(0xFF71717A)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // 4-step Main Milestone Bar
                  Row(
                    children: [
                      _buildMilestoneStep('Booked', true),
                      _buildMilestoneLine(stageIndex >= 2),
                      _buildMilestoneStep('Confirmed', stageIndex >= 2),
                      _buildMilestoneLine(stageIndex >= 3),
                      _buildMilestoneStep('En Route', stageIndex >= 3),
                      _buildMilestoneLine(stageIndex >= 7),
                      _buildMilestoneStep('Done', stageIndex >= 7),
                    ],
                  ),
                ],
              ),
            ),

            // Assigned Worker Card
            if (worker != null) ...[
              _buildAssignedWorkerCard(worker),
            ],

            // --- INSPECTION GATE (V2.0 Core Requirement) ---
            if (currentStatus == 'INSPECTION' || (stageIndex >= 4 && !widget.job.isInspectionApproved)) ...[
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFFBEB),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFFDE68A), width: 1.5),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.gavel, color: Color(0xFFD97706), size: 20),
                        SizedBox(width: 8),
                        Text(
                          'Inspection Gate Approval Required',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF92400E)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Ramesh Kumar has inspected the unit. Diagnosis: AC Coil Jet Wash + Capacitor Replacement.',
                      style: TextStyle(fontSize: 13, color: Color(0xFF78350F)),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('On-Site Estimate:', style: TextStyle(fontWeight: FontWeight.w600)),
                        Text(
                          '₹${widget.job.estimatedAmount}',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0F766E)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          setState(() {
                            widget.appState.approveInspectionEstimate();
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Estimate Approved! Technician has started work.'),
                              backgroundColor: Color(0xFF0F766E),
                            ),
                          );
                        },
                        icon: const Icon(Icons.check_circle, size: 18),
                        label: Text(
                          'Approve Estimate ₹${widget.job.estimatedAmount}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0F766E),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          elevation: 0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            // --- WORK COMPLETION CONFIRMATION GATE ---
            if (currentStatus == 'WORK_STARTED' || (stageIndex >= 6 && !widget.job.isCompletedConfirmed)) ...[
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE4E4E7)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.photo_camera_back, color: Color(0xFF0F766E), size: 20),
                        SizedBox(width: 8),
                        Text(
                          'Before & After Work Verification',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 80,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF1F5F9),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Center(
                              child: Text('📸 Before Photo\n(Dirty Filter)', textAlign: TextAlign.center, style: TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Container(
                            height: 80,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF0FDFA),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Center(
                              child: Text('📸 After Photo\n(Jet Cleaned)', textAlign: TextAlign.center, style: TextStyle(fontSize: 11, color: Color(0xFF0F766E), fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          setState(() {
                            widget.appState.confirmCompletion();
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Work confirmed! Proceed to payment.'),
                              backgroundColor: Color(0xFF0F766E),
                            ),
                          );
                        },
                        icon: const Icon(Icons.thumb_up, size: 18),
                        label: const Text('Confirm Work Done & Test Passed', style: TextStyle(fontWeight: FontWeight.bold)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF18181B),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          elevation: 0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            // Contextual Action Button: PAYMENT
            if (currentStatus == 'PAYMENT') ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton.icon(
                    onPressed: _openPayment,
                    icon: const Icon(Icons.payment),
                    label: Text(
                      'View Itemized Bill & Pay ₹${widget.job.finalAmount}',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0F766E),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      elevation: 0,
                    ),
                  ),
                ),
              ),
            ],

            // Contextual Action Button: REVIEW
            if (currentStatus == 'REVIEW') ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton.icon(
                    onPressed: _openReview,
                    icon: const Icon(Icons.star),
                    label: const Text('Rate Ramesh Kumar & Submit Review', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber.shade700,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      elevation: 0,
                    ),
                  ),
                ),
              ),
            ],

            // Contextual Action Button: CLOSED
            if (currentStatus == 'CLOSED') ...[
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0FDFA),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFCCFBF1)),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.verified, color: Color(0xFF0F766E), size: 24),
                    SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('KaamWala 30-Day Guarantee Active', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0F766E), fontSize: 13)),
                          Text('Free revisit if problem reoccurs within 30 days', style: TextStyle(fontSize: 11, color: Color(0xFF134E4A))),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],

            // 11-Stage Full Timeline Accordion
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFFE4E4E7)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('11-Stage Service Lifecycle', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  const SizedBox(height: 12),
                  ..._stages.asMap().entries.map((entry) {
                    final idx = entry.key;
                    final st = entry.value;
                    final isCompleted = stageIndex > idx;
                    final isCurrent = stageIndex == idx;

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          Container(
                            width: 22,
                            height: 22,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isCompleted
                                  ? const Color(0xFF0F766E)
                                  : (isCurrent ? const Color(0xFFFEF3C7) : const Color(0xFFF4F4F5)),
                              border: Border.all(
                                color: isCompleted || isCurrent ? const Color(0xFF0F766E) : const Color(0xFFD4D4D8),
                              ),
                            ),
                            child: Center(
                              child: isCompleted
                                  ? const Icon(Icons.check, size: 14, color: Colors.white)
                                  : Text(
                                      '${idx + 1}',
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        color: isCurrent ? const Color(0xFF92400E) : const Color(0xFF71717A),
                                      ),
                                    ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              _stageTitles[st] ?? st,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                                color: isCurrent ? const Color(0xFF0F766E) : const Color(0xFF3F3F46),
                              ),
                            ),
                          ),
                          if (isCurrent)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFEF3C7),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text('ACTIVE', style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: Color(0xFF92400E))),
                            ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),

            // Booking Summary Box
            Container(
              margin: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE4E4E7)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Booking Summary', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  const SizedBox(height: 12),
                  _buildSummaryRow(Icons.build, 'Service', widget.job.serviceName),
                  const SizedBox(height: 8),
                  _buildSummaryRow(Icons.description, 'Description', widget.job.description),
                  const SizedBox(height: 8),
                  _buildSummaryRow(Icons.place, 'Address', widget.job.address),
                  const SizedBox(height: 8),
                  _buildSummaryRow(Icons.schedule, 'Slot', '${widget.job.date} • ${widget.job.time}'),
                  const Divider(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Visit & Diagnostics Fee', style: TextStyle(fontSize: 12, color: Color(0xFF71717A))),
                      Text('₹${widget.job.visitFee}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total Estimate', style: TextStyle(fontSize: 12, color: Color(0xFF71717A))),
                      Text('₹${widget.job.finalAmount}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF0F766E))),
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

  Widget _buildAssignedWorkerCard(WorkerProfile worker) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE4E4E7)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 26,
                backgroundColor: const Color(0xFF18181B),
                child: Text(
                  worker.avatar,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
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
                        const SizedBox(width: 6),
                        const Icon(Icons.verified, color: Color(0xFF0F766E), size: 16),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '★ ${worker.rating} • ${worker.jobsCompleted}+ jobs completed',
                      style: const TextStyle(fontSize: 12, color: Color(0xFF71717A)),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFCCFBF1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'Aadhaar Verified Pro',
                        style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Color(0xFF0F766E)),
                      ),
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
                child: OutlinedButton.icon(
                  onPressed: () => _openMaskedCall(worker),
                  icon: const Icon(Icons.call, size: 16, color: Color(0xFF0F766E)),
                  label: const Text('Masked Call', style: TextStyle(color: Color(0xFF0F766E), fontWeight: FontWeight.bold)),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFF0F766E)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context); // Back to bottom tabs
                  },
                  icon: const Icon(Icons.chat_bubble_outline, size: 16),
                  label: const Text('Open Chat', style: TextStyle(fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0F766E),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: const Color(0xFF71717A)),
        const SizedBox(width: 8),
        SizedBox(
          width: 80,
          child: Text(label, style: const TextStyle(fontSize: 12, color: Color(0xFF71717A))),
        ),
        Expanded(
          child: Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF18181B))),
        ),
      ],
    );
  }

  Widget _buildMilestoneStep(String title, bool isDone) {
    return Column(
      children: [
        CircleAvatar(
          radius: 12,
          backgroundColor: isDone ? const Color(0xFF0F766E) : const Color(0xFFE4E4E7),
          child: Icon(
            isDone ? Icons.check : Icons.circle,
            size: 12,
            color: isDone ? Colors.white : const Color(0xFFA1A1AA),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: TextStyle(
            fontSize: 10,
            fontWeight: isDone ? FontWeight.bold : FontWeight.w500,
            color: isDone ? const Color(0xFF0F766E) : const Color(0xFF71717A),
          ),
        ),
      ],
    );
  }

  Widget _buildMilestoneLine(bool isDone) {
    return Expanded(
      child: Container(
        height: 2,
        margin: const EdgeInsets.only(bottom: 16),
        color: isDone ? const Color(0xFF0F766E) : const Color(0xFFE4E4E7),
      ),
    );
  }
}
