import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../../../../../domain/entities/education_system.dart';
import '../../../../../../../../../../domain/entities/educational_track_selection.dart';
import '../../../../../../../../../view_model/blocs/data_bloc/typedefs_bloc.dart';
import '../../../../../../../../common/assistance_pagination.dart';
import '../../../../../../../../common/education_system_card.dart';
import '../../../../../../../../common/responsive_list_widget.dart';
import '../../../../../../../../common/text_widget.dart';
import '../../../../../../../../general/app_indicator.dart';
import '../../../../controller/dashboard_controller.dart';
import '../controller/educational_track_selection_controller.dart';

class EducationalTrackSelectionPage extends StatefulWidget {
  const EducationalTrackSelectionPage({super.key});

  @override
  State<EducationalTrackSelectionPage> createState() =>
      _EducationalTrackSelectionPageState();
}

class _EducationalTrackSelectionPageState
    extends State<EducationalTrackSelectionPage> {
  late EducationalTrackSelectionController _controller;

  @override
  void initState() {
    super.initState();
    _controller = EducationalTrackSelectionController();
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
          if (value == 5 &&
              context
                      .read<DashboardController>()
                      .selectedEducationalStage
                      .value
                      ?.id ==
                  7) {
            _controller.getData(context);
          }
        });

        return BlocDataBuilder<EducationalTrackSelection>(
          bloc: _controller.educationalTracksBloc,
          builder: (context, state) {
            return state.maybeMap(
              loading: (value) => const Center(child: AppIndicator()),
              orElse:
                  () => const Center(
                    child: TextWidget(text: "Educational Track Selection"),
                  ),
              successList: (data) {
                return ValueListenableBuilder<ListType>(
                  valueListenable:
                      context.read<DashboardController>().listTypeNotifier,
                  builder: (context, value, child) {
                    return ResponsiveListWidget<EducationalTrackSelection>(
                      items: data.data ?? [],
                      listType: value,
                      itemBuilder:
                          (context, item, index) => ValueListenableBuilder(
                            valueListenable:
                                context
                                    .read<DashboardController>()
                                    .selectedEducationalTrack,
                            builder: (
                              BuildContext context,
                              dynamic selectedValue,
                              Widget? child,
                            ) {
                              final isSelected = item == selectedValue;
                              final onTap = () {
                                context
                                    .read<DashboardController>()
                                    .selectedEducationalTrack
                                    .value = item;
                              };

                              // Convert EducationalTrackSelection to SelectionData for card compatibility
                              final selectionData = SelectionData(
                                id: item.id,
                                name: item.name,
                                systemId: item.systemId,
                                createdAt: item.createdAt?.toIso8601String(),
                                updatedAt: item.updatedAt,
                              );

                              // Use different card based on view type
                              return value == ListType.grid
                                  ? EducationSystemCompactCard(
                                    educationSystem: selectionData,
                                    onTap: onTap,
                                    isSelected: isSelected,
                                  )
                                  : EducationSystemCard(
                                    educationSystem: selectionData,
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
