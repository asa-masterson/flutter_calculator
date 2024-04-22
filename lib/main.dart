import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/services.dart'; // Import flutter/services.dart to use LogicalKeyboardKey

void main() => runApp(const MyApp());

// Used for deeplinking (android)
final _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const MyApp(),
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: const MyHomePage(title: 'PigsAre.Calculating'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class NumberKeyPressedAction extends Intent {
  final String number;

  const NumberKeyPressedAction(this.number);
}

class NumberKeyPressedActionHandler extends Action<NumberKeyPressedAction> {
  final Function(String) buttonPressed;

  NumberKeyPressedActionHandler(this.buttonPressed);

  @override
  Object? invoke(covariant NumberKeyPressedAction intent) {
    buttonPressed(intent.number);
    return null;
  }
}

class _MyHomePageState extends State<MyHomePage> {
  String output = "0";
  String _output = "0";
  double num1 = 0;
  double num2 = 0;
  String operand = "";
  String query = "";
  String _query = "";
  bool duplicate = false;

  buttonPressed(String buttonText) {
    if(buttonText == "CLEAR"){
      _output = "0";
      num1 = 0;
      num2 = 0;
      operand = "";
    } else if(buttonText == "+" || buttonText == "-" || buttonText == "x" || buttonText == "/"){
      if(_query.isNotEmpty){
        if(_query[_query.length - 1] != buttonText) {
          num1 = double.parse(output);
          operand = buttonText;
          _output = "0";
        } else {
          duplicate = true;
        }
      } else {
        num1 = double.parse(output);
        operand = buttonText;
        _output = "0";
      }
    } else if(buttonText == "."){
      if(_output.contains(".")){
        // print("Already contains a decimal silly!");
      } else {
        _output = _output + buttonText;
      }
    } else if(buttonText == "=") {
      num2 = double.parse(output);
      if (operand == "+") {
        _output = (num1 + num2).toString();
      }
      if (operand == "-") {
        _output = (num1 - num2).toString();
      }
      if (operand == "x") {
        _output = (num1 * num2).toString();
      }
      if (operand == "/") {
        _output = (num1 / num2).toString();
      }
      num1 = 0;
      num2 = 0;
      operand = "";
    } else {
      _output = _output + buttonText;
    }
    setState(() {
      output = double.parse(_output).toStringAsFixed(2);
      if(duplicate) {
        duplicate = false;
      } else {
        if (buttonText == "=") {
          query = _query;
          _query = output;
        } else if (buttonText == "CLEAR") {
          query = "";
          _query = "";
        } else {
          query = _query + buttonText;
          _query = query;
        }
        if (output == "NaN" || output == "Infinity") {
          output = r"Error :\";
          _query = "";
          _output = "0";
        }
      }
    });
  }

  Widget buildButton(String buttonText){
    return Expanded(
      child: SizedBox(
        height: 70.0,
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0), // Adjust the radius here for more rectangular shape
              ),
              side: const BorderSide(color: Colors.pinkAccent, width: 2.0),
            ),
            child: Text(
              buttonText,
              style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.purpleAccent),
            ),
            onPressed: () => buttonPressed(buttonText),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      title: Text(widget.title, style: const TextStyle(color: Colors.pink)),
      ),
      body: Focus(
        autofocus: true,
        onKey: (FocusNode node, RawKeyEvent event) {
          if(event is RawKeyDownEvent) {
            final keyLabel = event.data.keyLabel;
            if(int.tryParse(keyLabel) != null) {
              buttonPressed(keyLabel);
            }
          }
          return KeyEventResult.ignored; // Return ignored to propagate the event to other widgets
        },
        child: Column(
          children: <Widget>[
            Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    output, // Big bold text
                    style: const TextStyle(
                        fontSize: 48.0,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      query, // Small grey text
                      style: const TextStyle(
                        fontSize: 20.0,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0), // Adjust the horizontal padding as needed
                child: Divider(
                  color: Colors.pink, // Set your desired color here
                  height: 20, // Optional: sets the Divider's height
                  thickness: 2, // Optional: sets the thickness of the line
                ),
              ),
            ),
            Column(
              children: [
                Row(
                  children: [
                    buildButton("7"),
                    buildButton("8"),
                    buildButton("9"),
                    buildButton("/"),
                  ],
                ),
                Row(
                  children: [
                    buildButton("4"),
                    buildButton("5"),
                    buildButton("6"),
                    buildButton("x"),
                  ],
                ),
                Row(
                  children: [
                    buildButton("1"),
                    buildButton("2"),
                    buildButton("3"),
                    buildButton("-"),
                  ],
                ),
                Row(
                  children: [
                    buildButton("."),
                    buildButton("0"),
                    buildButton("00"),
                    buildButton("+"),
                  ],
                ),
                Row(
                  children: [
                    buildButton("CLEAR"),
                    buildButton("="),
                  ],
                ),
              ],
            ),
          ]
        )
      ),
    );
  }
}