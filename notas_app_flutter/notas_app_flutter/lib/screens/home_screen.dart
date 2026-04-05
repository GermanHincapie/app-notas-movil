import 'package:flutter/material.dart';
import '../models/note.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';
import '../services/local_db_service.dart';
import '../services/sync_service.dart';
import 'login_screen.dart';
import 'note_form_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService _apiService = ApiService();
  final AuthService _authService = AuthService();
  final LocalDbService _localDbService = LocalDbService();
  final SyncService _syncService = SyncService();

  List<Note> notes = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    setState(() {
      loading = true;
    });

    try {
      final hasInternet = await _syncService.hasInternetConnection();

      if (hasInternet) {
        await _syncService.syncNotes();
        await _syncService.fetchAndStoreRemoteNotes();
      }

      final localNotes = await _localDbService.getNotes();

      if (!mounted) return;
      setState(() {
        notes = localNotes;
      });
    } catch (e) {
      try {
        final localNotes = await _localDbService.getNotes();

        if (!mounted) return;
        setState(() {
          notes = localNotes;
        });
      } catch (_) {
        if (!mounted) return;
      }
    } finally {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    }
  }

  Future<void> _deleteNote(int id) async {
    bool deletedOnline = false;

    try {
      deletedOnline = await _apiService.deleteNote(id);
    } catch (_) {
      deletedOnline = false;
    }

    await _localDbService.deleteNote(id);

    if (!mounted) return;

    if (!deletedOnline) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Nota eliminada localmente'),
        ),
      );
    }

    await _loadNotes();
  }

  Future<void> _logout() async {
    await _authService.logout();

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis notas'),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: _loadNotes,
            icon: const Icon(Icons.refresh),
          ),
          IconButton(
            onPressed: _logout,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : notes.isEmpty
              ? const Center(
                  child: Text(
                    'No tienes notas aún',
                    style: TextStyle(fontSize: 18),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadNotes,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: notes.length,
                    itemBuilder: (context, index) {
                      final note = notes[index];

                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        elevation: 3,
                        margin: const EdgeInsets.only(bottom: 14),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16),
                          title: Text(
                            note.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(note.content),
                                const SizedBox(height: 6),
                                Text(
                                  note.synced == 1
                                      ? 'Sincronizada'
                                      : 'Pendiente de sincronizar',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: note.synced == 1
                                        ? Colors.green
                                        : Colors.orange,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteNote(note.id!),
                          ),
                          onTap: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => NoteFormScreen(note: note),
                              ),
                            );

                            if (result == true) {
                              _loadNotes();
                            }
                          },
                        ),
                      );
                    },
                  ),
                ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const NoteFormScreen()),
          );

          if (result == true) {
            _loadNotes();
          }
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}