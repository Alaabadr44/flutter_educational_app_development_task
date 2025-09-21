import 'package:flutter/material.dart';
import 'package:flutter_application_bloc/src/presentation/view_model/blocs/data_bloc/typedefs_bloc.dart';
import 'package:provider/provider.dart';

import '../../../../../../../../../../domain/entities/classroom_grade_selection.dart';
import '../../../../../../../../../../domain/entities/education_system.dart';
import '../../../../../../../../common/assistance_pagination.dart';
import '../../../../../../../../common/education_system_card.dart';
import '../../../../../../../../common/responsive_list_widget.dart';
import '../../../../../../../../common/text_widget.dart';
import '../../../../../../../../general/app_indicator.dart';
import '../../../../controller/dashboard_controller.dart';
import '../controller/classroom_selection_controller.dart';

class ClassroomSelectionPage extends StatefulWidget {
  const ClassroomSelectionPage({super.key});

  @override
  State<ClassroomSelectionPage> createState() => _ClassroomSelectionPageState();
}

class _ClassroomSelectionPageState extends State<ClassroomSelectionPage> {
  late ClassroomSelectionController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ClassroomSelectionController();
    _controller.initDependencies(context: context);

    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   _controller.getData(context);
    // });
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
          if (value == 3) {
            _controller.getData(context);
          }
        });

        return BlocDataBuilder<ClassroomGradeSelection>(
          bloc: _controller.classroomsBloc,
          builder: (context, state) {
            return state.maybeMap(
              loading: (value) => const Center(child: AppIndicator()),
              orElse:
                  () => const Center(
                    child: TextWidget(text: "Classroom Selection"),
                  ),
              successList: (data) {
                // Validate current selection when new data loads
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  final selectedClassroom =
                      context
                          .read<DashboardController>()
                          .selectedClassroom
                          .value;
                  final currentClassrooms =
                      data.data ?? <ClassroomGradeSelection>[];

                  if (selectedClassroom != null &&
                      !currentClassrooms.any(
                        (classroom) => classroom.id == selectedClassroom.id,
                      )) {
                    // Clear invalid selection
                    context
                        .read<DashboardController>()
                        .selectedClassroom
                        .value = null;
                  }
                });

                return ValueListenableBuilder<ListType>(
                  valueListenable:
                      context.read<DashboardController>().listTypeNotifier,
                  builder: (context, value, child) {
                    return ResponsiveListWidget<ClassroomGradeSelection>(
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
                                    .selectedClassroom,
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
                                    .selectedClassroom
                                    .value = item;
                                // Clear future selections when classroom changes
                                context
                                    .read<DashboardController>()
                                    .selectedAcademicTerm
                                    .value = null;
                                context
                                    .read<DashboardController>()
                                    .selectedEducationalTrack
                                    .value = null;
                              };

                              // Convert ClassroomGradeSelection to SelectionData for card compatibility
                              final selectionData = SelectionData(
                                id: item.id,
                                name: item.name,
                                img: item.img,
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
