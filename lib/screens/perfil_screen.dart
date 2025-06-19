import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'auth_screen.dart';

import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';

class PerfilScreen extends StatelessWidget {
  const PerfilScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: AppBar(
          backgroundColor: Colors.teal[600],
          elevation: 0,
          leading: const Padding(
            padding: EdgeInsets.only(left: 16.0),
            child: Icon(
              Icons.arrow_back,
              size: 24,
              color: Colors.white,
            ),
          ),
          title: const Text(
            'Mi perfil',
            style: TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600,
              fontSize: 20,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
        ),
      ),
      body: Column(
        children: [
          // Header
          Container(
            height: 240,
            width: double.infinity,
            color: Colors.teal[600],
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.white,
                  child: const Text(
                    'AU',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                      fontSize: 36,
                      color: Colors.grey,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'usuario@ejemplo.com',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          // List of options overlapped using Transform
          Transform.translate(
            offset: const Offset(0, -32),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  _buildOption(
                    icon: Icons.list_alt,
                    iconColor: Colors.grey[700]!,
                    title: 'Mis pedidos',
                    onTap: () {},
                  ),
                  _buildOption(
                    icon: Icons.favorite,
                    iconColor: Colors.grey[700]!,
                    title: 'Favoritos',
                    onTap: () {},
                  ),
                  _buildOption(
                    icon: Icons.emoji_events,
                    iconColor: Colors.orange,
                    title: 'Ranking',
                    subtitle: 'Ver tu posición en el ranking',
                    onTap: () {},
                  ),
                  _buildOption(
                    icon: Icons.info_outline,
                    iconColor: Colors.grey[700]!,
                    title: 'Información',
                    subtitle: 'Información de la aplicación',
                    onTap: () {},
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal[600],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Cerrar sesión',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOption({
    required IconData icon,
    required Color iconColor,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: Icon(
          icon,
          size: 24,
          color: iconColor,
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
        subtitle: subtitle != null
            ? Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Text(
            subtitle,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
        )
            : null,
        trailing: const Icon(
          Icons.chevron_right,
          size: 24,
          color: Colors.grey,
        ),
        onTap: onTap,
      ),
    );
  }
}
