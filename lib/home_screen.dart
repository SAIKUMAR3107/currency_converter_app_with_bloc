import 'package:currency_converter_app/currency_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late LatestCurrency getCurrencyData;
  List<String> countryCode = [];
  TextEditingController usCurrency = TextEditingController();
  TextEditingController anyCurrency = TextEditingController();
  String? dropdownValueForUs;
  String? dropdownFirstType;
  String? dropdownSecondType;
  String answer1 = 'Converted Currency will be shown here :)';
  String answer2 = 'Converted Currency will be shown here :)';
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getCurrency();
    getCurrencyTypes();
  }

  Future getCurrency() async {
    var apiId = "04f299005c12454c91a94b7e050de635";
    var response = await http.Client().get(Uri.parse(
        "https://openexchangerates.org/api/latest.json?app_id=" + apiId));
    if (response.statusCode == 200) {
      var result = latestCurrencyFromJson(response.body);
      setState(() {
        getCurrencyData = result;
      });
    }
  }

  Future getCurrencyTypes() async {
    var response = await http.Client()
        .get(Uri.parse("https://openexchangerates.org/api/currencies.json"));
    if (response.statusCode == 200) {
      var result = currencyTypesFromJson(response.body);
      setState(() {
        isLoading = true;
        result.forEach((key, value) {
          countryCode.add("$value ($key)");
        });
        dropdownValueForUs = countryCode[0];
        dropdownFirstType = countryCode[1];
        dropdownSecondType = countryCode[2];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Currency Converter"),
        centerTitle: true,
      ),
      body: Visibility(
        replacement: Center(child: CircularProgressIndicator(),),
        visible: isLoading,
        child: SingleChildScrollView(
          child: Container(
              color: Colors.black,
              padding: EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.all(20),
                      decoration:
                          BoxDecoration(borderRadius: BorderRadius.circular(30)),
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
                                  fontFamily: "sans-serif-condensed-light",
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
                                  icon: const Icon(Icons.arrow_drop_down_rounded),
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
                                  items: countryCode
                                      .map<DropdownMenuItem<String>>((value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value,overflow: TextOverflow.ellipsis,maxLines: 1,),
                                    );
                                  }).toList(),
                                  hint: Text("Choose currency type"),
                                ),
                              ),
                              SizedBox(width: 10,),
                              ElevatedButton(style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.green)),onPressed: (){
                                setState(() {
                                  var rates = dropdownValueForUs?.substring(dropdownValueForUs!.indexOf("(")+1,dropdownValueForUs!.indexOf(")"));
                                  var convertedValue = (getCurrencyData.rates["$rates"]! * double.parse(usCurrency.text)).toStringAsFixed(2);
                                  answer1 = usCurrency.text.toString() + " USD To $rates is : " + convertedValue;
                                });
                              }, child: Text("Convert",style: TextStyle(color: Colors.white),)),
                            ],
                          ),
                          SizedBox(height: 15,),
                          Container(alignment:Alignment.topLeft,child: Text(answer1))
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 40,),
                  Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.all(20),
                      decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(30)),
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
                                  fontFamily: "sans-serif-condensed-light",
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
                            icon: const Icon(Icons.arrow_drop_down_rounded),
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
                            items: countryCode
                                .map<DropdownMenuItem<String>>((value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value,overflow: TextOverflow.ellipsis,maxLines: 1,),
                              );
                            }).toList(),
                            hint: Text("Choose currency type"),
                          ),
                          SizedBox(width: 5,),
                          Text("To",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                          SizedBox(width: 5,),
                          DropdownButton<String>(
                            value: dropdownSecondType,
                            icon: const Icon(Icons.arrow_drop_down_rounded),
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
                            items: countryCode
                                .map<DropdownMenuItem<String>>((value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value,overflow: TextOverflow.ellipsis,maxLines: 1,),
                              );
                            }).toList(),
                            hint: Text("Choose currency type"),
                          ),
                          SizedBox(height: 5,),
                          ElevatedButton(style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.green)),onPressed: (){
                            setState(() {
                              var currencyRatesFrom = dropdownFirstType?.substring(dropdownFirstType!.indexOf("(")+1,dropdownFirstType!.indexOf(")"));
                              var currencyRatesTo = dropdownSecondType?.substring(dropdownSecondType!.indexOf("(")+1,dropdownSecondType!.indexOf(")"));
                              var convertedValue = ( double.parse(anyCurrency.text) / getCurrencyData.rates["$currencyRatesFrom"]! * getCurrencyData.rates["$currencyRatesTo"]! ).toStringAsFixed(2);
                              answer2 = anyCurrency.text.toString() + " $currencyRatesFrom To $currencyRatesTo is : " + convertedValue;
                            });
                          }, child: Text("Convert",style: TextStyle(color: Colors.white),)),
                          SizedBox(height: 15,),
                          Container(alignment:Alignment.topLeft,child: Text(answer2))
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 70,)
                ],
              )),
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
