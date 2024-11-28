import 'dart:async';
import 'package:ap_solutions/features/SCERT_books/data/scert_books_data.dart';
import 'package:ap_solutions/features/SCERT_books/models/scert_books_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';

part 'scert_books_event.dart';
part 'scert_books_state.dart';

class ScertBooksBloc extends Bloc<ScertBooksEvent, ScertBooksState> {
  ScertBooksBloc() : super(ScertBooksInitial()) {
    on<GetScertBooksData>(getScertBooksData);
    on<ToggleChapterVisibilty>(toggleChapterVisibilty);
    on<ToggleSubChapterVisibilty>(toggleSubChapterVisibilty);
  }

  List<bool> showChapters = [];
  List<List<bool>> showSubChapters = [];

  FutureOr<void> getScertBooksData(
      GetScertBooksData event, Emitter<ScertBooksState> emit) async {
    emit(ScertBooksLoading());

    try {
      final data = await FetchScertBooksData.fetchScertBooksData();

      final modelData = ScertBooksModel.fromJson(data);

      showChapters = List<bool>.filled(modelData.data!.length, false);

      showSubChapters = List<List<bool>>.generate(
        modelData.data!.length,
        (index) => List<bool>.filled(
          modelData.data![index].solutions!.length,
          false,
        ),
      );

      emit(ScertBooksSuccess(
          scertData: modelData,
          showChapters: showChapters,
          showSubChapters: showSubChapters));
    } catch (e) {
      print(e.toString());
      emit(ScertBooksError());
    }
  }

  FutureOr<void> toggleChapterVisibilty(
      ToggleChapterVisibilty event, Emitter<ScertBooksState> emit) {
    showChapters[event.index] = !showChapters[event.index];
    emit(
      ScertBooksSuccess(
          scertData: (state as ScertBooksSuccess).scertData,
          showChapters: showChapters,
          showSubChapters: showSubChapters),
    );
  }

  FutureOr<void> toggleSubChapterVisibilty(
      ToggleSubChapterVisibilty event, Emitter<ScertBooksState> emit) {
    showSubChapters[event.chapterIndex][event.subChapterIndex] =
        !showSubChapters[event.chapterIndex][event.subChapterIndex];

    emit(
      ScertBooksSuccess(
          scertData: (state as ScertBooksSuccess).scertData,
          showChapters: showChapters,
          showSubChapters: showSubChapters),
    );
  }
}
