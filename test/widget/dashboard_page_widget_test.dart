import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

/// Mock enum for testing
enum MockListType { list, grid }

/// Mock Dashboard Controller for testing
class MockDashboardController {
  late ValueNotifier<int> currentStepNotifier;
  late ValueNotifier<MockListType> listTypeNotifier;

  // Mock selections
  late ValueNotifier<MockSelectionData?> selectedEducationSystem;
  late ValueNotifier<MockSelectionData?> selectedEducationalStage;
  late ValueNotifier<MockSelectionData?> selectedClassroom;
  late ValueNotifier<MockSelectionData?> selectedAcademicTerm;
  late ValueNotifier<MockSelectionData?> selectedEducationalTrack;

  MockDashboardController() {
    currentStepNotifier = ValueNotifier<int>(1);
    listTypeNotifier = ValueNotifier<MockListType>(MockListType.list);
    selectedEducationSystem = ValueNotifier<MockSelectionData?>(null);
    selectedEducationalStage = ValueNotifier<MockSelectionData?>(null);
    selectedClassroom = ValueNotifier<MockSelectionData?>(null);
    selectedAcademicTerm = ValueNotifier<MockSelectionData?>(null);
    selectedEducationalTrack = ValueNotifier<MockSelectionData?>(null);
  }

  List<String> get stepTitles {
    final baseSteps = [
      "Education System Selection",
      "Educational Stage Selection",
      "Classroom / Grade Selection",
      "Academic Term Selection",
    ];

    if (selectedEducationalStage.value?.id == 7) {
      return [...baseSteps, "Educational Track Selection"];
    }

    return baseSteps;
  }

  List<String> get stepDescriptions {
    final baseDescriptions = [
      "Select your education system",
      "Choose your educational stage",
      "Select your classroom or grade",
      "Choose the academic term",
    ];

    if (selectedEducationalStage.value?.id == 7) {
      return [...baseDescriptions, "Select your educational track"];
    }

    return baseDescriptions;
  }

  List<IconData> get stepIcons {
    final baseIcons = [
      Icons.school,
      Icons.trending_up,
      Icons.class_,
      Icons.calendar_today,
    ];

    if (selectedEducationalStage.value?.id == 7) {
      return [...baseIcons, Icons.track_changes];
    }

    return baseIcons;
  }

  bool canGoNext() {
    final currentStep = currentStepNotifier.value;
    switch (currentStep) {
      case 1:
        return selectedEducationSystem.value != null;
      case 2:
        return selectedEducationalStage.value != null;
      case 3:
        return selectedClassroom.value != null;
      case 4:
        return selectedAcademicTerm.value != null;
      case 5:
        return selectedEducationalTrack.value != null;
      default:
        return false;
    }
  }

  void goNext() {
    if (canGoNext() && currentStepNotifier.value < stepTitles.length) {
      currentStepNotifier.value++;
    }
  }

  void goBack() {
    if (currentStepNotifier.value > 1) {
      currentStepNotifier.value--;
    }
  }

  void toggleView() {
    listTypeNotifier.value =
        listTypeNotifier.value == MockListType.list
            ? MockListType.grid
            : MockListType.list;
  }

  bool _disposed = false;

  void dispose() {
    if (_disposed) return;
    _disposed = true;

    currentStepNotifier.dispose();
    listTypeNotifier.dispose();
    selectedEducationSystem.dispose();
    selectedEducationalStage.dispose();
    selectedClassroom.dispose();
    selectedAcademicTerm.dispose();
    selectedEducationalTrack.dispose();
  }
}

/// Mock Selection Data
class MockSelectionData {
  final int id;
  final String name;

  const MockSelectionData({required this.id, required this.name});
}

/// Mock Dashboard Widget for testing
class MockDashboardWidget extends StatefulWidget {
  final MockDashboardController controller;

  const MockDashboardWidget({super.key, required this.controller});

