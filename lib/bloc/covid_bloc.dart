import 'package:bloc_demo/bloc/covid_event.dart';
import 'package:bloc_demo/bloc/covid_state.dart';
import 'package:bloc_demo/resources/api_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CovidBloc extends Bloc<CovidEvent, CovidState> {
  CovidBloc() : super(CovidInitial()) {
    final ApiRepository apiRepository = ApiRepository();

    on<GetCovidList>((event, emit) async {
      try {
        emit(CovidLoading());
        final covidList = await apiRepository.fetchCovidList();
        emit(CovidLoaded(covidList));
        if (covidList.error != null) {
          emit(CovidError(covidList.error));
        }
      } on NetworkError {
        emit(const CovidError('Failed to load data. is your device online?'));
      }
    });
  }
}
