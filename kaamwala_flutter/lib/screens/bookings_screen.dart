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

class _BookingsScreenState extends State<BookingsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final allJobs = widget.appState.allJobs;
    final activeJobs = allJobs.where((j) => j.status != 'CLOSED' && j.status != 'CANCELLED').toList();
    final completedJobs = allJobs.where((j) => j.status == 'CLOSED' || j.status == 'WORK_COMPLETED').toList();
    final cancelledJobs = allJobs.where((j) => j.status == 'CANCELLED').toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('My Bookings & History', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF18181B),
        elevation: 0.5,
        bottom: TabBar(
          controller: _tabController,
          labelColor: const Color(0xFF0F766E),
          unselectedLabelColor: const Color(0xFF71717A),
          indicatorColor: const Color(0xFF0F766E),
          indicatorWeight: 3,
          isScrollable: true,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          tabs: [
            Tab(text: 'All (${allJobs.length})'),
            Tab(text: 'Active (${activeJobs.length})'),
            Tab(text: 'Completed (${completedJobs.length})'),
            Tab(text: 'Cancelled (${cancelledJobs.length})'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildJobsList(allJobs),
          _buildJobsList(activeJobs),
          _buildJobsList(completedJobs),
          _buildJobsList(cancelledJobs),
        ],
      ),
    );
  }

  Widget _buildJobsList(List<CustomerJob> jobs) {
    if (jobs.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Color(0xFFF1F5F9),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.assignment_outlined, size: 48, color: Color(0xFFA1A1AA)),
            ),
            const SizedBox(height: 16),
            const Text(
              'No bookings found',
              style: TextStyle(color: Color(0xFF18181B), fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 6),
            const Text(
              'Your booked services will show up here',
              style: TextStyle(color: Color(0xFF71717A), fontSize: 13),
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
        final isActive = job.status != 'CLOSED' && job.status != 'CANCELLED';

        return Container(
          margin: const EdgeInsets.only(bottom: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: isActive ? const Color(0xFF0F766E).withOpacity(0.3) : const Color(0xFFE4E4E7),
              width: isActive ? 1.5 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
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
            borderRadius: BorderRadius.circular(18),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          if (isActive) ...[
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: Color(0xFF10B981),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 6),
                          ],
                          Text(
                            job.id,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              color: Color(0xFF0F766E),
                            ),
                          ),
                        ],
                      ),
                      _buildStatusPill(job.status),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    job.serviceName,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF18181B)),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    job.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 12, color: Color(0xFF71717A)),
                  ),
                  const SizedBox(height: 12),

                  if (job.assignedWorker != null) ...[
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 14,
                            backgroundColor: const Color(0xFF18181B),
                            child: Text(
                              job.assignedWorker!.avatar,
                              style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              '${job.assignedWorker!.name} • Assigned Pro',
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF27272A)),
                            ),
                          ),
                          Text(
                            '₹${job.finalAmount}',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF0F766E)),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],

                  const Divider(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.schedule, size: 14, color: Color(0xFF71717A)),
                          const SizedBox(width: 6),
                          Text(
                            '${job.date} • ${job.time}',
                            style: const TextStyle(fontSize: 12, color: Color(0xFF71717A)),
                          ),
                        ],
                      ),
                      if (isActive) ...[
                        ElevatedButton.icon(
                          onPressed: () {
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
                          icon: const Icon(Icons.navigation, size: 14),
                          label: const Text('Track Live', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0F766E),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            minimumSize: Size.zero,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                            elevation: 0,
                          ),
                        ),
                      ] else ...[
                        OutlinedButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Re-booking ${job.serviceName}...'),
                                backgroundColor: const Color(0xFF0F766E),
                              ),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF0F766E),
                            side: const BorderSide(color: Color(0xFF0F766E)),
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            minimumSize: Size.zero,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          ),
                          child: const Text('Book Again', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                        ),
                      ],
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
      case 'CANCELLED':
        bg = const Color(0xFFFEF2F2);
        text = const Color(0xFFB91C1C);
        break;
      case 'BROADCASTING':
        bg = const Color(0xFFFEF3C7);
        text = const Color(0xFF92400E);
        break;
      case 'ON_THE_WAY':
      case 'WORK_STARTED':
      case 'INSPECTION':
        bg = const Color(0xFFF0FDFA);
        text = const Color(0xFF0F766E);
        break;
      default:
        bg = const Color(0xFFF0FDFA);
        text = const Color(0xFF0F766E);
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
