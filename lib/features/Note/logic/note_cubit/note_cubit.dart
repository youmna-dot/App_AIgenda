// lib/features/note/logic/note_cubit/note_cubit.dart

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/models/filter_request.dart';
import '../../domain/note_repository.dart';
import '../../data/models/note_model.dart';
import 'note_state.dart';

class NoteCubit extends Cubit<NoteState> {
  final NoteRepository repository;

  NoteCubit(this.repository) : super(NoteInitial());

  Future<void> getNotes(
      int workspaceId,
      String spaceId, {
        FilterRequest filter = const FilterRequest(),
      }) async {
    try {
      emit(NoteLoading());
      final result = await repository.getNotes(workspaceId, spaceId, filter: filter);
      emit(NotesSuccess(result));
    } catch (e) {
      emit(NoteError(_handleError(e)));
    }
  }

  Future<void> getNoteById(
      int workspaceId,
      String spaceId,
      String noteId,
      ) async {
    try {
      emit(NoteLoading());
      final note = await repository.getNoteById(workspaceId, spaceId, noteId);
      emit(NoteDetailSuccess(note));
    } catch (e) {
      emit(NoteError(_handleError(e)));
    }
  }

  Future<NoteModel> createNoteAndReturn({
    required int workspaceId,
    required String spaceId,
    required String title,
    String type = 'Text',
    bool isPinned = false,
    String? plainText,
    String? htmlContent,
    String? richTextJson,
  }) async {
    try {
      final note = await repository.createNote(
        workspaceId:  workspaceId,
        spaceId:      spaceId,
        title:        title,
        type:         type,
        isPinned:     isPinned,
        plainText:    plainText,
        htmlContent:  htmlContent,
        richTextJson: richTextJson,
      );
      await getNotes(workspaceId, spaceId);
      return note;
    } catch (e) {
      emit(NoteError(_handleError(e)));
      rethrow;
    }
  }

  Future<void> updateNote({
    required int workspaceId,
    required String spaceId,
    required String noteId,
    required String title,
    String type = 'Text',       // [FIX] مش nullable — الـ data source بيحتاجه دايماً
    bool isPinned = false,      // [FIX] مش nullable
    String? plainText,
    String? htmlContent,
    String? richTextJson,
  }) async {
    try {
      emit(NoteLoading());
      await repository.updateNote(
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
      await getNotes(workspaceId, spaceId);
    } catch (e) {
      emit(NoteError(_handleError(e)));
    }
  }

  Future<void> deleteNote(
      int workspaceId,
      String spaceId,
      String noteId,
      ) async {
    try {
      emit(NoteLoading());
      await repository.deleteNote(workspaceId, spaceId, noteId);
      await getNotes(workspaceId, spaceId);
    } catch (e) {
      emit(NoteError(_handleError(e)));
    }
  }

  Future<void> togglePin({
    required int workspaceId,
    required String spaceId,
    required NoteModel note,
  }) async {
    // [FIX] بنبعت الـ content الموجود مع الـ toggle
    // قبل كده: كان بيبعت updateNote بدون plainText → الـ API بيرفض
    await updateNote(
      workspaceId: workspaceId,
      spaceId:     spaceId,
      noteId:      note.id,
      title:       note.title,
      type:        note.type,
      isPinned:    !note.isPinned,       // ← الـ toggle
      plainText:   note.plainText,       // ← الـ content الموجود
      htmlContent: note.text?.htmlContent,
    );
  }

  String _handleError(dynamic error) => error.toString();
}