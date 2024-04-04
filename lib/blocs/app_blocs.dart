import 'package:currency_converter_app/blocs/app_events.dart';
import 'package:currency_converter_app/blocs/app_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import '../repository/currency_repository.dart';

class CurrencyBloc extends Bloc<CurrencyEvents, CurrencyState1> {
  final CurrencyRepository _currencyRepository;

  CurrencyBloc(this._currencyRepository) : super(CurrencyLoadingState()) {
    on<LoadCurrencyEvent>((event, emit) async {
      emit(CurrencyLoadingState());
      try {
        final currency = await _currencyRepository.getCurrency(http.Client());
        final countryCode = await _currencyRepository.getCurrencyTypes();
        emit(CurrencyLoadedState(currency, countryCode));
      } catch (e) {
        emit(CurrencyErrorState(e.toString()));
      }
    });
  }
}
