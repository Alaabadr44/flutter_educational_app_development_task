import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_bloc/src/presentation/view/pages/app_business/pages/dashboard/controller/dashboard_controller.dart';
import 'package:flutter_application_bloc/src/domain/entities/education_system.dart';
import 'package:flutter_application_bloc/src/domain/entities/classroom_grade_selection.dart';
import 'package:flutter_application_bloc/src/domain/entities/academic_term_selection.dart';
import 'package:flutter_application_bloc/src/domain/entities/educational_track_selection.dart';
import 'package:flutter_application_bloc/src/core/utils/page_controller.dart';
import 'package:flutter_application_bloc/src/presentation/view/mixins/list_type_view.dart';
import 'package:flutter_application_bloc/src/core/config/l10n/generated/l10n.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_application_bloc/src/core/config/injector.dart';
import 'package:flutter_application_bloc/src/core/services/sound_service.dart';
import 'package:audioplayers/audioplayers.dart';

// Mock class for AudioPlayersServices
class MockAudioPlayersServices implements AudioPlayersServices {
  @override
  late AudioPlayer audioPlayer;

  @override
  Future initializeService() async {
    // Mock implementation - do nothing
  }

  @override
  String get name => "Mock Audio Player Service";

  @override
  playAssetSound(
    String path, {
    double? volume,
    double? balance,
    AudioContext? ctx,
    Duration? position,
    PlayerMode? mode,
  }) async {
    // Mock implementation - do nothing
  }

  @override
  playNetworkSound(String url) async {
    // Mock implementation - do nothing
  }

  @override
  void stopSound() async {
    // Mock implementation - do nothing
  }
}

