import 'dart:async';
import 'package:ap_solutions/features/State_board_notes/data/fetch_state_board_notes.dart';
import 'package:ap_solutions/features/State_board_notes/models/state_board_notes_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';
part 'state_board_notes_event.dart';
part 'state_board_notes_state.dart';

class StateBoardNotesBloc
    extends Bloc<StateBoardNotesEvent, StateBoardNotesState> {
  StateBoardNotesBloc() : super(StateBoardNotesInitial()) {
    on<GetStateBoardNotesData>(getStateBoardNotesData);
    on<ToggleChildVisibility>(toggleChildVisibility);
  }

  List<bool> showChildData = [];

  FutureOr<void> getStateBoardNotesData(
      GetStateBoardNotesData event, Emitter<StateBoardNotesState> emit) async {
    emit(StateBoardNotesLoading());

    try {
      final data = await FetchStateBoardNotes.fetchStateBoardNotes(event.titleHref);

      final modelData = StateBoardNotesModel.fromJson(data);

      showChildData = List<bool>.filled(data['solutions'].length, false);

      emit(StateBoardNotesSuccess(
          stateBoardNotesData: modelData, showChildData: showChildData));
    } catch (e) {
      emit(StateBoardNotesError());
    }
  }

  FutureOr<void> toggleChildVisibility(
      ToggleChildVisibility event, Emitter<StateBoardNotesState> emit) {
    showChildData[event.childIndex] = !showChildData[event.childIndex];
    emit(
      StateBoardNotesSuccess(
        stateBoardNotesData:
            (state as StateBoardNotesSuccess).stateBoardNotesData,
        showChildData: showChildData,
      ),
    );
  }
}
