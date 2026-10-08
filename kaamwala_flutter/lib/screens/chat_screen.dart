import 'package:flutter/material.dart';
import '../services/app_state.dart';
import '../widgets/masked_call_dialog.dart';

class ChatScreen extends StatefulWidget {
  final AppState appState;

  const ChatScreen({
    super.key,
    required this.appState,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _msgController = TextEditingController();

  final List<String> _quickReplies = [
    'Are you on the way?',
    'Please call when you reach the gate.',
    'I am at Flat 402, 4th floor.',
    'Do you need a ladder or stool?',
  ];

  @override
  void dispose() {
    _msgController.dispose();
    super.dispose();
  }

  void _sendMessage([String? quickText]) {
    final text = quickText ?? _msgController.text;
    if (text.trim().isEmpty) return;
    widget.appState.addMessage(text);
    _msgController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final assignedWorker = widget.appState.activeJob.selectedWorker;
    final workerName = assignedWorker?.workerName ?? 'Manoj Kumar (Technician)';

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF1E293B),
        elevation: 0.5,
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: const Color(0xFF059669).withOpacity(0.15),
              child: const Icon(Icons.person, color: Color(0xFF059669), size: 22),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(workerName, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                  const Row(
                    children: [
                      CircleAvatar(radius: 3, backgroundColor: Color(0xFF059669)),
                      SizedBox(width: 4),
                      Text('Online • In-App Masked Bridge', style: TextStyle(fontSize: 10, color: Color(0xFF059669))),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.call, color: Color(0xFF059669)),
            tooltip: 'Secure Masked Call',
            onPressed: () {
              if (assignedWorker != null) {
                showDialog(
                  context: context,
                  builder: (context) => MaskedCallDialog(
                    workerName: assignedWorker.workerName,
                    workerPhoto: assignedWorker.workerPhoto,
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('No technician assigned yet to call.')),
                );
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Privacy banner
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: const Color(0xFFECFDF5),
            child: const Row(
              children: [
                Icon(Icons.shield_outlined, color: Color(0xFF059669), size: 16),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'KaamWala Privacy Guard: Phone numbers are masked for your safety.',
                    style: TextStyle(fontSize: 11, color: Color(0xFF065F46), fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ),

          // Messages List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: widget.appState.messages.length,
              itemBuilder: (context, index) {
                final msg = widget.appState.messages[index];
                return Align(
                  alignment: msg.isCustomer ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.78),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: msg.isCustomer ? const Color(0xFF059669) : Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(16),
                        topRight: const Radius.circular(16),
                        bottomLeft: Radius.circular(msg.isCustomer ? 16 : 4),
                        bottomRight: Radius.circular(msg.isCustomer ? 4 : 16),
                      ),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 4, offset: const Offset(0, 1)),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: msg.isCustomer ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                      children: [
                        Text(
                          msg.text,
                          style: TextStyle(
                            color: msg.isCustomer ? Colors.white : const Color(0xFF1E293B),
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              msg.time,
                              style: TextStyle(
                                fontSize: 10,
                                color: msg.isCustomer ? Colors.white70 : Colors.grey.shade500,
                              ),
                            ),
                            if (msg.isCustomer) ...[
                              const SizedBox(width: 4),
                              const Icon(Icons.done_all, size: 12, color: Colors.white70),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Quick Replies Chips
          SizedBox(
            height: 38,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _quickReplies.length,
              separatorBuilder: (context, index) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final reply = _quickReplies[index];
                return ActionChip(
                  label: Text(reply, style: const TextStyle(fontSize: 11)),
                  backgroundColor: Colors.white,
                  side: BorderSide(color: Colors.grey.shade300),
                  onPressed: () => _sendMessage(reply),
                );
              },
            ),
          ),
          const SizedBox(height: 8),

          // Message Input Field
          Container(
            padding: const EdgeInsets.fromLTRB(16, 6, 16, 16),
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _msgController,
                    decoration: InputDecoration(
                      hintText: 'Type your message...',
                      hintStyle: TextStyle(fontSize: 14, color: Colors.grey.shade400),
                      filled: true,
                      fillColor: const Color(0xFFF1F5F9),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onSubmitted: (val) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  radius: 22,
                  backgroundColor: const Color(0xFF059669),
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white, size: 18),
                    onPressed: () => _sendMessage(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
