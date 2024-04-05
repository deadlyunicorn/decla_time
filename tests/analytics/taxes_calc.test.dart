import "package:decla_time/analytics/business/tax_calculation.dart";
import "package:test/test.dart";

void main() {
  //? Calculate yearly tax

  //* Case 1 - <10K EUR -> tax is 9%
  test("Tax for income below 10K", () {
    final TaxCalculation calculation = TaxCalculation(
      yearlyIncome: 5000,
      untaxedAmount: 480,
    );
    expect(calculation.totalAfterFees, 436.8);
    expect(calculation.fees, 43.20);
    expect(
      calculation.totalAfterFees + calculation.fees,
      calculation.untaxedAmount,
    );

    final TaxCalculation calculation2 = TaxCalculation(
      yearlyIncome: 10000,
      untaxedAmount: 480,
    );
    expect(calculation2.totalAfterFees, 436.8);
    expect(calculation2.fees, 43.20);
    expect(
      calculation2.totalAfterFees + calculation2.fees,
      calculation2.untaxedAmount,
    );
  });

  //* Case 2 - <20K EUR -> tax is 22%
  test("Tax for income below 20K", () {
    final TaxCalculation calculation2 = TaxCalculation(
      yearlyIncome: 10001,
      untaxedAmount: 480,
    );
    expect(calculation2.totalAfterFees, 374.4);
    expect(calculation2.fees, 105.60);
    expect(
      calculation2.totalAfterFees + calculation2.fees,
      calculation2.untaxedAmount,
    );

    final TaxCalculation calculation3 = TaxCalculation(
      yearlyIncome: 20000,
      untaxedAmount: 480,
    );
    expect(calculation3.totalAfterFees, 374.4);
    expect(calculation3.fees, 105.60);
    expect(
      calculation3.totalAfterFees + calculation3.fees,
      calculation3.untaxedAmount,
    );
  });
  //* Case 3 - <30K EUR -> tax is 28%
  test("Tax for income below 30K", () {
    final TaxCalculation calculation2 = TaxCalculation(
      yearlyIncome: 20001,
      untaxedAmount: 480,
    );
    expect(calculation2.totalAfterFees, 345.6);
    expect(calculation2.fees, 134.4);
    expect(
      calculation2.totalAfterFees + calculation2.fees,
      calculation2.untaxedAmount,
    );

    final TaxCalculation calculation3 = TaxCalculation(
      yearlyIncome: 30000,
      untaxedAmount: 480,
    );
    expect(calculation3.totalAfterFees, 345.6);
    expect(calculation3.fees, 134.4);
    expect(
      calculation3.totalAfterFees + calculation3.fees,
      calculation3.untaxedAmount,
    );
  });

  //* Case 4 - <40K EUR -> tax is 36%
  test("Tax for income below 40K", () {
    final TaxCalculation calculation2 = TaxCalculation(
      yearlyIncome: 30001,
      untaxedAmount: 480,
    );
    expect(calculation2.fees, 172.8);
    expect(calculation2.totalAfterFees, 307.2);
    expect(
      calculation2.totalAfterFees + calculation2.fees,
      calculation2.untaxedAmount,
    );

    final TaxCalculation calculation3 = TaxCalculation(
      yearlyIncome: 40000,
      untaxedAmount: 480,
    );
    expect(calculation3.totalAfterFees, 307.2);
    expect(calculation3.fees, 172.8);
    expect(
      calculation3.totalAfterFees + calculation3.fees,
      calculation3.untaxedAmount,
    );
  });
  //* Case 5 - ELSE -> tax is 44%
  test("Tax for income above 40K", () {
    final TaxCalculation calculation2 = TaxCalculation(
      yearlyIncome: 40001,
      untaxedAmount: 480,
    );
    expect(calculation2.fees, 211.2);
    expect(calculation2.totalAfterFees, 268.8);
    expect(
      calculation2.totalAfterFees + calculation2.fees,
      calculation2.untaxedAmount,
    );

    final TaxCalculation calculation3 = TaxCalculation(
      yearlyIncome: 9123123,
      untaxedAmount: 480,
    );
    expect(calculation3.totalAfterFees, 268.8);
    expect(calculation3.fees, 211.2);
    expect(
      calculation3.totalAfterFees + calculation3.fees,
      calculation3.untaxedAmount,
    );
  });
}
