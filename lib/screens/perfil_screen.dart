import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'auth_screen.dart';

class PerfilScreen extends StatelessWidget {
  const PerfilScreen({super.key});

  String _initialsFromEmail(String email) {
    final parts = email.split('@').first.split(RegExp(r'[^A-Za-z0-9]+'));
    final initials = parts.where((p) => p.isNotEmpty).map((p) => p[0]).join();
    if (initials.length >= 2) return initials.substring(0, 2).toUpperCase();
    return initials.toUpperCase();
  }

  Future<void> _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    if (context.mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const AuthScreen()),
            (route) => false,
      );
    }
  }

  Widget _tile({
    required BuildContext context,
    required String title,
    required IconData icon,
    String? subtitle,
    Color subtitleColor = Colors.black54,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 2, offset: Offset(0, 1)),
        ],
      ),
      child: ListTile(
        leading: Icon(icon, color: AppTheme.primaryColor),
        title: Text(title),
        subtitle: subtitle == null
            ? null
            : Text(subtitle, style: TextStyle(color: subtitleColor)),
        onTap: () {},
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const Scaffold(body: Center(child: Text('Sin usuario')));
    }

    final userStream = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .snapshots();

    return Scaffold(
      appBar: AppBar(title: const Text('Mi perfil')),
      backgroundColor: AppTheme.gray100,
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: userStream,
        builder: (context, snapshot) {
          final data = snapshot.data?.data();
          final score = (data?['score'] ?? 0).toDouble();

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 16),
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.teal.shade600,
                  child: Text(
                    _initialsFromEmail(user.email ?? ''),
                    style: const TextStyle(color: Colors.white, fontSize: 24),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  user.email ?? '',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 24),
                _tile(
                  context: context,
                  title: 'Mis publicaciones',
                  icon: Icons.list_alt,
                ),
                _tile(
                  context: context,
                  title: 'Me interesa',
                  icon: Icons.favorite,
                ),
                _tile(
                  context: context,
                  title: 'Ranking',
                  icon: Icons.emoji_events,
                  subtitle: 'Puntuación ${score.toStringAsFixed(1)}',
                  subtitleColor: Colors.orange,
                ),
                _tile(
                  context: context,
                  title: 'Información de usuario',
                  icon: Icons.info_outline,
                  subtitle: 'UID: ${user.uid}',
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal.shade600,
                    ),
                    onPressed: () => _logout(context),
                    child: const Text('Cerrar sesión'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}