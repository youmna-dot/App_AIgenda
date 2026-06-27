// lib/features/note/domain/note_repository.dart

import '../../../core/models/filter_request.dart';
import '../../../core/models/paginated_response.dart';
import '../data/models/note_model.dart';

abstract class NoteRepository {
  Future<PaginatedResponse<NoteModel>> getNotes(
      int workspaceId,
      String spaceId, {
        FilterRequest filter = const FilterRequest(),
      });

  Future<NoteModel> getNoteById(
      int workspaceId,
      String spaceId,
      String noteId,
      );

  Future<NoteModel> createNote({
    required int workspaceId,
    required String spaceId,
    required String title,
    String type,        // default في الـ impl
    bool isPinned,      // default في الـ impl
    String? plainText,
    String? htmlContent,
    String? richTextJson,
  });

  Future<void> updateNote({
    required int workspaceId,
    required String spaceId,
    required String noteId,
    required String title,
    String type,        // [FIX] مش nullable — متوافق مع data source
    bool isPinned,      // [FIX] مش nullable — متوافق مع data source
    String? plainText,
    String? htmlContent,
    String? richTextJson,
  });

  Future<void> deleteNote(
      int workspaceId,
      String spaceId,
      String noteId,
      );
}