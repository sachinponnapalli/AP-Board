import 'dart:async';

import 'package:ap_solutions/features/Intermediate_solutions/data/fetch_intermediate_solutions_data.dart';
import 'package:ap_solutions/features/Intermediate_solutions/models/intermediate_solutions_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';

part 'intermediate_solutions_event.dart';
part 'intermediate_solutions_state.dart';

class IntermediateSolutionsBloc
    extends Bloc<IntermediateSolutionsEvent, IntermediateSolutionsState> {
  IntermediateSolutionsBloc() : super(IntermediateSolutionsInitial()) {
    on<GetIntermediateSolutionsData>(getIntermediateSolutionsData);
    on<ToggleChildVisibility>(toggleChildVisibility);
  }

  List<bool> showChildData = [];

  FutureOr<void> getIntermediateSolutionsData(
      GetIntermediateSolutionsData event,
      Emitter<IntermediateSolutionsState> emit) async {
    emit(IntermediateSolutionsLoading());
    try {
      final data =
          await FetchIntermediateSolutionsData.fetchIntermediateSolutionsData(
              event.titleHref);

      final modelData = IntermediateSolutionsModel.fromJson(data);

      showChildData = List<bool>.filled(modelData.solutions!.length, false);

      emit(
        IntermediateSolutionsSuccess(
          intermediateSolutionsData: modelData,
          showChildData: showChildData,
        ),
      );
    } catch (e) {
      emit(IntermediateSolutionsError());
    }
  }

  FutureOr<void> toggleChildVisibility(
      ToggleChildVisibility event, Emitter<IntermediateSolutionsState> emit) {
    showChildData[event.childIndex] = !showChildData[event.childIndex];

    emit(
      IntermediateSolutionsSuccess(
        intermediateSolutionsData:
            (state as IntermediateSolutionsSuccess).intermediateSolutionsData,
        showChildData: showChildData,
      ),
    );
  }
}
