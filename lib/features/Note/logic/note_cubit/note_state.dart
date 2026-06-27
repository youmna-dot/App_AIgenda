// lib/features/note/logic/note_cubit/note_state.dart

import '../../../../core/models/paginated_response.dart';
import '../../data/models/note_model.dart';

abstract class NoteState {}

class NoteInitial   extends NoteState {}
class NoteLoading   extends NoteState {}
class NoteActionSuccess extends NoteState {}

class NotesSuccess extends NoteState {
  final PaginatedResponse<NoteModel> data;
  NotesSuccess(this.data);
}

class NoteDetailSuccess extends NoteState {
  final NoteModel note;
  NoteDetailSuccess(this.note);
}

class NoteError extends NoteState {
  final String message;
  NoteError(this.message);
}