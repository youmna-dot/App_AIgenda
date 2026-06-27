// lib/features/note/data/repositories/note_repository_impl.dart

import '../../../../core/models/filter_request.dart';
import '../../../../core/models/paginated_response.dart';
import '../../domain/note_repository.dart';
import '../data_source/note_remote_data_source.dart';
import '../models/note_model.dart';

class NoteRepositoryImpl implements NoteRepository {
  final NoteRemoteDataSource remote;

  NoteRepositoryImpl(this.remote);

  @override
  Future<PaginatedResponse<NoteModel>> getNotes(
      int workspaceId,
      String spaceId, {
        FilterRequest filter = const FilterRequest(),
      }) => remote.getNotes(workspaceId, spaceId, filter: filter);

  @override
  Future<NoteModel> getNoteById(
      int workspaceId,
      String spaceId,
      String noteId,
      ) => remote.getNoteById(workspaceId, spaceId, noteId);

  @override
  Future<NoteModel> createNote({
    required int workspaceId,
    required String spaceId,
    required String title,
    String type = 'Text',
    bool isPinned = false,
    String? plainText,
    String? htmlContent,
    String? richTextJson,
  }) => remote.createNote(
    workspaceId:  workspaceId,
    spaceId:      spaceId,
    title:        title,
    type:         type,
    isPinned:     isPinned,
    plainText:    plainText,
    htmlContent:  htmlContent,
    richTextJson: richTextJson,
  );

  @override
  Future<void> updateNote({
    required int workspaceId,
    required String spaceId,
    required String noteId,
    required String title,
    String type = 'Text',      // [FIX] مش nullable
    bool isPinned = false,     // [FIX] مش nullable
    String? plainText,
    String? htmlContent,
    String? richTextJson,
  }) => remote.updateNote(
    workspaceId:  workspaceId,
    spaceId:      spaceId,
    noteId:       noteId,
    title:        title,
    type:         type,
    isPinned:     isPinned,
    plainText:    plainText,
    htmlContent:  htmlContent,
    richTextJson: richTextJson,
  );

  @override
  Future<void> deleteNote(
      int workspaceId,
      String spaceId,
      String noteId,
      ) => remote.deleteNote(workspaceId, spaceId, noteId);
}