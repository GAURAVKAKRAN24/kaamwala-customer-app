import 'package:flutter/material.dart';
import '../models/app_models.dart';
import '../services/app_state.dart';
import '../services/mock_data.dart';
import 'create_request_screen.dart';
import 'job_detail_screen.dart';

class NotificationsScreen extends StatelessWidget {
  final AppState appState;

  const NotificationsScreen({
    super.key,
    required this.appState,
  });

  void _onTapNotification(BuildContext context, NotificationItem item) {
    // Mark as read
    appState.markNotificationAsRead(item.id);

    // Navigate to relevant screen based on notification type
    if (item.type == 'worker' || item.title.contains('accepted') || item.title.contains('on the way')) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => JobDetailScreen(
            job: appState.activeJob,
            appState: appState,
          ),
        ),
      );
    } else if (item.type == 'promo') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CreateRequestScreen(
            appState: appState,
            initialCategory: MockRepository.categories.first, // AC Service
          ),
        ),
      );
    } else {
      // General/wallet notification
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${item.title}: ${item.subtitle}'),
          backgroundColor: const Color(0xFF0F766E),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final notifs = appState.notifications;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Notifications & Alerts', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF18181B),
        elevation: 0.5,
        actions: [
          TextButton(
            onPressed: () {
              appState.markAllNotificationsAsRead();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('All alerts marked as read'),
                  backgroundColor: Color(0xFF0F766E),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: const Text('Mark read', style: TextStyle(color: Color(0xFF0F766E), fontWeight: FontWeight.bold)),
          ),
        ],
      ),
      body: notifs.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: const BoxDecoration(
                      color: Color(0xFFF1F5F9),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.notifications_none, size: 48, color: Color(0xFFA1A1AA)),
                  ),
                  const SizedBox(height: 16),
                  const Text('No new alerts', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 4),
                  const Text('All caught up!', style: TextStyle(color: Color(0xFF71717A), fontSize: 13)),
                ],
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: notifs.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final item = notifs[index];
                return InkWell(
                  onTap: () => _onTapNotification(context, item),
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: item.isRead ? const Color(0xFFE4E4E7) : const Color(0xFF0F766E).withOpacity(0.35),
                        width: item.isRead ? 1 : 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 6, offset: const Offset(0, 2)),
                      ],
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: item.isRead ? const Color(0xFFF4F4F5) : const Color(0xFFF0FDFA),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            _getIconForType(item.type),
                            color: item.isRead ? const Color(0xFF71717A) : const Color(0xFF0F766E),
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      item.title,
                                      style: TextStyle(
                                        fontWeight: item.isRead ? FontWeight.w600 : FontWeight.bold,
                                        fontSize: 14,
                                        color: const Color(0xFF18181B),
                                      ),
                                    ),
                                  ),
                                  Text(
                                    item.time,
                                    style: const TextStyle(fontSize: 11, color: Color(0xFFA1A1AA)),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                item.subtitle,
                                style: const TextStyle(fontSize: 12, color: Color(0xFF71717A), height: 1.3),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  Text(
                                    item.type == 'worker' ? 'View Job Details →' : 'Tap to open →',
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: Color(0xFF0F766E),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        if (!item.isRead) ...[
                          const SizedBox(width: 6),
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Color(0xFF0F766E),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  IconData _getIconForType(String type) {
    switch (type) {
      case 'wallet':
        return Icons.account_balance_wallet;
      case 'security':
        return Icons.security;
      case 'promo':
        return Icons.discount;
      default:
        return Icons.notifications;
    }
  }
}
