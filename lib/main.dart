import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

/*
NAME    SHOAIB FAROOQ
REG$    SP17_BCS_070
 */
void main() {
  runApp(simple_cal());
}

class simple_cal extends StatefulWidget {
  @override
  _simple_calState createState() => _simple_calState();
}

class _simple_calState extends State<simple_cal> {
  Text GenerateText(text, size, color) {
    return Text(
      text,
      style: TextStyle(
        fontSize: size,
        color: color,
      ),
    );
  }

  Expanded generate_row(i) {
    if (i != 4)
      return Expanded(
        child:
            Row(children: List.generate(4, (j) => generate_button(j, i * 4))),
      );
    else
      return Expanded(
        child: Row(children: List.generate(3, (i) => generate_button(16, i))),
      );
  }

  Expanded generate_button(i, count) {
    String text = content[i + count];
    return Expanded(
      child: SizedBox.expand(
        child: FlatButton(
          child: GenerateText(text, 27.0, Colors.black),
          onPressed: () {
            setState(
              () {
                if (text == 'C') {
                  result = obj.Pop();
                } else if (text == 'AC') {
                  obj.clear();
                  result = 0.0;
                } else if (text == '=') {
                  result = obj.result;
                  obj.clear();
                  obj.first_stack.add(result.toString());
                } else
                  result = obj.Push(text);
              },
            );
          },
        ),
      ),
    );
  }

  List content = [
    "C",
    "/",
    "*",
    "AC",
    "7",
    "8",
    "9",
    "-",
    "4",
    "5",
    "6",
    "+",
    "1",
    "2",
    "3",
    "%",
    "0",
    ".",
    "="
  ];
  double result = 0;
  StackControl obj = StackControl();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('CALCULATOR'),
          backgroundColor: Colors.red,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: Container(
                alignment: Alignment.bottomRight,
                decoration: BoxDecoration(color: Colors.black),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GenerateText(result.toString(), 40.0, Colors.white),
                    GenerateText(obj.getExperation(), 30.0, Colors.yellow),
                  ],
                ),
              ),
            ),
            Container(
              height: 450,
              child: Column(
                children: List.generate(5, (i) => generate_row(i)),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class StackControl {
  int i;
  String num1 = "";
  double result = 0;
  List oprator = ["+", "*", "-", "/"];
  List number_list = List.generate(11, (n) => (n == 10) ? "." : n.toString());
  List first_stack = [];
  List Oprend_stack = [];
  List Opratortack = [];
  List ResultStack = [];

  double Push(text) {
    if (number_list.contains(text)) {
      num1 += text;
      if (first_stack.isNotEmpty && !oprator.contains(first_stack.last))
        first_stack.removeLast();
      first_stack.add(num1);
    } else if (oprator.contains(text)) {
      (first_stack.isEmpty) ? first_stack.add('0') : 0;
      first_stack.add(text);
      num1 = "";
    }
    result = reassignment();
    return result;
  }

  reassignment() {
    String text = "";
    Oprend_stack.clear();
    Opratortack.clear();
    ResultStack.clear();
    //arrange for orent and oprators
    for (i = 0; i < first_stack.length; i++) {
      text = first_stack[i];
      if (oprator.contains(text)) {
        while (
            Opratortack.isNotEmpty && prority_check(text, Opratortack.last)) {
          Oprend_stack.add(Opratortack.last);
          Opratortack.removeLast();
        }
        Opratortack.add(text);
      } else
        Oprend_stack.add(text);
    }
    //transfer remaning oprators from oprators to oprent
    while (Opratortack.isNotEmpty) {
      Oprend_stack.add(Opratortack.last);
      Opratortack.removeLast();
    }
    //final calculation
    for (i = 0; i < Oprend_stack.length; i++) {
      text = Oprend_stack[i];
      if (oprator.contains(text)) {
        final_calculation(text);
      } else
        ResultStack.add(double.parse(text));
    }
    //return final result
    if (ResultStack.isNotEmpty) {
      return ResultStack[0];
    } else
      return 0;
  }

  final_calculation(symol) {
    double val1, val2;
    if (ResultStack.length == 1) return ResultStack[0];
    val1 = ResultStack.last;
    ResultStack.removeLast();
    val2 = ResultStack.last;
    ResultStack.removeLast();
    if (symol == '+')
      ResultStack.add(val1 + val2);
    else if (symol == '-')
      ResultStack.add(val2 - val1);
    else if (symol == '*')
      ResultStack.add(val1 * val2);
    else if (symol == '/') ResultStack.add(val2 / val1);
  }

  bool prority_check(current_value, existing_value) {
    int current = get_priorty(current_value);
    int privious = get_priorty(existing_value);
    if (current_value == existing_value) {
      return false;
    }
    if (current <= privious) {
      return true;
    } else if (current > privious) return false;
  }

  int get_priorty(value) {
    if (value == '*' || value == '/') {
      return 2;
    } else
      return 1;
  }

  getExperation() {
    String point = "";
    for (i = 0; i < first_stack.length; i++) point += first_stack[i];
    return point;
  }

  Pop() {
    num1 = "";
    if (first_stack.isNotEmpty) {
      String temp = first_stack.last;
      if (temp.length == 1) {
        first_stack.removeLast();
      } else {
        temp = temp.substring(0, temp.length - 1);
        first_stack.removeLast();
        first_stack.add(temp);
      }
    }
    return reassignment();
  }

  clear() {
    if (ResultStack.isNotEmpty) result = ResultStack[0];
    num1 = "";
    first_stack.clear();
    Opratortack.clear();
    Oprend_stack.clear();
    ResultStack.clear();
    return result;
  }
}
