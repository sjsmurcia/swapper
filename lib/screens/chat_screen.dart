import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  final String exchangeId;
  const ChatScreen({super.key, required this.exchangeId});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();

  Stream<QuerySnapshot<Map<String, dynamic>>> get _messagesStream =>
      FirebaseFirestore.instance
          .collection('exchanges')
          .doc(widget.exchangeId)
          .collection('messages')
          .orderBy('timestamp')
          .snapshots();

  Stream<DocumentSnapshot<Map<String, dynamic>>> get _statusStream =>
      FirebaseFirestore.instance
          .collection('exchanges')
          .doc(widget.exchangeId)
          .snapshots();

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;
    await FirebaseFirestore.instance
        .collection('exchanges')
        .doc(widget.exchangeId)
        .collection('messages')
        .add({
      'text': text,
      'senderId': uid,
      'timestamp': FieldValue.serverTimestamp(),
    });
    _messageController.clear();
    _scrollToBottom();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: _statusStream,
          builder: (context, snapshot) {
            final data = snapshot.data?.data();
            final status = data?['status'] == 'typing'
                ? 'Escribiendo…'
                : 'En línea';
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Chat de intercambio'),
                Text(
                  status,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: Colors.white70),
                ),
              ],
            );
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: _messagesStream,
              builder: (context, snapshot) {
                final messages = snapshot.data?.docs ?? [];
                _scrollToBottom();
                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final msg = messages[index].data();
                    final isMe = msg['senderId'] ==
                        FirebaseAuth.instance.currentUser?.uid;
                    final alignment =
                    isMe ? Alignment.centerRight : Alignment.centerLeft;
                    final bgColor = isMe
                        ? Colors.teal.shade600
                        : Colors.grey.shade200;
                    final textColor = isMe ? Colors.white : Colors.black;
                    return Container(
                      alignment: alignment,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: bgColor,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          msg['text'] ?? '',
                          style: TextStyle(color: textColor),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration:
                    const InputDecoration(hintText: 'Escribe un mensaje'),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  color: Colors.orange,
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}