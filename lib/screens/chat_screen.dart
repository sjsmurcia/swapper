import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatExchangeScreen extends StatefulWidget {
  const ChatExchangeScreen({Key? key}) : super(key: key);

  @override
  _ChatExchangeScreenState createState() => _ChatExchangeScreenState();
}

class _ChatExchangeScreenState extends State<ChatExchangeScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<_ChatMessage> _messages = [
    // TODO: Replace with real message data
    _ChatMessage(text: 'Hola, ¿cómo estás?', isMine: false),
    _ChatMessage(text: 'Bien, gracias. ¿Y tú?', isMine: true),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: AppBar(
          backgroundColor: Colors.teal.shade600,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, size: 24, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            'Chat de intercambio',
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          actions: [
            Center(
              child: Text(
                'En línea', // Cambiar a 'Escribiendo…' según estado
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.7),
                ),
              ),
            ),
            const SizedBox(width: 16),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Container(
                color: Colors.grey[100],
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListView.builder(
                  reverse: true,
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    final msg = _messages[_messages.length - 1 - index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Align(
                        alignment: msg.isMine ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          decoration: BoxDecoration(
                            color: msg.isMine ? Colors.teal.shade600 : Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                          child: Text(
                            msg.text,
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              color: msg.isMine ? Colors.white : Colors.grey.shade900,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                height: 56,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        decoration: InputDecoration(
                          hintText: 'Escribe un mensaje',
                          hintStyle: GoogleFonts.inter(
                            fontSize: 16,
                            color: Colors.grey.shade700,
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                        ),
                        style: GoogleFonts.inter(fontSize: 16, color: Colors.black),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.send, size: 24),
                      color: const Color(0xFFFFB74D),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      onPressed: () {
                        final text = _controller.text.trim();
                        if (text.isNotEmpty) {
                          setState(() {
                            _messages.add(_ChatMessage(text: text, isMine: true));
                          });
                          _controller.clear();
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChatMessage {
  final String text;
  final bool isMine;
  _ChatMessage({required this.text, required this.isMine});
}