void main() {
  group('DashboardController Tests', () {
    late DashboardController controller;

    setUpAll(() async {
      // Initialize Flutter binding for tests
      TestWidgetsFlutterBinding.ensureInitialized();

      // Register mock AudioPlayersServices
      final mockAudioService = MockAudioPlayersServices();
      injector.registerSingleton<AudioPlayersServices>(mockAudioService);
    });

    tearDownAll(() {
      // Clean up injector
      if (injector.isRegistered<AudioPlayersServices>()) {
        injector.unregister<AudioPlayersServices>();
      }
    });

    setUp(() async {
      // Create controller
      controller = DashboardController();
      controller.initDependencies();
    });

    // Helper function to get a test context with localization
    Future<BuildContext> getTestContext(WidgetTester tester) async {
      late BuildContext capturedContext;

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: S.delegate.supportedLocales,
          home: Builder(
            builder: (context) {
              capturedContext = context;
              return const Scaffold(body: Text('Test'));
            },
          ),
        ),
      );

      return capturedContext;
    }

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
      testWidgets('should return correct base step titles', (
        WidgetTester tester,
      ) async {
        // Arrange
        final context = await getTestContext(tester);

        // Act
        final stepTitles = controller.stepTitles(context);

        // Assert
        expect(stepTitles.length, equals(4));
        expect(stepTitles[0], equals(S.of(context).education_system_selection));
        expect(
          stepTitles[1],
          equals(S.of(context).educational_stage_selection),
        );
        expect(stepTitles[2], equals(S.of(context).classroom_selection));
        expect(stepTitles[3], equals(S.of(context).academic_term_selection));
      });

      testWidgets('should return correct base step descriptions', (
        WidgetTester tester,
      ) async {
        // Arrange
        final context = await getTestContext(tester);

        // Act
        final descriptions = controller.stepDescriptions(context);

        // Assert
        expect(descriptions.length, equals(4));
        expect(descriptions[0], equals(S.of(context).select_education_system));
        expect(descriptions[1], equals(S.of(context).select_educational_stage));
        expect(descriptions[2], equals(S.of(context).select_classroom_grade));
        expect(descriptions[3], equals(S.of(context).select_academic_term));
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

      testWidgets('should include Educational Track step when stage ID is 7', (
        WidgetTester tester,
      ) async {
        // Arrange
        final context = await getTestContext(tester);

        // Act
        final stepTitles = controller.stepTitles(context);

        // Assert
        expect(stepTitles.length, equals(5));
        expect(
          stepTitles[4],
          equals(S.of(context).educational_track_selection),
        );
      });

      testWidgets(
        'should include Educational Track description when stage ID is 7',
        (WidgetTester tester) async {
          // Arrange
          final context = await getTestContext(tester);

          // Act
          final descriptions = controller.stepDescriptions(context);

          // Assert
          expect(descriptions.length, equals(5));
          expect(
            descriptions[4],
            equals(S.of(context).select_educational_track),
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
      testWidgets(
        'should allow going to next step when current step is valid',
        (WidgetTester tester) async {
          // Arrange
          final context = await getTestContext(tester);
          controller.selectedEducationSystem.value = SelectionData(
            id: 1,
            name: 'Public System',
          );

          // Act
          controller.goNext(context);

          // Assert
          expect(controller.currentStepNotifier.value, equals(2));
        },
      );

      testWidgets(
        'should not allow going to next step when current step is invalid',
        (WidgetTester tester) async {
          // Arrange
          final context = await getTestContext(tester);
          // No selection made

          // Act
          controller.goNext(context);

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

      testWidgets('should allow jumping to specific valid step', (
        WidgetTester tester,
      ) async {
        // Arrange
        final context = await getTestContext(tester);

        // Act
        controller.goToStep(3, context);

        // Assert
        expect(controller.currentStepNotifier.value, equals(3));
      });

      testWidgets('should not allow jumping to invalid step', (
        WidgetTester tester,
      ) async {
        // Arrange
        final context = await getTestContext(tester);
        final initialStep = controller.currentStepNotifier.value;

        // Act
        controller.goToStep(10, context); // Invalid step

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
      testWidgets(
        'should handle complete workflow for stage with track requirement',
        (WidgetTester tester) async {
          // Arrange
          final context = await getTestContext(tester);

          // Step 1: Education System Selection
          expect(controller.canGoNext(), isFalse);
          controller.selectedEducationSystem.value = SelectionData(
            id: 1,
            name: 'Public',
          );
          expect(controller.canGoNext(), isTrue);
          controller.goNext(context);
          expect(controller.currentStepNotifier.value, equals(2));

          // Step 2: Educational Stage Selection (ID 7 - requires track)
          expect(controller.canGoNext(), isFalse);
          controller.selectedEducationalStage.value = SelectionData(
            id: 7,
            name: 'High School',
          );
          expect(controller.canGoNext(), isTrue);
          controller.goNext(context);
          expect(controller.currentStepNotifier.value, equals(3));

          // Step 3: Classroom Selection
          expect(controller.canGoNext(), isFalse);
          controller.selectedClassroom.value = ClassroomGradeSelection(
            id: 12,
            name: 'Grade 12',
          );
          expect(controller.canGoNext(), isTrue);
          controller.goNext(context);
          expect(controller.currentStepNotifier.value, equals(4));

          // Step 4: Academic Term Selection
          expect(controller.canGoNext(), isFalse);
          controller.selectedAcademicTerm.value = AcademicTermSelection(
            id: 1,
            name: 'First Term',
          );
          expect(controller.canGoNext(), isTrue);
          controller.goNext(context);
          expect(controller.currentStepNotifier.value, equals(5));

          // Step 5: Educational Track Selection (required for stage 7)
          expect(controller.canGoNext(), isFalse);
          controller.selectedEducationalTrack.value = EducationalTrackSelection(
            id: 1,
            name: 'Scientific',
          );
          expect(controller.canGoNext(), isTrue);

          // Verify all steps are present
          expect(controller.stepTitles(context).length, equals(5));
        },
      );

      testWidgets(
        'should handle complete workflow for stage without track requirement',
        (WidgetTester tester) async {
          // Arrange
          final context = await getTestContext(tester);

          // Steps 1-4 for middle school (no track required)
          controller.selectedEducationSystem.value = SelectionData(
            id: 1,
            name: 'Public',
          );
          controller.goNext(context);

          controller.selectedEducationalStage.value = SelectionData(
            id: 5,
            name: 'Middle School',
          );
          controller.goNext(context);

          controller.selectedClassroom.value = ClassroomGradeSelection(
            id: 6,
            name: 'Grade 6',
          );
          controller.goNext(context);

          controller.selectedAcademicTerm.value = AcademicTermSelection(
            id: 1,
            name: 'First Term',
          );

          // Should be at step 4 and can proceed (no step 5 for non-7 stages)
          expect(controller.currentStepNotifier.value, equals(4));
          expect(controller.canGoNext(), isTrue);
          expect(controller.stepTitles(context).length, equals(4));
        },
      );
    });

    group('Edge Cases and Boundary Tests', () {
      testWidgets('should handle stage changes that affect step count', (
        WidgetTester tester,
      ) async {
        // Arrange
        final context = await getTestContext(tester);

        // Start with stage that requires track
        controller.selectedEducationalStage.value = SelectionData(
          id: 7,
          name: 'High School',
        );
        expect(controller.stepTitles(context).length, equals(5));

        // Act - Change to stage that doesn't require track
        controller.selectedEducationalStage.value = SelectionData(
          id: 5,
          name: 'Middle School',
        );

        // Assert
        expect(controller.stepTitles(context).length, equals(4));
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

      testWidgets('should handle null selections gracefully', (
        WidgetTester tester,
      ) async {
        // Arrange
        final context = await getTestContext(tester);

        // Act & Assert - Should not crash
        expect(() => controller.stepTitles(context), returnsNormally);
        expect(() => controller.stepDescriptions(context), returnsNormally);
        expect(() => controller.stepIcons, returnsNormally);
        expect(() => controller.canGoNext(), returnsNormally);
        expect(() => controller.getSelections(), returnsNormally);
      });
    });
  });
}
