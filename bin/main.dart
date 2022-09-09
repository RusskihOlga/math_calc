import 'package:math_calc/parser.dart';
import 'package:math_calc/scanner.dart';

void main() {
  var expression = "3*x+15/(3+2)";
  var scanner = Scanner(expression: expression, variables: { "x" : -10 });
  var scanExp = scanner.scan();
  if (scanner.variables == null && expression.contains(RegExp(r'[a-zA-Z]'))) {
    print("Некорректное выражения");
  } else {
    var parser = Parser(scanExp);
    var parsed = parser.parse();
    var result = scanner.evaluate(parsed);
    print("$expression = $result");
  }
}