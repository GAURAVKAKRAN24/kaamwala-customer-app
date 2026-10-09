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
  static const Map<String, String> _stageTitles = {
    'REQUESTED': 'Request Posted',
    'QUOTATIONS_RECEIVED': 'Quotes Received',
    'WORKER_SELECTED': 'Technician Selected',
    'WORKER_CONFIRMED': 'Booking Confirmed',
    'ON_THE_WAY': 'Technician On the Way',
    'ARRIVED': 'Technician Arrived',
    'INSPECTION': 'Inspection & Diagnostics',
    'WORK_STARTED': 'Work in Progress',
    'WORK_COMPLETED': 'Work Completed',
    'PAYMENT': 'Payment Pending',
    'REVIEW': 'Rate & Review',
    'CLOSED': 'Job Completed & Closed',
  };

  static const Map<String, String> _stageDescriptions = {
    'REQUESTED': 'Broadcasting your requirement to top-rated nearby pros...',
    'QUOTATIONS_RECEIVED': 'Multiple verified technicians have submitted price estimates.',
    'WORKER_SELECTED': 'You picked a technician. Waiting for arrival confirmation.',
    'WORKER_CONFIRMED': 'Technician has accepted your booking & prepared equipment.',
    'ON_THE_WAY': 'Technician is en route with live GPS route tracking.',
    'ARRIVED': 'Technician has reached your premises. Please verify identity badge.',
    'INSPECTION': 'Inspecting AC/appliance and providing final transparent quote.',
    'WORK_STARTED': 'Deep cleaning and repair work currently in progress.',
    'WORK_COMPLETED': 'Work finished! Technician has cleaned up and tested appliance.',
    'PAYMENT': 'Verify itemized invoice and pay safely via UPI/Card/Cash.',
    'REVIEW': 'Share feedback and rate work quality, punctuality, and behavior.',
    'CLOSED': 'Order completed. Covered under KaamWala 30-Day Service Guarantee.',
  };

  void _openMaskedCall(Quote worker) {
    showDialog(
      context: context,
      builder: (context) => MaskedCallDialog(
        workerName: worker.workerName,
        workerPhoto: worker.workerPhoto,
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
    final stageIndex = AppState.lifecycleStages.indexOf(currentStatus);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.job.id, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text(
              widget.job.serviceName,
              style: const TextStyle(fontSize: 12, color: Colors.white70),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF059669),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Stage Status Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Color(0xFF059669),
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
                                color: Color(0xFFA7F3D0),
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
                        widget.job.date,
                        style: const TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
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
                    style: const TextStyle(color: Colors.white, fontSize: 13, height: 1.3),
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
                border: Border.all(color: Colors.grey.shade200),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8, offset: const Offset(0, 2)),
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
                          color: const Color(0xFFECFDF5),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.bolt, color: Color(0xFF059669), size: 20),
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
                              currentStatus == 'CLOSED' ? 'Service finished & covered under 30-day warranty' : 'Verified KaamWala Pro allocated to your locality',
                              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Real 4-step Milestone Bar
                  Row(
                    children: [
                      _buildMilestoneStep('Booked', true),
                      _buildMilestoneLine(stageIndex >= 3),
                      _buildMilestoneStep('Confirmed', stageIndex >= 3),
                      _buildMilestoneLine(stageIndex >= 4),
                      _buildMilestoneStep('En Route', stageIndex >= 4),
                      _buildMilestoneLine(stageIndex >= 8),
                      _buildMilestoneStep('Completed', stageIndex >= 8),
                    ],
                  ),
                ],
              ),
            ),

            // Assigned Worker or Quotes Section
            if (widget.job.selectedWorker != null) ...[
              _buildAssignedWorkerCard(widget.job.selectedWorker!),
            ] else if (widget.job.quotes.isNotEmpty) ...[
              _buildQuotationsSection(),
            ],

            // Contextual Action Buttons
            if (currentStatus == 'PAYMENT') ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _openPayment,
                    icon: const Icon(Icons.payment),
                    label: const Text('View Authoritative Bill & Pay Now', style: TextStyle(fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF059669),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
              ),
            ],

            if (currentStatus == 'REVIEW') ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _openReview,
                    icon: const Icon(Icons.star),
                    label: const Text('Rate Technician & Submit Review', style: TextStyle(fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber.shade700,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
              ),
            ],

            // Job Details Summary Box
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Booking Summary', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 12),
                  _buildSummaryRow(Icons.build, 'Service', widget.job.serviceName),
                  const SizedBox(height: 8),
                  _buildSummaryRow(Icons.description, 'Description', widget.job.description),
                  const SizedBox(height: 8),
                  _buildSummaryRow(Icons.place, 'Address', widget.job.address),
                  const SizedBox(height: 8),
                  _buildSummaryRow(Icons.schedule, 'Slot', '${widget.job.date} • ${widget.job.time}'),
                  const Divider(height: 20),
                  const Row(
                    children: [
                      Icon(Icons.verified_user, color: Color(0xFF059669), size: 18),
                      SizedBox(width: 8),
                      Text(
                        'KaamWala 30-Day Doorstep Guarantee',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF059669)),
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

  Widget _buildAssignedWorkerCard(Quote worker) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 26,
                backgroundColor: Colors.grey.shade200,
                child: const Icon(Icons.person, size: 30, color: Color(0xFF059669)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(worker.workerName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        const SizedBox(width: 6),
                        const Icon(Icons.verified, color: Color(0xFF059669), size: 16),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 14),
                        const SizedBox(width: 4),
                        Text(
                          '${worker.workerRating} (${worker.workerJobs} jobs completed)',
                          style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                        ),
                      ],
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
                  icon: const Icon(Icons.call, size: 16, color: Color(0xFF059669)),
                  label: const Text('Masked Call', style: TextStyle(color: Color(0xFF059669), fontWeight: FontWeight.bold)),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFF059669)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context); // Go back to bottom tabs and switch to Chat
                  },
                  icon: const Icon(Icons.chat_bubble_outline, size: 16),
                  label: const Text('Open Chat', style: TextStyle(fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF059669),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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

  Widget _buildQuotationsSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Received Quotations (2)',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFECFDF5),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  'Transparent Pricing',
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF059669)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ...widget.job.quotes.map((quote) {
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.grey.shade200,
                        child: const Icon(Icons.person, color: Color(0xFF059669)),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(quote.workerName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                            Text('★ ${quote.workerRating} • ${quote.workerJobs} jobs', style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          quote.arrivalTime,
                          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Color(0xFF334155)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '"${quote.message}"',
                    style: TextStyle(fontStyle: FontStyle.italic, fontSize: 12, color: Colors.grey.shade700),
                  ),
                  const SizedBox(height: 10),
                  // Price breakdown
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Visit / Inspection', style: TextStyle(fontSize: 10, color: Colors.grey.shade600)),
                            Text('₹${quote.visitFee}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Estimated Repair', style: TextStyle(fontSize: 10, color: Colors.grey.shade600)),
                            Text('₹${quote.estimateMin} - ₹${quote.estimateMax}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF059669))),
                          ],
                        ),
                        if (quote.partsExtra)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFEF3C7),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text('Parts Extra', style: TextStyle(fontSize: 9, color: Color(0xFF92400E), fontWeight: FontWeight.bold)),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.call, color: Color(0xFF059669)),
                        onPressed: () => _openMaskedCall(quote),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              widget.appState.selectWorker(quote);
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF059669),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            elevation: 0,
                          ),
                          child: const Text('Accept Quote & Hire', style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: Colors.grey.shade600),
        const SizedBox(width: 8),
        SizedBox(
          width: 80,
          child: Text(label, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
        ),
        Expanded(
          child: Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF1E293B))),
        ),
      ],
    );
  }

  Widget _buildMilestoneStep(String title, bool isDone) {
    return Column(
      children: [
        CircleAvatar(
          radius: 12,
          backgroundColor: isDone ? const Color(0xFF059669) : Colors.grey.shade200,
          child: Icon(
            isDone ? Icons.check : Icons.circle,
            size: 12,
            color: isDone ? Colors.white : Colors.grey.shade400,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: TextStyle(
            fontSize: 10,
            fontWeight: isDone ? FontWeight.bold : FontWeight.w500,
            color: isDone ? const Color(0xFF059669) : Colors.grey.shade500,
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
        color: isDone ? const Color(0xFF059669) : Colors.grey.shade300,
      ),
    );
  }
}
