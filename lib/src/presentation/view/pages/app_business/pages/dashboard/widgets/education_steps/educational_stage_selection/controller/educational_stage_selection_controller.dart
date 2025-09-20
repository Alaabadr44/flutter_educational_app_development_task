import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../../../../../core/utils/api_info.dart';
import '../../../../../../../../../../core/utils/app_logger.dart';
import '../../../../../../../../../../core/utils/enums.dart';
import '../../../../../../../../../../core/utils/page_controller.dart';
import '../../../../../../../../../../domain/entities/education_system.dart';
import '../../../../../../../../../view_model/blocs/data_bloc/api_data_bloc.dart';
import '../../../../../../../../../view_model/blocs/data_bloc/api_data_event.dart';
import '../../../../controller/dashboard_controller.dart';

class EducationalStageSelectionController implements AppPageController {
  late final ApiDataBloc<SelectionData> educationalStagesBloc;

  @override
  void disposeDependencies({BuildContext? context}) {
    educationalStagesBloc.close();
  }

  @override
  void initDependencies({BuildContext? context}) {
    educationalStagesBloc = ApiDataBloc<SelectionData>();
   
  }

  getData(BuildContext context) {

    educationalStagesBloc.add(
       ApiDataEvent.index(
        queryParams: ApiInfo(
          // endpoint: ApiRoute.educationalStages.route,
          endpoint: ApiRoute.educationalStages.route,
          body: {
            "system_id":
                context
                    .read<DashboardController>()
                    .selectedEducationSystem.value?.id,
          },
        ),
        apiMethod: ApiRequestType.post,
        listWithoutPagination: true,
      ),
    );
  }

  @override
  // TODO: implement route
  String? get route => throw UnimplementedError();
}
