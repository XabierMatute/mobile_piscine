import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.dark(
          onPrimary: const Color.fromARGB(255, 1, 10, 87),

        )
      ),
      home: const MyHomePage(title: 'Calculator'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String expression = "";
  String result = "";

  void appendToExpression(String digit) {
    expression += digit;
  }

  void clearExpression() {
    if (expression.isNotEmpty) {
      expression = expression.substring(0, expression.length - 1);
    }
  }

  void fclearExpression() {
    expression = "";
    result = "";
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
          CalculatorButtons(), // Los botones se colocarán en la parte inferior
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

  // Método para verificar si la cadena está vacía y devolver "0" en ese caso
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
          // Puedes agregar más displays aquí si es necesario
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
    this.onPressed, // Parámetro opcional con valor predeterminado
  });

  final String text;
  final Color textColor;
  final VoidCallback? onPressed; // Parámetro opcional

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ElevatedButton(
        onPressed: onPressed ?? () {
          print(text); // Valor predeterminado: imprime el texto del botón
        },
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

class NumberButton extends CalculatorButton {
  final String digit;

  static void _onPressed() {
    print("caramba");
  }

  const NumberButton({
    super.key,
    required this.digit,
  }) : super(
          text: digit,
          textColor: Colors.black,
          onPressed: _onPressed,
        );
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
  const CalculatorButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
        children: <Widget>[
          CalculatorButtonRow(
            children: const <Widget>[
              NumberButton(digit: "7"),
              NumberButton(digit: "8"),
              NumberButton(digit: "9"),
              CalculatorButton(text: 'C', textColor: Colors.red),
              CalculatorButton(text: 'AC', textColor: Colors.red),
            ],
          ),
          CalculatorButtonRow(
            children: const <Widget>[
              NumberButton(digit: "4"),
              NumberButton(digit: "5"),
              NumberButton(digit: "6"),
              CalculatorButton(text: '+', textColor: Colors.white),
              CalculatorButton(text: '-', textColor: Colors.white),
            ],
          ),
          CalculatorButtonRow(
            children: const <Widget>[
              NumberButton(digit: "7"),
              NumberButton(digit: "8"),
              NumberButton(digit: "9"),
              CalculatorButton(text: 'x', textColor: Colors.white),
              CalculatorButton(text: '/', textColor: Colors.white),
            ],
          ),
          CalculatorButtonRow(
            children: const <Widget>[
              NumberButton(digit: "0"),
              NumberButton(digit: "."), //tecnically not a number
              NumberButton(digit: "00"),  //tecnically not a digit
              CalculatorButton(text: '=', textColor: Colors.white),
              CalculatorButton(text: '', textColor: Colors.white),
            ],
          ),
        ],
    );
  }
}
 
