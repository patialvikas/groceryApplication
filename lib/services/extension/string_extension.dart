import 'dart:math';

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}

extension NumberRounding on double {
  double toPrecision() {
    print('THISTHISTHISTHISTHISTHIS'+this.toString());
    double mod = pow(10.0, 2);
    return ((this * mod).round().toDouble() / mod);
  }
}
