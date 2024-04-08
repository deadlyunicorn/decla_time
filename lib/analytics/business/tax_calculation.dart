
class TaxCalculation {
  double get yearlyIncome => _yearlyIncome;
  final double _yearlyIncome;

  double untaxedAmount;
  double get taxRate {
    if (yearlyIncome <= 10000) {
      return 0.09;
    } else if (yearlyIncome <= 20000) {
      return 0.22;
    } else if (yearlyIncome <= 30000) {
      return 0.28;
    } else if (yearlyIncome <= 40000) {
      return 0.36;
    } else {
      return 0.44;
    }
  }

  double get fees {
    return (untaxedAmount * taxRate * 100).round() / 100;
  }

  double get totalAfterFees {
    return ((untaxedAmount * (1 - 1 * taxRate)) * 100).round() / 100;
  }

  TaxCalculation({
    required double yearlyIncome,
    required this.untaxedAmount,
  }) : _yearlyIncome = yearlyIncome;
}
