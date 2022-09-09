enum TypeOperator { add, sub, mul, div, lPar, rPar, value }

extension TypeOperatorString on TypeOperator {
  String toStringEnum() {
    switch (this) {
      case TypeOperator.add:
        return "+";
      case TypeOperator.sub:
        return "-";
      case TypeOperator.mul:
        return "*";
      case TypeOperator.div:
        return "/";
      case TypeOperator.lPar:
        return "(";
      case TypeOperator.rPar:
        return ")";
      default:
        return "";
    }
  }

  TypeOperator fromString(String s) {
    switch (s) {
      case "+":
        return TypeOperator.add;
      case "-":
        return TypeOperator.sub;
      case "*":
        return TypeOperator.mul;
      case "/":
        return TypeOperator.div;
      case "(":
        return TypeOperator.lPar;
      case ")":
        return TypeOperator.rPar;
      default:
        return TypeOperator.value;
    }
  }
}