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
import '../controller/educational_stage_selection_controller.dart';

class EducationalStageSelectionPage extends StatefulWidget {
  const EducationalStageSelectionPage({super.key});

  @override
  State<EducationalStageSelectionPage> createState() =>
      _EducationalStageSelectionPageState();
}

class _EducationalStageSelectionPageState
    extends State<EducationalStageSelectionPage> {
  late EducationalStageSelectionController _controller;

  @override
  void initState() {
    super.initState();
    _controller = EducationalStageSelectionController();
    _controller.initDependencies(context: context);
  }

  @override
  void dispose() {
    _controller.disposeDependencies(context: context);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: context.read<DashboardController>().currentStepNotifier,
      builder: (BuildContext context, dynamic value, Widget? child) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (value == 2) {
            _controller.getData(context);
          }
        });

        return BlocDataBuilder<SelectionData>(
          bloc: _controller.educationalStagesBloc,
          builder: (context, state) {
            return state.maybeMap(
              loading: (value) => const Center(child: AppIndicator()),
              orElse:
                  () => const Center(
                    child: TextWidget(text: "Educational Stage Selection"),
                  ),
              successList: (data) {
                return ValueListenableBuilder<ListType>(
                  valueListenable:
                      context.read<DashboardController>().listTypeNotifier,
                  builder: (context, value, child) {
                    return ResponsiveListWidget<SelectionData>(
                      items: data.data ?? [],
                      listType: value,
                      childAspectRatio: 1.2, // Reduce height for grid items
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      itemBuilder:
                          (context, item, index) => ValueListenableBuilder(
                            valueListenable:
                                context
                                    .read<DashboardController>()
                                    .selectedEducationalStage,
                            builder: (
                              BuildContext context,
                              dynamic selectedValue,
                              Widget? child,
                            ) {
                              final isSelected = item == selectedValue;
                              final onTap = () {
                                context.read<DashboardController>().playSound();
                                context
                                    .read<DashboardController>()
                                    .selectedEducationalStage
                                    .value = item;
                                // Handle stage change to rebuild steps if necessary
                                context
                                    .read<DashboardController>()
                                    .onEducationalStageChanged();
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
      },
    );
  }
}
