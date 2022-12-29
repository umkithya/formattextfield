import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:math' as math;
import 'package:flutter/services.dart';

// import 'helper/currency_formatter.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String tempString = "";
  bool noCollape = false;
  bool isPlusOne = false;
  bool isPlusOnDel = false;
  int plusValue = 0;
  bool isBackSpace = false;

  @override
  Widget build(BuildContext context) {
    final subscriptionPriceController = TextEditingController();
    String formNum(String s) {
      return NumberFormat.decimalPattern().format(
        int.parse(s),
      );
    }

    void inputValue(String string) {
      noCollape = false;
      isPlusOne = false;
      isPlusOnDel = false;
      plusValue = 0;
      // });

      if (tempString.length > string.length) {
        try {
          debugPrint('Backspace${tempString.length}=$string=${string.length}');

          if (string.isNotEmpty) {
            // debugPrint('HHH==${numFormat.format(55555)}');
            if (string.contains(".")) {
              var temp = string;
              var strList = string.split(".");
              strList[0] = formNum(
                strList[0].replaceAll(',', ''),
              );
              string = "${strList[0]}.${strList[1]}";
              if (temp.length > string.length) {
                isPlusOnDel = true;
                plusValue = string.length - temp.length;
              }
              debugPrint(
                  'plusValue$isPlusOnDel==${string.length}==${temp.length}');
              debugPrint(
                  '$string==baseOffset${subscriptionPriceController.selection.baseOffset}==${string.length}');
              try {
                subscriptionPriceController.value = TextEditingValue(
                    text: string,
                    selection: TextSelection.fromPosition(TextPosition(
                        offset: isPlusOnDel
                            ? subscriptionPriceController.selection.baseOffset -
                                1
                            : subscriptionPriceController
                                .selection.baseOffset)));
              } catch (e) {
                debugPrint('$e');
              }
            } else {
              if (string.length > 10) {
                var startLength = string.length - 11;
                string = string.replaceRange(
                    (string.length - 1) - startLength, string.length, "");
              }
              string = formNum(
                string.replaceAll(',', ''),
              );
              subscriptionPriceController.value = TextEditingValue(
                  text: string,
                  selection: TextSelection.collapsed(offset: string.length));
            }
          }

          tempString = string;
          return;
        } catch (e) {
          debugPrint('Ex==$e');
          return;
        }
      } else if (string.isNotEmpty) {
        debugPrint('Local${Platform.localeName}');

        if (Platform.localeName.contains("KH")) {
          if (string[string.length - 1].contains(",")) {
            string = string.replaceRange(string.length - 1, string.length, ".");
            debugPrint('String$string');
          }
        }

        try {
          if (!string.contains(".")) {
            if (string.length > 10 && !string.contains(".")) {
              debugPrint('v0===${string.length}');

              string =
                  string.replaceRange(string.length - 1, string.length, "");
              debugPrint('v===${string.length}');
            }
            string = formNum(
              string.replaceAll(',', ''),
            );
          } else {
            debugPrint('IsContain$string==${string[string.length - 1] != "."}');
            if (string[string.length - 1] != ".") {
              debugPrint('Hello');
              var temp = string;
              var strList = string.split(".");
              debugPrint('Hello1$strList');
              strList[0] = formNum(
                strList[0].replaceAll(',', ''),
              );

              debugPrint('Hello2${strList[0]}');

              string = "${strList[0]}.${strList[1]}";
              debugPrint('temp==${temp.length}string==${string.length}');
              if (string.length > temp.length) {
                isPlusOne = true;
                plusValue = string.length - temp.length;
              }
              debugPrint(
                  "strList=${temp.length}==after${string.length},plus=$plusValue==$isPlusOne");

              // setState(() {
              noCollape = true;
              // });
            }
          }
          // } else {
          //   string = formNum(
          //     string.replaceAll(',', ''),
          //   );
          // }
        } catch (e) {
          debugPrint('EX$e');
        }
        if (string.contains("..")) {
          debugPrint('v0===$string');

          string = string.replaceRange(string.length - 1, string.length, "");
          debugPrint('v===$string');
        }

        if (string.contains(".,")) {
          debugPrint('v0===$string');

          string = string.replaceRange(string.length - 1, string.length, "");
          debugPrint('v===$string');
        }
        if (string.contains(".") && string[string.length - 1].contains(".")) {
          debugPrint('a0===$string');

          string = string.replaceRange(string.length - 1, string.length, ".");
          debugPrint('a===$string');
        }
        tempString = string;
        if (noCollape == false) {
          debugPrint('WORK');
          subscriptionPriceController.value = TextEditingValue(
            text: string,
            selection: TextSelection.collapsed(
              offset: string.length,
            ),
          );
        } else {
          debugPrint(
              'subscriptionPriceController=${subscriptionPriceController.selection.baseOffset}==${isPlusOne ? 1 + subscriptionPriceController.selection.baseOffset : subscriptionPriceController.selection.baseOffset}');
          subscriptionPriceController.value = TextEditingValue(
              text: string,
              selection: isPlusOne
                  ? TextSelection.fromPosition(TextPosition(
                      offset:
                          subscriptionPriceController.selection.baseOffset + 1))
                  : subscriptionPriceController.selection);
        }
      } else {
        debugPrint('Empty');
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Demo TextField")),
      body: Container(
        width: double.infinity,
        color: Colors.black26,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                color: Colors.white,
                height: 50,
                child: TextFormField(
                  focusNode: FocusNode(),
                  controller: subscriptionPriceController,
                  onFieldSubmitted: (price) {},
                  onChanged: (string) {
                    inputValue(string);
                  },
                  inputFormatters: [
                    DecimalTextInputFormatter(decimalRange: 2),
                    FilteringTextInputFormatter.allow(RegExp('[0-9.,]')),
                    LengthLimitingTextInputFormatter(13)
                  ],
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                ),
              ),
            ),
            // child: TextFieldPro(
            //   hintText: "ok",
            //   label: "ok",

            //   // height: 50,
            //   // controller: textconroller,
            //   // hintext: "",
            //   // onchange: (value) {
            //   //   // if (value.contains('.')) {
            //   //   // format.format(value);
            //   //   // }
            //   //   textconroller.value = TextEditingValue(
            //   //     text: value,
            //   //     selection: TextSelection.collapsed(offset: value.length),
            //   //   );
            //   // },
            //   // inputFormatters: <TextInputFormatter>[
            //   //   CurrencyFormatter(allowFraction: true),
            //   //   // WhitelistingTextInputFormatter(RegExp(r'^\d+\.?\d{0,2}')),
            //   // ],
            //   // keyboardType: TextInputType.numberWithOptions(decimal: true),
            // ),
          ],
        ),
      ),
    );
  }
}

class DecimalTextInputFormatter extends TextInputFormatter {
  DecimalTextInputFormatter({this.decimalRange = 0}) : assert(decimalRange > 0);

  final int decimalRange;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue, // unused.
    TextEditingValue newValue,
  ) {
    TextSelection newSelection = newValue.selection;
    String truncated = newValue.text;

    String value = newValue.text;

    if (value.contains(".") &&
        value.substring(value.indexOf(".") + 1).length > decimalRange) {
      truncated = oldValue.text;
      newSelection = oldValue.selection;
    } else if (value == ".") {
      truncated = "0.";

      newSelection = newValue.selection.copyWith(
        baseOffset: math.min(truncated.length, truncated.length + 1),
        extentOffset: math.min(truncated.length, truncated.length + 1),
      );
    }

    return TextEditingValue(
      text: truncated,
      selection: newSelection,
      composing: TextRange.empty,
    );
  }
}
