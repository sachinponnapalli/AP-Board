part of 'state_board_notes_bloc.dart';

@immutable
sealed class StateBoardNotesEvent {}

final class GetStateBoardNotesData extends StateBoardNotesEvent {
  final String titleHref;

  GetStateBoardNotesData({required this.titleHref});
}

final class ToggleChildVisibility extends StateBoardNotesEvent {
  final int childIndex;

  ToggleChildVisibility({required this.childIndex});
}
