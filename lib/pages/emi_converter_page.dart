import 'dart:math' as Math;

import 'package:bank_ifsc_flutter/network/model/emi_model.dart';
import 'package:bank_ifsc_flutter/utils/UiUtils.dart';
import 'package:bank_ifsc_flutter/utils/WidgetUtils.dart';
import 'package:bank_ifsc_flutter/utils/strings.dart';
import 'package:flutter/material.dart';

class EmiConverterPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _EmiConverterPageState();
  }
}

class _EmiConverterPageState extends State<EmiConverterPage> {
  TextEditingController tecAmount = TextEditingController();
  TextEditingController tecInterest = TextEditingController();
  TextEditingController tesTenureYears = TextEditingController(text: "0");
  TextEditingController tesTenureMonths = TextEditingController(text: "0");
  int tenure = 0;
  double emi = 0.0;
  double totalAmount = 0.0;
  double totalInterest = 0.0;
  List<EmiModel> paymentList = new List();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(emiConverterTitle),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _getTopSection(context),
              _getBottomSection(context),
              Card(
                child: Container(
                  margin: EdgeInsets.all(16.0),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: _getEmiBreakDown(context)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _getTopSection(BuildContext context) {
    return Card(
      child: Container(
        margin: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(compoundInterestPrincipalAmt, style: UiUtils.getTextStyleForSubHeaders()),
            TextField(
              controller: tecAmount,
              decoration: InputDecoration(hintText: compoundInterestPrincipalAmtEx),
              keyboardType: TextInputType.numberWithOptions(signed: true, decimal: true),
            ),
            SizedBox(height: 16.0),
            Text(compoundInterestAnnualInt, style: UiUtils.getTextStyleForSubHeaders()),
            TextField(
              controller: tecInterest,
              decoration: InputDecoration(hintText: compoundInterestAnnualIntEx),
              keyboardType: TextInputType.numberWithOptions(signed: true, decimal: true),
            ),
            SizedBox(height: 16.0),
            Text("Loan Tenure", style: UiUtils.getTextStyleForSubHeaders()),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: tesTenureYears,
                    keyboardType: TextInputType.numberWithOptions(signed: false, decimal: false),
                  ),
                ),
                Text("Years", style: UiUtils.getTextStyleForSecondaryText()),
                SizedBox(width: 32.0),
                Expanded(
                  child: TextField(
                    controller: tesTenureMonths,
                    keyboardType: TextInputType.numberWithOptions(signed: true, decimal: true),
                  ),
                ),
                Text("Months", style: UiUtils.getTextStyleForSecondaryText()),
              ],
            ),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Expanded(
                  child: RaisedButton(
                    onPressed: () {
                      setState(() {
                        tecAmount.text = "";
                        tecInterest.text = "";
                        tesTenureYears.text = "0";
                        tesTenureMonths.text = "0";
                        emi = 0.0;
                        totalInterest = 0.0;
                        totalAmount = 0.0;
                        WidgetUtils.dismissKeyboard(context);
                      });
                    },
                    child: Text(compoundInterestReset),
                    color: Theme.of(context).primaryColorLight,
                  ),
                ),
                SizedBox(width: 32.0),
                Expanded(
                  child: RaisedButton(
                    onPressed: () {
                      setState(() {
                        WidgetUtils.dismissKeyboard(context);
                        _calculate();
                      });
                    },
                    child: Text(compoundInterestCalculate),
                    color: Theme.of(context).primaryColorLight,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _getBottomSection(BuildContext context) {
    return Card(
      child: Container(
          margin: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  _getResultColumn("${totalInterest.ceil()} ₹", "Total Interest"),
                  _getResultColumn("${totalAmount.ceil()} ₹", "Total Amount"),
                ],
              ),
              SizedBox(height: 32.0),
              Column(
                children: <Widget>[
                  Text("EMI/month", style: UiUtils.getTextStyleForSubHeaders()),
                  SizedBox(height: 8.0),
                  Text("${emi.ceil()} ₹", style: UiUtils.getTextStyleForHeaders()),
                ],
              )
            ],
          )),
    );
  }

  Widget _getResultColumn(String data, String subLabel) {
    return Column(
      children: <Widget>[
        Text(data, style: UiUtils.getTextStyleForHeaders()),
        Text(subLabel, style: UiUtils.getTextStyleForSecondaryText()),
      ],
    );
  }

  List<Widget> _getEmiBreakDown(BuildContext context) {
    List<Widget> widgets = List();
    if (paymentList.isNotEmpty) {
      widgets.add(_getRowContent("Months", "Principal", "Interest", "Balance", true));
      paymentList.forEach((EmiModel emiModel) {
        widgets.add(Padding(
          padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
          child: _getRowContent(emiModel.displayMonthYear, "${emiModel.principalAmount.ceil()} ₹",
              "${emiModel.interestAmount.ceil()} ₹", "${emiModel.balanceAmount.ceil()} ₹", false),
        ));
      });
    } else {
      widgets.add(SizedBox());
    }

    return widgets;
  }

  Widget _getRowContent(String column1, String column2, String column3, String column4, bool bold) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        bold
            ? Text(column1, style: UiUtils.getTextStyleForListSubTitle(isBold: true))
            : Text(column1, style: UiUtils.getTextStyleForSecondaryText()),
        bold
            ? Text(column2, style: UiUtils.getTextStyleForListSubTitle(isBold: true))
            : Text(column2, style: UiUtils.getTextStyleForSecondaryText()),
        bold
            ? Text(column3, style: UiUtils.getTextStyleForListSubTitle(isBold: true))
            : Text(column3, style: UiUtils.getTextStyleForSecondaryText()),
        bold
            ? Text(column4, style: UiUtils.getTextStyleForListSubTitle(isBold: true))
            : Text(column4, style: UiUtils.getTextStyleForSecondaryText())
      ],
    );
  }

  _calculate() {
    if (tecAmount.text != null &&
        tecAmount.text.isNotEmpty &&
        tecInterest.text != null &&
        tecInterest.text.isNotEmpty &&
        tesTenureYears.text != null &&
        tesTenureYears.text.isNotEmpty &&
        tesTenureMonths.text != null &&
        tesTenureMonths.text.isNotEmpty) {
      double principal = double.parse(tecAmount.text);
      double rate = double.parse(tecInterest.text);
      double periodInyears = double.parse(tesTenureYears.text);
      double periodInMonths = double.parse(tesTenureMonths.text);

      tenure = ((periodInyears * 12) + periodInMonths).toInt();
      //tlStats.removeAllViewsInLayout();

      emi = _calculateMonthlyEmi(principal, rate, tenure);

      totalAmount = _calculateTotalAmount(emi, tenure);

      totalInterest = _calculateTotalInterest(principal, totalAmount);

      paymentList = _getEmiPaymentStats(principal, rate, tenure, emi);
    }
  }

  double _calculateMonthlyEmi(double principal, double rate, int tenure) {
    double monthlyRate = ((rate / 12) / 100);
    double emi = principal * monthlyRate * Math.pow(1 + monthlyRate, tenure) / (Math.pow(1 + monthlyRate, tenure) - 1);
    return emi;
  }

  double _calculateTotalAmount(double emiMonthly, int tenure) {
    double totalAmount = emiMonthly * tenure;
    return totalAmount;
  }

  double _calculateTotalInterest(double principal, double totalAmount) {
    double totalInterest = totalAmount - principal;
    return totalInterest;
  }

  List<EmiModel> _getEmiPaymentStats(double loanValue, double rate, int tenureMonth, double emiMonthly) {
    int currentYear = DateTime.now().year;
    List<EmiModel> paymentList = new List();
    for (int i = 0; i < tenureMonth; i++) {
      EmiModel emiPaymentDetails = new EmiModel();

      emiPaymentDetails.paymentYear = (currentYear + (i / 12)).toInt();
      emiPaymentDetails.paymentMonth = i % 12;
      emiPaymentDetails.displayMonthYear =
          "${_getMonthText(emiPaymentDetails.paymentMonth)},${emiPaymentDetails.paymentYear.toInt()}";

      double interestAmount = loanValue * (rate / 12 / 100);
      emiPaymentDetails.interestAmount = interestAmount;

      double principalAmount = emiMonthly - interestAmount;
      emiPaymentDetails.principalAmount = principalAmount;

      emiPaymentDetails.balanceAmount = loanValue - principalAmount;
      loanValue = loanValue - principalAmount;

      paymentList.add(emiPaymentDetails);
    }
    return paymentList;
  }

  String _getMonthText(int month) {
    switch (month) {
      case 0:
        return "Jan";
      case 1:
        return "Feb";
      case 2:
        return "Mar";
      case 3:
        return "Apr";
      case 4:
        return "May";
      case 5:
        return "Jun";
      case 6:
        return "Jul";
      case 7:
        return "Aug";
      case 8:
        return "Sep";
      case 9:
        return "Oct";
      case 10:
        return "Nov";
      case 11:
        return "Dec";
      default:
        return "$month";
    }
  }
}
