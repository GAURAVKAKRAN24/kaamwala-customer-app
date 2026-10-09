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
    'Gate code is 204.',
    'Please call on arrival.',
    'Do you have genuine copper pipe?',
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
    final assignedWorker = widget.appState.activeJob.assignedWorker;
    final workerName = assignedWorker?.name ?? 'Ramesh Kumar (AC Expert)';
    final workerAvatar = assignedWorker?.avatar ?? 'RK';

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF18181B),
        elevation: 0.5,
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: const Color(0xFF18181B),
              child: Text(
                workerAvatar,
                style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(workerName, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                  const Row(
                    children: [
                      CircleAvatar(radius: 3, backgroundColor: Color(0xFF10B981)),
                      SizedBox(width: 4),
                      Text('Online • In-App Masked Bridge', style: TextStyle(fontSize: 10, color: Color(0xFF0F766E))),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.call, color: Color(0xFF0F766E)),
            tooltip: 'Secure Masked Call',
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => MaskedCallDialog(
                  workerName: workerName,
                  workerPhoto: workerAvatar,
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Privacy banner
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: const Color(0xFFF0FDFA),
            child: const Row(
              children: [
                Icon(Icons.shield_outlined, color: Color(0xFF0F766E), size: 16),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'KaamWala Privacy Guard: Phone numbers are masked for safety.',
                    style: TextStyle(fontSize: 11, color: Color(0xFF0F766E), fontWeight: FontWeight.w600),
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
                      color: msg.isCustomer ? const Color(0xFF0F766E) : Colors.white,
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
                            color: msg.isCustomer ? Colors.white : const Color(0xFF18181B),
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
                                color: msg.isCustomer ? const Color(0xFFCCFBF1) : const Color(0xFFA1A1AA),
                              ),
                            ),
                            if (msg.isCustomer) ...[
                              const SizedBox(width: 4),
                              const Icon(Icons.done_all, size: 12, color: Color(0xFFCCFBF1)),
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
                  side: const BorderSide(color: Color(0xFFE4E4E7)),
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
                      hintStyle: const TextStyle(fontSize: 13, color: Color(0xFFA1A1AA)),
                      filled: true,
                      fillColor: const Color(0xFFF8FAFC),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: const BorderSide(color: Color(0xFFE4E4E7)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: const BorderSide(color: Color(0xFF0F766E), width: 1.5),
                      ),
                    ),
                    onSubmitted: (val) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  radius: 22,
                  backgroundColor: const Color(0xFF0F766E),
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
