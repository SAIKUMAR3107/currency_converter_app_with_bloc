import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class CurrencyState extends Equatable {}

class UpdatedCurrencyState extends CurrencyState {
  double? currency;
  double? anyCurrency;

  UpdatedCurrencyState({this.currency, this.anyCurrency});

  UpdatedCurrencyState copyWith({double? currency, double? anyCurrency}) {
    return UpdatedCurrencyState(
        currency: currency ?? this.currency,
        anyCurrency: anyCurrency ?? this.anyCurrency);
  }

  @override
  List<Object?> get props => [currency, anyCurrency];
}
