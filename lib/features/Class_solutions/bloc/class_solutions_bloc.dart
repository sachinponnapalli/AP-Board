import 'dart:async';
import 'package:ap_solutions/features/Class_solutions/data/fetch_class_solutions_data.dart';
import 'package:ap_solutions/features/Class_solutions/models/class_solutions_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

part 'class_solutions_event.dart';
part 'class_solutions_state.dart';

class ClassSolutionsBloc
    extends Bloc<ClassSolutionsEvent, ClassSolutionsState> {
  ClassSolutionsBloc() : super(ClassSolutionsInitial()) {
    on<GetSolutionsData>(getSolutionsData);
    on<ToggleChildVisibility>(toggleChildVisibility);
  }
  List<bool> showChildData = [];

  FutureOr<void> getSolutionsData(
      GetSolutionsData event, Emitter<ClassSolutionsState> emit) async {
    emit(ClassSolutionsLoading());

    try {
      final parsedBox = Hive.box('parsedDataCache');

      if (parsedBox.containsKey(event.titleHref)) {
        final data = parsedBox.get(event.titleHref);

        final modelData = ClassSolutionsModel.fromJson(data);
        showChildData = List<bool>.filled(data['solutions'].length, false);

        emit(ClassSolutionsSuccess(
            classSolutionsData: modelData, showChildData: showChildData));
      } else {
        final data = await FetchClassSolutionsData.fetchClassSolutionsData(
            event.titleHref);

        final modelData = ClassSolutionsModel.fromJson(data);

        showChildData = List<bool>.filled(data['solutions'].length, false);

        await parsedBox.put(event.titleHref, data);

        emit(ClassSolutionsSuccess(
            classSolutionsData: modelData, showChildData: showChildData));
      }
    } catch (e) {
      emit(ClassSolutionsError());
    }
  }

  FutureOr<void> toggleChildVisibility(
      ToggleChildVisibility event, Emitter<ClassSolutionsState> emit) {
    showChildData[event.childIndex] = !showChildData[event.childIndex];

    emit(
      ClassSolutionsSuccess(
        classSolutionsData: (state as ClassSolutionsSuccess).classSolutionsData,
        showChildData: showChildData,
      ),
    );
  }
}
