import 'package:flutter/material.dart';
import 'package:flutter_application_bloc/src/presentation/view_model/blocs/data_bloc/typedefs_bloc.dart';
import 'package:provider/provider.dart';

import '../../../../../../../../../../domain/entities/education_system.dart';
import '../../../../../../../../common/assistance_pagination.dart';
import '../../../../../../../../common/education_system_card.dart';
import '../../../../../../../../common/responsive_list_widget.dart';
import '../../../../../../../../common/text_widget.dart';
import '../../../../../../../../general/app_indicator.dart';
import '../../../../controller/dashboard_controller.dart';
import '../controller/education_systems_selection_controller.dart';

class EducationSystemSelectionPage extends StatefulWidget {
  const EducationSystemSelectionPage({super.key});

  @override
  State<EducationSystemSelectionPage> createState() =>
      _EducationSystemSelectionPageState();
}

class _EducationSystemSelectionPageState
    extends State<EducationSystemSelectionPage> {
  late EducationSystemsSelectionController _controller;

  @override
  void initState() {
    super.initState();
    _controller = EducationSystemsSelectionController();
    _controller.initDependencies(context: context);
  }

  @override
  void dispose() {
    _controller.disposeDependencies(context: context);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocDataBuilder<SelectionData>(
      bloc: _controller.educationSystemsBloc,
      builder: (context, state) {
        return state.maybeMap(
          loading: (value) => const Center(child: AppIndicator()),
          orElse:
              () => const Center(
                child: TextWidget(text: "Education System Selection"),
              ),
          successList: (data) {
            return ValueListenableBuilder<ListType>(
              valueListenable:
                  context.read<DashboardController>().listTypeNotifier,
              builder: (context, value, child) {
                return ResponsiveListWidget<SelectionData>(
                  items: data.data ?? [],
                  listType: value,
                  itemBuilder:
                      (context, item, index) => ValueListenableBuilder(
                        valueListenable:
                            context
                                .read<DashboardController>()
                                .selectedEducationSystem,
                        builder: (
                          BuildContext context,
                          dynamic selectedValue,
                          Widget? child,
                        ) {
                          final isSelected = item == selectedValue;
                          final onTap = () {
                            context
                                .read<DashboardController>()
                                .selectedEducationSystem
                                .value = item;
                          };

                          // Use different card based on view type
                          return value == ListType.grid
                              ? EducationSystemCompactCard(
                                educationSystem: item,
                                onTap: onTap,
                                isSelected: isSelected,
                              )
                              : EducationSystemCard(
                                educationSystem: item,
                                onTap: onTap,
                                isSelected: isSelected,
                                showSelectionIndicator: true,
                              );
                        },
                      ),
                );
              },
            );
          },
        );
      },
    );
  }
}
