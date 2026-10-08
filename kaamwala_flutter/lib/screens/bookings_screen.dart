import 'package:flutter/material.dart';
import '../models/app_models.dart';
import '../services/app_state.dart';
import 'job_detail_screen.dart';

class BookingsScreen extends StatefulWidget {
  final AppState appState;

  const BookingsScreen({
    super.key,
    required this.appState,
  });

  @override
  State<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final active = widget.appState.activeJob.status != 'CLOSED' ? [widget.appState.activeJob] : <CustomerJob>[];
    final past = widget.appState.pastJobs;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('My Bookings', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF1E293B),
        elevation: 0.5,
        bottom: TabBar(
          controller: _tabController,
          labelColor: const Color(0xFF059669),
          unselectedLabelColor: Colors.grey.shade600,
          indicatorColor: const Color(0xFF059669),
          indicatorWeight: 3,
          tabs: [
            Tab(text: 'Active (${active.length})'),
            Tab(text: 'History (${past.length})'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildJobsList(active, isActive: true),
          _buildJobsList(past, isActive: false),
        ],
      ),
    );
  }

  Widget _buildJobsList(List<CustomerJob> jobs, {required bool isActive}) {
    if (jobs.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.assignment_outlined, size: 60, color: Colors.grey.shade400),
            const SizedBox(height: 12),
            Text(
              isActive ? 'No active bookings currently' : 'No past bookings yet',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 15),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: jobs.length,
      itemBuilder: (context, index) {
        final job = jobs[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 6, offset: const Offset(0, 2)),
            ],
          ),
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => JobDetailScreen(
                    job: job,
                    appState: widget.appState,
                  ),
                ),
              );
            },
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(job.id, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF059669))),
                      _buildStatusPill(job.status),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    job.serviceName,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    job.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                  const Divider(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.calendar_today, size: 14, color: Colors.grey),
                          const SizedBox(width: 6),
                          Text(job.date, style: TextStyle(fontSize: 12, color: Colors.grey.shade700)),
                        ],
                      ),
                      Row(
                        children: [
                          const Text('Details', style: TextStyle(color: Color(0xFF059669), fontWeight: FontWeight.bold, fontSize: 13)),
                          const SizedBox(width: 4),
                          const Icon(Icons.arrow_forward_ios, size: 12, color: Color(0xFF059669)),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatusPill(String status) {
    Color bg;
    Color text;

    switch (status) {
      case 'CLOSED':
        bg = const Color(0xFFF1F5F9);
        text = const Color(0xFF475569);
        break;
      case 'QUOTATIONS_RECEIVED':
        bg = const Color(0xFFFEF3C7);
        text = const Color(0xFF92400E);
        break;
      case 'ON_THE_WAY':
      case 'WORK_STARTED':
        bg = const Color(0xFFDBEAFE);
        text = const Color(0xFF1E40AF);
        break;
      default:
        bg = const Color(0xFFECFDF5);
        text = const Color(0xFF065F46);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(6)),
      child: Text(
        status.replaceAll('_', ' '),
        style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: text),
      ),
    );
  }
}
