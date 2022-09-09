import 'dart:math';

import 'package:math_calc/type_operator.dart';
import 'package:collection/collection.dart';

class Scanner {
  final String expression;
  final Map<String, double>? variables;

  Scanner({
    required this.expression,
    this.variables,
  });

  List<Scanned> scan() {
    var expression = this.expression;
    if (variables != null) {
      variables!.forEach((key, value) {
        expression = expression.replaceAll(key, value.toString());
      });
    }

    String value = "";
    TypeOperator? oldType;
    List<Scanned> scannedExpr = [];
    for (var i = 0; i < expression.length; i++) {
      var item = expression[i];
      var type = TypeOperator.values.firstWhereOrNull(
        (element) => element.toStringEnum() == item,
      );
      if (type != null) {
        if (value.isNotEmpty) {
          var st = Scanned(
            exp: value,
            type: TypeOperator.value,
          );
          scannedExpr.add(st);
        }
        if (oldType != TypeOperator.value && type == TypeOperator.sub) {
          value += expression[i];
          continue;
        }
        value = expression[i];
        var st = Scanned(
          exp: value,
          type: type,
        );
        scannedExpr.add(st);
        value = "";
        oldType = type;
      } else {
        value += expression[i];
      }
    }

    if (value.isNotEmpty) {
      var st = Scanned(
        exp: value,
        type: TypeOperator.value,
      );
      scannedExpr.add(st);
    }

    return scannedExpr;
  }

  double evaluate(List<Scanned> expressions) {
    if (expressions.length == 1) {
      return double.parse(expressions[0].exp);
    }

    List<Scanned> simpleExpr = [];
    var idx = expressions
        .map((e) => e.type)
        .toList()
        .lastIndexWhere((element) => element == TypeOperator.lPar);
    int matchingRPAR = -1;
    if (idx >= 0) {
      for (var i = idx + 1; i < expressions.length; i++) {
        var curr = expressions[i];
        if (curr.type == TypeOperator.rPar) {
          matchingRPAR = i;
          break;
        } else {
          simpleExpr.add(expressions[i]);
        }
      }
    } else {
      simpleExpr.addAll(expressions);
      return _evaluateSimpleExpression(expressions);
    }

    var value = _evaluateSimpleExpression(simpleExpr);
    List<Scanned> partiallyEvaluatedExpression = [];
    for (int i = 0; i < idx; i++) {
      partiallyEvaluatedExpression.add(expressions[i]);
    }
    partiallyEvaluatedExpression.add(Scanned(
      exp: value.toString(),
      type: TypeOperator.value,
    ));
    for (int i = matchingRPAR + 1; i < expressions.length; i++) {
      partiallyEvaluatedExpression.add(expressions[i]);
    }

    return evaluate(partiallyEvaluatedExpression);
  }

  double _evaluateSimpleExpression(List<Scanned> expressions) {
    if (expressions.length == 1) {
      return double.parse(expressions[0].exp);
    } else {
      List<Scanned> newExpression = [];

      var mulIdx =
          expressions.map((e) => e.type).toList().indexOf(TypeOperator.mul);
      var divIdx =
          expressions.map((e) => e.type).toList().indexOf(TypeOperator.div);
      var computationIdx = (mulIdx >= 0 && divIdx >= 0)
          ? min(mulIdx, divIdx)
          : max(mulIdx, divIdx);
      if (computationIdx != -1) {
        var left = double.parse(expressions[computationIdx - 1].exp);
        var right = double.parse(expressions[computationIdx + 1].exp);
        var ans = computationIdx == mulIdx ? left * right : left / right * 1.0;
        for (int i = 0; i < computationIdx - 1; i++) {
          newExpression.add(expressions[i]);
        }
        newExpression.add(Scanned(
          exp: ans.toString(),
          type: TypeOperator.value,
        ));
        for (int i = computationIdx + 2; i < expressions.length; i++) {
          newExpression.add(expressions[i]);
        }
        return _evaluateSimpleExpression(newExpression);
      } else {
        var addIdx =
            expressions.map((e) => e.type).toList().indexOf(TypeOperator.add);
        var subIdx =
            expressions.map((e) => e.type).toList().indexOf(TypeOperator.sub);
        var computationIdx2 = (addIdx >= 0 && subIdx >= 0)
            ? min(addIdx, subIdx)
            : max(addIdx, subIdx);
        if (computationIdx2 != -1) {
          var left = double.parse(expressions[computationIdx2 - 1].exp);
          var right = double.parse(expressions[computationIdx2 + 1].exp);
          var ans =
              computationIdx2 == addIdx ? left + right : (left - right) * 1.0;
          for (int i = 0; i < computationIdx2 - 1; i++) {
            newExpression.add(expressions[i]);
          }
          newExpression.add(Scanned(
            exp: ans.toString(),
            type: TypeOperator.value,
          ));
          for (int i = computationIdx2 + 2; i < expressions.length; i++) {
            newExpression.add(expressions[i]);
          }
          return _evaluateSimpleExpression(newExpression);
        }
      }
    }
    return -1.0;
  }
}

class Scanned {
  final String exp;
  final TypeOperator type;

  Scanned({
    required this.exp,
    required this.type,
  });

  @override
  String toString() {
    return "Expression: $exp, type $type";
  }
}
