// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_application_bloc/src/presentation/view/pages/app_business/pages/dashboard/screen/dashboard_page_sfl.dart';
import 'package:flutter_application_bloc/src/presentation/view/pages/auth/login/screen/login_page.dart';

import '../../domain/entities/subjects_data.dart';
import '../../domain/entities/unit_data.dart';
import '../../presentation/view/pages/app_business/models/user_selections_model.dart';
import '../../presentation/view/pages/splash/splash_screen.dart';
import '../utils/app_logger.dart';
import '../utils/enums.dart';
import 'service_interface.dart';

import '../../presentation/view/pages/app_business/pages/subjects/screen/subjects_page_sfl.dart';

import '../../presentation/view/pages/app_business/pages/units/screen/units_page_sfl.dart';

import '../../presentation/view/pages/app_business/pages/questions/screen/questions_page_sfl.dart'; 




class RouterService implements ServiceInterface {
  @override
  String get name => 'Router Service';

  @override
  Future<void> initializeService() async {
    AppLogger.logDebug('$name Success initialization');
  }

  static String get initialRoute => AppLocalRoute.splash.route;

  static final routes = <String, Widget Function(BuildContext, {Object? arg})>{
    AppLocalRoute.splash.route:
        (BuildContext context, {Object? arg}) => const SplashScreen(),
    AppLocalRoute.login.route:
        (BuildContext context, {Object? arg}) => const LoginPage(),

    AppLocalRoute.dashboard.route:
        (BuildContext context, {Object? arg}) => DashboardPageSfl(),

    AppLocalRoute.subjects.route:
        (BuildContext context, {Object? arg}) =>
            SubjectsPageSfl(userSelections: arg as UserSelectionsModel),

    AppLocalRoute.units.route:
        (BuildContext context, {Object? arg}) =>
            UnitsPageSfl(subject:  arg as Subject),
  
    AppLocalRoute.questions.route: (BuildContext context, {Object? arg}) =>
        QuestionsPageSfl(lesson: arg as Lesson),
  
};
  var onGenerateRoute = (RouteSettings settings) {
    final String? name = settings.name;
    final Function(BuildContext, {Object? arg})? pageContentBuilder =
        routes[name];
    if (pageContentBuilder != null) {
      if (settings.arguments != null) {
        final Route route = MaterialPageRoute(
          settings: settings,
          builder:
              (context) => pageContentBuilder(context, arg: settings.arguments),
        );
        return route;
      } else {
        final Route route = MaterialPageRoute(
          settings: settings,
          builder: (context) => pageContentBuilder(context),
        );
        return route;
      }
    }
  };

  // Singleton
  RouterService.int();
  static RouterService? _instance;
  factory RouterService() => _instance ??= RouterService.int();
}
