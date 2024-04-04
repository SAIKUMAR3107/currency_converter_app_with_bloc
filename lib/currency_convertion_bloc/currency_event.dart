import 'package:equatable/equatable.dart';

abstract class CurrencyEvent extends Equatable {}

class OnButtonClickEvent extends CurrencyEvent {
  int? usDollar;
  String? currencyType;

  OnButtonClickEvent({required this.usDollar, required this.currencyType});

  @override
  List<Object?> get props => [usDollar, currencyType];
}

class OnConverterClickEvent extends CurrencyEvent {
  int? amount;
  String? currencyFromType;
  String? currencyToType;

  OnConverterClickEvent(
      {required this.amount,
      required this.currencyFromType,
      required this.currencyToType});

  @override
  List<Object?> get props => [amount, currencyFromType, currencyToType];
}
