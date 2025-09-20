import 'package:flutter/material.dart';
import 'package:flutter_application_bloc/src/core/services/user_service.dart';
import 'package:flutter_application_bloc/src/presentation/view_model/blocs/data_bloc/api_data_bloc.dart';
import 'package:flutter_application_bloc/src/presentation/view_model/blocs/data_bloc/api_data_event.dart';
import '../../../../../../../core/utils/api_info.dart';
import '../../../../../../../core/utils/app_logger.dart';
import '../../../../../../../core/utils/enums.dart';
import '../../../../../../../core/utils/page_controller.dart';
import '../../../../../../../domain/entities/subjects_data.dart';
import '../../../../../mixins/list_type_view.dart';
import '../../../models/user_selections_model.dart';

class SubjectsController with ListTypeView implements AppPageController {
  UserSelectionsModel? userSelections;
  late ApiDataBloc<SubjectsData> subjectsBloc;

  @override
  void disposeDependencies({BuildContext? context}) {
    subjectsBloc.close(); 
    onDisposeListTypeView();
  }

  @override
  void initDependencies({
    BuildContext? context,
    UserSelectionsModel? userSelections,
  }) {
    this.userSelections = userSelections;
    AppLogger.logDebug('UserSelections: ${userSelections?.toJson()}');
    subjectsBloc = ApiDataBloc<SubjectsData>();
    getSubjects();
    onInitListTypeView();
  }

  void getSubjects() {
    subjectsBloc.add(
      ApiDataEvent.store(
        queryParams: ApiInfo(
          endpoint: ApiRoute.subjects.route,
          body: {
            "child_id": UserService.currentUser?.loginData?.id,
            "term_id": userSelections?.selectedAcademicTerm?.id,
            "path_id": userSelections?.selectedEducationalTrack?.id,
          },
        ),
        // apiMethod: ApiRequestType.post,
      ),
    );
  }

  @override
  String? get route => throw UnimplementedError();
}
