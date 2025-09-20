import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../../../../../core/utils/api_info.dart';
import '../../../../../../../../../../core/utils/enums.dart';
import '../../../../../../../../../../core/utils/page_controller.dart';
import '../../../../../../../../../../domain/entities/educational_track_selection.dart';
import '../../../../../../../../../view_model/blocs/data_bloc/api_data_bloc.dart';
import '../../../../../../../../../view_model/blocs/data_bloc/api_data_event.dart';
import '../../../../controller/dashboard_controller.dart';

class EducationalTrackSelectionController implements AppPageController {
  late ApiDataBloc<EducationalTrackSelection> educationalTracksBloc;

  @override
  void disposeDependencies({BuildContext? context}) {
    educationalTracksBloc.close();
  }

  @override
  void initDependencies({BuildContext? context}) {
    educationalTracksBloc = ApiDataBloc<EducationalTrackSelection>();
  }

  void getData(BuildContext context) {
    educationalTracksBloc.add(
      ApiDataEvent.index(
        queryParams: ApiInfo(
          endpoint: ApiRoute.paths.route,
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
