import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_bloc/src/presentation/view/pages/app_business/pages/questions/controller/questions_controller.dart';
import 'package:flutter_application_bloc/src/domain/entities/unit_data.dart';
import 'package:flutter_application_bloc/src/domain/entities/quizc_data.dart';
import 'package:flutter_application_bloc/src/core/utils/page_controller.dart';

void main() {
  group('QuestionsController Tests', () {
    late QuestionsController controller;
    late Lesson testLesson;
    late List<QuizcData> testQuestions;

    setUp(() {
      // Set up test data
      testLesson = Lesson(
        id: 1,
        name: 'Introduction to Mathematics',
        sort: 1,
        subjectId: 1,
        unitId: 1,
        systemId: 1,
        stageId: 7,
        classroomId: 12,
        termId: 1,
      );

      testQuestions = [
        QuizcData(
          id: 1,
          correctSelect: 'B',
          point: 10,
          quesText: 'What is 2 + 2?',
          select1Text: '3',
          select2Text: '4',
          select3Text: '5',
          select4Text: '6',
        ),
        QuizcData(
          id: 2,
          correctSelect: 'A',
          point: 15,
          quesText: 'What is the capital of France?',
          select1Text: 'Paris',
          select2Text: 'London',
          select3Text: 'Berlin',
          select4Text: 'Madrid',
        ),
        QuizcData(
          id: 3,
          correctSelect: 'C',
          point: 20,
          quesText: 'What is 5 * 3?',
          select1Text: '10',
          select2Text: '12',
          select3Text: '15',
          select4Text: '18',
        ),
      ];

      // Create controller
      controller = QuestionsController();
    });

    tearDown(() {
      try {
        controller.disposeDependencies();
      } catch (e) {
        // Ignore disposal errors in tests
      }
    });

    group('Basic Properties', () {
      test('should initialize with null lesson', () {
        // Assert
        expect(controller.lesson, isNull);
      });

      test('should implement AppPageController interface', () {
        // Assert
        expect(controller, isA<AppPageController>());
      });

      test('should throw UnimplementedError for route getter', () {
        // Act & Assert
        expect(() => controller.route, throwsUnimplementedError);
      });

      test('should have correct constants', () {
        // Assert
        expect(QuestionsController.maxAttempts, equals(3));
        expect(QuestionsController.hintAfterAttempts, equals(3));
        expect(QuestionsController.quizDurationMinutes, equals(30));
      });
    });

    group('Initialization and Lesson Management', () {
      test('should store lesson when provided during initialization', () {
        // Act
        controller.lesson = testLesson;

        // Assert
        expect(controller.lesson, equals(testLesson));
        expect(controller.lesson?.id, equals(1));
        expect(controller.lesson?.name, equals('Introduction to Mathematics'));
      });

      test('should handle null lesson', () {
        // Act
        controller.lesson = null;

        // Assert
        expect(controller.lesson, isNull);
      });

      test('should handle lesson assignment without full initialization', () {
        // Act
        controller.lesson = testLesson;

        // Assert
        expect(controller.lesson, equals(testLesson));
        expect(controller.lesson?.id, equals(1));
        expect(controller.lesson?.name, equals('Introduction to Mathematics'));
      });
    });

    group('Questions Management', () {
      test('should store questions correctly', () {
        // Act
        controller.questions = testQuestions;

        // Assert
        expect(controller.questions, equals(testQuestions));
        expect(controller.questions.length, equals(3));
        expect(controller.questions[0].quesText, equals('What is 2 + 2?'));
        expect(controller.questions[1].correctSelect, equals('A'));
        expect(controller.questions[2].point, equals(20));
      });

      test('should handle empty questions list', () {
        // Act
        controller.questions = [];

        // Assert
        expect(controller.questions, isEmpty);
      });
    });

    group('Quiz Data Classes', () {
      test('should create QuizAnswer correctly', () {
        // Arrange & Act
        final answer = QuizAnswer(
          questionId: 1,
          selectedOption: 'B',
          isCorrect: true,
          attempts: 2,
        );

        // Assert
        expect(answer.questionId, equals(1));
        expect(answer.selectedOption, equals('B'));
        expect(answer.isCorrect, isTrue);
        expect(answer.attempts, equals(2));
      });

      test('should create QuizResults correctly', () {
        // Arrange & Act
        final results = QuizResults(
          totalQuestions: 10,
          correctAnswers: 8,
          totalPoints: 80,
          percentage: 80,
          timeSpent: 900, // 15 minutes
          answers: {},
        );

        // Assert
        expect(results.totalQuestions, equals(10));
        expect(results.correctAnswers, equals(8));
        expect(results.totalPoints, equals(80));
        expect(results.percentage, equals(80));
        expect(results.timeSpent, equals(900));
        expect(results.grade, equals('A'));
        expect(results.isPassed, isTrue);
      });
    });

    group('Quiz Results Grade System', () {
      test('should return correct grades for different percentages', () {
        final testCases = [
          (95, 'A+'),
          (90, 'A+'),
          (85, 'A'),
          (80, 'A'),
          (75, 'B'),
          (70, 'B'),
          (65, 'C'),
          (60, 'C'),
          (55, 'F'),
          (0, 'F'),
        ];

        for (final (percentage, expectedGrade) in testCases) {
          final results = QuizResults(
            totalQuestions: 10,
            correctAnswers: percentage ~/ 10,
            totalPoints: percentage,
            percentage: percentage,
            timeSpent: 300,
            answers: {},
          );
          expect(
            results.grade,
            equals(expectedGrade),
            reason: 'Percentage $percentage should give grade $expectedGrade',
          );
        }
      });

      test('should determine pass/fail correctly', () {
        final passingResult = QuizResults(
          totalQuestions: 10,
          correctAnswers: 6,
          totalPoints: 60,
          percentage: 60,
          timeSpent: 300,
          answers: {},
        );

        final failingResult = QuizResults(
          totalQuestions: 10,
          correctAnswers: 5,
          totalPoints: 50,
          percentage: 50,
          timeSpent: 300,
          answers: {},
        );

        expect(passingResult.isPassed, isTrue);
        expect(failingResult.isPassed, isFalse);
      });
    });

    group('Utility Methods', () {
      test('should format time correctly', () {
        expect(controller.formatTime(0), equals('00:00'));
        expect(controller.formatTime(59), equals('00:59'));
        expect(controller.formatTime(60), equals('01:00'));
        expect(controller.formatTime(125), equals('02:05'));
        expect(controller.formatTime(3661), equals('61:01'));
      });
    });
  });
}
