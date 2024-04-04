import 'package:currency_converter_app/blocs/app_states.dart';
import 'package:currency_converter_app/currency_convertion_bloc/currency_bloc.dart';
import 'package:currency_converter_app/currency_convertion_bloc/currency_event.dart';
import 'package:currency_converter_app/currency_convertion_bloc/currency_state.dart';
import 'package:currency_converter_app/repository/currency_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


import '../blocs/app_blocs.dart';
import '../blocs/app_events.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> countryCode = [];
  TextEditingController usCurrency = TextEditingController();
  TextEditingController anyCurrency = TextEditingController();
  String? dropdownValueForUs;
  String? dropdownFirstType;
  String? dropdownSecondType;
  String answer1 = 'Converted Currency will be shown here :)';
  String answer2 = 'Converted Currency will be shown here :)';

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => CurrencyBloc(RepositoryProvider.of<CurrencyRepository>(context))..add(LoadCurrencyEvent()),),
        BlocProvider(create: (context) => CurrencyConverterUSBloc(RepositoryProvider.of<CurrencyRepository>(context))..add(OnButtonClickEvent(usDollar: null, currencyType: null))),
        BlocProvider(create: (context) => CurrencyConverterUSBloc(RepositoryProvider.of<CurrencyRepository>(context))..add(OnConverterClickEvent(amount: null, currencyFromType: null, currencyToType: null)),)
      ],
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Color(0xFF352315),
            title: Text("Currency Converter",style: TextStyle(color: Colors.white),),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            child: Container(
              child: BlocBuilder<CurrencyBloc, CurrencyState1>(
                builder: (context, state) {
                  if (state is CurrencyLoadingState) {
                    return Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(image: DecorationImage(image: AssetImage("assets/background.jpg"),fit: BoxFit.fill)),
                      child: Center(
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      ),
                    );
                  }
                  if (state is CurrencyLoadedState) {
                    List<String> code = state.countryCode;
                    return Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(image: DecorationImage(image: AssetImage("assets/background.jpg"),fit: BoxFit.fill)),
                      padding: EdgeInsets.only(left: 10,right: 10,top: 10),
                      child: Column(
                        children: [
                          Card(
                            elevation: 10,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              padding: EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color: Colors.white),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      "Convert to Any Currency",
                                      style: TextStyle(
                                          color: Colors.black87,
                                          fontSize: 25,
                                          fontFamily:
                                              "sans-serif-condensed-light",
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  TextField(
                                    controller: anyCurrency,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      hintText: "Enter Amount to Convert",
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  DropdownButton<String>(
                                    value: dropdownFirstType,
                                    icon:
                                        const Icon(Icons.arrow_drop_down_rounded),
                                    iconSize: 24,
                                    elevation: 16,
                                    isExpanded: true,
                                    underline: Container(
                                      height: 2,
                                      color: Colors.grey.shade400,
                                    ),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        dropdownFirstType = newValue!;
                                      });
                                    },
                                    items: code
                                        .map<DropdownMenuItem<String>>((value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(
                                          value,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                      );
                                    }).toList(),
                                    hint: Text("Choose currency From type"),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    "To",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  DropdownButton<String>(
                                    value: dropdownSecondType,
                                    icon:
                                        const Icon(Icons.arrow_drop_down_rounded),
                                    iconSize: 24,
                                    elevation: 16,
                                    isExpanded: true,
                                    underline: Container(
                                      height: 2,
                                      color: Colors.grey.shade400,
                                    ),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        dropdownSecondType = newValue!;
                                      });
                                    },
                                    items: code
                                        .map<DropdownMenuItem<String>>((value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(
                                          value,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                      );
                                    }).toList(),
                                    hint: Text("Choose currency TO type"),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  ElevatedButton(
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStatePropertyAll(
                                                  Colors.green)),
                                      onPressed: () {
                                        var currencyRatesFrom = dropdownFirstType?.substring(dropdownFirstType!.indexOf("(") + 1,dropdownFirstType!.indexOf(")"));
                                        var currencyRatesTo = dropdownSecondType?.substring(dropdownSecondType!.indexOf("(") + 1, dropdownSecondType!.indexOf(")"));
                                        context.read<CurrencyConverterUSBloc>().add(OnConverterClickEvent(amount: int.parse(anyCurrency.text), currencyFromType: currencyRatesFrom, currencyToType: currencyRatesTo));
                                      },
                                      child: Text(
                                        "Convert",
                                        style: TextStyle(color: Colors.white),
                                      )),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  BlocBuilder<CurrencyConverterUSBloc, UpdatedCurrencyState>(builder: (context, state) {
                                      return Container(
                                          alignment: Alignment.center,
                                          child: Text(state.anyCurrency == null
                                              ? answer2
                                              : anyCurrency.text.toString() +
                                                  " ${dropdownFirstType?.substring(dropdownFirstType!.indexOf("(") + 1, dropdownFirstType!.indexOf(")"))} = " +
                                                  state.anyCurrency!
                                                      .toStringAsFixed(4) +
                                                  " ${dropdownSecondType?.substring(dropdownSecondType!.indexOf("(") + 1, dropdownSecondType!.indexOf(")"))}", style: TextStyle(fontSize: 20),));
                                    },
                                  )
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          Card(
                            elevation: 10,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              padding: EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color: Colors.white),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      "USD to any currency type",
                                      style: TextStyle(
                                          color: Colors.black87,
                                          fontSize: 25,
                                          fontFamily:
                                              "sans-serif-condensed-light",
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  TextField(
                                    controller: usCurrency,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      hintText: "Enter Amount In Dollers",
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: DropdownButton<String>(
                                          value: dropdownValueForUs,
                                          icon: const Icon(
                                              Icons.arrow_drop_down_rounded),
                                          iconSize: 24,
                                          elevation: 16,
                                          isExpanded: true,
                                          underline: Container(
                                            height: 2,
                                            color: Colors.grey.shade400,
                                          ),
                                          onChanged: (String? newValue) {
                                            setState(() {
                                              dropdownValueForUs = newValue!;
                                            });
                                          },
                                          items: code
                                              .map<DropdownMenuItem<String>>(
                                                  (value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(
                                                value,
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                              ),
                                            );
                                          }).toList(),
                                          hint: Text("Choose currency type"),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      ElevatedButton(
                                          style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStatePropertyAll(
                                                      Colors.green)),
                                          onPressed: () {
                                            var rates = dropdownValueForUs?.substring(dropdownValueForUs!.indexOf("(") + 1, dropdownValueForUs!.indexOf(")"));
                                            context.read<CurrencyConverterUSBloc>().add(OnButtonClickEvent(usDollar: int.parse(usCurrency.text), currencyType: rates!,));
                                          },
                                          child: Text(
                                            dropdownValueForUs?.substring(dropdownValueForUs!.indexOf("(") + 1, dropdownValueForUs!.indexOf(")")) == null
                                                ? "Convert"
                                                : "Convert ${dropdownValueForUs?.substring(dropdownValueForUs!.indexOf("(") + 1, dropdownValueForUs!.indexOf(")"))}",
                                            style: TextStyle(color: Colors.white),
                                          )),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  BlocBuilder<CurrencyConverterUSBloc, UpdatedCurrencyState>(builder: (context, state) {
                                      return Container(
                                          alignment: Alignment.center,
                                          child: Text(state.currency == null
                                              ? answer1
                                              : usCurrency.text.toString() +
                                                  " USD = " +
                                                  state.currency!
                                                      .toStringAsFixed(2) +
                                                  " ${dropdownValueForUs?.substring(dropdownValueForUs!.indexOf("(") + 1, dropdownValueForUs!.indexOf(")"))}",style: TextStyle(fontSize: 20),));
                                    },
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  if (state is CurrencyErrorState) {
                    return AlertDialog(
                      title: Text(
                        state.error,
                        style: TextStyle(fontSize: 20),
                      ),
                      actions: [
                        TextButton(
                            onPressed: () {
                              SystemNavigator.pop();
                            },
                            child: Text("Turn on internet on restart"))
                      ],
                    );
                  }
                  return Container(
                    child: Text(
                      "SAIUKUMAR",
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                  );
                },
              ),
            ),
          )),
    );
  }
}
