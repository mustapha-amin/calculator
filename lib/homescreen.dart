import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _eqnCtrl = TextEditingController();
  FocusNode myFocusNode = FocusNode();
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    _eqnCtrl.text = "0";
    super.initState();
  }

  String eqn = "0";
  String res = "0";
  String expr = "";
  double eqnFontSize = 38;
  double resFontSize = 48;

  void _changeFocusNode() async {
    await Future.delayed(const Duration(milliseconds: 20));
    scrollController.jumpTo(scrollController.position.maxScrollExtent);
    myFocusNode.unfocus();
    await Future.delayed(const Duration(milliseconds: 20));
    myFocusNode.requestFocus();
  }

  void buttonPressed(String buttonText) {
    setState(() {
      if (_eqnCtrl.text[0] == 'x' || _eqnCtrl.text[0] == "÷") {
        _eqnCtrl.text = "0";
      }
      if (_eqnCtrl.text[0] == '.') {
        _eqnCtrl.text = "0.";
      }
      if (buttonText == "C") {
        _eqnCtrl.text = "0";
        res = "0";
        eqnFontSize = 38;
        resFontSize = 48;
      } else if (buttonText == "CE") {
        eqnFontSize = 48;
        resFontSize = 38;
        _eqnCtrl.text = _eqnCtrl.text.substring(0, eqn.length - 1);
        if (_eqnCtrl.text.isEmpty) {
          _eqnCtrl.text = '0';
          eqnFontSize = 38;
          resFontSize = 48;
        }
      } else if (buttonText == "=") {
        eqnFontSize = 38;
        resFontSize = 48;
        expr = _eqnCtrl.text;
        expr = expr.replaceAll('x', '*');
        expr = expr.replaceAll('÷', '/');
        expr = expr.replaceAll('%', '* 0.01');
        try {
          Parser p = Parser();
          Expression exp = p.parse(expr);
          ContextModel cm = ContextModel();
          String result = "${exp.evaluate(EvaluationType.REAL, cm)}";
          if (result.endsWith('.0')) {
            res = result.substring(0, result.length - 2);
          } else {
            res = result;
          }
        } catch (e) {
          res = 'Error';
        }
      } else {
        eqnFontSize = 48;
        resFontSize = 38;
        if (_eqnCtrl.text == "0") {
          _eqnCtrl.text = buttonText;
        } else {
          _eqnCtrl.text += buttonText;
        }
      }
    });

    _changeFocusNode();
  }

  Widget buildButton(String buttonText, double height, Color? buttonColor) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.115 * height,
      width: MediaQuery.of(context).size.width / 4,
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor: buttonColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: const BorderSide(
              color: Colors.white,
              width: 1,
              style: BorderStyle.solid,
            ),
          ),
          padding: const EdgeInsets.all(10),
        ),
        onPressed: () {
          buttonPressed(buttonText);
        },
        child: Text(
          buttonText,
          style: const TextStyle(
            fontWeight: FontWeight.normal,
            color: Colors.white,
            fontSize: 30,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Simple calculator"),
        centerTitle: true,
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: Column(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  alignment: Alignment.centerRight,
                  child: TextField(
                    scrollController: scrollController,
                    textAlign: TextAlign.end,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                    ),
                    focusNode: myFocusNode,
                    maxLines: 1,
                    controller: _eqnCtrl,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: eqnFontSize,
                    ),
                    readOnly: true,
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  alignment: Alignment.centerRight,
                  child: Text(
                    res,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: res.characters.length < 10 ? resFontSize : 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Row(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.75,
                  child: Table(
                    children: [
                      TableRow(
                        children: [
                          buildButton("C", 1, Colors.redAccent),
                          buildButton("CE", 1, Colors.orange),
                          buildButton("÷", 1, Colors.orange),
                        ],
                      ),
                      TableRow(
                        children: [
                          buildButton("7", 1, Colors.black),
                          buildButton("8", 1, Colors.black),
                          buildButton("9", 1, Colors.black),
                        ],
                      ),
                      TableRow(
                        children: [
                          buildButton("4", 1, Colors.black),
                          buildButton("5", 1, Colors.black),
                          buildButton("6", 1, Colors.black),
                        ],
                      ),
                      TableRow(
                        children: [
                          buildButton("1", 1, Colors.black),
                          buildButton("2", 1, Colors.black),
                          buildButton("3", 1, Colors.black),
                        ],
                      ),
                      TableRow(
                        children: [
                          buildButton(".", 1, Colors.black),
                          buildButton("0", 1, Colors.black),
                          buildButton("%", 1, Colors.black),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.25,
                  child: Table(
                    children: [
                      TableRow(
                        children: [
                          buildButton("x", 1, Colors.orange),
                        ],
                      ),
                      TableRow(
                        children: [
                          buildButton("-", 1, Colors.orange),
                        ],
                      ),
                      TableRow(
                        children: [
                          buildButton("+", 1, Colors.orange),
                        ],
                      ),
                      TableRow(
                        children: [
                          buildButton("=", 2, Colors.blue[700]),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
