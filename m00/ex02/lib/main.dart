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
            child: CalculatorDisplays()
          ),
          CalculatorButtons(), // Los botones se colocarán en la parte inferior
        ],
      ),
    );
  }
}

class CalculatorDisplays extends StatelessWidget {
  const CalculatorDisplays({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          CalculatorDisplay(displayValue: '0'),
          CalculatorDisplay(displayValue: '0'),
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
  const CalculatorButton({super.key, required this.text, this.textColor = Colors.white});

  final String text;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ElevatedButton(
        onPressed: () {
          print(text);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.indigo,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.indigoAccent),
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
              CalculatorButton(text: '7', textColor: Colors.black),
              CalculatorButton(text: '8', textColor: Colors.black),
              CalculatorButton(text: '9', textColor: Colors.black),
              CalculatorButton(text: 'C', textColor: Colors.red),
              CalculatorButton(text: 'AC', textColor: Colors.red),
            ],
          ),
          CalculatorButtonRow(
            children: const <Widget>[
              CalculatorButton(text: '4', textColor: Colors.black),
              CalculatorButton(text: '5', textColor: Colors.black),
              CalculatorButton(text: '6', textColor: Colors.black),
              CalculatorButton(text: '+', textColor: Colors.white),
              CalculatorButton(text: '-', textColor: Colors.white),
            ],
          ),
          CalculatorButtonRow(
            children: const <Widget>[
              CalculatorButton(text: '1', textColor: Colors.black),
              CalculatorButton(text: '2', textColor: Colors.black),
              CalculatorButton(text: '3', textColor: Colors.black),
              CalculatorButton(text: 'x', textColor: Colors.white),
              CalculatorButton(text: '/', textColor: Colors.white),
            ],
          ),
          CalculatorButtonRow(
            children: const <Widget>[
              CalculatorButton(text: '0', textColor: Colors.black),
              CalculatorButton(text: '.', textColor: Colors.black),
              CalculatorButton(text: '00', textColor: Colors.black),
              CalculatorButton(text: '=', textColor: Colors.white),
              CalculatorButton(text: '', textColor: Colors.white),
            ],
          ),
        ],
    );
  }
}
 