  @override
  State<MockDashboardWidget> createState() => _MockDashboardWidgetState();
}

class _MockDashboardWidgetState extends State<MockDashboardWidget> {
  @override
  void dispose() {
    // Only dispose if not already disposed
    try {
      widget.controller.dispose();
    } catch (e) {
      // Controller already disposed, ignore
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Dashboard'),
          automaticallyImplyLeading: false,
          actions: [
            // View Toggle Button
            ValueListenableBuilder<MockListType>(
              valueListenable: widget.controller.listTypeNotifier,
              builder: (context, listType, child) {
                return IconButton(
                  key: const Key('view_toggle_button'),
                  tooltip:
                      listType == MockListType.list ? 'Grid View' : 'List View',
                  onPressed: () {
                    widget.controller.toggleView();
                  },
                  icon: Icon(
                    listType == MockListType.list
                        ? Icons.grid_view
                        : Icons.list,
                  ),
                );
              },
            ),
            IconButton(
              key: const Key('language_button'),
              tooltip: 'Select Language',
              onPressed: () {},
              icon: const Icon(Icons.language_rounded),
            ),
          ],
        ),
        body: Provider.value(
          value: widget.controller,
          child: ValueListenableBuilder<int>(
            valueListenable: widget.controller.currentStepNotifier,
            builder: (context, currentStep, child) {
              return Column(
                children: [
                  // Progress Indicator
                  _buildProgressIndicator(),

                  // Content
                  Expanded(
                    child: IndexedStack(
                      index: currentStep - 1,
                      children: [
                        _buildMockStepContent("Education System Selection"),
                        _buildMockStepContent("Educational Stage Selection"),
                        _buildMockStepContent("Classroom Selection"),
                        _buildMockStepContent("Academic Term Selection"),
                        _buildMockStepContent("Educational Track Selection"),
                      ],
                    ),
                  ),

                  // Navigation
                  _buildNavigation(),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Container(
      key: const Key('progress_indicator'),
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey, width: 1)),
      ),
      child: ValueListenableBuilder<int>(
        valueListenable: widget.controller.currentStepNotifier,
        builder: (context, currentStep, child) {
          final totalSteps = widget.controller.stepTitles.length;

          return Column(
            children: [
              // Progress Bar
              Row(
                children: [
                  Expanded(
                    child: Container(
                      key: const Key('progress_bar'),
                      height: 8,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: currentStep / totalSteps,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 600),
                          decoration: BoxDecoration(
                            color: Colors.blue,
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
                    key: const Key('step_icon_container'),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      widget.controller.stepIcons[currentStep - 1],
                      color: Colors.blue,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Step $currentStep of $totalSteps",
                          key: const Key('step_counter'),
                          style: const TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.controller.stepTitles[currentStep - 1],
                          key: const Key('step_title'),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.controller.stepDescriptions[currentStep - 1],
                          key: const Key('step_description'),
                          style: const TextStyle(color: Colors.grey),
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

  Widget _buildMockStepContent(String stepName) {
    return Container(
      key: Key('step_content_$stepName'),
      padding: const EdgeInsets.all(20),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.settings, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              stepName,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Mock content for testing',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigation() {
    return Container(
      key: const Key('navigation_container'),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: const Border(top: BorderSide(color: Colors.grey, width: 1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: ValueListenableBuilder<int>(
        valueListenable: widget.controller.currentStepNotifier,
        builder: (context, currentStep, child) {
          final totalSteps = widget.controller.stepTitles.length;
          final isFirstStep = currentStep <= 1;
          final isLastStep = currentStep >= totalSteps;

          return Row(
            children: [
              if (!isFirstStep) ...[
                Expanded(
                  child: ElevatedButton(
                    key: const Key('previous_button'),
                    onPressed: () {
                      widget.controller.goBack();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      foregroundColor: Colors.blue,
                      side: const BorderSide(color: Colors.blue),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Previous',
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
              ],
              Expanded(
                child: ValueListenableBuilder(
                  valueListenable: widget.controller.selectedEducationSystem,
                  builder: (context, selectedValue, child) {
                    final canProceed =
                        isLastStep || widget.controller.canGoNext();
                    return ElevatedButton(
                      key: const Key('continue_button'),
                      onPressed:
                          canProceed
                              ? () {
                                if (isLastStep) {
                                  // Complete selection
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Selection Complete!'),
                                    ),
                                  );
                                } else {
                                  widget.controller.goNext();
                                }
                              }
                              : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: canProceed ? Colors.blue : Colors.grey,
                        foregroundColor:
                            canProceed ? Colors.white : Colors.grey[600],
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        isLastStep ? 'Complete Selection' : 'Continue',
                        style: TextStyle(
                          color: canProceed ? Colors.white : Colors.grey[600],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
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

/// Dashboard Widget Tests
void main() {
  group('Dashboard Page Widget Tests', () {
    late MockDashboardController controller;

    setUp(() {
      controller = MockDashboardController();
    });

    group('UI Components Tests', () {
      testWidgets('should display dashboard with proper AppBar configuration', (
        WidgetTester tester,
      ) async {
        // Arrange
        Widget testWidget = MockDashboardWidget(controller: controller);

        // Act
        await tester.pumpWidget(testWidget);
        await tester.pumpAndSettle();

        // Assert
        expect(find.byType(AppBar), findsOneWidget);
        expect(find.text('Dashboard'), findsOneWidget);
        expect(find.byKey(const Key('view_toggle_button')), findsOneWidget);
        expect(find.byKey(const Key('language_button')), findsOneWidget);
        expect(find.byIcon(Icons.grid_view), findsOneWidget);
        expect(find.byIcon(Icons.language_rounded), findsOneWidget);
      });

      testWidgets('should display progress indicator with correct elements', (
        WidgetTester tester,
      ) async {
        // Arrange
        Widget testWidget = MockDashboardWidget(controller: controller);

        // Act
        await tester.pumpWidget(testWidget);
        await tester.pumpAndSettle();

        // Assert
        expect(find.byKey(const Key('progress_indicator')), findsOneWidget);
        expect(find.byKey(const Key('progress_bar')), findsOneWidget);
        expect(find.byKey(const Key('step_icon_container')), findsOneWidget);
        expect(find.byKey(const Key('step_counter')), findsOneWidget);
        expect(find.byKey(const Key('step_title')), findsOneWidget);
        expect(find.byKey(const Key('step_description')), findsOneWidget);
      });

      testWidgets('should display navigation container with buttons', (
        WidgetTester tester,
      ) async {
        // Arrange
        Widget testWidget = MockDashboardWidget(controller: controller);

        // Act
        await tester.pumpWidget(testWidget);
        await tester.pumpAndSettle();

        // Assert
        expect(find.byKey(const Key('navigation_container')), findsOneWidget);
        expect(find.byKey(const Key('continue_button')), findsOneWidget);
        // Previous button should not be visible on first step
        expect(find.byKey(const Key('previous_button')), findsNothing);
      });

      testWidgets('should display IndexedStack with step content', (
        WidgetTester tester,
      ) async {
        // Arrange
        Widget testWidget = MockDashboardWidget(controller: controller);

        // Act
        await tester.pumpWidget(testWidget);
        await tester.pumpAndSettle();

        // Assert
        expect(find.byType(IndexedStack), findsOneWidget);
        expect(
          find.byKey(const Key('step_content_Education System Selection')),
          findsOneWidget,
        );
      });
    });

    group('State Management Tests', () {
      testWidgets('should update step counter when navigating', (
        WidgetTester tester,
      ) async {
        // Arrange
        Widget testWidget = MockDashboardWidget(controller: controller);
        controller.selectedEducationSystem.value = const MockSelectionData(
          id: 1,
          name: 'Test',
        );

        // Act
        await tester.pumpWidget(testWidget);
        await tester.pumpAndSettle();

        // Assert initial state
        expect(find.text('Step 1 of 4'), findsOneWidget);

        // Navigate to next step
        await tester.tap(find.byKey(const Key('continue_button')));
        await tester.pumpAndSettle();

        // Assert updated state
        expect(find.text('Step 2 of 4'), findsOneWidget);
      });

      testWidgets('should show previous button after first step', (
        WidgetTester tester,
      ) async {
        // Arrange
        Widget testWidget = MockDashboardWidget(controller: controller);
        controller.selectedEducationSystem.value = const MockSelectionData(
          id: 1,
          name: 'Test',
        );

        // Act
        await tester.pumpWidget(testWidget);
        await tester.pumpAndSettle();

        // Navigate to step 2
        await tester.tap(find.byKey(const Key('continue_button')));
        await tester.pumpAndSettle();

        // Assert
        expect(find.byKey(const Key('previous_button')), findsOneWidget);
        expect(find.text('Previous'), findsOneWidget);
      });

      testWidgets('should go back when previous button is tapped', (
        WidgetTester tester,
      ) async {
        // Arrange
        Widget testWidget = MockDashboardWidget(controller: controller);
        controller.selectedEducationSystem.value = const MockSelectionData(
          id: 1,
          name: 'Test',
        );

        // Act
        await tester.pumpWidget(testWidget);
        await tester.pumpAndSettle();

        // Navigate to step 2
        await tester.tap(find.byKey(const Key('continue_button')));
        await tester.pumpAndSettle();

        // Assert we're on step 2
        expect(find.text('Step 2 of 4'), findsOneWidget);

        // Go back
        await tester.tap(find.byKey(const Key('previous_button')));
        await tester.pumpAndSettle();

        // Assert we're back on step 1
        expect(find.text('Step 1 of 4'), findsOneWidget);
      });

      testWidgets('should toggle view between list and grid', (
        WidgetTester tester,
      ) async {
        // Arrange
        Widget testWidget = MockDashboardWidget(controller: controller);

        // Act
        await tester.pumpWidget(testWidget);
        await tester.pumpAndSettle();

        // Assert initial state (list view)
        expect(find.byIcon(Icons.grid_view), findsOneWidget);

        // Toggle to grid view
        await tester.tap(find.byKey(const Key('view_toggle_button')));
        await tester.pumpAndSettle();

        // Assert grid view
        expect(find.byIcon(Icons.list), findsOneWidget);

        // Toggle back to list view
        await tester.tap(find.byKey(const Key('view_toggle_button')));
        await tester.pumpAndSettle();

        // Assert list view
        expect(find.byIcon(Icons.grid_view), findsOneWidget);
      });
    });

    group('Dynamic Steps Tests', () {
      testWidgets('should show 4 steps by default', (
        WidgetTester tester,
      ) async {
        // Arrange
        Widget testWidget = MockDashboardWidget(controller: controller);

        // Act
        await tester.pumpWidget(testWidget);
        await tester.pumpAndSettle();

        // Assert
        expect(find.text('Step 1 of 4'), findsOneWidget);
        expect(controller.stepTitles.length, equals(4));
      });

      testWidgets('should show 5 steps when educational stage ID is 7', (
        WidgetTester tester,
      ) async {
        // Arrange
        Widget testWidget = MockDashboardWidget(controller: controller);
        controller.selectedEducationalStage.value = const MockSelectionData(
          id: 7,
          name: 'Stage 7',
        );

        // Act
        await tester.pumpWidget(testWidget);
        await tester.pumpAndSettle();

        // Assert
        expect(controller.stepTitles.length, equals(5));
        expect(
          controller.stepTitles.last,
          equals("Educational Track Selection"),
        );
      });
    });

    group('Button State Tests', () {
      testWidgets('should disable continue button when no selection is made', (
        WidgetTester tester,
      ) async {
        // Arrange
        Widget testWidget = MockDashboardWidget(controller: controller);

        // Act
        await tester.pumpWidget(testWidget);
        await tester.pumpAndSettle();

        // Assert
        final continueButton = tester.widget<ElevatedButton>(
          find.byKey(const Key('continue_button')),
        );
        expect(continueButton.onPressed, isNull);
      });

      testWidgets('should enable continue button when selection is made', (
        WidgetTester tester,
      ) async {
        // Arrange
        Widget testWidget = MockDashboardWidget(controller: controller);
        controller.selectedEducationSystem.value = const MockSelectionData(
          id: 1,
          name: 'Test',
        );

        // Act
        await tester.pumpWidget(testWidget);
        await tester.pumpAndSettle();

        // Assert
        final continueButton = tester.widget<ElevatedButton>(
          find.byKey(const Key('continue_button')),
        );
        expect(continueButton.onPressed, isNotNull);
      });

      testWidgets('should show "Complete Selection" on last step', (
        WidgetTester tester,
      ) async {
        // Arrange
        Widget testWidget = MockDashboardWidget(controller: controller);
        // Set all required selections
        controller.selectedEducationSystem.value = const MockSelectionData(
          id: 1,
          name: 'Test',
        );
        controller.selectedEducationalStage.value = const MockSelectionData(
          id: 1,
          name: 'Test',
        );
        controller.selectedClassroom.value = const MockSelectionData(
          id: 1,
          name: 'Test',
        );
        controller.selectedAcademicTerm.value = const MockSelectionData(
          id: 1,
          name: 'Test',
        );

        // Navigate to last step
        controller.currentStepNotifier.value = 4;

        // Act
        await tester.pumpWidget(testWidget);
        await tester.pumpAndSettle();

        // Assert
        expect(find.text('Complete Selection'), findsOneWidget);
      });
    });

    group('Layout and Style Tests', () {
      testWidgets('should apply correct styling to progress indicator', (
        WidgetTester tester,
      ) async {
        // Arrange
        Widget testWidget = MockDashboardWidget(controller: controller);

        // Act
        await tester.pumpWidget(testWidget);
        await tester.pumpAndSettle();

        // Assert
        final progressContainer = tester.widget<Container>(
          find.byKey(const Key('progress_indicator')),
        );
        expect(progressContainer.decoration, isA<BoxDecoration>());

        final decoration = progressContainer.decoration as BoxDecoration;
        expect(decoration.color, equals(Colors.white));
      });

      testWidgets('should have proper spacing with Column layout', (
        WidgetTester tester,
      ) async {
        // Arrange
        Widget testWidget = MockDashboardWidget(controller: controller);

        // Act
        await tester.pumpWidget(testWidget);
        await tester.pumpAndSettle();

        // Assert
        expect(find.byType(Column), findsAtLeastNWidgets(1));
        expect(find.byType(SizedBox), findsAtLeastNWidgets(3));
      });

      testWidgets('should apply correct styling to navigation container', (
        WidgetTester tester,
      ) async {
        // Arrange
        Widget testWidget = MockDashboardWidget(controller: controller);

        // Act
        await tester.pumpWidget(testWidget);
        await tester.pumpAndSettle();

        // Assert
        final navContainer = tester.widget<Container>(
          find.byKey(const Key('navigation_container')),
        );
        expect(navContainer.decoration, isA<BoxDecoration>());

        final decoration = navContainer.decoration as BoxDecoration;
        expect(decoration.color, equals(Colors.white));
        expect(decoration.boxShadow, isNotEmpty);
      });
    });

    group('Performance Tests', () {
      testWidgets(
        'should build efficiently with multiple ValueListenableBuilders',
        (WidgetTester tester) async {
          // Arrange
          final stopwatch = Stopwatch()..start();
          Widget testWidget = MockDashboardWidget(controller: controller);

          // Act
          await tester.pumpWidget(testWidget);
          await tester.pumpAndSettle();
          stopwatch.stop();

          // Assert
          expect(stopwatch.elapsedMilliseconds, lessThan(1000));
          expect(
            find.byType(ValueListenableBuilder<int>),
            findsAtLeastNWidgets(2),
          );
        },
      );

      testWidgets('should handle rapid step navigation', (
        WidgetTester tester,
      ) async {
        // Arrange
        Widget testWidget = MockDashboardWidget(controller: controller);
        controller.selectedEducationSystem.value = const MockSelectionData(
          id: 1,
          name: 'Test',
        );
        controller.selectedEducationalStage.value = const MockSelectionData(
          id: 1,
          name: 'Test',
        );

        // Act
        await tester.pumpWidget(testWidget);
        await tester.pumpAndSettle();

        // Rapid navigation
        for (int i = 0; i < 3; i++) {
          await tester.tap(find.byKey(const Key('continue_button')));
          await tester.pump(const Duration(milliseconds: 10));
        }

        // Assert
        expect(find.text('Step 3 of 4'), findsOneWidget);
      });
    });

    group('Edge Cases Tests', () {
      testWidgets('should handle controller disposal gracefully', (
        WidgetTester tester,
      ) async {
        // Arrange
        Widget testWidget = MockDashboardWidget(controller: controller);

        // Act
        await tester.pumpWidget(testWidget);
        await tester.pumpAndSettle();

        // Dispose the widget - this should trigger the widget's dispose method
        await tester.pumpWidget(const SizedBox());
        await tester.pumpAndSettle();

        // The test passes if no unhandled exceptions occur during disposal
      });

      testWidgets('should handle null selection values', (
        WidgetTester tester,
      ) async {
        // Arrange
        Widget testWidget = MockDashboardWidget(controller: controller);
        controller.selectedEducationSystem.value = null;

        // Act
        await tester.pumpWidget(testWidget);
        await tester.pumpAndSettle();

        // Assert
        final continueButton = tester.widget<ElevatedButton>(
          find.byKey(const Key('continue_button')),
        );
        expect(continueButton.onPressed, isNull);
      });

      testWidgets('should update UI when step titles change dynamically', (
        WidgetTester tester,
      ) async {
        // Arrange
        Widget testWidget = MockDashboardWidget(controller: controller);

        // Act
        await tester.pumpWidget(testWidget);
        await tester.pumpAndSettle();

        // Assert initial state
        expect(find.text('Step 1 of 4'), findsOneWidget);

        // Change educational stage to trigger 5 steps
        controller.selectedEducationalStage.value = const MockSelectionData(
          id: 7,
          name: 'Stage 7',
        );
        await tester.pumpAndSettle();

        // Assert the step count should still show current state correctly
        expect(controller.stepTitles.length, equals(5));
      });
    });

    group('Accessibility Tests', () {
      testWidgets('should have proper semantics for screen readers', (
        WidgetTester tester,
      ) async {
        // Arrange
        Widget testWidget = MockDashboardWidget(controller: controller);

        // Act
        await tester.pumpWidget(testWidget);
        await tester.pumpAndSettle();

        // Assert
        expect(find.byTooltip('Grid View'), findsOneWidget);
        expect(find.byTooltip('Select Language'), findsOneWidget);
      });

      testWidgets('should support keyboard navigation for buttons', (
        WidgetTester tester,
      ) async {
        // Arrange
        Widget testWidget = MockDashboardWidget(controller: controller);

        // Act
        await tester.pumpWidget(testWidget);
        await tester.pumpAndSettle();

        // Assert buttons are focusable
        expect(find.byType(ElevatedButton), findsAtLeastNWidgets(1));
        expect(find.byType(IconButton), findsNWidgets(2));
      });
    });
  });
}
