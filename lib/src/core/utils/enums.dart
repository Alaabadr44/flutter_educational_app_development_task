import 'extension.dart';
import 'package:flutter/material.dart';

enum ApiRoute {
  // Auth
  login('/login'),
  logout('/logout'),
  deleteAccount('/delete_account'),
  educationSystems('/public/systems'),
  educationalStages('/public/stages'),
  classrooms('/public/classrooms'),
  subjects('/public/subjects'),
  terms('/public/terms'),
  lessons('/lessons'),
  questions('/lessons/questions'),
  paths('/public/paths');

  final String route;

  const ApiRoute(this.route);
}

enum AppLocalRoute {
  login('/login_page'),
  splash('/'),
  dashboard('/dashboard'),
  imageViewer('/image_viewer'),
  subjects('/subjects'),
  units('/units'), 
  lessons('/lessons'), 
  questions('/questions');

  final String route;

  const AppLocalRoute(this.route);
}

enum BottomNavigationPages {
  vehicles(0),
  customers(1),
  home(2),
  contracts(3),
  menu(4);

  final int page;
  const BottomNavigationPages(this.page);
  static List<BottomNavigationPages> get withOutHome {
    List<BottomNavigationPages> pages = List.from(BottomNavigationPages.values);
    pages.remove(BottomNavigationPages.home);
    return pages;
  }
}

enum SupportLanguage {
  english({'name': 'English', 'langCode': 'en', 'font': 'Poppins'}),
  arabic({'name': 'العربية', 'langCode': 'ar', 'font': 'Cairo'});

  final Map<String, String> info;

  const SupportLanguage(this.info);
}

enum SupportTheme {
  dark('Dark Mod'),
  light('Light Mod');

  final String themeMod;

  const SupportTheme(this.themeMod);
}

enum FileSource { camera, glary, both, files }

enum ThemeColor {
  baseColor,
  reverseBaseColor,
  primaryColor,
  secondaryColor,
  textPrimaryColor,
  textAccentColor,
  textSecondaryColor,
  cardPrimaryColor,
  cardAccentColor,
  cardSecondaryColor,
  successColor,
  errorColor,
  warningColor,
}

enum StyleText { greenDim }

enum DeviceScreenType { mobile, tablet }

enum ApiRequestType { get, post, delete, put }

enum FieldType { text, numbers, password, confirmPass, email, phone }

enum AuthWay {
  phone("phone_number"),
  email("email");

  const AuthWay(this.apiType);
  final String apiType;
}

enum Gender {
  male("male"),
  female("female");

  const Gender(this.apiType);
  final String apiType;
  static Gender? getByApiType(String? apiType) {
    if (apiType == null) return null;
    return Gender.values.firstWhereOrNull(
      (element) => element.apiType == apiType,
    );
  }
}

enum CustomerType {
  resident("resident"),
  citizen("citizen"),
  tourist("tourist");

  const CustomerType(this.apiType);
  final String apiType;
  static CustomerType? getByApiType(String? apiType) {
    if (apiType == null) return null;
    return CustomerType.values.firstWhereOrNull(
      (element) => element.apiType == apiType,
    );
  }
}

enum LocationType {
  landmark("1"),
  city("2"),
  district("3");

  const LocationType(this.apiType);
  final String apiType;
}

enum SearchBy { car, contract, vehicle }

enum RepairStatus {
  needsRepair("needs_repair"),
  pending("pending"),
  completed("completed"),
  inProgress("in_progress"),
  onHold("on_hold");

  const RepairStatus(this.apiType);
  final String apiType;
}

/// Payment method types enum
enum PaymentMethodType {
  cash("cash"),
  check("check"),
  card("card"),
  transfer("transfer");

  final String apiType;

  const PaymentMethodType(this.apiType);

  bool get isCash => this == PaymentMethodType.cash;
  bool get isCheck => this == PaymentMethodType.check;
  bool get isCard => this == PaymentMethodType.card;
  bool get isTransfer => this == PaymentMethodType.transfer;

  IconData get icon {
    switch (this) {
      case PaymentMethodType.cash:
        return Icons.payments_rounded;
      case PaymentMethodType.check:
        return Icons.receipt_long_rounded;
      case PaymentMethodType.card:
        return Icons.credit_card_rounded;
      case PaymentMethodType.transfer:
        return Icons.account_balance_rounded;
      default:
        return Icons.payment_rounded;
    }
  }

  Color get color {
    switch (this) {
      case PaymentMethodType.cash:
        return Colors.green;
      case PaymentMethodType.check:
        return Colors.blue;
      case PaymentMethodType.card:
        return Colors.purple;
      case PaymentMethodType.transfer:
        return Colors.orange;
    }
  }

  static PaymentMethodType? getByApiType(String? apiType) {
    if (apiType == null) return null;
    try {
      return PaymentMethodType.values.firstWhere(
        (type) => type.apiType == apiType.toLowerCase(),
      );
    } catch (e) {
      return null;
    }
  }

  String get description {
    switch (this) {
      case PaymentMethodType.cash:
        return "direct_cash_payment";
      case PaymentMethodType.check:
        return "payment_by_check_or_cheque";
      case PaymentMethodType.card:
        return "credit_or_debit_card_payment";
      case PaymentMethodType.transfer:
        return "bank_transfer_or_wire_payment";
    }
  }
}

/* 


         "Direct cash payment"

         "Payment by check or cheque"

         "Credit or debit card payment"

         "Bank transfer or wire payment"
 */

enum InsuranceType {
  comprehensive("comprehensive"),
  basic("basic");

  const InsuranceType(this.apiType);
  final String apiType;
}
