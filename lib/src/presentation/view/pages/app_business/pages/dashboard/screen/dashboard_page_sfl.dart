import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../../core/config/app_colors.dart';
import '../../../../../../../core/config/l10n/generated/l10n.dart';
import '../../../../../../../core/utils/enums.dart';
import '../../../../../../../core/utils/extension.dart';
import '../../../../../../../core/utils/layout/responsive_layout.dart';
import '../../../../../common/assistance_pagination.dart';
import '../../../../../commbonant/lang_bottom_sheet.dart';
import '../../../../../common/fields/_field_helper/form_key.dart';
import '../../../../../common/fields/generic_text_field.dart';
import '../../../../../common/text_widget.dart';
import '../controller/dashboard_controller.dart';
import '../widgets/education_steps/academic_term_selection/page/academic_term_selection_page.dart';
import '../widgets/education_steps/classroom_selection/page/classroom_selection_page.dart';
import '../widgets/education_steps/education_systems_selection/page/education_systems_selection_page.dart';
import '../widgets/education_steps/educational_stage_selection/page/educational_stage_selection_page.dart';
import '../widgets/education_steps/educational_track_selection/page/educational_track_selection_page.dart';

class DashboardPageSfl extends StatefulWidget {
  const DashboardPageSfl({super.key});

  @override
  State<DashboardPageSfl> createState() => _DashboardPageSflState();
}

class _DashboardPageSflState extends State<DashboardPageSfl>
    with TickerProviderStateMixin {
  late DashboardController _pageController;
  @override
  void initState() {
    super.initState();
    _pageController = DashboardController();
    _pageController.initDependencies(context: context);
  }

  @override
  void dispose() {
    _pageController.disposeDependencies();
    // mainPageController.disposeDependencies();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      isPadding: true,
      onBackPage: (context) {}, // Prevent back navigation
      canPop: false,
      appBar: AppBar(
        title: TextWidget(text: S.current.dashboard),
        automaticallyImplyLeading: false,

        actions: [
          // View Toggle Button
          ValueListenableBuilder(
            valueListenable: _pageController.listTypeNotifier,
            builder: (context, listType, child) {
              return IconButton(
                tooltip: listType == ListType.list ? 'Grid View' : 'List View',
                onPressed: () {
                  _pageController.toggleView();
                },
                icon: Icon(
                  listType == ListType.list ? Icons.grid_view : Icons.list,
                ),
              );
            },
          ),
          IconButton(
            tooltip: S.current.select_language,
            onPressed: () {
              context.showSheet(
                SizedBox(
                  height: context.screenSize.height * 0.4,
                  child: LangBottomWidget(isLable: true, onTab: () {}),
                ),
              );
            },
            icon: const Icon(Icons.language_rounded),
          ),
        ], // Remove back button
      ),
      builder: (context, info) {
        return ResponsiveLayout(
          isPadding: true,
          // bottomNavigationBar: AppBtnNavBar(controller: mainPageController),
          builder: (context, info) {
            return ValueListenableBuilder<int>(
              valueListenable: _pageController.currentStepNotifier,
              builder: (context, currentStep, child) {
                return Column(
                  children: [
                    // Progress Indicator
                    _buildProgressIndicator(),

                    // Content with IndexedStack
                    Provider.value(
                      value: _pageController,
                      child: Expanded(
                        child: IndexedStack(
                          index: currentStep - 1,
                          children: [
                            EducationSystemSelectionPage(),
                            EducationalStageSelectionPage(),
                            ClassroomSelectionPage(),
                            AcademicTermSelectionPage(),
                            EducationalTrackSelectionPage(),
                          ],
                        ),
                      ),
                    ),

                    // Navigation
                    _buildNavigation(),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildProgressIndicator() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: AppColors.grey100, width: 1)),
      ),
      child: ValueListenableBuilder<int>(
        valueListenable: _pageController.currentStepNotifier,
        builder: (context, currentStep, child) {
          final controller = _pageController;
          final totalSteps = controller.stepTitles.length;

          return Column(
            children: [
              // Progress Bar
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 8,
                      decoration: BoxDecoration(
                        color: AppColors.grey100,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: currentStep / totalSteps,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 600),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppColors.primaryColor,
                                AppColors.primaryColor.withValues(alpha: 0.8),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Step Info
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      controller.stepIcons[currentStep - 1],
                      color: AppColors.primaryColor,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextWidget(
                          text: "Step $currentStep of $totalSteps",
                          style: context.bodyS?.copyWith(
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        TextWidget(
                          text: controller.stepTitles[currentStep - 1],
                          style: context.titleM?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimaryColor,
                          ),
                        ),
                        const SizedBox(height: 4),
                        TextWidget(
                          text: controller.stepDescriptions[currentStep - 1],
                          style: context.bodyM?.copyWith(
                            color: AppColors.grey600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildNavigation() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: const Border(
          top: BorderSide(color: AppColors.grey100, width: 1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: ValueListenableBuilder<int>(
        valueListenable: _pageController.currentStepNotifier,
        builder: (context, currentStep, child) {
          final controller = _pageController;
          final totalSteps = controller.stepTitles.length;
          final isFirstStep = currentStep <= 1;
          final isLastStep = currentStep >= totalSteps;

          return Row(
            children: [
              if (!isFirstStep) ...[
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      controller.goBack();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      foregroundColor: AppColors.primaryColor,
                      side: BorderSide(color: AppColors.primaryColor),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: TextWidget(
                      text: 'Previous',
                      style: context.bodyM?.copyWith(
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
              ],
              Expanded(
                child: ValueListenableBuilder<int>(
                  valueListenable: controller.currentStepNotifier,
                  builder: (context, currentStep, child) {
                    return ValueListenableBuilder(
                      valueListenable:
                          currentStep == 1
                              ? controller.selectedEducationSystem
                              : currentStep == 2
                              ? controller.selectedEducationalStage
                              : currentStep == 3
                              ? controller.selectedClassroom
                              : currentStep == 4
                              ? controller.selectedAcademicTerm
                              : currentStep == 5 &&
                                  controller
                                          .selectedEducationalStage
                                          .value
                                          ?.id ==
                                      7
                              ? controller.selectedEducationalTrack
                              : controller.selectedAcademicTerm, // Fallback
                      builder: (context, selectedValue, child) {
                        final canProceed = isLastStep || controller.canGoNext();
                        return ElevatedButton(
                          onPressed:
                              canProceed
                                  ? () {
                                    if (isLastStep) {
                                      context.nextNamed(
                                        AppLocalRoute.subjects.route,
                                        argument: controller.getSelections(),
                                      );
                                    } else {
                                      controller.goNext();
                                    }
                                  }
                                  : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                canProceed
                                    ? AppColors.primaryColor
                                    : AppColors.grey400,
                            foregroundColor:
                                canProceed ? Colors.white : AppColors.grey600,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: TextWidget(
                            text:
                                isLastStep ? 'Complete Selection' : 'Continue',
                            style: context.bodyM?.copyWith(
                              color:
                                  canProceed ? Colors.white : AppColors.grey600,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
