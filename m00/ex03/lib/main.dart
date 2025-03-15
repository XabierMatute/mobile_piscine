import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.dark(
          onPrimary: const Color.fromARGB(255, 1, 10, 87),
        ),
      ),
      home: const MyHomePage(title: 'Calculator'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String expression = "";
  String result = "";

  void appendToExpression(String digit) {
    setState(() {
      expression += digit;
    });
  }

  void clearExpression() {
    setState(() {
      if (expression.isNotEmpty) {
        expression = expression.substring(0, expression.length - 1);
      }
    });
  }

  void fullClearExpression() {
    setState(() {
      expression = "";
      result = "";
    });
  }

  void calculateResult() {
    setState(() {
      try {
        result = operate(expression);
      } catch (e) {
        result = "Error";
      }
    });
  }

  String operate(String expression) {
    try {
      expression = expression.replaceAll('x', '*');

      ExpressionParser p = GrammarParser();
      Expression exp = p.parse(expression);

      ContextModel cm = ContextModel();

      double evalResult = exp.evaluate(EvaluationType.REAL, cm);

      try {
        if (evalResult.isNaN) {
          return "Error: undeterminate";
        }
        if (evalResult == evalResult.toInt()) {
          return evalResult.toInt().toString();
        }
      }
      catch (e) {
        //pass
      }
      
      return evalResult.toString();

    } catch (e) {
      return "Error: ${e.toString()}";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Center(
          child: Text(widget.title),
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: CalculatorDisplays(expression: expression, result: result),
          ),
          CalculatorButtons(
            onButtonPressed: (String value) {
              if (value == 'C') {
                clearExpression();
              } else if (value == 'AC') {
                fullClearExpression();
              } else if (value == '=') {
                calculateResult();
              } else {
                appendToExpression(value);
              }
            },
          ),
        ],
      ),
    );
  }
}

class CalculatorDisplays extends StatelessWidget {
  final String expression;
  final String result;

  const CalculatorDisplays({
    super.key,
    required this.expression,
    required this.result,
  });

  String _validateDisplayValue(String value) {
    return value.isEmpty ? "0" : value;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          CalculatorDisplay(displayValue: _validateDisplayValue(expression)),
          CalculatorDisplay(displayValue: _validateDisplayValue(result)),
        ],
      ),
    );
  }
}

class CalculatorDisplay extends StatelessWidget {
  const CalculatorDisplay({super.key, required this.displayValue});

  final String displayValue;

  @override
  Widget build(BuildContext context) {
    return Text(
      displayValue,
      style: Theme.of(context).textTheme.headlineMedium,
      textAlign: TextAlign.right,
    );
  }
}

class CalculatorButton extends StatelessWidget {
  const CalculatorButton({
    super.key,
    required this.text,
    this.textColor = Colors.white,
    this.onPressed,
  });

  final String text;
  final Color textColor;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.indigo,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.indigoAccent),
            borderRadius: BorderRadius.zero,
          ),
          minimumSize: Size(double.infinity, double.infinity),
          padding: EdgeInsets.zero,
        ),
        child: Container(
          alignment: Alignment.center,
          child: Text(
            text,
            style: TextStyle(color: textColor),
          ),
        ),
      ),
    );
  }
}

class NumberButton extends StatelessWidget {
  final String digit;
  final ValueChanged<String> onPressed;

  const NumberButton({
    super.key,
    required this.digit,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return CalculatorButton(
      text: digit,
      onPressed: () => onPressed(digit),
    );
  }
}

class OperatorButton extends StatelessWidget {
  final String operator;
  final ValueChanged<String> onPressed;

  const OperatorButton({
    super.key,
    required this.operator,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return CalculatorButton(
      text: operator,
      onPressed: () => onPressed(operator),
    );
  }
}


class CalculatorButtonRow extends StatelessWidget {
  const CalculatorButtonRow({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: children,
      ),
    );
  }
}

class CalculatorButtons extends StatelessWidget {
  final Function(String) onButtonPressed;

  const CalculatorButtons({super.key, required this.onButtonPressed});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        CalculatorButtonRow(
          children: <Widget>[
            NumberButton(digit: "7", onPressed: onButtonPressed),
            NumberButton(digit: "8", onPressed: onButtonPressed),
            NumberButton(digit: "9", onPressed: onButtonPressed),
            CalculatorButton(text: 'C', textColor: Colors.red, onPressed: () => onButtonPressed('C')),
            CalculatorButton(text: 'AC', textColor: Colors.red, onPressed: () => onButtonPressed('AC')),
          ],
        ),
        CalculatorButtonRow(
          children: <Widget>[
            NumberButton(digit: "4", onPressed: onButtonPressed),
            NumberButton(digit: "5", onPressed: onButtonPressed),
            NumberButton(digit: "6", onPressed: onButtonPressed),
            OperatorButton(operator: '+', onPressed: onButtonPressed),
            OperatorButton(operator: '-', onPressed: onButtonPressed),
          ],
        ),
        CalculatorButtonRow(
          children: <Widget>[
            NumberButton(digit: "1", onPressed: onButtonPressed),
            NumberButton(digit: "2", onPressed: onButtonPressed),
            NumberButton(digit: "3", onPressed: onButtonPressed),
            OperatorButton(operator: 'x', onPressed: onButtonPressed),
            OperatorButton(operator: '/', onPressed: onButtonPressed),
          ],
        ),
        CalculatorButtonRow(
          children: <Widget>[
            NumberButton(digit: "0", onPressed: onButtonPressed),
            NumberButton(digit: ".", onPressed: onButtonPressed), 
            NumberButton(digit: "00", onPressed: onButtonPressed), 
            OperatorButton(operator: '=', onPressed: onButtonPressed),
            CalculatorButton(text: '', textColor: Colors.white, onPressed: () {}),
          ],
        ),
      ],
    );
  }
}

