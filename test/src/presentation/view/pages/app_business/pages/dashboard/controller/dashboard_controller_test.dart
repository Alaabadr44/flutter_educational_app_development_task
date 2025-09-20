import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_bloc/src/presentation/view/pages/app_business/pages/dashboard/controller/dashboard_controller.dart';
import 'package:flutter_application_bloc/src/domain/entities/education_system.dart';
import 'package:flutter_application_bloc/src/domain/entities/classroom_grade_selection.dart';
import 'package:flutter_application_bloc/src/domain/entities/academic_term_selection.dart';
import 'package:flutter_application_bloc/src/domain/entities/educational_track_selection.dart';
import 'package:flutter_application_bloc/src/core/utils/page_controller.dart';
import 'package:flutter_application_bloc/src/presentation/view/mixins/list_type_view.dart';

void main() {
  group('DashboardController Tests', () {
    late DashboardController controller;

    setUp(() {
      // Create controller
      controller = DashboardController();
      controller.initDependencies();
    });

    tearDown(() {
      try {
        controller.disposeDependencies();
      } catch (e) {
        // Ignore disposal errors in tests
      }
    });

    group('Basic Properties', () {
      test('should implement AppPageController interface', () {
        // Assert
        expect(controller, isA<AppPageController>());
      });

      test('should include ListTypeView mixin', () {
        // Assert
        expect(controller, isA<ListTypeView>());
      });

      test('should return null for route getter', () {
        // Act & Assert
        expect(controller.route, isNull);
      });

      test('should initialize with step 1', () {
        // Assert
        expect(controller.currentStepNotifier.value, equals(1));
      });
    });

    group('Step Management - Base Steps (No Track)', () {
      test('should return correct base step titles', () {
        // Act
        final stepTitles = controller.stepTitles;

        // Assert
        expect(stepTitles.length, equals(4));
        expect(stepTitles[0], equals("Education System Selection"));
        expect(stepTitles[1], equals("Educational Stage Selection"));
        expect(stepTitles[2], equals("Classroom / Grade Selection"));
        expect(stepTitles[3], equals("Academic Term Selection"));
      });

      test('should return correct base step descriptions', () {
        // Act
        final descriptions = controller.stepDescriptions;

        // Assert
        expect(descriptions.length, equals(4));
        expect(descriptions[0], equals("Select your education system"));
        expect(descriptions[1], equals("Choose your educational stage"));
        expect(descriptions[2], equals("Select your classroom or grade"));
        expect(descriptions[3], equals("Choose the academic term"));
      });

      test('should return correct base step icons', () {
        // Act
        final icons = controller.stepIcons;

        // Assert
        expect(icons.length, equals(4));
        expect(icons[0], equals(Icons.school));
        expect(icons[1], equals(Icons.trending_up));
        expect(icons[2], equals(Icons.class_));
        expect(icons[3], equals(Icons.calendar_today));
      });
    });

    group('Step Management - With Educational Track (Stage ID 7)', () {
      setUp(() {
        // Set educational stage to ID 7 (requires track selection)
        controller.selectedEducationalStage.value = SelectionData(
          id: 7,
          name: 'High School',
        );
      });

      test('should include Educational Track step when stage ID is 7', () {
        // Act
        final stepTitles = controller.stepTitles;

        // Assert
        expect(stepTitles.length, equals(5));
        expect(stepTitles[4], equals("Educational Track Selection"));
      });

      test(
        'should include Educational Track description when stage ID is 7',
        () {
          // Act
          final descriptions = controller.stepDescriptions;

          // Assert
          expect(descriptions.length, equals(5));
          expect(
            descriptions[4],
            equals("Select your educational track (Secondary only)"),
          );
        },
      );

      test('should include Educational Track icon when stage ID is 7', () {
        // Act
        final icons = controller.stepIcons;

        // Assert
        expect(icons.length, equals(5));
        expect(icons[4], equals(Icons.track_changes));
      });
    });

    group('Navigation Logic', () {
      test('should allow going to next step when current step is valid', () {
        // Arrange
        controller.selectedEducationSystem.value = SelectionData(
          id: 1,
          name: 'Public System',
        );

        // Act
        controller.goNext();

        // Assert
        expect(controller.currentStepNotifier.value, equals(2));
      });

      test(
        'should not allow going to next step when current step is invalid',
        () {
          // Arrange - No selection made

          // Act
          controller.goNext();

          // Assert
          expect(controller.currentStepNotifier.value, equals(1));
        },
      );

      test('should allow going back to previous step', () {
        // Arrange
        controller.currentStepNotifier.value = 3;

        // Act
        controller.goBack();

        // Assert
        expect(controller.currentStepNotifier.value, equals(2));
      });

      test('should not go back below step 1', () {
        // Arrange
        controller.currentStepNotifier.value = 1;

        // Act
        controller.goBack();

        // Assert
        expect(controller.currentStepNotifier.value, equals(1));
      });

      test('should allow jumping to specific valid step', () {
        // Act
        controller.goToStep(3);

        // Assert
        expect(controller.currentStepNotifier.value, equals(3));
      });

      test('should not allow jumping to invalid step', () {
        // Arrange
        final initialStep = controller.currentStepNotifier.value;

        // Act
        controller.goToStep(10); // Invalid step

        // Assert
        expect(controller.currentStepNotifier.value, equals(initialStep));
      });
    });

    group('Validation Logic - canGoNext()', () {
      test(
        'should return false for step 1 when no education system selected',
        () {
          // Arrange
          controller.currentStepNotifier.value = 1;

          // Act & Assert
          expect(controller.canGoNext(), isFalse);
        },
      );

      test('should return true for step 1 when education system selected', () {
        // Arrange
        controller.currentStepNotifier.value = 1;
        controller.selectedEducationSystem.value = SelectionData(
          id: 1,
          name: 'Public System',
        );

        // Act & Assert
        expect(controller.canGoNext(), isTrue);
      });

      test(
        'should return false for step 2 when no educational stage selected',
        () {
          // Arrange
          controller.currentStepNotifier.value = 2;

          // Act & Assert
          expect(controller.canGoNext(), isFalse);
        },
      );

      test('should return true for step 2 when educational stage selected', () {
        // Arrange
        controller.currentStepNotifier.value = 2;
        controller.selectedEducationalStage.value = SelectionData(
          id: 5,
          name: 'Middle School',
        );

        // Act & Assert
        expect(controller.canGoNext(), isTrue);
      });

      test('should return false for step 3 when no classroom selected', () {
        // Arrange
        controller.currentStepNotifier.value = 3;

        // Act & Assert
        expect(controller.canGoNext(), isFalse);
      });

      test('should return true for step 3 when classroom selected', () {
        // Arrange
        controller.currentStepNotifier.value = 3;
        controller.selectedClassroom.value = ClassroomGradeSelection(
          id: 1,
          name: 'Grade 6',
        );

        // Act & Assert
        expect(controller.canGoNext(), isTrue);
      });

      test('should return false for step 4 when no academic term selected', () {
        // Arrange
        controller.currentStepNotifier.value = 4;

        // Act & Assert
        expect(controller.canGoNext(), isFalse);
      });

      test('should return true for step 4 when academic term selected', () {
        // Arrange
        controller.currentStepNotifier.value = 4;
        controller.selectedAcademicTerm.value = AcademicTermSelection(
          id: 1,
          name: 'First Term',
        );

        // Act & Assert
        expect(controller.canGoNext(), isTrue);
      });

      test(
        'should return false for step 5 when stage ID is 7 but no track selected',
        () {
          // Arrange
          controller.selectedEducationalStage.value = SelectionData(
            id: 7,
            name: 'High School',
          );
          controller.currentStepNotifier.value = 5;

          // Act & Assert
          expect(controller.canGoNext(), isFalse);
        },
      );

      test(
        'should return true for step 5 when stage ID is 7 and track selected',
        () {
          // Arrange
          controller.selectedEducationalStage.value = SelectionData(
            id: 7,
            name: 'High School',
          );
          controller.currentStepNotifier.value = 5;
          controller.selectedEducationalTrack.value = EducationalTrackSelection(
            id: 1,
            name: 'Scientific Track',
          );

          // Act & Assert
          expect(controller.canGoNext(), isTrue);
        },
      );
    });

    group('User Selections Management', () {
      test('should return UserSelectionsModel with all selections', () {
        // Arrange
        controller.selectedEducationSystem.value = SelectionData(
          id: 1,
          name: 'System 1',
        );
        controller.selectedEducationalStage.value = SelectionData(
          id: 7,
          name: 'High School',
        );
        controller.selectedClassroom.value = ClassroomGradeSelection(
          id: 1,
          name: 'Grade 12',
        );
        controller.selectedAcademicTerm.value = AcademicTermSelection(
          id: 1,
          name: 'First Term',
        );
        controller.selectedEducationalTrack.value = EducationalTrackSelection(
          id: 1,
          name: 'Scientific',
        );

        // Act
        final selections = controller.getSelections();

        // Assert
        expect(
          selections.selectedEducationSystem,
          equals(controller.selectedEducationSystem.value),
        );
        expect(
          selections.selectedEducationalStage,
          equals(controller.selectedEducationalStage.value),
        );
        expect(
          selections.selectedClassroom,
          equals(controller.selectedClassroom.value),
        );
        expect(
          selections.selectedAcademicTerm,
          equals(controller.selectedAcademicTerm.value),
        );
        expect(
          selections.selectedEducationalTrack,
          equals(controller.selectedEducationalTrack.value),
        );
      });

      test(
        'should return UserSelectionsModel with null values when no selections made',
        () {
          // Act
          final selections = controller.getSelections();

          // Assert
          expect(selections.selectedEducationSystem, isNull);
          expect(selections.selectedEducationalStage, isNull);
          expect(selections.selectedClassroom, isNull);
          expect(selections.selectedAcademicTerm, isNull);
          expect(selections.selectedEducationalTrack, isNull);
        },
      );
    });

    group('Educational Stage Change Logic', () {
      test('should reset selections when stage changes', () {
        // Arrange - Set up initial state
        controller.selectedEducationalStage.value = SelectionData(
          id: 7,
          name: 'High School',
        );
        controller.selectedEducationalTrack.value = EducationalTrackSelection(
          id: 1,
          name: 'Scientific',
        );
        controller.selectedClassroom.value = ClassroomGradeSelection(
          id: 1,
          name: 'Grade 12',
        );
        controller.selectedAcademicTerm.value = AcademicTermSelection(
          id: 1,
          name: 'First Term',
        );
        controller.currentStepNotifier.value = 4;

        // Act - Change stage to non-7
        controller.selectedEducationalStage.value = SelectionData(
          id: 5,
          name: 'Middle School',
        );
        controller.onEducationalStageChanged();

        // Assert - Should reset subsequent selections
        expect(controller.selectedEducationalTrack.value, isNull);
        expect(controller.selectedClassroom.value, isNull);
        expect(controller.selectedAcademicTerm.value, isNull);
        expect(controller.currentStepNotifier.value, equals(4));
      });
    });

    group('Complete Workflow Tests', () {
      test(
        'should handle complete workflow for stage with track requirement',
        () {
          // Step 1: Education System Selection
          expect(controller.canGoNext(), isFalse);
          controller.selectedEducationSystem.value = SelectionData(
            id: 1,
            name: 'Public',
          );
          expect(controller.canGoNext(), isTrue);
          controller.goNext();
          expect(controller.currentStepNotifier.value, equals(2));

          // Step 2: Educational Stage Selection (ID 7 - requires track)
          expect(controller.canGoNext(), isFalse);
          controller.selectedEducationalStage.value = SelectionData(
            id: 7,
            name: 'High School',
          );
          expect(controller.canGoNext(), isTrue);
          controller.goNext();
          expect(controller.currentStepNotifier.value, equals(3));

          // Step 3: Classroom Selection
          expect(controller.canGoNext(), isFalse);
          controller.selectedClassroom.value = ClassroomGradeSelection(
            id: 12,
            name: 'Grade 12',
          );
          expect(controller.canGoNext(), isTrue);
          controller.goNext();
          expect(controller.currentStepNotifier.value, equals(4));

          // Step 4: Academic Term Selection
          expect(controller.canGoNext(), isFalse);
          controller.selectedAcademicTerm.value = AcademicTermSelection(
            id: 1,
            name: 'First Term',
          );
          expect(controller.canGoNext(), isTrue);
          controller.goNext();
          expect(controller.currentStepNotifier.value, equals(5));

          // Step 5: Educational Track Selection (required for stage 7)
          expect(controller.canGoNext(), isFalse);
          controller.selectedEducationalTrack.value = EducationalTrackSelection(
            id: 1,
            name: 'Scientific',
          );
          expect(controller.canGoNext(), isTrue);

          // Verify all steps are present
          expect(controller.stepTitles.length, equals(5));
        },
      );

      test(
        'should handle complete workflow for stage without track requirement',
        () {
          // Steps 1-4 for middle school (no track required)
          controller.selectedEducationSystem.value = SelectionData(
            id: 1,
            name: 'Public',
          );
          controller.goNext();

          controller.selectedEducationalStage.value = SelectionData(
            id: 5,
            name: 'Middle School',
          );
          controller.goNext();

          controller.selectedClassroom.value = ClassroomGradeSelection(
            id: 6,
            name: 'Grade 6',
          );
          controller.goNext();

          controller.selectedAcademicTerm.value = AcademicTermSelection(
            id: 1,
            name: 'First Term',
          );

          // Should be at step 4 and can proceed (no step 5 for non-7 stages)
          expect(controller.currentStepNotifier.value, equals(4));
          expect(controller.canGoNext(), isTrue);
          expect(controller.stepTitles.length, equals(4));
        },
      );
    });

    group('Edge Cases and Boundary Tests', () {
      test('should handle stage changes that affect step count', () {
        // Arrange - Start with stage that requires track
        controller.selectedEducationalStage.value = SelectionData(
          id: 7,
          name: 'High School',
        );
        expect(controller.stepTitles.length, equals(5));

        // Act - Change to stage that doesn't require track
        controller.selectedEducationalStage.value = SelectionData(
          id: 5,
          name: 'Middle School',
        );

        // Assert
        expect(controller.stepTitles.length, equals(4));
      });

      test('should maintain step consistency when selections change', () {
        // Arrange
        controller.currentStepNotifier.value = 3;
        controller.selectedEducationSystem.value = SelectionData(
          id: 1,
          name: 'Public',
        );
        controller.selectedEducationalStage.value = SelectionData(
          id: 5,
          name: 'Middle School',
        );

        // Act
        controller.selectedClassroom.value = ClassroomGradeSelection(
          id: 6,
          name: 'Grade 6',
        );

        // Assert
        expect(controller.currentStepNotifier.value, equals(3));
        expect(controller.canGoNext(), isTrue);
      });

      test('should handle null selections gracefully', () {
        // Act & Assert - Should not crash
        expect(() => controller.stepTitles, returnsNormally);
        expect(() => controller.stepDescriptions, returnsNormally);
        expect(() => controller.stepIcons, returnsNormally);
        expect(() => controller.canGoNext(), returnsNormally);
        expect(() => controller.getSelections(), returnsNormally);
      });
    });
  });
}
