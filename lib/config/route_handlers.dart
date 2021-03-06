import 'package:bank_ifsc_flutter/network/model/bank_data.dart';
import 'package:bank_ifsc_flutter/screens/balance_check_detail_page.dart';
import 'package:bank_ifsc_flutter/screens/balance_check_list_page.dart';
import 'package:bank_ifsc_flutter/screens/bank_customer_care_page.dart';
import 'package:bank_ifsc_flutter/screens/bank_detail_page.dart';
import 'package:bank_ifsc_flutter/screens/compound_interest_page.dart';
import 'package:bank_ifsc_flutter/screens/currency_converter_page.dart';
import 'package:bank_ifsc_flutter/screens/emi_converter_page.dart';
import 'package:bank_ifsc_flutter/screens/home_page.dart';
import 'package:bank_ifsc_flutter/screens/search_bank_page.dart';
import 'package:bank_ifsc_flutter/utils/widget_utils.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';

class RouteHandler {
  // route all request to home page
  Handler rootHandler = new Handler(handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    return new HomePage();
  });

  Handler searchBankRouteHandler = new Handler(handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    return new SearchBankPage(
      bankName: params["bankName"]?.first,
      bankState: params["bankState"]?.first,
      bankCity: params["bankCity"]?.first,
      bankBranch: params["bankBranch"]?.first,
    );
  });

  Handler bankDetailsRouteHandler = new Handler(handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    return new BankDetailsPage(
      bankData: BankData(
          bank: params["bankName"]?.first,
          state: params["bankState"]?.first,
          city: params["bankCity"]?.first,
          branch: params["bankBranch"]?.first,
          ifsc: params["bankIFSC"]?.first,
          district: params["bankDistrict"]?.first,
          contact: params["bankContact"]?.first,
          address: params["bankAddress"]?.first,
          rtgs: params["bankRtgs"]?.first),
      bankIFSC: params["bankIFSC"]?.first,
    );
  });

  Handler bankBalanceCheckPageRouteHandler =
      new Handler(handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    return new BankBalanceCheckPage();
  });

  Handler bankBalanceDetailPageRouteHandler =
      new Handler(handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    return new BankBalanceDetailPage(
      bankName: params["bankName"]?.first,
      bankBalanceNum: params["bankBalanceNum"]?.first,
      miniStatementNum: params["miniStatementNum"]?.first,
      customerCareNum: params["customerCareNum"]?.first,
      officialWebsite: params["officialWebsite"]?.first,
      personalWebsite: params["personalWebsite"]?.first,
    );
  });

  Handler bankCustomerCareRouteHandler = new Handler(handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    return new BankCustomerCarePage();
  });

  Handler currencyConverterRouteHandler =
      new Handler(handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    return new CurrencyConverterPage();
  });

  Handler compoundInterestRouteHandler = new Handler(handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    return new CompoundInterestPage();
  });

  Handler emiRouteHandler = new Handler(handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    return new EmiConverterPage();
  });

  Handler atmRouteHandler = new Handler(
      type: HandlerType.function,
      handlerFunc: (BuildContext context, Map<String, List<String>> params) {
        WidgetUtils.launchMapURL("ATM near me");
      });

  Handler branchRouteHandler = new Handler(
      type: HandlerType.function,
      handlerFunc: (BuildContext context, Map<String, List<String>> params) {
        WidgetUtils.launchMapURL("Bank near me");
      });
}
