import 'dart:async';
import 'dart:io';
import 'package:ap_solutions/features/Chapters/data/fetch_chapters_data.dart';
import 'package:ap_solutions/features/Chapters/models/chapters_model.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';

part 'chapters_event.dart';
part 'chapters_state.dart';

class ChaptersBloc extends Bloc<ChaptersEvent, ChaptersState> {
  ChaptersBloc() : super(ChaptersInitial()) {
    on<GetChaptersData>(getChaptersData);
    on<ToggleSubChapterVisibility>(toggleSubChapterVisibility);
  }

  List<bool> chapterParts = [];

  FutureOr<void> getChaptersData(
      GetChaptersData event, Emitter<ChaptersState> emit) async {
    emit(ChaptersLoading());
    try {
      final parsedBox = Hive.box('parsedDataCache');

      if (parsedBox.containsKey(event.titleHref)) {
        final data = parsedBox.get(event.titleHref);
        final modelData = ChaptersModel.fromJson(data);

        if (modelData.solutions!.length > 1) {
          chapterParts = List<bool>.filled(modelData.solutions!.length, false);
          emit(ChaptersSucesss(
              chapterData: modelData, chapterParts: chapterParts));
        } else {
          emit(ChaptersSucesss(chapterData: modelData, chapterParts: null));
        }
      } else {
        final data = await FetchChaptersData.fetchChapters(event.titleHref);

        final modelData = ChaptersModel.fromJson(data);
        chapterParts = List<bool>.filled(data['solutions'].length, false);

        emit(ChaptersSucesss(
            chapterData: modelData, chapterParts: chapterParts));
      }
    } on SocketException catch (e) {
      emit(NoInternetConnection(screenName: e.toString()));
    } catch (e) {
      debugPrint(e.toString());
      emit(ChaptersError());
    }
  }

  FutureOr<void> toggleSubChapterVisibility(
      ToggleSubChapterVisibility event, Emitter<ChaptersState> emit) {
    chapterParts[event.index] = !chapterParts[event.index];

    emit(
      ChaptersSucesss(
          chapterData: (state as ChaptersSucesss).chapterData,
          chapterParts: chapterParts),
    );
  }
}
