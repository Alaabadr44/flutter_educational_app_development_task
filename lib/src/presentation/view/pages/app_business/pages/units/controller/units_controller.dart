import 'package:flutter/material.dart';
import 'package:flutter_application_bloc/src/presentation/view_model/blocs/data_bloc/api_data_bloc.dart';

import '../../../../../../../core/utils/api_info.dart';
import '../../../../../../../core/utils/enums.dart';
import '../../../../../../../core/utils/page_controller.dart';
import '../../../../../../../domain/entities/subjects_data.dart';
import '../../../../../../../domain/entities/unit_data.dart';
import '../../../../../../view_model/blocs/data_bloc/api_data_event.dart';
import '../../../../../mixins/list_type_view.dart';

class UnitsController with ListTypeView implements AppPageController {
  late ApiDataBloc<UnitData> unitsBloc;
  Subject? subject;

  @override
  void disposeDependencies({BuildContext? context}) {
    unitsBloc.close();
    onDisposeListTypeView();
  }

  @override
  void initDependencies({BuildContext? context, Subject? subject}) {
    this.subject = subject;
    unitsBloc = ApiDataBloc<UnitData>();
    onInitListTypeView();
    getUnits();
  }

  void getUnits() {
    unitsBloc.add(
      ApiDataEvent.index(
        apiMethod: ApiRequestType.post,
        queryParams: ApiInfo(
          endpoint: ApiRoute.lessons.route,
          body: {'subject_id': subject?.id},
        ),
        listWithoutPagination: true,
      ),
    );
  }

  @override
  String? get route => throw UnimplementedError();
}
