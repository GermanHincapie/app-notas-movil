import 'package:flutter/material.dart';
import '../models/note.dart';
import '../services/api_service.dart';
import '../services/local_db_service.dart';
import '../services/sync_service.dart';

class NoteFormScreen extends StatefulWidget {
  final Note? note;

  const NoteFormScreen({super.key, this.note});

  @override
  State<NoteFormScreen> createState() => _NoteFormScreenState();
}

class _NoteFormScreenState extends State<NoteFormScreen> {
  final ApiService _apiService = ApiService();
  final LocalDbService _localDbService = LocalDbService();
  final SyncService _syncService = SyncService();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  bool _loading = false;

  @override
  void initState() {
    super.initState();

    if (widget.note != null) {
      _titleController.text = widget.note!.title;
      _contentController.text = widget.note!.content;
    }
  }

  Future<void> _saveNote() async {
    setState(() {
      _loading = true;
    });

    final hasInternet = await _syncService.hasInternetConnection();

    final note = Note(
      id: widget.note?.id,
      userId: widget.note?.userId,
      title: _titleController.text.trim(),
      content: _contentController.text.trim(),
      updatedAt: DateTime.now().toIso8601String(),
      synced: hasInternet ? 1 : 0,
    );

    try {
      if (widget.note == null) {
        if (hasInternet) {
          await _apiService.createNote(note);
        }
        await _localDbService.insertNote(note);
      } else {
        if (hasInternet) {
          await _apiService.updateNote(note);
        }
        await _localDbService.updateNote(note);
      }

      if (!mounted) return;
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al guardar la nota')),
      );
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.note != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Editar nota' : 'Nueva nota'),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                hintText: 'Título',
                prefixIcon: Icon(Icons.title),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: TextField(
                controller: _contentController,
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
                decoration: const InputDecoration(
                  hintText: 'Escribe tu nota aquí...',
                  alignLabelWithHint: true,
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _loading ? null : _saveNote,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: _loading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(isEditing ? 'Actualizar nota' : 'Guardar nota'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}