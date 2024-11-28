import 'dart:async';
import 'package:ap_solutions/core/endpoints.dart';
import 'package:ap_solutions/features/Home/data/fetch_home_data.dart';
import 'package:ap_solutions/features/Home/models/home_model.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    on<GetHomeData>(getHomeData);
  }

  FutureOr<void> getHomeData(GetHomeData event, Emitter<HomeState> emit) async {
    emit(HomeLoading());

    try {
      final parsedBox = Hive.box('parsedDataCache');

      if (parsedBox.containsKey(mainUrl)) {
        final data = parsedBox.get(mainUrl);
        final modelData = HomeModel.fromJson(data);

        emit(HomeSuccess(homeData: modelData));
      } else {
        final data = await FetchHomeData.fetchHomeData(mainUrl);

        final modelData = HomeModel.fromJson(data);

        await parsedBox.put(mainUrl, data);

        emit(HomeSuccess(homeData: modelData));
      }
    } catch (e) {
      // print(e.toString());
      emit(HomeError());
    }
  }
}
