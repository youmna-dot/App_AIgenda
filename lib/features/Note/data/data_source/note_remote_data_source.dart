// lib/features/note/data/data_source/note_remote_data_source.dart

import 'package:dio/dio.dart';

import '../../../../core/models/filter_request.dart';
import '../../../../core/models/paginated_response.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/api_keys.dart';
import '../../../../core/network/api_service.dart';
import '../models/note_model.dart';

class NoteRemoteDataSource {
  final ApiService apiService;

  NoteRemoteDataSource(this.apiService);

  Future<PaginatedResponse<NoteModel>> getNotes(
      int workspaceId,
      String spaceId, {
        FilterRequest filter = const FilterRequest(),
      }) async {
    final data = await apiService.get(
      ApiEndpoints.notes(workspaceId, spaceId),
      queryParameters: filter.toQueryParams(),
    );
    return PaginatedResponse.fromJson(data, NoteModel.fromJson);
  }

  Future<NoteModel> getNoteById(
      int workspaceId,
      String spaceId,
      String noteId,
      ) async {
    final data = await apiService.get(
      ApiEndpoints.noteById(workspaceId, spaceId, noteId),
    );
    return NoteModel.fromJson(data);
  }

  Future<NoteModel> createNote({
    required int workspaceId,
    required String spaceId,
    required String title,
    String type = 'Text',
    bool isPinned = false,
    String? plainText,
    String? htmlContent,
    String? richTextJson,
  }) async {
    final effectivePlain = plainText ?? '';
    final effectiveHtml  = htmlContent ?? _toHtml(effectivePlain);

    final formData = FormData.fromMap({
      ApiKeys.noteTitle:    title,
      ApiKeys.noteType:     type,
      ApiKeys.noteIsPinned: isPinned.toString(),

      if (type == 'Text') ...{
        // كلاهما required من الـ API — بنبعتهم دايماً حتى لو فاضيين
        ApiKeys.notePlainText:    effectivePlain,
        ApiKeys.noteHtmlContent:  effectiveHtml,
        if (richTextJson != null)
          ApiKeys.noteRichTextJson: richTextJson,
      },
    });

    final data = await apiService.post(
      ApiEndpoints.notes(workspaceId, spaceId),
      data: formData,
    );
    return NoteModel.fromJson(data);
  }

  Future<void> updateNote({
    required int workspaceId,
    required String spaceId,
    required String noteId,
    required String title,
    String type = 'Text',
    bool isPinned = false,
    String? plainText,
    String? htmlContent,
    String? richTextJson,
  }) async {
    final effectivePlain = plainText ?? '';
    final effectiveHtml  = htmlContent ?? _toHtml(effectivePlain);

    final formData = FormData.fromMap({
      ApiKeys.noteTitle:    title,
      ApiKeys.noteType:     type,
      ApiKeys.noteIsPinned: isPinned.toString(),

      if (type == 'Text') ...{
        ApiKeys.notePlainText:    effectivePlain,
        ApiKeys.noteHtmlContent:  effectiveHtml,
        if (richTextJson != null)
          ApiKeys.noteRichTextJson: richTextJson,
      },
    });

    await apiService.put(
      ApiEndpoints.noteById(workspaceId, spaceId, noteId),
      data: formData,
    );
  }

  Future<void> deleteNote(
      int workspaceId,
      String spaceId,
      String noteId,
      ) async {
    await apiService.delete(
      ApiEndpoints.noteById(workspaceId, spaceId, noteId),
    );
  }

  static String _toHtml(String text) {
    if (text.isEmpty) return '<p></p>';
    return text.split('\n').map((l) => '<p>${_esc(l)}</p>').join();
  }

  static String _esc(String t) => t
      .replaceAll('&', '&amp;')
      .replaceAll('<', '&lt;')
      .replaceAll('>', '&gt;')
      .replaceAll('"', '&quot;');
}