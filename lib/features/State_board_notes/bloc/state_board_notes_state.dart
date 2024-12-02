part of 'state_board_notes_bloc.dart';

@immutable
sealed class StateBoardNotesState {}

final class StateBoardNotesInitial extends StateBoardNotesState {}

final class StateBoardNotesLoading extends StateBoardNotesState {}

final class StateBoardNotesSuccess extends StateBoardNotesState {
  final StateBoardNotesModel stateBoardNotesData;
  final List<bool> showChildData;

  StateBoardNotesSuccess({
    required this.stateBoardNotesData,
    required this.showChildData,
  });
}

final class StateBoardNotesError extends StateBoardNotesState {}
