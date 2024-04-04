import 'package:currency_converter_app/model/currency_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

@immutable
abstract class CurrencyState1 extends Equatable {}

//currency Loading state
class CurrencyLoadingState extends CurrencyState1 {
  @override
  List<Object?> get props => [];
}

//Currency loaded state
class CurrencyLoadedState extends CurrencyState1 {
  final LatestCurrency currency;
  final List<String> countryCode;

  CurrencyLoadedState(this.currency, this.countryCode);

  @override
  List<Object?> get props => [currency];
}

//Error state
class CurrencyErrorState extends CurrencyState1 {
  final String error;

  CurrencyErrorState(this.error);

  @override
  List<Object?> get props => [error];
}
