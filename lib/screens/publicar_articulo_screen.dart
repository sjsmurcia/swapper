import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../theme/app_theme.dart';

class PublicarArticuloScreen extends StatefulWidget {
  const PublicarArticuloScreen({super.key});

  @override
  State<PublicarArticuloScreen> createState() => _PublicarArticuloScreenState();
}

class _PublicarArticuloScreenState extends State<PublicarArticuloScreen> {
  final _formKey = GlobalKey<FormState>();
  final _tituloController = TextEditingController();
  final _descripcionController = TextEditingController();
  String? _categoria;
  XFile? _imagen;
  bool _loading = false;

  @override
  void dispose() {
    _tituloController.dispose();
    _descripcionController.dispose();
    super.dispose();
  }

  Future<void> _seleccionarImagen() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _imagen = picked;
      });
    }
  }

  Future<void> _publicar() async {
    if (!_formKey.currentState!.validate() || _imagen == null) return;
    setState(() => _loading = true);
    try {
      final ref = FirebaseStorage.instance
          .ref('articulos/${DateTime.now().millisecondsSinceEpoch}_${_imagen!.name}');
      await ref.putFile(File(_imagen!.path));
      final url = await ref.getDownloadURL();

      await FirebaseFirestore.instance.collection('articulos').add({
        'titulo': _tituloController.text.trim(),
        'descripcion': _descripcionController.text.trim(),
        'categoria': _categoria,
        'imagen': url,
        'fecha': FieldValue.serverTimestamp(),
      });

      if (mounted) Navigator.of(context).pop();
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Publicar artículo')),
      body: SingleChildScrollView(
        padding: AppTheme.horizontalPadding,
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              GestureDetector(
                onTap: _loading ? null : _seleccionarImagen,
                child: Container(
                  height: 180,
                  width: double.infinity,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppTheme.gray200,
                    borderRadius: BorderRadius.circular(AppTheme.borderRadius),
                  ),
                  child: _imagen == null
                      ? const Text('Subir foto')
                      : Image.file(File(_imagen!.path), fit: BoxFit.cover),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _tituloController,
                decoration: const InputDecoration(labelText: 'Título'),
                validator: (value) =>
                value == null || value.isEmpty ? 'Ingresa un título' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descripcionController,
                decoration: const InputDecoration(labelText: 'Descripción'),
                maxLines: 3,
                validator: (value) => value == null || value.isEmpty
                    ? 'Ingresa una descripción'
                    : null,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _categoria,
                decoration: const InputDecoration(labelText: 'Categoría'),
                items: const [
                  DropdownMenuItem(value: 'Ropa', child: Text('Ropa')),
                  DropdownMenuItem(value: 'Herramientas', child: Text('Herramientas')),
                  DropdownMenuItem(value: 'Equipos', child: Text('Equipos')),
                  DropdownMenuItem(value: 'Electrodomésticos', child: Text('Electrodomésticos')),
                  DropdownMenuItem(value: 'Otros', child: Text('Otros')),
                ],
                onChanged: _loading
                    ? null
                    : (value) {
                  setState(() {
                    _categoria = value;
                  });
                },
                validator: (value) => value == null ? 'Selecciona una categoría' : null,
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal.shade600,
                    disabledBackgroundColor: Colors.teal.shade200,
                  ),
                  onPressed: _loading ? null : _publicar,
                  child: _loading
                      ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                      : const Text('Publicar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}