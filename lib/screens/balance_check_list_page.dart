import 'package:bank_ifsc_flutter/network/ifsc_api.dart';
import 'package:bank_ifsc_flutter/network/model/bank_care_data.dart';
import 'package:bank_ifsc_flutter/network/model/response_model.dart';
import 'package:bank_ifsc_flutter/utils/widget_utils.dart';
import 'package:bank_ifsc_flutter/misc/strings.dart';
import 'package:bank_ifsc_flutter/widgets/w_bank_card.dart';
import 'package:flutter/material.dart';

class BankBalanceCheckPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _BankBalanceCheckPageStage();
  }
}

class _BankBalanceCheckPageStage extends State<BankBalanceCheckPage> {
  ResponseModel<List<BankCareData>> responseModel;

  @override
  void initState() {
    loadBankDataFromAPI();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(balanceCheckBankBalanceCheck),
      ),
      body: _getBody(responseModel),
    );
  }

  void loadBankDataFromAPI() async {
    var model = await IfscAPI().getCustomerCareInfo();

    setState(() {
      responseModel = model;
    });
  }

  Widget _getBody(ResponseModel<List<BankCareData>> responseModel) {
    Widget container = Center(child: Text(noBankFound));
    if (responseModel == null) {
      container = Center(child: CircularProgressIndicator());
    } else if (responseModel.errorCode != 200) {
      WidgetUtils.showSnackBar(context, networkError);
    } else if (responseModel.data != null && responseModel.data.isNotEmpty) {
      container = _getBankCardsList(responseModel.data);
    }

    return container;
  }

  Widget _getBankCardsList(List<BankCareData> bankData) {
    return Container(
      margin: EdgeInsetsDirectional.only(start: 8.0, end: 8.0, top: 16.0, bottom: 8.0),
      child: ListView.builder(
        itemBuilder: (BuildContext context, int position) {
          return BankCard(bankData[position]);
        },
        itemCount: bankData.length,
      ),
    );
  }
}
