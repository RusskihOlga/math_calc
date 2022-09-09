import 'package:math_calc/scanner.dart';
import 'package:math_calc/type_operator.dart';

class Parser {
  final List<Scanned> expressions;

  Parser(this.expressions);

  List<Scanned> parse() {
    TypeOperator? prev;
    TypeOperator? curr;
    TypeOperator? next;

    List<Scanned> properlyParsedExpression = [];

    List<TypeOperator> types = expressions.map((e) => e.type).toList();
    List<int> indexes = [];
    List<Scanned> negativeValues = [];

    for (int i = 0; i < types.length - 1; i++) {
      prev = i == 0 ? null : types[i - 1];
      curr = types[i];
      next = types[i + 1];
      if (prev == null &&
          curr == TypeOperator.sub &&
          next == TypeOperator.value) {
        var negativeValue = Scanned(
          exp: (-1 * double.parse(expressions[i + 1].exp)).toString(),
          type: TypeOperator.value,
        );
        indexes.add(i);
        negativeValues.add(negativeValue);
      } else if (prev == TypeOperator.lPar &&
          curr == TypeOperator.sub &&
          next == TypeOperator.value) {
        var negativeValue = Scanned(
          exp: (-1 * double.parse(expressions[i + 1].exp)).toString(),
          type: TypeOperator.value,
        );
        indexes.add(i);
        negativeValues.add(negativeValue);
      }
    }

    var maxIterations = expressions.length;
    var i = 0;
    var j = 0;
    while (i < maxIterations) {
      if (indexes.contains(i) && j < negativeValues.length) {
        properlyParsedExpression.add(negativeValues[j]);
        j++;
        i++;
      } else {
        properlyParsedExpression.add(expressions[i]);
      }
      i++;
    }
    return properlyParsedExpression;
  }
}
