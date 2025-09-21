import 'package:flutter/material.dart';
import 'package:flutter_application_bloc/src/presentation/view_model/blocs/data_bloc/typedefs_bloc.dart';
import 'package:provider/provider.dart';

import '../../../../../../../../../../domain/entities/academic_term_selection.dart';
import '../../../../../../../../../../domain/entities/education_system.dart';
import '../../../../../../../../common/assistance_pagination.dart';
import '../../../../../../../../common/education_system_card.dart';
import '../../../../../../../../common/responsive_list_widget.dart';
import '../../../../../../../../common/text_widget.dart';
import '../../../../../../../../general/app_indicator.dart';
import '../../../../controller/dashboard_controller.dart';
import '../controller/academic_term_selection_controller.dart';

class AcademicTermSelectionPage extends StatefulWidget {
  const AcademicTermSelectionPage({super.key});

  @override
  State<AcademicTermSelectionPage> createState() =>
      _AcademicTermSelectionPageState();
}

class _AcademicTermSelectionPageState extends State<AcademicTermSelectionPage> {
  late AcademicTermSelectionController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AcademicTermSelectionController();
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
          if (value == 4) {
            _controller.getData(context);
          }
        });

        return BlocDataBuilder<AcademicTermSelection>(
          bloc: _controller.academicTermsBloc,
          builder: (context, state) {
            return state.maybeMap(
              loading: (value) => const Center(child: AppIndicator()),
              orElse:
                  () => const Center(
                    child: TextWidget(text: "Academic Term Selection"),
                  ),
              successList: (data) {
                return ValueListenableBuilder<ListType>(
                  valueListenable:
                      context.read<DashboardController>().listTypeNotifier,
                  builder: (context, value, child) {
                    return ResponsiveListWidget<AcademicTermSelection>(
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
                                    .selectedAcademicTerm,
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
                                    .selectedAcademicTerm
                                    .value = item;
                              };

                              // Convert AcademicTermSelection to SelectionData for card compatibility
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
