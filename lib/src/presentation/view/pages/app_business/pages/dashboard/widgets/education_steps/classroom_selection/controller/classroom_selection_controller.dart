import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../../../../../core/utils/api_info.dart';
import '../../../../../../../../../../core/utils/enums.dart';
import '../../../../../../../../../../core/utils/page_controller.dart';
import '../../../../../../../../../../domain/entities/classroom_grade_selection.dart';
import '../../../../../../../../../view_model/blocs/data_bloc/api_data_bloc.dart';
import '../../../../../../../../../view_model/blocs/data_bloc/api_data_event.dart';
import '../../../../controller/dashboard_controller.dart';

class ClassroomSelectionController implements AppPageController {
  late ApiDataBloc<ClassroomGradeSelection> classroomsBloc;
  @override
  void disposeDependencies({BuildContext? context}) {
    classroomsBloc.close();
  }

  @override
  void initDependencies({BuildContext? context}) {
    classroomsBloc = ApiDataBloc<ClassroomGradeSelection>();
  }

  void getData(BuildContext context) {
    classroomsBloc.add(
      ApiDataEvent.index(
        queryParams: ApiInfo(endpoint: ApiRoute.classrooms.route,body: {
          'system_id': context.read<DashboardController>().selectedEducationSystem.value?.id,
          'stage_id': context.read<DashboardController>().selectedEducationalStage.value?.id,
         
        }),
        apiMethod: ApiRequestType.post,
        listWithoutPagination: true,
      ),
    );
  }

  @override
  // TODO: implement route
  String? get route => throw UnimplementedError();
}
