import 'package:connectivity_plus/connectivity_plus.dart';
import '../models/note.dart';
import 'api_service.dart';
import 'local_db_service.dart';

class SyncService {
  final LocalDbService _localDbService = LocalDbService();
  final ApiService _apiService = ApiService();

  Future<bool> hasInternetConnection() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  Future<void> syncNotes() async {
    final hasConnection = await hasInternetConnection();

    if (!hasConnection) return;

    final unsyncedNotes = await _localDbService.getUnsyncedNotes();

    for (Note note in unsyncedNotes) {
      final success = await _apiService.createNote(note);

      if (success && note.id != null) {
        await _localDbService.markNoteAsSynced(note.id!);
      }
    }
  }

  Future<void> fetchAndStoreRemoteNotes() async {
    final hasConnection = await hasInternetConnection();

    if (!hasConnection) return;

    final remoteNotes = await _apiService.getNotes();

    await _localDbService.clearNotes();

    for (final note in remoteNotes) {
      await _localDbService.insertNote(
        Note(
          id: note.id,
          userId: note.userId,
          title: note.title,
          content: note.content,
          updatedAt: note.updatedAt,
          synced: 1,
        ),
      );
    }
  }
}