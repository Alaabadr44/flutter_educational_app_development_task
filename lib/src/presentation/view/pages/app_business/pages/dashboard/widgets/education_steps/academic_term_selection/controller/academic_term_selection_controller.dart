import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../../../../../core/utils/api_info.dart';
import '../../../../../../../../../../core/utils/enums.dart';
import '../../../../../../../../../../core/utils/page_controller.dart';
import '../../../../../../../../../../domain/entities/academic_term_selection.dart';
import '../../../../../../../../../view_model/blocs/data_bloc/api_data_bloc.dart';
import '../../../../../../../../../view_model/blocs/data_bloc/api_data_event.dart';
import '../../../../controller/dashboard_controller.dart';

class AcademicTermSelectionController implements AppPageController {
  late ApiDataBloc<AcademicTermSelection> academicTermsBloc;

  @override
  void disposeDependencies({BuildContext? context}) {
    academicTermsBloc.close();
  }

  @override
  void initDependencies({BuildContext? context}) {
    academicTermsBloc = ApiDataBloc<AcademicTermSelection>();
  }

  void getData(BuildContext context) {
    academicTermsBloc.add(
      ApiDataEvent.index(
        queryParams: ApiInfo(
          endpoint: ApiRoute.terms.route,
          body: {
            'classroom_id':
                context.read<DashboardController>().selectedClassroom.value?.id,
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
