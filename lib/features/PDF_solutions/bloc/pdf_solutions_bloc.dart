import 'dart:async';

import 'package:ap_solutions/core/utils/show_toast.dart';
import 'package:ap_solutions/features/PDF_solutions/models/chapters_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/adapters.dart';

part 'pdf_solutions_event.dart';
part 'pdf_solutions_state.dart';

class PdfSolutionsBloc extends Bloc<PdfSolutionsEvent, PdfSolutionsState> {
  PdfSolutionsBloc() : super(PdfSolutionsInitial()) {
    on<PdfLoadedSuccess>(pdfLoadedSuccess);
    on<ToggleBookmark>(toggleBookmark);
    on<CheckBookmark>(checkBookmark);
  }

  FutureOr<void> pdfLoadedSuccess(
      PdfLoadedSuccess event, Emitter<PdfSolutionsState> emit) {
    emit(PdfSolutionsSuccess());
  }

  FutureOr<void> checkBookmark(
      CheckBookmark event, Emitter<PdfSolutionsState> emit) {
    final bookmarkBox = Hive.box('bookmark');
    bool isBookmarked = bookmarkBox.containsKey(event.chapter.chapterHref);

    if (isBookmarked) {
      emit(Bookmarked());
    } else {
      emit(NotBookmarked());
    }
  }

  FutureOr<void> toggleBookmark(
      ToggleBookmark event, Emitter<PdfSolutionsState> emit) async {
    final bookmarkBox = Hive.box('bookmark');

    if (bookmarkBox.containsKey(event.chapter.chapterHref)) {
      await bookmarkBox.delete(event.chapter.chapterHref);
      showToast("Bookmark Removed", 3);

      emit(NotBookmarked());
    } else {
      await bookmarkBox.put(event.chapter.chapterHref, event.chapter.toMap());
      showToast("Bookmark Added", 3);

      emit(Bookmarked());
    }
  }
}
