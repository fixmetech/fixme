import 'package:fixme/features/technician_profile/controller/technician_message_controller.dart';
import 'package:flutter/material.dart';

class TechnicianMessagePopup extends StatefulWidget {
  final String technicianName;

  const TechnicianMessagePopup({
    Key? key,
    required this.technicianName,
  }) : super(key: key);

  @override
  State<TechnicianMessagePopup> createState() => _TechnicianMessagePopupState();
}

class _TechnicianMessagePopupState extends State<TechnicianMessagePopup> {
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> _messages = [];
  late final TechnicianMessageController _chatController;
  final String chatId = "1"; // You should set this appropriately!
  final String senderId = "llDbEONrE3aq376BBuqIXE0Vev73";

  @override
  void initState() {
    super.initState();
    _chatController = TechnicianMessageController();
    _loadMessages();
  }

  void _loadMessages() async {
    try {
      final messages = await _chatController.fetchMessages(chatId);
      setState(() {
        _messages.clear();
        _messages.addAll(messages.map((msg) => ChatMessage(
          message: msg['text'] ?? '',
          sender: msg['senderId'] == senderId ? "You" : widget.technicianName,
          timestamp: _formatTimestamp(msg['timestamp']),
          isMe: msg['senderId'] == senderId,
        )));
      });
    } catch (e) {
      // Optionally, show error in UI
    }
  }

  String _formatTimestamp(dynamic millis) {
    if (millis == null) return "";
    final dt = DateTime.fromMillisecondsSinceEpoch(millis is int ? millis : int.tryParse(millis.toString()) ?? 0);
    return "${dt.hour}:${dt.minute.toString().padLeft(2, '0')}";
  }


  void _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    try {
      await _chatController.sendMessage(chatId, senderId, text);
      _messageController.clear();
      _loadMessages(); // Refresh messages after sending
    } catch (e) {
      // Optionally, show error in UI
    }
  }


  String _getCurrentTime() {
    final now = DateTime.now();
    return "${now.hour}:${now.minute.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: BoxDecoration(
          color: Colors.blue[25],
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue[700],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.blue[100],
                    child: Text(
                      widget.technicianName[0].toUpperCase(),
                      style: TextStyle(
                        color: Colors.blue[800],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.technicianName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "Technical Support",
                          style: TextStyle(
                            color: Colors.blue[100],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            // Messages List
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  return _messages[index];
                },
              ),
            ),
            // Message Input
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
                border: Border(
                  top: BorderSide(color: Colors.blue[200]!),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: "Type a message...",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide(color: Colors.blue[300]!),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide(color: Colors.blue[600]!),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  FloatingActionButton(
                    mini: true,
                    backgroundColor: Colors.blue[600],
                    onPressed: _sendMessage,
                    child: const Icon(Icons.send, color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }
}

class ChatMessage extends StatelessWidget {
  final String message;
  final String sender;
  final String timestamp;
  final bool isMe;

  const ChatMessage({
    Key? key,
    required this.message,
    required this.sender,
    required this.timestamp,
    required this.isMe,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isMe) ...[
            CircleAvatar(
              radius: 16,
              backgroundColor: Colors.blue[100],
              child: Text(
                sender[0].toUpperCase(),
                style: TextStyle(
                  color: Colors.blue[800],
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              decoration: BoxDecoration(
                color: isMe ? Colors.blue[600] : Colors.blue[50],
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: isMe ? const Radius.circular(16) : const Radius.circular(4),
                  bottomRight: isMe ? const Radius.circular(4) : const Radius.circular(16),
                ),
                border: Border.all(
                  color: Colors.blue[200]!,
                  width: 1,
                ),
              ),
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message,
                    style: TextStyle(
                      color: isMe ? Colors.white : Colors.blue[900],
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    timestamp,
                    style: TextStyle(
                      color: isMe ? Colors.blue[100] : Colors.blue[400],
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isMe) ...[
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 16,
              backgroundColor: Colors.blue[700],
              child: const Text(
                'Y',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}