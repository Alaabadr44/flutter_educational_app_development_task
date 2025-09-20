import 'package:flutter/material.dart';

import '../../../../../../../../../../core/utils/api_info.dart';
import '../../../../../../../../../../core/utils/enums.dart';
import '../../../../../../../../../../core/utils/page_controller.dart';
import '../../../../../../../../../../domain/entities/education_system.dart';
import '../../../../../../../../../view_model/blocs/data_bloc/api_data_bloc.dart';
import '../../../../../../../../../view_model/blocs/data_bloc/api_data_event.dart';

class EducationSystemsSelectionController implements AppPageController {
  late ApiDataBloc<SelectionData> educationSystemsBloc;

  @override
  void initDependencies({BuildContext? context}) {
    educationSystemsBloc = ApiDataBloc<SelectionData>();
    getEducationSystems();
  }

  @override
  void disposeDependencies({BuildContext? context}) {
    educationSystemsBloc.close();

  }

  void getEducationSystems() {
    educationSystemsBloc.add(
      ApiDataEvent.index(
        queryParams: ApiInfo(endpoint: ApiRoute.educationSystems.route),
        apiMethod: ApiRequestType.post,
        listWithoutPagination: true,
      ),
    );
  }

  @override
  String? get route => ApiRoute.educationSystems.route;
}
