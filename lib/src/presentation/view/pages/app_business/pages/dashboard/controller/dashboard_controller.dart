import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import '../../../../../../../core/config/assets/assets.gen.dart';
import '../../../../../../../core/config/injector.dart';
import '../../../../../../../core/services/sound_service.dart';
import '../../../../../../../core/services/user_service.dart';
import '../../../../../../../core/utils/enums.dart';
import '../../../../../../../core/utils/extension.dart';
import '../../../../../../../core/utils/page_controller.dart';
import '../../../../../../../domain/entities/education_system.dart';
import '../../../../../../../domain/entities/classroom_grade_selection.dart';
import '../../../../../../../domain/entities/academic_term_selection.dart';
import '../../../../../../../domain/entities/educational_track_selection.dart';
import '../../../../../mixins/list_type_view.dart';
import '../../../models/user_selections_model.dart';

class DashboardController with ListTypeView implements AppPageController {
  late ValueNotifier<SelectionData?> selectedEducationSystem;
  late ValueNotifier<SelectionData?> selectedEducationalStage;
  late ValueNotifier<ClassroomGradeSelection?> selectedClassroom;
  late ValueNotifier<AcademicTermSelection?> selectedAcademicTerm;
  late ValueNotifier<EducationalTrackSelection?> selectedEducationalTrack;

  // Step titles - dynamically generated based on selected stage
  List<String> get stepTitles {
    final baseSteps = [
      "Education System Selection",
      "Educational Stage Selection",
      "Classroom / Grade Selection",
      "Academic Term Selection",
    ];

    // Only add Educational Track Selection if selected stage ID is 7
    if (selectedEducationalStage.value?.id == 7) {
      return [...baseSteps, "Educational Track Selection"];
    }

    return baseSteps;
  }

  // Step descriptions - dynamically generated based on selected stage
  List<String> get stepDescriptions {
    final baseDescriptions = [
      "Select your education system",
      "Choose your educational stage",
      "Select your classroom or grade",
      "Choose the academic term",
    ];

    // Only add Educational Track description if selected stage ID is 7
    if (selectedEducationalStage.value?.id == 7) {
      return [
        ...baseDescriptions,
        "Select your educational track (Secondary only)",
      ];
    }

    return baseDescriptions;
  }

  // Step icons - dynamically generated based on selected stage
  List<IconData> get stepIcons {
    final baseIcons = [
      Icons.school,
      Icons.trending_up,
      Icons.class_,
      Icons.calendar_today,
    ];

    // Only add Educational Track icon if selected stage ID is 7
    if (selectedEducationalStage.value?.id == 7) {
      return [...baseIcons, Icons.track_changes];
    }

    return baseIcons;
  }

  final ValueNotifier<int> currentStepNotifier = ValueNotifier<int>(1);

  @override
  void disposeDependencies({BuildContext? context}) {
    currentStepNotifier.dispose();
    onDisposeListTypeView();

    selectedEducationSystem.dispose();
    selectedEducationalStage.dispose();
    selectedClassroom.dispose();
    selectedAcademicTerm.dispose();
    selectedEducationalTrack.dispose();
  }

  // Navigation methods
  bool canGoNext() {
    switch (currentStepNotifier.value) {
      case 1: // Education System Selection
        return selectedEducationSystem.value != null;
      case 2: // Educational Stage Selection
        return selectedEducationalStage.value != null;
      case 3: // Classroom Selection
        return selectedClassroom.value != null;
      case 4: // Academic Term Selection
        return selectedAcademicTerm.value != null;
      case 5: // Educational Track Selection (only if stage ID == 7)
        if (selectedEducationalStage.value?.id == 7) {
          return selectedEducationalTrack.value != null;
        }
        return true; // Should not reach here if step 5 doesn't exist
      default:
        return true; // For now, allow other steps
    }
  }

  void goNext() {
    if (currentStepNotifier.value < stepTitles.length && canGoNext()) {
     

      currentStepNotifier.value++;
    }
  }






UserSelectionsModel getSelections() {
  return UserSelectionsModel(
    selectedEducationSystem: selectedEducationSystem.value,
    selectedEducationalStage: selectedEducationalStage.value,
    selectedClassroom: selectedClassroom.value,
    selectedAcademicTerm: selectedAcademicTerm.value,
    selectedEducationalTrack: selectedEducationalTrack.value,
  );
}

  void goBack() {
    if (currentStepNotifier.value > 1) {
      currentStepNotifier.value--;
    }
  }

  void goToStep(int step) {
    if (step >= 1 && step <= stepTitles.length) {
      currentStepNotifier.value = step;
    }
  }

  // Method to handle stage selection changes and reset steps if necessary
  void onEducationalStageChanged() {
    // If current step is beyond Academic Term (step 4) and stage is not 7,
    // reset to Academic Term step
    if (currentStepNotifier.value > 4 &&
        selectedEducationalStage.value?.id != 7) {
      currentStepNotifier.value = 4;
      // Clear educational track selection since it's no longer applicable
      selectedEducationalTrack.value = null;
    }
    // Clear classroom and subsequent selections when stage changes
    selectedClassroom.value = null;
    selectedAcademicTerm.value = null;
    selectedEducationalTrack.value = null;
  }

  // Method to validate and clear invalid selections when navigating back
  void validateClassroomSelection() {
    // This method can be called when returning to classroom step
    // to ensure the selected classroom is still valid for the current stage
    // For now, we'll keep the selection but future API calls will handle validation
  }

  @override
  void initDependencies({BuildContext? context}) {
   

    // Initialize with first step
    onInitListTypeView();
    currentStepNotifier.value = 1;

    selectedEducationSystem = ValueNotifier<SelectionData?>(null);
    selectedEducationalStage = ValueNotifier<SelectionData?>(null);
    selectedClassroom = ValueNotifier<ClassroomGradeSelection?>(null);
    selectedAcademicTerm = ValueNotifier<AcademicTermSelection?>(null);
    selectedEducationalTrack = ValueNotifier<EducationalTrackSelection?>(null);
  }

  @override
  String? get route => null;

  logout(BuildContext context) async {
    playSound();
    // Clear user data
    await UserService.removeUserData();

    // Navigate to login and clear stack
    if (context.mounted) {
      context.nextReplacementNamed(AppLocalRoute.login.route);
    }
  }

  void playSound() {
    injector<AudioPlayersServices>().playAssetSound(Assets.sounds.login);
  }
}
