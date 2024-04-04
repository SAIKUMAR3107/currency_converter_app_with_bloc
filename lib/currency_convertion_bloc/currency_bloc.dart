import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import '../repository/currency_repository.dart';
import 'currency_event.dart';
import 'currency_state.dart';
import 'package:flutter_tts/flutter_tts.dart';

class CurrencyConverterUSBloc
    extends Bloc<CurrencyEvent, UpdatedCurrencyState> {
  final CurrencyRepository _currencyRepository;

  CurrencyConverterUSBloc(this._currencyRepository)
      : super(UpdatedCurrencyState()) {
    on<OnButtonClickEvent>(_currencyState);
    on<OnConverterClickEvent>(_currencyToState);
  }

  void _currencyState(
      OnButtonClickEvent event, Emitter<UpdatedCurrencyState> emit) async {
    var value = await _currencyRepository.getCurrency(http.Client());
    var finalPrice = value.rates["${event.currencyType}"]! * event.usDollar!;
    var finalCurrencyType = "";
    var karthik = await _currencyRepository.countryCode;
    karthik.forEach((element) {
      if (element.contains(event.currencyType!)) {
        finalCurrencyType = element.substring(0, element.indexOf("("));
      }
    });
    var speakText = event.usDollar.toString() +
        " USD = " +
        finalPrice.toStringAsFixed(2) +
        " $finalCurrencyType";
    emit(state.copyWith(currency: finalPrice));
    await FlutterTts().setLanguage("en-US");
    await FlutterTts().setVolume(0.5);
    await FlutterTts().setPitch(1);
    await FlutterTts().speak(speakText);
  }

  void _currencyToState(
      OnConverterClickEvent event, Emitter<UpdatedCurrencyState> emit) async {
    var value = await _currencyRepository.getCurrency(http.Client());
    var finalCurrencyType = "";
    var karthik = await _currencyRepository.countryCode;
    karthik.forEach((element) {
      if (element.contains(event.currencyToType!)) {
        finalCurrencyType = element.substring(0, element.indexOf("("));
      }
    });
    var finalValue = event.amount! /
        value.rates["${event.currencyFromType}"]! *
        value.rates["${event.currencyToType}"]!;
    var speakText = event.amount!.toString() +
        " ${event.currencyFromType} = " +
        finalValue.toStringAsFixed(4) +
        " $finalCurrencyType";
    emit(state.copyWith(anyCurrency: finalValue));
    await FlutterTts().setLanguage("en-US");
    await FlutterTts().setVolume(0.5);
    await FlutterTts().setPitch(1);
    await FlutterTts().speak(speakText);
  }
}
