```dart
import 'package:flutter/material.dart';

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ø­Ø§Ø³Ø¨Ø©',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
        brightness: Brightness.light,
      ),
      debugShowCheckedModeBanner: false,
      home: const CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _display = '0';
  String _expression = '';
  double? _firstOperand;
  String? _operator;
  bool _waitingForSecondOperand = false;

  void _inputDigit(String digit) {
    if (_waitingForSecondOperand) {
      setState(() {
        _display = digit;
        _waitingForSecondOperand = false;
      });
    } else {
      setState(() {
        _display = _display == '0' ? digit : _display + digit;
      });
    }
  }

  void _inputDecimal() {
    if (_waitingForSecondOperand) {
      setState(() {
        _display = '0.';
        _waitingForSecondOperand = false;
      });
      return;
    }
    if (!_display.contains('.')) {
      setState(() {
        _display += '.';
      });
    }
  }

  void _performOperation(String op) {
    final double currentValue = double.parse(_display);
    if (_firstOperand == null) {
      _firstOperand = currentValue;
    } else if (_operator != null) {
      final double result = _calculateResult(_firstOperand!, currentValue, _operator!);
      _display = _formatResult(result);
      _firstOperand = result;
    }
    setState(() {
      _operator = op;
      _waitingForSecondOperand = true;
      _expression = '${_formatResult(_firstOperand!)} $op';
    });
  }

  double _calculateResult(double a, double b, String op) {
    switch (op) {
      case '+':
        return a + b;
      case '-':
        return a - b;
      case 'Ã':
        return a * b;
      case 'Ã·':
        return b != 0 ? a / b : double.nan;
      default:
        return b;
    }
  }

  String _formatResult(double value) {
    if (value.isNaN) {
      return 'Ø®Ø·Ø£';
    }
    if (value == value.floorToDouble()) {
      return value.toInt().toString();
    }
    return value.toStringAsFixed(2);
  }

  void _calculateResult() {
    if (_firstOperand == null || _operator == null) return;
    final double currentValue = double.parse(_display);
    final double result = _calculateResult(_firstOperand!, currentValue, _operator!);
    setState(() {
      _display = _formatResult(result);
      _expression = '${_formatResult(_firstOperand!)} $_operator ${_formatResult(currentValue)} =';
      _firstOperand = result;
      _operator = null;
      _waitingForSecondOperand = true;
    });
  }

  void _clear() {
    setState(() {
      _display = '0';
      _expression = '';
      _firstOperand = null;
      _operator = null;
      _waitingForSecondOperand = false;
    });
  }

  void _delete() {
    if (_display.length > 1) {
      setState(() {
        _display = _display.substring(0, _display.length - 1);
      });
    } else {
      setState(() {
        _display = '0';
      });
    }
  }

  void _toggleSign() {
    if (_display == '0') return;
    setState(() {
      if (_display.startsWith('-')) {
        _display = _display.substring(1);
      } else {
        _display = '-$_display';
      }
    });
  }

  void _percentage() {
    final double value = double.parse(_display) / 100;
    setState(() {
      _display = _formatResult(value);
    });
  }

  Widget _buildButton(String text, {Color? color, double flex = 1}) {
    return Expanded(
      flex: flex ~/ 1,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: SizedBox(
          height: 70,
          child: ElevatedButton(
            onPressed: () {
              switch (text) {
                case 'AC':
                  _clear();
                  break;
                case 'â«':
                  _delete();
                  break;
                case '%':
                  _percentage();
                  break;
                case 'Ã·':
                case 'Ã':
                case '-':
                case '+':
                  _performOperation(text);
                  break;
                case '=':
                  _calculateResult();
                  break;
                case '.':
                  _inputDecimal();
                  break;
                case '+/-':
                  _toggleSign();
                  break;
                default:
                  _inputDigit(text);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: color ?? Theme.of(context).colorScheme.surfaceVariant,
              foregroundColor: color != null ? Colors.white : Theme.of(context).colorScheme.onSurfaceVariant,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              textStyle: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            child: Text(text),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ø­Ø§Ø³Ø¨Ø©'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              alignment: Alignment.bottomRight,
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    _expression,
                    style: TextStyle(
                      fontSize: 20,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.right,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _display,
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ],
              ),
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  children: [
                    _buildButton('AC', color: Colors.red.shade400),
                    _buildButton('+/-'),
                    _buildButton('%'),
                    _buildButton('Ã·', color: Colors.orange.shade400),
                  ],
                ),
                Row(
                  children: [
                    _buildButton('7'),
                    _buildButton('8'),
                    _buildButton('9'),
                    _buildButton('Ã', color: Colors.orange.shade400),
                  ],
                ),
                Row(
                  children: [
                    _buildButton('4'),
                    _buildButton('5'),
                    _buildButton('6'),
                    _buildButton('-', color: Colors.orange.shade400),
                  ],
                ),
                Row(
                  children: [
                    _buildButton('1'),
                    _buildButton('2'),
                    _buildButton('3'),
                    _buildButton('+', color: Colors.orange.shade400),
                  ],
                ),
                Row(
                  children: [
                    _buildButton('0', flex: 2),
                    _buildButton('.'),
                    _buildButton('=', color: Colors.blue.shade400),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
```